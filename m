Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A4C166210
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 17:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgBTQOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 11:14:43 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46135 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgBTQOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 11:14:43 -0500
Received: by mail-qt1-f194.google.com with SMTP id i14so3216946qtv.13
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 08:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlgOWD70sGSD6Q6S9d4i72Mqm2+mfzaFs9aekElBY4s=;
        b=fJGjxpzwZas2SHHKSac3FieS+YV+ZCc43Btj+4opOVqOcyC/1BsWh9vYTYpcJflbxj
         bi8SP09WCEX0BuoxK2iofVOrukIOhubAb2SiyZz0MX8wyxa9GEOVmaDXmiZpSbInf1rs
         8zx4XtVZrQcwl93tG+E4pR8A83Aku1/0j9YpQDwj1CBFeaf/o8F2c+ydA65cP9eS5fKR
         KuB/BO57DQhDr1yI5OYd4lA706QlaNzNP+HJe2udc+42gZrYcSeTSzdwU60bleQlGw/n
         8T9oy6tYc8+KPiZmldHgedqBts/6xmytW6biWJGmxFe5euSENk8/pGJzUu4T29gGFbsN
         QYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vlgOWD70sGSD6Q6S9d4i72Mqm2+mfzaFs9aekElBY4s=;
        b=bqv8jMTjtHIpkUyAeJzrPaMsLnNvXOEGX8hexsOQIJHJOH1LSR54N7AaYkgZzv0Jyb
         R1E2O5BPFVPCgyx1nY2rLN3Rbm2oWJaKQ9FEY1y3dX/s5VszHtSoqKiW/78VijePYf1m
         /m52gbfyVRYFuPYxcM5vVqg/H+4yf7gtvZgMXRsjkO19oZencO3Xp/It/NNzkFnPpq5/
         s/Jb4dq+FEnO4tJ7OwXk8JY5wkbuw8jf8vyKmCkA/snSpWKO5jNOs6lhh3vX87DQQ6Wj
         ZRenoHLtXmoVSZJjfM9jaYY9m1gBGAkHSq7Ibg2pdFgV6qS3ba5rVheJO/v6AOM8KB/V
         HO5w==
X-Gm-Message-State: APjAAAVI1tP2uvH+jDkcSfBniCoCJM7Lrp0NQGM1kc/hG+9biFOK6JQ4
        DVQnlXJSkfdICJjvohCjnwh6tPaCqAnUrE7NZkXHgcA0Jkcdrw==
X-Google-Smtp-Source: APXvYqzro9bjUdDoqdxbO0hSHg5hQHKSxY20PYs5XLGavt8RUKl/gt8SVHfere+lkXEy7e/cn+yK2SGy/Ek+Bmhbm/o=
X-Received: by 2002:ac8:340c:: with SMTP id u12mr26975327qtb.257.1582215281878;
 Thu, 20 Feb 2020 08:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
 <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
 <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
 <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
 <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
 <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
 <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com>
 <CACT4Y+bSBD_=rmGCF3mngiRKOfa7cv0odFaadF1wyEV9NVhQcg@mail.gmail.com>
 <CAHmME9pQQhQtg8JymxMbSMgnhZ9BpjEoTb=sSNndjp1rXnzi_Q@mail.gmail.com>
 <CAHmME9or-Wwx63ZtwYzOWV9KQJY1aarx2Eh8iF2P--BXfz6u+g@mail.gmail.com>
 <CACT4Y+a8N7_n4t_vxezKJVkd1+gDHaMzpeG18MuDE04+r3341A@mail.gmail.com>
 <CACT4Y+atqrSfZuquPZcRUKNtVbLdu+B5YN3=YmDb38Ruzj3Pzw@mail.gmail.com>
 <CACT4Y+bMzYZeMvv2DdTuTKtJFzTcHhinp7N7VmSiXqSBDyj8Ug@mail.gmail.com>
 <CACT4Y+bUXAstk41RPSF-EQDh7A8-XkTbc53nQTHt4DS5AUhr-A@mail.gmail.com> <CAHmME9pr4=cn5ijSNs05=fjdfQon49kyEzymkUREJ=xzTZ7Q7w@mail.gmail.com>
In-Reply-To: <CAHmME9pr4=cn5ijSNs05=fjdfQon49kyEzymkUREJ=xzTZ7Q7w@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 20 Feb 2020 17:14:30 +0100
Message-ID: <CACT4Y+aTBNZAekX_D+QdofqBdUuG9BkzLq+TFDxr8-sSqL9hdQ@mail.gmail.com>
Subject: Re: syzkaller wireguard key situation [was: Re: [PATCH net-next v2]
 net: WireGuard secure network tunnel]
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 11:23 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Feb 18, 2020 at 11:00 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > I've added descriptions for wireguard packets:
> > https://github.com/google/syzkaller/commit/012fbc3229ebef871a201ea431b16610e6e0d345
> > It gives all reachable coverage (without breaking crypto).
>
> Oh, great, that looks really good. It now fails at the index match,
> which is basically trying to brute force a 32-bit integer that's
> changing every 3 minutes, which syzkaller is probably too slow to do
> on it's own. But that's fine.
>
> Your commit has some questions in it, like "# Not clear if these
> indexes are also generated randomly and we need to guess them or
> not.". Here's what's up with those indices:
>
> Message message_handshake_initiation: the sender picks a random 32-bit
> number, and places it in the "sender_index" field.
> Message message_handshake_response: the sender picks a random 32-bit
> number, and places it in the "sender_index" field. It places the
> 32-bit number that it received from message_handshake_initiation into
> the "receiver_index" field.
> Message message_handshake_cookie: the sender places the 32-bit number
> that it received from message_handshake_initiation or
> message_handshake_response into the "receive_index" field.
> Message message_data: the sender places the 32-bit number that it
> picked for the  message_handshake_initiation or
> message_handshake_response into the "key_idx" field.
>
> I'm not sure it'll be too feasible to correlate these relations via
> fuzzing. And either way, I think we've got decent enough non-crypto
> coverage now on the receive path.
>
> I noticed a small seemingly insignificant function with low coverage
> that's on the rtnl path that might benefit from some attention and
> also help find bugs in other devices: wg_netdevice_notification. This
> triggers on various things, but the only case it really cares about is
> NETDEV_REGISTER, which happens when the interface changes network
> namespaces. WireGuard holds a reference to its underlying creating
> namespace, and in order to avoid circular reference counting or UaF it
> needs to either relinquish or get a reference. There are other drivers
> with similar type of reference counting management, I would assume.
> This sort of thing seems up the ally of the types of bugs and races
> syzkaller likes to find. The way to trigger it is with `ip link set
> dev wg0 netns blah`, and then back to its original netns. That's this
> code in net/core/rtnetlink.c:
>
>        if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] ||
> tb[IFLA_TARGET_NETNSID]) {
>                struct net *net = rtnl_link_get_net_capable(skb, dev_net(dev),
>                                                            tb, CAP_NET_ADMIN);
>                if (IS_ERR(net)) {
>                        err = PTR_ERR(net);
>                        goto errout;
>                }
>
>                err = dev_change_net_namespace(dev, net, ifname);
>                put_net(net);
>                if (err)
>                        goto errout;
>                status |= DO_SETLINK_MODIFIED;
>        }
>
> That seems to have decent coverage, but not over wireguard. Is that
> just a result of the syzkaller @devname not yet being expanded to
> wg{0,1,2}, and it'll take a few more weeks for it to learn that?
> @netns_id seems probably good, being restricted to 0:4; is it possible
> these weren't created though a priori?

Running an instance aimed at these functions:

"enable_syscalls": [
"socket$nl_generic",
"syz_genetlink_get_family_id$wireguard",
"sendmsg$WG_CMD*",
"ioctl$ifreq_SIOCGIFINDEX_wireguard*",
"socket$nl_route",
"sendmsg$nl_route",
"setsockopt",
"syz_emit_ethernet",
"syz_extract_tcp_res",
"socket$inet*",
"accept4$inet*",
"bind$inet*",
"connect$inet*",
"sendto$inet*",
"recvfrom$inet*",
"syz_genetlink_get_family_id$fou",
"sendmsg$FOU*",
"unshare",
"setns",
"socket",
"socketpair",
"getuid",
"getgid",
"bpf",
"setsockopt",
"getsockopt",
"ioctl",
"accept4",
"connect",
"bind",
"listen",
"sendmsg",
"recvmsg",
"syz_emit_ethernet",
"syz_extract_tcp_res",
"write$tun",
"syz_init_net_socket",
"syz_genetlink_get_family_id",
"syz_open_procfs$namespace",
"ioctl$NS_GET*",
"ioctl$TUN*",
"openat$tun",
"getpid",
"mmap"
]

I got some coverage in wg_netdevice_notification:
https://imgur.com/a/1sJZKtp

Or you mean the parts that are still red?

I think theoretically these parts should be reachable too because
syzkaller can do unshare and obtain net ns fd's.

It's quite hard to test because it just crashes all the time on known bugs.
So maybe the most profitable way to get more coverage throughout the
networking subsystem now is to fix the top layer of crashers ;)

2020/02/20 16:29:08 vm-9: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 16:32:25 vm-6: crash: kernel BUG at net/core/skbuff.c:LINE!
2020/02/20 16:33:13 vm-16: crash: INFO: task hung in register_netdevice_notifier
2020/02/20 16:33:46 vm-5: crash: INFO: task hung in register_netdevice_notifier
2020/02/20 16:34:22 vm-2: crash: WARNING in restore_regulatory_settings
2020/02/20 16:34:27 vm-4: crash: unregister_netdevice: waiting for DEV
to become free
2020/02/20 16:35:04 vm-26: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 16:35:17 vm-34: crash: no output from test machine
2020/02/20 16:35:20 vm-0: crash: INFO: task hung in register_netdevice_notifier
2020/02/20 16:36:42 vm-3: crash: WARNING in restore_regulatory_settings
2020/02/20 16:37:47 vm-29: crash: INFO: task hung in register_netdevice_notifier
2020/02/20 16:38:54 vm-31: crash: INFO: task hung in register_netdevice_notifier
2020/02/20 16:39:00 vm-9: crash: INFO: task hung in register_netdevice_notifier
2020/02/20 16:41:41 vm-4: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 16:43:00 vm-23: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 16:44:01 vm-2: crash: possible deadlock in htab_lru_map_delete_node
2020/02/20 16:44:06 vm-38: crash: INFO: task hung in register_netdevice_notifier
2020/02/20 16:47:13 vm-8: crash: unregister_netdevice: waiting for DEV
to become free
2020/02/20 16:47:20 vm-25: crash: unregister_netdevice: waiting for
DEV to become free
2020/02/20 16:47:33 vm-18: crash: BUG: using smp_processor_id() in
preemptible [ADDR] code: syz-executor
2020/02/20 16:49:37 vm-37: crash: unregister_netdevice: waiting for
DEV to become free
2020/02/20 16:51:51 vm-12: crash: WARNING in print_bfs_bug
2020/02/20 16:53:28 vm-4: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 16:55:24 vm-17: crash: INFO: task hung in register_netdevice_notifier
2020/02/20 16:56:26 vm-34: crash: BUG: MAX_LOCKDEP_KEYS too low!
2020/02/20 16:57:11 vm-3: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 16:57:44 vm-31: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 16:58:13 vm-33: crash: BUG: MAX_LOCKDEP_KEYS too low!
2020/02/20 16:58:35 vm-32: crash: BUG: using smp_processor_id() in
preemptible [ADDR] code: syz-executor
2020/02/20 17:03:12 vm-9: crash: INFO: task hung in raw_release
2020/02/20 17:03:20 vm-3: crash: unregister_netdevice: waiting for DEV
to become free
2020/02/20 17:03:26 vm-6: crash: BUG: using smp_processor_id() in
preemptible [ADDR] code: syz-executor
2020/02/20 17:05:08 vm-31: crash: INFO: task hung in lock_sock_nested
2020/02/20 17:06:01 vm-16: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 17:06:24 vm-26: crash: INFO: task hung in bcm_release
2020/02/20 17:07:20 vm-27: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 17:08:03 vm-11: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
2020/02/20 17:08:05 vm-17: crash: WARNING in hsr_addr_subst_dest
2020/02/20 17:09:12 vm-22: crash: BUG: MAX_LOCKDEP_ENTRIES too low!
