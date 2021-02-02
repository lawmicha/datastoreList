## DataStore Blog Post Comment

This is a getting started with DataStore using the default Blog/Post/Comment schema from `amplify add api`

1. `amplify init`

2. `amplify add api` 
```
? Please select from one of the below mentioned services: GraphQL
? Provide API name: datastorelist
? Choose the default authorization type for the API API key
? Enter a description for the API key: 
? After how many days from now the API key should expire (1-365): 365
? Do you want to configure advanced settings for the GraphQL API No, I am done.
? Do you have an annotated GraphQL schema? No
? Choose a schema template: One-to-many relationship (e.g., “Blogs” with “Posts” and “Comments”)
```
3. `amplify update api` and choose Enable for DataStore

5. `amplify push` and `amplify codegen models`

6. `pod install`

7. `xed .`

8. Click Populate to create 10 Blogs, 10 Posts for each blog, 10s Comment for each post

9. `amplify console api` and query for blogs, post and comments, ie.

```
query MyQuery {
  listBlogs {
    items {
      createdAt
      id
      name
    }
    nextToken
  }
  listComments {
    items {
      content
      id
      postID
    }
    nextToken
  }
  listPosts {
    items {
      id
      title
      blogID
    }
    nextToken
  }
}


```
9. Once the app has completed saving, when the console logging finishes, click on View to display the blogs/post/comments







