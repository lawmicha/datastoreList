## DataStore Blog Post Comment

This is a getting started with DataStore using the default Blog/Post/Comment schema from `amplify add api`

1. `amplify init`

2. `amplify add api` 
```
? Please select from one of the below mentioned services: GraphQL
? Provide API name: apilist
? Choose the default authorization type for the API API key
? Enter a description for the API key: 
? After how many days from now the API key should expire (1-365): 365
? Do you want to configure advanced settings for the GraphQL API No, I am done.
? Do you have an annotated GraphQL schema? No
? Choose a schema template: One-to-many relationship (e.g., “Blogs” with “Posts” and “Comments”)
```

3. `amplify push` and `amplify codegen models`

4. `pod install`

5. `xed .`

6. Click Populate to create 10 Blogs, 10 Posts for each blog, 10s Comment for each post

7. `amplify console api` and query for blogs, post and comments, ie.

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
8. Once the app has completed saving, click on "View Data" to display the blogs/post/comments

8. Click "Load more" to display more items for the same page.







