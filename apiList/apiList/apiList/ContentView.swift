//
//  ContentView.swift
//  apiList
//
//  Created by Law, Michael on 2/2/21.
//

import SwiftUI
import Amplify

struct ContentView: View {
    func populateData() {
        for _ in 1...10 {
            let blog = Blog(name: "My blog")
            _ = Amplify.API.mutate(request: .create(blog))
            
            for _ in 1...10 {
                let post = Post(title: "My Post", blog: blog)
                _ = Amplify.API.mutate(request: .create(post))

                for _ in 1...10 {
                    let comment = Comment(post: post, content: "My Comment")
                    _ = Amplify.API.mutate(request: .create(comment))
                }
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack {
                Button("Populate Data", action: {
                    populateData()
                })
                NavigationLink(destination: BlogListView()) {
                    Text("View Data")
                }
            }
        }
    }
}
import class Amplify.List

class BlogListViewModel: ObservableObject {
    @Published var blogs = [Blog]()
    var ref: List<Blog>?
    
    init() {
        Amplify.API.query(request: .paginatedList(Blog.self, limit: 3)) { (result) in
            switch result {
            case .success(let graphQLResponse):
                switch graphQLResponse {
                case .success(let blogs):
                    self.ref = blogs
                    self.blogs = blogs.elements
                    
                case .failure(let error):
                    print("\(error)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    func getNextPage() {
        guard let ref = ref, ref.hasNextPage() else {
            return
        }
        return ref.getNextPage { (result) in
            switch result {
            case .success(let nextPage):
                self.ref = nextPage
                let elements = nextPage.elements
                DispatchQueue.main.async {
                    self.blogs.append(contentsOf: elements)
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
extension Blog: Identifiable { }
struct BlogListView: View {
    @ObservedObject var vm = BlogListViewModel()
    var body: some View {
        NavigationView {
            VStack {
                Button("Load More", action: {
                    vm.getNextPage()
                })
                Spacer()
                SwiftUI.List {
                    ForEach(vm.blogs) { blog in
                        NavigationLink(destination: PostListView(blog)) {
                            Text(blog.id)
                        }
                    }
                }
                Spacer()
            }
            
        
        }.navigationBarTitle("Blogs")
    }
}

class PostListViewModel: ObservableObject {
    @Published var posts = [Post]()
    var ref: List<Post>?
    init(_ blog: Blog) {
        guard let posts = blog.posts else {
            return
        }
        self.ref = posts
        self.posts = posts.elements
    }
    func getNextPage() {
        guard let ref = ref, ref.hasNextPage() else {
            return
        }
        return ref.getNextPage { (result) in
            switch result {
            case .success(let nextPage):
                self.ref = nextPage
                let elements = nextPage.elements
                DispatchQueue.main.async {
                    self.posts.append(contentsOf: elements)
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
extension Post: Identifiable { }
struct PostListView: View {
    @ObservedObject var vm: PostListViewModel
    init(_ blog: Blog) {
        self.vm = PostListViewModel(blog)
    }
    var body: some View {
        NavigationView {
            SwiftUI.List {
                Button("Load More", action: {
                    vm.getNextPage()
                })
                ForEach(vm.posts) { post in
                    NavigationLink(destination: CommentListView(post)) {
                        Text(post.id)
                    }
                }
            }
        }.navigationBarTitle("Posts")
    }
}

class CommentListViewModel: ObservableObject {
    @Published var comments = [Comment]()
    
    init(_ post: Post) {
        guard let comments = post.comments else {
            return
        }
        
        self.comments = comments.elements
    }
}
extension Comment: Identifiable { }
struct CommentListView: View {
    let vm: CommentListViewModel
    init(_ post: Post) {
        self.vm = CommentListViewModel(post)
    }
    var body: some View {
        NavigationView {
            SwiftUI.List {
                ForEach(vm.comments) { comment in
                    Text(comment.content)
                }
            }
        }.navigationBarTitle("Comments")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
