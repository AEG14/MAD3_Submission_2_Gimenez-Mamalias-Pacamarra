# REST Activity

## Project Division and Task Contributions

### Harley Mamalias:

- Task 1: Get or Show All Posts
- Task 2: Show Details of Specific Posts

### Aithan Gimenez:

- Task 3: Add a new post
- Task 7: Validation on inputs

### Anthony Pacamarra:

- Task 5: Edit a Post
- Task 6: Delete a Post

## Initial Project Setup

Harley Mamalias initiated the project and set up the foundational structure, defining show functionalities and interfaces for tasks 1 and 2.

## Post-Merge Modifications and Conflict Resolution

After the implementation of individual tasks and merging everything, several issues were identified, particularly with newly added posts not being editable or have displayable details. To resolve these conflicts and improve functionality:

- Aithan Gimenez revised the `updatePost` and `getPostById` methods. These methods were modified to first check for errors when interacting with external resources (jsonplaceholder). If an error occurred, the methods were updated to retrieve and update posts locally from the `localPost` list instead. Thus making the new posts editable and have displayable details.

- Anthony Pacamarra addressed validation concerns related to the postId in new posts. When deleting posts, the `_highestId` seems to be not updated. Thus, he improved the functionality for deleting posts, to update the `_highestId`, so that newly added posts will have their postId correctly displayed.

- Harley Mamalias redesigned the aesthetics of the entire user interface, enhancing the overall user experience.
