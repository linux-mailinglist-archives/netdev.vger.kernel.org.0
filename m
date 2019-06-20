Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967704CAA3
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 11:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfFTJWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 05:22:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33905 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfFTJWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 05:22:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id k11so2270553wrl.1
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 02:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VUW8pghrki7VFfJ8lAarbeR/4uI+3sn1OoEoiPpk2Ec=;
        b=oQAqVFEEfbga36MiBEkzhXwaIeumqGWR8YTgDUJT9RAWHjblipVj9K1+A0BuaFeKm8
         +lqEnjgsfhob+PJoHi+1fdnOII4HyPkNvNjbYI/Q3pTmnSDDybvx5wz5I3mQBZeQPSfJ
         zq0zN1H8VUHXspfF6hZng1LuVSXRcrsC4BG1zRgNLEaY4MO6qg93oQvh+j5hTuB6BAPm
         iodBr6YvcI279lktL2s2cqtFx11LQ/JnW/YJtKOMgvQdrH0YytagPK674JmX6PVzkN56
         jNTundnS0E88nUi5/Vn03nbXJyJVTMvNMBlAdrD4oymWk/LLKfvO1oelXqMGIwgrLN9j
         gsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VUW8pghrki7VFfJ8lAarbeR/4uI+3sn1OoEoiPpk2Ec=;
        b=T3tOnqZFs481Wla+jmcKPkxPTdMDG/1ZcPUmj2L9/4Oaep5K/g+yBGd+e770KFO85s
         jLuVcowOBA9fQnzxlt8Sg0f4PoA/dq2nnlR5mtSlErkCzYb2eGrbq4V/zT4tjWi6E+Vi
         7eFJxUO/JeBL44RWtJDiLh0xBCd6wEAKZD+iuzJdMIyNhqps0+3rilBm17PSvIKS3EIG
         E05R2lsrAZhZlZdscW+T8mf6ZPkQEsDBS8DC1CvAIhPVPZjjaz8mwHqD/tOSVIpTIXMU
         A6waIBULEMPQE7PRbcaj2Trt1DcO9fpxi+oVtHPlP50tLi+uwnFTKZgC4jiYOavMXvqm
         yjYQ==
X-Gm-Message-State: APjAAAWl0OsFeVsjED7fximE09Hlz06fdGLry5+D5ybtpaTTR6hjWJAI
        tJ1n/qoBkhIx60Tyy/aFDJMHZQ==
X-Google-Smtp-Source: APXvYqw5b4fIqlt6GiUR3C6yAZWC49fRdnOf3a/NqbQxqxUIHekVa87vhxCTnGvu1yTAf6zmjLH62A==
X-Received: by 2002:adf:ec49:: with SMTP id w9mr22119287wrn.303.1561022524006;
        Thu, 20 Jun 2019 02:22:04 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id x17sm22385673wrq.64.2019.06.20.02.22.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 02:22:03 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:22:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2] ipv6: Error when route does not have any
 valid nexthops
Message-ID: <20190620092202.GC2504@nanopsycho>
References: <20190620091021.18210-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620091021.18210-1-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 20, 2019 at 11:10:21AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>When user space sends invalid information in RTA_MULTIPATH, the nexthop
>list in ip6_route_multipath_add() is empty and 'rt_notif' is set to
>NULL.
>
>The code that emits the in-kernel notifications does not check for this
>condition, which results in a NULL pointer dereference [1].
>
>Fix this by bailing earlier in the function if the parsed nexthop list
>is empty. This is consistent with the corresponding IPv4 code.
>
>v2:
>* Check if parsed nexthop list is empty and bail with extack set
>
>[1]
>kasan: CONFIG_KASAN_INLINE enabled
>kasan: GPF could be caused by NULL-ptr deref or user memory access
>general protection fault: 0000 [#1] PREEMPT SMP KASAN
>CPU: 0 PID: 9190 Comm: syz-executor149 Not tainted 5.2.0-rc5+ #38
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>Google 01/01/2011
>RIP: 0010:call_fib6_multipath_entry_notifiers+0xd1/0x1a0
>net/ipv6/ip6_fib.c:396
>Code: 8b b5 30 ff ff ff 48 c7 85 68 ff ff ff 00 00 00 00 48 c7 85 70 ff ff
>ff 00 00 00 00 89 45 88 4c 89 e0 48 c1 e8 03 4c 89 65 80 <42> 80 3c 28 00
>0f 85 9a 00 00 00 48 b8 00 00 00 00 00 fc ff df 4d
>RSP: 0018:ffff88809788f2c0 EFLAGS: 00010246
>RAX: 0000000000000000 RBX: 1ffff11012f11e59 RCX: 00000000ffffffff
>RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>RBP: ffff88809788f390 R08: ffff88809788f8c0 R09: 000000000000000c
>R10: ffff88809788f5d8 R11: ffff88809788f527 R12: 0000000000000000
>R13: dffffc0000000000 R14: ffff88809788f8c0 R15: ffffffff89541d80
>FS:  000055555632c880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 0000000020000080 CR3: 000000009ba7c000 CR4: 00000000001406f0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>Call Trace:
>  ip6_route_multipath_add+0xc55/0x1490 net/ipv6/route.c:5094
>  inet6_rtm_newroute+0xed/0x180 net/ipv6/route.c:5208
>  rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5219
>  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5237
>  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
>  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1917
>  sock_sendmsg_nosec net/socket.c:646 [inline]
>  sock_sendmsg+0xd7/0x130 net/socket.c:665
>  ___sys_sendmsg+0x803/0x920 net/socket.c:2286
>  __sys_sendmsg+0x105/0x1d0 net/socket.c:2324
>  __do_sys_sendmsg net/socket.c:2333 [inline]
>  __se_sys_sendmsg net/socket.c:2331 [inline]
>  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2331
>  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>RIP: 0033:0x4401f9
>Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
>48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>RSP: 002b:00007ffc09fd0028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
>RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
>RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
>R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
>R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000
>
>Reported-by: syzbot+382566d339d52cd1a204@syzkaller.appspotmail.com
>Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add / replace")
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> net/ipv6/route.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>index c4d285fe0adc..891c8cd27712 100644
>--- a/net/ipv6/route.c
>+++ b/net/ipv6/route.c
>@@ -5043,6 +5043,12 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
> 		rtnh = rtnh_next(rtnh, &remaining);
> 	}
> 
>+	if (list_empty(&rt6_nh_list)) {
>+		NL_SET_ERR_MSG(extack,
>+			       "Invalid nexthop configuration - no valid nexthops");

No need for a line wrap.

Anyway, the fix looks fine.
Reviewed-by: Jiri Pirko <jiri@mellanox.com>


>+		return -EINVAL;
>+	}
>+
> 	/* for add and replace send one notification with all nexthops.
> 	 * Skip the notification in fib6_add_rt2node and send one with
> 	 * the full route when done
>-- 
>2.20.1
>
