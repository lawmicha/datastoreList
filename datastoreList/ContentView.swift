//
//  ContentView.swift
//  datastoreList
//
//  Created by Law, Michael on 2/2/21.
//

import SwiftUI
import Amplify

struct ContentView: View {
    func populateData() {
        for _ in 1...10 {
            let blog = Blog(name: "My blog")
            _ = Amplify.DataStore.save(blog)
            
            for _ in 1...10 {
                let post = Post(title: "My Post", blog: blog)
                _ = Amplify.DataStore.save(post)
                
                for _ in 1...10 {
                    let comment = Comment(post: post, content: "My Comment")
                    _ = Amplify.DataStore.save(comment)
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

class BlogListViewModel: ObservableObject {
    @Published var blogs = [Blog]()
    
    init() {
        Amplify.DataStore.query(Blog.self) { (result) in
            switch result {
            case .success(let blogs):
                self.blogs = blogs
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
extension Blog: Identifiable { }
struct BlogListView: View {
    let vm = BlogListViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.blogs) { blog in
                    NavigationLink(destination: PostListView(blog)) {
                        Text(blog.id)
                    }
                }
            }
        }.navigationBarTitle("Blogs")
    }
}

class PostListViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init(_ blog: Blog) {
        guard let posts = blog.posts else {
            return
        }
        
        self.posts = posts.elements
    }
}
extension Post: Identifiable { }
struct PostListView: View {
    let vm: PostListViewModel
    init(_ blog: Blog) {
        self.vm = PostListViewModel(blog)
    }
    var body: some View {
        NavigationView {
            List {
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
            List {
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
