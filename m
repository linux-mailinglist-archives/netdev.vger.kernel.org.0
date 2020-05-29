Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732591E84DD
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgE2Rca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgE2RcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:32:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8B3C008634;
        Fri, 29 May 2020 10:32:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a4so87979pfo.4;
        Fri, 29 May 2020 10:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xSIlGQHFnhBRTaujpeSu6NCSShwDd3XiqYjBdiAZ4IA=;
        b=ISEcv9sA43BgP6UFAZLSCdeeYtUUC9sOL4OIjLb8shR/Gtknog6HhSvm5vmbZ8FYjA
         o8kWJiqyNSzzlg+QfYcYC5iEfRY1nEiCvu36LgpQBr4I7X5Lm3b+jCwffrB0z0b6yXYl
         A6AVOBAs0hzsjLlOYfEF5STq/Jq7oAtKkzdfIn/THx3x37fX68myKS/OpEcwBpsf/yyS
         QzZCnX3ZbOgLcIM6PQU9wwUXkc8uJ9tr8KVIFg3byNMqWp3xP/MuE0oFTTp4CoY3LDvF
         K0vo7y/hjWPg92TRSEbzv9gBqqdzw1EF9Q2gH51917maZ95RG7C4Cj4fTPRgDJbYEkKG
         hBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xSIlGQHFnhBRTaujpeSu6NCSShwDd3XiqYjBdiAZ4IA=;
        b=FMsz3AZ2qadDb2KkTRZjseQRJCcuh8byAzx8Cnn2+p1DaO8I8GP1MmWptwqCR4DnTK
         JvvkorRW0Ya1zkbOjThTLheNTSPYVbmdvKSufbPavL5sNoU6FCa/5a8SS/677w2LzR8u
         JFQoUIXiGe8oaM9vJ/AddidlfD1LYgVRcrZg3msFCpc95hNdgl+vFeD22ozewt2btFqv
         jfUxsKaEZ6cC4MG2hfMaKNKWDB0YMxI+/8G1BKcePwzjrdixpMR0YJ/dcg+h+OK0MX5e
         DIx2Wan6bafNk7JsG2zOfdS3u+IOEQUUTMxeMTpctpunj93l4dM3IdJcSAhU3k3x+oWw
         oMrA==
X-Gm-Message-State: AOAM533Cb0Z2q7UDbPY1FSOE+rHdzXYo06iMsFX5TqAGseXohFAlPtov
        8gPnXa64PayzeaiRfwRAzGs=
X-Google-Smtp-Source: ABdhPJyOl9/wFb/7bBEsVNiQqgJNms/qK0reUIcRYpbpHVEKJ53Dq2Qq4In5F+B/qN8bFou4U0kTWw==
X-Received: by 2002:a62:641:: with SMTP id 62mr9464558pfg.283.1590773545181;
        Fri, 29 May 2020 10:32:25 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j6sm87712pjb.0.2020.05.29.10.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 10:32:24 -0700 (PDT)
Subject: Re: general protection fault in inet_unhash
To:     Andrii Nakryiko <andriin@fb.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, guro@fb.com,
        kuba@kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <00000000000018e1d305a6b80a73@google.com>
 <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
 <CACT4Y+aNBkhxuMOk4_eqEmLjHkjbw4wt0nBvtFCw2ssn3m2NTA@mail.gmail.com>
 <da6dd6d1-8ed9-605c-887f-a956780fc48d@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b1b315b5-4b1f-efa1-b137-90732fa3f606@gmail.com>
Date:   Fri, 29 May 2020 10:32:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <da6dd6d1-8ed9-605c-887f-a956780fc48d@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/20 11:32 PM, Andrii Nakryiko wrote:
> On 5/28/20 11:23 PM, Dmitry Vyukov wrote:
>> On Thu, May 28, 2020 at 11:01 PM 'Andrii Nakryiko' via syzkaller-bugs
>> <syzkaller-bugs@googlegroups.com> wrote:
>>>
>>> On 5/28/20 9:44 AM, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following crash on:
>>>>
>>>> HEAD commit:    dc0f3ed1 net: phy: at803x: add cable diagnostics support f..
>>>> git tree:       net-next
>>>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D17289cd2100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=t1v5ZakZM9Aw_9u_I6FbFZ28U0GFs0e9dMMUOyiDxO4&e=
>>>> kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D7e1bc97341edbea6&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=yeXCTODuJF6ExmCJ-ppqMHsfvMCbCQ9zkmZi3W6NGHo&e=
>>>> dashboard link: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D3610d489778b57cc8031&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=8fAJHh81yojiinnGJzTw6hN4w4A6XRZST4463CWL9Y8&e=
>>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>>> syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D15f237aa100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=cPv-hQsGYs0CVz3I26BmauS0hQ8_YTWHeH5p-U5ElWY&e=
>>>> C reproducer:   https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.c-3Fx-3D1553834a100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=r6sGJDOgosZDE9sRxqFnVibDNJFt_6IteSWeqEQLbNE&e=
>>>>
>>>> The bug was bisected to:
>>>>
>>>> commit af6eea57437a830293eab56246b6025cc7d46ee7
>>>> Author: Andrii Nakryiko <andriin@fb.com>
>>>> Date:   Mon Mar 30 02:59:58 2020 +0000
>>>>
>>>>       bpf: Implement bpf_link-based cgroup BPF program attachment
>>>>
>>>> bisection log:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_bisect.txt-3Fx-3D1173cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=rJIpYFSAMRfea3349dd7PhmLD_hriVwq8ZtTHcSagBA&e=
>>>> final crash:    https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_report.txt-3Fx-3D1373cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=TWpx5JNdxKiKPABUScn8WB7u3fXueCp7BXwQHg4Unz0&e=
>>>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D1573cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=-SMhn-dVZI4W51EZQ8Im0sdThgwt9M6fxUt3_bcYvk8&e=
>>>>
>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>> Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
>>>> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
>>>>
>>>> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
>>>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>>>> CPU: 0 PID: 7063 Comm: syz-executor654 Not tainted 5.7.0-rc6-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>> RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
>>>
>>> No idea why it was bisected to bpf_link change. It seems completely
>>> struct sock-related. Seems like
>>
>> Hi Andrii,
>>
>> You can always find a detailed explanation of syzbot bisections under
>> the "bisection log" link.
> 
> Right. Sorry, I didn't mean that bisect went wrong or anything like that. I just don't see how my change has anything to do with invalid socket state. As I just replied in another email, this particular repro is using bpf_link_create() for cgroup attachment, which was added in my patch. So running repro before my patch would always fail to attach BPF program, and thus won't be able to repro the issue (because the bug is somewhere in the interaction between BPF program attachment and socket itself). So it will always bisect to my patch :)

L2TP seems to use sk->sk_node to insert sockets into l2tp_ip_table, _and_ uses l2tp_ip_prot.unhash == inet_unhash

So if/when BPF_CGROUP_RUN_PROG_INET_SOCK(sk) returns an error and inet_create() calls sk_common_release()
bad things happen, because inet_unhash() expects a valid hashinfo pointer.

I guess the following patch should fix this.

Bug has been there forever, but only BPF_CGROUP_RUN_PROG_INET_SOCK(sk) could trigger it.

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 10cf7c3dcbb3fb1b27657588f3d1ba806cba737f..097c80c0e323777df997a189eb456e3ae6d26888 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -231,6 +231,7 @@ int l2tp_nl_register_ops(enum l2tp_pwtype pw_type,
                         const struct l2tp_nl_cmd_ops *ops);
 void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
 int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg);
+void l2tp_unhash(struct sock *sk);
 
 static inline void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel)
 {
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 0d7c887a2b75db65afba7955a2bf9572a6a37786..461bffa534a039410070834ac6144c23239a27bb 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -221,6 +221,16 @@ static int l2tp_ip_open(struct sock *sk)
        return 0;
 }
 
+void l2tp_unhash(struct sock *sk)
+{
+       if (sk_unhashed(sk))
+               return;
+       write_lock_bh(&l2tp_ip_lock);
+       sk_del_node_init(sk);
+       write_unlock_bh(&l2tp_ip_lock);
+}
+EXPORT_SYMBOL(l2tp_unhash);
+
 static void l2tp_ip_close(struct sock *sk, long timeout)
 {
        write_lock_bh(&l2tp_ip_lock);
@@ -595,7 +605,7 @@ static struct proto l2tp_ip_prot = {
        .recvmsg           = l2tp_ip_recvmsg,
        .backlog_rcv       = l2tp_ip_backlog_recv,
        .hash              = inet_hash,
-       .unhash            = inet_unhash,
+       .unhash            = l2tp_unhash,
        .obj_size          = sizeof(struct l2tp_ip_sock),
 #ifdef CONFIG_COMPAT
        .compat_setsockopt = compat_ip_setsockopt,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index d148766f40d117c50fc28092173d3686428d1dfc..1d9911937aad524c9ad5edcdf23297b81c2d0a21 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -729,7 +729,7 @@ static struct proto l2tp_ip6_prot = {
        .recvmsg           = l2tp_ip6_recvmsg,
        .backlog_rcv       = l2tp_ip6_backlog_recv,
        .hash              = inet6_hash,
-       .unhash            = inet_unhash,
+       .unhash            = l2tp_unhash,
        .obj_size          = sizeof(struct l2tp_ip6_sock),
 #ifdef CONFIG_COMPAT
        .compat_setsockopt = compat_ipv6_setsockopt,



> 
>>
>>> struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
>>>
>>> ends up being NULL.
>>>
>>> Can some more networking-savvy people help with investigating this, please?
>>>
>>>> Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
>>>> RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
>>>> RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
>>>> RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
>>>> RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
>>>> R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
>>>> R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
>>>> FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> Call Trace:
>>>>    sk_common_release+0xba/0x370 net/core/sock.c:3210
>>>>    inet_create net/ipv4/af_inet.c:390 [inline]
>>>>    inet_create+0x966/0xe00 net/ipv4/af_inet.c:248
>>>>    __sock_create+0x3cb/0x730 net/socket.c:1428
>>>>    sock_create net/socket.c:1479 [inline]
>>>>    __sys_socket+0xef/0x200 net/socket.c:1521
>>>>    __do_sys_socket net/socket.c:1530 [inline]
>>>>    __se_sys_socket net/socket.c:1528 [inline]
>>>>    __x64_sys_socket+0x6f/0xb0 net/socket.c:1528
>>>>    do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>>>>    entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>>> RIP: 0033:0x441e29
>>>> Code: e8 fc b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>>>> RSP: 002b:00007ffdce184148 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
>>>> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441e29
>>>> RDX: 0000000000000073 RSI: 0000000000000002 RDI: 0000000000000002
>>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>>> R13: 0000000000402c30 R14: 0000000000000000 R15: 0000000000000000
>>>> Modules linked in:
>>>> ---[ end trace 23b6578228ce553e ]---
>>>> RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
>>>> Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
>>>> RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
>>>> RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
>>>> RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
>>>> RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
>>>> R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
>>>> R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
>>>> FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>
>>>>
>>>> ---
>>>> This bug is generated by a bot. It may contain errors.
>>>> See https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=NELwknC4AyuWSJIHbwt_O_c0jfPc_6D9RuKHh_adQ_Y&e=  for more information about syzbot.
>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>>
>>>> syzbot will keep track of this bug report. See:
>>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23status&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=YfV-e6A04EIqHwezxYop7CpJyhXD8DVzwTPUT0xckaM&e=  for how to communicate with syzbot.
>>>> For information about bisection process see: https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23bisection&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=xOFzqI48uvECf4XFjlhNl4LBOT02lz1HlCL6MT1uMrI&e=
>>>> syzbot can test patches for this bug, for details see:
>>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23testing-2Dpatches&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=_cj6MOAz3yNlXgjMuyRu6ZOEjRvYWEvtTd7kE46wVfo&e=
>>>>
>>>
>>> -- 
>>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>>> To view this discussion on the web visit https://urldefense.proofpoint.com/v2/url?u=https-3A__groups.google.com_d_msgid_syzkaller-2Dbugs_d65c8424-2De78c-2D63f9-2D3711-2D532494619dc6-2540fb.com&d=DwIFaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=b2VQiGg0nrxk96tqrmflMQ24DJk-MOxx4uyOs7wSUJ0&s=TYFus0Dh0-ZHiL510kJIyPOWCyX34UzLWR4QvS3r_iY&e= .
> 
