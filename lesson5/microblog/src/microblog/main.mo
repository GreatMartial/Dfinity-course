import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

actor {
    public type Message = {
        lastTime: Time.Time;
        msg: Text;
        author: Text;
    };

    public type Microblog = actor {
        follow: shared(Principal) -> async (); 
        follows: shared query () -> async [Principal];
        post: shared(Text) -> async ();
        posts: shared query (Time.Time) -> async [Message]; // 返回所有发布的消息
        timeline: shared (Time.Time) -> async [Message]; // 返回所有关注对象发布的消息
        set_name: shared (Text) -> async (); // 设置作者名字
        get_name: shared query () -> async ?Text; // 获取作者名字
    };

    stable var author: Text = "yiyi"

    public shared func set_name(name: Text): async {
        author = name;
    };

    public shared func query get_name(): async ?Text {
        return author;
    };

    var followed: List.List<Principal> = List.nil();

    public shared func follow(id: Principal) : async () {
        followed := List.push(id, followed);
    };
    public shared query func follows() : async [Principal] {
        List.toArray(followed)
    };

    stable var messages: List.List<Message> = List.nil();

    public shared func post(tx: Text) : async () {
        let name = await get_name();
        let now: Time.Time = Time.now();
        var message = {
            lastTime = now;
            msg = tx;
            author = name;
        };

        messages := List.push(message, messages);
    };

    public shared query func posts(since: Time.Time) : async [Message] {
        let timeFunc = func (msg: Message): Bool {
            if (msg.lastTime >= since) {
                return true;
            };
            return false;
        };
        List.toArray(List.filter(messages, timeFunc));
    };
    public shared func timeline(since: Time.Time) : async [Message] {
        var all: List.List<Message> = List.nil();

        for (id in Iter.fromList(followed)) {
            let canister: Microblog = actor(Principal.toText(id));
            let msgs = await canister.posts(since);
            for (msg in Iter.fromArray(msgs)) {
                all := List.push(msg, all)
            }
        };

        List.toArray(all)
    };

    public shared func fetchPosts(canisterId: Text): async [message] {
        var all: List.List<Message> = List.nil();

        let canister: Microblog = actor(canister);
        let msgs = await canister.posts(0);
        for (msg in Iter.fromArray(msgs)) {
            all := List.push(msg, all));
        };

        List.toArray(all);
    }
};