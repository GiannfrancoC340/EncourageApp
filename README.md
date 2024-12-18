# Encourage

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Encourage is an app that displays a random positive message of encouragement for users daily. The user can select between various categories of encouragement such as Motivation and Self-Love, and click a button to receive a random message daily. The user can repeat this for every category daily. It will only be 1 message per day. The user can sign up or log in to an account as well. The purpose of this app is to try and uplift as many people as possible in a way that is effective and widespread. I have struggled with trying to stay positive under certain scenarios, so I know what its like to feel a certain type of way. I want to help reassure people that its okay to feel down sometimes, and make sure people feel good when they hear positive words to uplift them.

### App Evaluation

- **Category:** Productivity.
- **Mobile:** Yes, Mobile App only.
- **Story:**  I want to try to motivate and uplift as many people as possible with simple messages. They can reach thousands of people with a few clicks and it can be effective and widespread.
- **Market:** Anyone. From ages 12-90.
- **Habit:** Daily use.
- **Scope:** Narrow.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can sign up for an account.
* User can log in to an existing account.
* User can reset their password if they forgot it.
* Once logged in, the user can see a welcome message and a list of categories.
* User can scroll through the categories until the bottom.
* There will be a tab bar controller to see the home page, mood tracker page, and profile page.
* When clicking on each category, there will be a section to generate a message via button.
* There will also be a section at the bottom to display that message.
* The user can rate it with a thumbs up or thumbs down.
* The user can go back and repeat the same process with other categories.
* If the user wants to go back to a category they have received a message, the message will still be there until the daily limit ends.
* There will be a daily limit for generating messages.
* Generating messages will be free.
* In the mood tracker screen, the user can type how they feel. Users can log in and track how they feel when they receive a message. It can be before or after they receive a message.
* User can type into a large textbox how they feel, and share how the messages have affected them.
* It will be private for every user.
* The textbox will be separated by day.
* In the profile screen, the user can see the email of their account.
* The user can reset their password here.
* The user can also sign out here.
* Everytime the user creates a new account, it will be tracked in the database.
* There will be a Settings Button/Tab.
* The user can see all important settings here.

**Optional Nice-to-have Stories**

* The user can create a username.
* The username will be displayed under the email in the Profile screen.
* The user can change their username in the Profile screen.
* The user can add a ribbon next to a message to save it as a favorite.
* The user can see a tab called Favorites to see all their favorite messages.
* The database will store all generated messages.

### 2. Screen Archetypes

- [ ] **Login Screen**
* User can log in to an account.
* User can sign up for an account.
* User can reset their password if they forgot.
- [ ] **Home Screen**
* User can see a welcome message and categories to click on.
* User can scroll to the bottom to see all available categories to click.
* When clicking on a category, it will take the user to the Category Screen.
* The user can click the Settings button to see all the settings.
- [ ] **Settings Screen**
* The user can see all settings here.
* User can scroll to the bottom to see all available settings.
* User can go back to the home screen in the top left.
- [ ] **Category Screen**
* The user can see 2 sections: a top section that has a button to generate the message, and a bottom section to display the message.
* User can click the button and it will generate a message to be shown at the bottom.
* For each category, the user can generate a message once per day.
* The user can go back to the previous screen in the top left.
- [ ] **Mood Tracker Screen**
* The user can track how they feel when they receive a message. It can be before or after they receive a message.
* User can type into a large textbox how they feel, and share how the messages have affected them.
* It will be separated based on day.
- [ ] **Profile Screen**
* User can see the email of the account they are signed in to.
* User can change their password here.
* User can sign out if they choose.

### 3. Navigation

**Tab Navigation** (Tab to Screen)


- [ ] Home Screen
- [ ] Mood Tracker Screen
- [ ] Profile Screen

**Flow Navigation** (Screen to Screen)

- [ ] **Login Screen**
  * Leads to **Home Screen**
- [ ] **Home Screen**
  * Leads to **Settings Screen**
- [ ] **Home Screen**
  * Leads to **Category Screen**
- [ ] **Mood Tracker Screen**
  * Leads to itself
- [ ] **Profile Screen**
  * Leads to **Login Screen**


## Wireframes

![IMG_2639](https://github.com/user-attachments/assets/49462e71-135d-4f04-8bb6-77b93a7f5fd1)

![IMG_2640](https://github.com/user-attachments/assets/6769afe2-3361-4038-92fe-f547097184a5)

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 


### Models

[Model Name, e.g., User]
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| username | String | unique id for the user post (default field)   |
| password | String | user's password for login authentication      |
| ...      | ...    | ...                          


### Networking

- [List of network requests by screen]
- [Example: `[GET] /users` - to retrieve user data]
- ...
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
