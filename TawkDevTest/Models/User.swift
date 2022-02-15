//
//  User.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 14/02/22.
//

import CoreData
import Foundation

/// Github User Model
@objc(User)
class User: NSManagedObject, Codable {
    @NSManaged var id: Int32
    @NSManaged var login: String?
    @NSManaged var nodeID: String?
    @NSManaged var avatarURL: String?
    @NSManaged var gravatarID: String?
    @NSManaged var url: String?
    @NSManaged var htmlURL: String?
    @NSManaged var followersURL: String?
    @NSManaged var followingURL: String?
    @NSManaged var gistsURL: String?
    @NSManaged var starredURL: String?
    @NSManaged var subscriptionsURL: String?
    @NSManaged var organizationsURL: String?
    @NSManaged var reposURL: String?
    @NSManaged var eventsURL: String?
    @NSManaged var receivedEventsURL: String?
    @NSManaged var type: String?

    @NSManaged var name: String?
    @NSManaged var company: String?
    @NSManaged var blog: String?
    @NSManaged var notes: String?
    @NSManaged var followers: Int32
    @NSManaged var following: Int32 

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case name
        case company
        case blog
        case notes
        case followers
        case following
    }

    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
        else {
            fatalError("Failed to decode User")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.decode(String.self, forKey: .login)
        id = try container.decode(Int32.self, forKey: .id)
        nodeID = try container.decode(String.self, forKey: .nodeID)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
        gravatarID = try container.decode(String.self, forKey: .gravatarID)
        url = try container.decode(String.self, forKey: .url)
        htmlURL = try container.decode(String.self, forKey: .htmlURL)
        followersURL = try container.decode(String.self, forKey: .followersURL)
        followingURL = try container.decode(String.self, forKey: .followingURL)
        gistsURL = try container.decode(String.self, forKey: .gistsURL)
        starredURL = try container.decode(String.self, forKey: .starredURL)
        subscriptionsURL = try container.decode(String.self, forKey: .subscriptionsURL)
        organizationsURL = try container.decode(String.self, forKey: .organizationsURL)
        reposURL = try container.decode(String.self, forKey: .reposURL)
        eventsURL = try container.decode(String.self, forKey: .eventsURL)
        receivedEventsURL = try container.decode(String.self, forKey: .receivedEventsURL)
        type = try container.decode(String.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        company = try container.decodeIfPresent(String.self, forKey: .company)
        blog = try container.decodeIfPresent(String.self, forKey: .blog)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        followers = try container.decodeIfPresent(Int32.self, forKey: .followers) ?? 0
        following = try container.decodeIfPresent(Int32.self, forKey: .following) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(login, forKey: .login)
        try container.encode(id, forKey: .id)
        try container.encode(nodeID, forKey: .nodeID)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(gravatarID, forKey: .gravatarID)
        try container.encode(url, forKey: .url)
        try container.encode(htmlURL, forKey: .htmlURL)
        try container.encode(followersURL, forKey: .followersURL)
        try container.encode(followingURL, forKey: .followingURL)
        try container.encode(gistsURL, forKey: .gistsURL)
        try container.encode(starredURL, forKey: .starredURL)
        try container.encode(subscriptionsURL, forKey: .subscriptionsURL)
        try container.encode(organizationsURL, forKey: .organizationsURL)
        try container.encode(reposURL, forKey: .reposURL)
        try container.encode(eventsURL, forKey: .eventsURL)
        try container.encode(receivedEventsURL, forKey: .receivedEventsURL)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(company, forKey: .company)
        try container.encodeIfPresent(blog, forKey: .blog)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(following, forKey: .following)
        try container.encodeIfPresent(followers, forKey: .followers)
    }
}

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
}
