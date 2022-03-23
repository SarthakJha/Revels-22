import Foundation

struct entrydat:Codable{
    let entry_data:profile
}

struct profile:Codable{
    let ProfilePage:[graphh]
}

struct graphh:Codable{
    let graphql:user1
}

struct user1:Codable{
    let user:edge_media
}

struct edge_media:Codable {
    let edge_owner_to_timeline_media:Edges
}

struct Edges: Codable {
    let edges: [Node]
}

struct Node: Codable {
    let node: Media
}

struct Media: Codable {
    let display_url: String
    let edge_media_to_comment:num
    let edge_liked_by:num
    let shortcode:String
}

struct num:Codable {
    let count:Int
}
