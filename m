Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B091936908C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242149AbhDWKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:48:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbhDWKsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:48:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13N9tbs5016979;
        Fri, 23 Apr 2021 10:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=b6jPf2c2Llj7JcKVVnVbmyHMjENwqIGhmtemfodirCc=;
 b=Gc3/dJYwkQPg3cRFsiv4NPYhnAsNHBmYvIpBNsuadycxwJqrkDWlA2CEDJTTVgzJG+Id
 nmFUFZsIILiKOGUoYfFAUTEsT1cGWUrIdIrfNkuX8NK8SnXlHcwUcldtRiTIow7TsHsr
 ddk04DHbuDotxO3i6Lh+6fQG3op2U/KSULw6s9ULT/SHWfGOwc7txJnzdadSw1n6h9eI
 YZnZ+OhuINMLeutxWLhQ8an+GVPROhQGD/f0k8VJ1GdfRhLXr/TwpOpw+xEl2kQuk403
 XaFqypeTQizt8JTjsA2ADlO4nfnHfOcSe3OLi/mLgRJ8kmXIf8JPjQWotVA/u2krUw/z FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38022y7e5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 10:47:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13NAjSFI192109;
        Fri, 23 Apr 2021 10:47:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 383cbey9fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 10:47:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13NAlD4s025364;
        Fri, 23 Apr 2021 10:47:13 GMT
Received: from [10.175.33.123] (/10.175.33.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Apr 2021 03:47:13 -0700
Subject: Re: WARNING in netlbl_cipsov4_add
To:     syzbot <syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com>,
        Paul Moore <paul@paul-moore.com>
References: <000000000000307cc205bbbf31d3@google.com>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
From:   Vegard Nossum <vegard.nossum@oracle.com>
Message-ID: <29f03460-c0ba-07a0-ef98-9597ef157797@oracle.com>
Date:   Fri, 23 Apr 2021 12:47:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000307cc205bbbf31d3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230068
X-Proofpoint-ORIG-GUID: mfusiCC0oiSNrghS1LCRd7nM0RVeREn2
X-Proofpoint-GUID: mfusiCC0oiSNrghS1LCRd7nM0RVeREn2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1011 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Paul,

This syzbot report reproduces in mainline for me and it looks like
you're the author/maintainer of this code, so I'm just adding some info
to hopefully aid the preparation of a fix:

On 2021-02-20 08:05, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4773acf3 b43: N-PHY: Fix the update of coef for the PHY re..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=13290cb0d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
> dashboard link: https://syzkaller.appspot.com/bug?extid=cdd51ee2e6b0b2e18c0d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1267953cd00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d98524d00000
> 
> Bisection is inconclusive: the issue happens on the oldest tested release.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1127cc82d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1327cc82d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1527cc82d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8425 at mm/page_alloc.c:4979 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5014
> Modules linked in:
> CPU: 0 PID: 8425 Comm: syz-executor629 Not tainted 5.11.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4979
> Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
> RSP: 0018:ffffc900017ef3e0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 1ffff920002fde80 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000040dc0
> RBP: 0000000000040dc0 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff81b29ac1 R11: 0000000000000000 R12: 0000000000000015
> R13: 0000000000000015 R14: 0000000000000000 R15: ffff88801209c980
> FS:  0000000001c35300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fbf6f3656c0 CR3: 000000001db9e000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
>   alloc_pages include/linux/gfp.h:547 [inline]
>   kmalloc_order+0x32/0xd0 mm/slab_common.c:837
>   kmalloc_order_trace+0x14/0x130 mm/slab_common.c:853
>   kmalloc_array include/linux/slab.h:592 [inline]
>   kcalloc include/linux/slab.h:621 [inline]
>   netlbl_cipsov4_add_std net/netlabel/netlabel_cipso_v4.c:188 [inline]
>   netlbl_cipsov4_add+0x5a9/0x23e0 net/netlabel/netlabel_cipso_v4.c:416
>   genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
>   genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>   genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
>   netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>   genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>   netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>   netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>   sock_sendmsg_nosec net/socket.c:652 [inline]
>   sock_sendmsg+0xcf/0x120 net/socket.c:672
>   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
>   ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
>   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x43fcc9
> Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdcdd33c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043fcc9
> RDX: 0000000000004904 RSI: 0000000020000140 RDI: 0000000000000003
> RBP: 0000000000403730 R08: 0000000000000005 R09: 00000000004004a0
> R10: 0000000000000003 R11: 0000000000000246 R12: 00000000004037c0
> R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

Running strace on the reproducer says:

socket(PF_NETLINK, SOCK_RAW, NETLINK_GENERIC) = 3
socket(PF_NETLINK, SOCK_RAW, NETLINK_GENERIC) = 4
sendto(4, 
"(\0\0\0\20\0\5\0\0\0\0\0\0\0\0\0\3\0\0\0\21\0\2\0NLBL_CIPSOv4\0\0\0\0", 
40, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 40
recvfrom(4, 
"\234\0\0\0\20\0\0\0\0\0\0\0\f\r\0\0\1\2\0\0\21\0\2\0NLBL_CIPSOv4\0\0\0\0\6\0\1\0\24\0\0\0\10\0\3\0\3\0\0\0\10\0\4\0\0\0\0\0\10\0\5\0\f\0\0\0T\0\6\0\24\0\1\0\10\0\1\0\1\0\0\0\10\0\2\0\v\0\0\0\24\0\2\0\10\0\1\0\2\0\0\0\10\0\2\0\v\0\0\0\24\0\3\0\10\0\1\0\3\0\0\0\10\0\2\0\n\0\0\0\24\0\4\0\10\0\1\0\4\0\0\0\10\0\2\0\f\0\0\0", 
4096, 0, NULL, NULL) = 156
recvfrom(4, 
"$\0\0\0\2\0\0\0\0\0\0\0\f\r\0\0\0\0\0\0(\0\0\0\20\0\5\0\0\0\0\0\0\0\0\0", 
4096, 0, NULL, NULL) = 36
sendmsg(3, {msg_name(0)=NULL, 
msg_iov(1)=[{"T\0\0\0\24\0\1\0\0\0\0\0\0\0\0\0\1\0\0\0,\0\10\200\34\0\7\200\10\0\5\0\3608) 
\10\0\6\0\0\0\0\0\10\0\6\0\0\0\0\0\f\0\7\200\10\0\5\0\0\0\0\0\4\0\4\200\10\0\1\0\0\0\0\0\10\0\2\0\1\0\0\0", 
84}], msg_controllen=0, msg_flags=0}, 0) = 84

We're ending up in netlbl_cipsov4_add() with CIPSO_V4_MAP_TRANS, so it 
calls netlbl_cipsov4_add_std() where this is the problematic allocation:

doi_def->map.std->lvl.local = kcalloc(doi_def->map.std->lvl.local_size,
                                       sizeof(u32),
                                       GFP_KERNEL);

It looks like there is already a check on the max size:

if (nla_get_u32(nla_b) >
     CIPSO_V4_MAX_LOC_LVLS)
         goto add_std_failure;
if (nla_get_u32(nla_b) >=
     doi_def->map.std->lvl.local_size)
      doi_def->map.std->lvl.local_size =
              nla_get_u32(nla_b) + 1;

However, the limit is quite generous:

#define CIPSO_V4_INV_LVL              0x80000000
#define CIPSO_V4_MAX_LOC_LVLS         (CIPSO_V4_INV_LVL - 1)

so maybe a fix would just lower this to something that agrees with the
page allocator?

I would say it looks like the issue has been there since either
96cb8e3313c7a1 or fd3858554b62c3.

At first glance it may appear like there is a similar issue with
doi_def->map.std->lvl.cipso_size, but that one looks restricted to a
saner limit of CIPSO_V4_MAX_REM_LVLS == 255. It's probably better to
double check both in case I read this wrong.

Hope this helps,


Vegard
