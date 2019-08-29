# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(
    [
        {
            "icon": "",
            "identity": "takaishi",
            "introduction": "チーフ",
            "name": "高石",
            "password": "kazuki",
            "unsubscribed": false
        },
        {
            "icon": "",
            "identity": "ozaki",
            "introduction": "次期チーフ筆頭候補",
            "name": "OZAKI",
            "password": "yu",
            "unsubscribed": false
        },
        {
            "icon": "",
            "identity": "shiga",
            "introduction": "帰宅部",
            "name": "SHIGASHI",
            "password": "yuya",
            "unsubscribed": false
        }
    ]
)

BodyPart.create!(
            [
                {"name": "上腕三頭筋"},
                {"name": "表情筋"},
                {"name": "腹筋"}
            ]
)

MusclePost.create!(
              [
                  {
                      "title": "腕立て",
                      "body": "腕立て千回",
                      "user_id": 2
                  },
                  {
                      "title": "腹筋",
                      "body": "腹筋千回",
                      "user_id": 2
                  },
                  {
                      "title": "超腕立て",
                      "body": "腕立て5千回",
                      "user_id": 1
                  },
                  {
                      "title": "超腹筋",
                      "body": "腹筋5千回",
                      "user_id": 1
                  },
                  {
                      "title": "全身筋トレ",
                      "body": "なんかすごい動き",
                      "user_id": 1
                  }
              ]
)

TagMap.create!(
          [
              {
                  "body_part_id": 1,
                  "muscle_post_id": 1
              },
              {
                  "body_part_id": 2,
                  "muscle_post_id": 2
              },
              {
                  "body_part_id": 1,
                  "muscle_post_id": 3
              },
              {
                  "body_part_id": 2,
                  "muscle_post_id": 4
              },
              {
                  "body_part_id": 1,
                  "muscle_post_id": 5
              },
              {
                  "body_part_id": 2,
                  "muscle_post_id": 5
              },
              {
                  "body_part_id": 3,
                  "muscle_post_id": 5
              }
          ]
)