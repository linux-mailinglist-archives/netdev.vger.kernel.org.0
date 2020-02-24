Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371CD16A100
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 10:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBXJE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 04:04:28 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38429 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBXJE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 04:04:28 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1j69f4-0000HH-4S; Mon, 24 Feb 2020 10:04:22 +0100
Received: from [IPv6:2a03:f580:87bc:d400:6ccf:3365:1a9c:55ad] (unknown [IPv6:2a03:f580:87bc:d400:6ccf:3365:1a9c:55ad])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0355F4BF396;
        Mon, 24 Feb 2020 08:54:19 +0000 (UTC)
Subject: Re: KMSAN: uninit-value in number (2)
To:     syzbot <syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com,
        Oliver Hartkopp <socketcan@hartkopp.net>
References: <0000000000000955df059f4e276f@google.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 mQINBFFVq30BEACtnSvtXHoeHJxG6nRULcvlkW6RuNwHKmrqoksispp43X8+nwqIFYgb8UaX
 zu8T6kZP2wEIpM9RjEL3jdBjZNCsjSS6x1qzpc2+2ivjdiJsqeaagIgvy2JWy7vUa4/PyGfx
 QyUeXOxdj59DvLwAx8I6hOgeHx2X/ntKAMUxwawYfPZpP3gwTNKc27dJWSomOLgp+gbmOmgc
 6U5KwhAxPTEb3CsT5RicsC+uQQFumdl5I6XS+pbeXZndXwnj5t84M+HEj7RN6bUfV2WZO/AB
 Xt5+qFkC/AVUcj/dcHvZwQJlGeZxoi4veCoOT2MYqfR0ax1MmN+LVRvKm29oSyD4Ts/97cbs
 XsZDRxnEG3z/7Winiv0ZanclA7v7CQwrzsbpCv+oj+zokGuKasofzKdpywkjAfSE1zTyF+8K
 nxBAmzwEqeQ3iKqBc3AcCseqSPX53mPqmwvNVS2GqBpnOfY7Mxr1AEmxdEcRYbhG6Xdn+ACq
 Dq0Db3A++3PhMSaOu125uIAIwMXRJIzCXYSqXo8NIeo9tobk0C/9w3fUfMTrBDtSviLHqlp8
 eQEP8+TDSmRP/CwmFHv36jd+XGmBHzW5I7qw0OORRwNFYBeEuiOIgxAfjjbLGHh9SRwEqXAL
 kw+WVTwh0MN1k7I9/CDVlGvc3yIKS0sA+wudYiselXzgLuP5cQARAQABtCZNYXJjIEtsZWlu
 ZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPokCVAQTAQoAPgIbAwIeAQIXgAULCQgHAwUV
 CgkICwUWAgMBABYhBMFAC6CzmJ5vvH1bXCte4hHFiupUBQJcUsSbBQkM366zAAoJECte4hHF
 iupUgkAP/2RdxKPZ3GMqag33jKwKAbn/fRqAFWqUH9TCsRH3h6+/uEPnZdzhkL4a9p/6OeJn
 Z6NXqgsyRAOTZsSFcwlfxLNHVxBWm8pMwrBecdt4lzrjSt/3ws2GqxPsmza1Gs61lEdYvLST
 Ix2vPbB4FAfE0kizKAjRZzlwOyuHOr2ilujDsKTpFtd8lV1nBNNn6HBIBR5ShvJnwyUdzuby
 tOsSt7qJEvF1x3y49bHCy3uy+MmYuoEyG6zo9udUzhVsKe3hHYC2kfB16ZOBjFC3lH2U5An+
 yQYIIPZrSWXUeKjeMaKGvbg6W9Oi4XEtrwpzUGhbewxCZZCIrzAH2hz0dUhacxB201Y/faY6
 BdTS75SPs+zjTYo8yE9Y9eG7x/lB60nQjJiZVNvZ88QDfVuLl/heuIq+fyNajBbqbtBT5CWf
 mOP4Dh4xjm3Vwlz8imWW/drEVJZJrPYqv0HdPbY8jVMpqoe5jDloyVn3prfLdXSbKPexlJaW
 5tnPd4lj8rqOFShRnLFCibpeHWIumqrIqIkiRA9kFW3XMgtU6JkIrQzhJb6Tc6mZg2wuYW0d
 Wo2qvdziMgPkMFiWJpsxM9xPk9BBVwR+uojNq5LzdCsXQ2seG0dhaOTaaIDWVS8U/V8Nqjrl
 6bGG2quo5YzJuXKjtKjZ4R6k762pHJ3tnzI/jnlc1sXz
Message-ID: <545255e6-0ad1-bdcd-c421-9823833326f3@pengutronix.de>
Date:   Mon, 24 Feb 2020 09:54:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0000000000000955df059f4e276f@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/20 9:28 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    8bbbc5cf kmsan: don't compile memmove
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=1661da7ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cd0e9a6b0e555cc3
> dashboard link: https://syzkaller.appspot.com/bug?extid=9bcb0c9409066696d3aa
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111141a1e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ad5245e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in number+0x9f8/0x2000 lib/vsprintf.c:459
> CPU: 1 PID: 11897 Comm: syz-executor136 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
>  number+0x9f8/0x2000 lib/vsprintf.c:459
>  vsnprintf+0x1d85/0x31b0 lib/vsprintf.c:2640
>  vscnprintf+0xc2/0x180 lib/vsprintf.c:2677
>  vprintk_store+0xef/0x11d0 kernel/printk/printk.c:1917
>  vprintk_emit+0x2c0/0x860 kernel/printk/printk.c:1984
>  vprintk_default+0x90/0xa0 kernel/printk/printk.c:2029
>  vprintk_func+0x636/0x820 kernel/printk/printk_safe.c:386
>  printk+0x18b/0x1d3 kernel/printk/printk.c:2062
>  canfd_rcv+0x370/0x3a0 net/can/af_can.c:697
>  __netif_receive_skb_one_core net/core/dev.c:5198 [inline]
>  __netif_receive_skb net/core/dev.c:5312 [inline]
>  netif_receive_skb_internal net/core/dev.c:5402 [inline]
>  netif_receive_skb+0xe77/0xf20 net/core/dev.c:5461
>  tun_rx_batched include/linux/skbuff.h:4321 [inline]
>  tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
>  tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
>  call_write_iter include/linux/fs.h:1901 [inline]
>  new_sync_write fs/read_write.c:483 [inline]
>  __vfs_write+0xa5a/0xca0 fs/read_write.c:496
>  vfs_write+0x44a/0x8f0 fs/read_write.c:558
>  ksys_write+0x267/0x450 fs/read_write.c:611
>  __do_sys_write fs/read_write.c:623 [inline]
>  __se_sys_write+0x92/0xb0 fs/read_write.c:620
>  __x64_sys_write+0x4a/0x70 fs/read_write.c:620
>  do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440239
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffd3d6d1f28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000003172 RCX: 0000000000440239
> RDX: 0000000000000004 RSI: 0000000020000200 RDI: 0000000000000003
> RBP: 656c6c616b7a7973 R08: 0000000000401ac0 R09: 0000000000401ac0
> R10: 0000000000401ac0 R11: 0000000000000246 R12: 0000000000401ac0
> R13: 0000000000401b50 R14: 0000000000000000 R15: 0000000000000000
> 
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
>  kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
>  kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
>  slab_alloc_node mm/slub.c:2793 [inline]
>  __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4401
>  __kmalloc_reserve net/core/skbuff.c:142 [inline]
>  __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
>  alloc_skb include/linux/skbuff.h:1051 [inline]
>  alloc_skb_with_frags+0x18c/0xa70 net/core/skbuff.c:5766
>  sock_alloc_send_pskb+0xada/0xc60 net/core/sock.c:2242
>  tun_alloc_skb drivers/net/tun.c:1529 [inline]
>  tun_get_user+0x10ae/0x6f60 drivers/net/tun.c:1843
>  tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
>  call_write_iter include/linux/fs.h:1901 [inline]
>  new_sync_write fs/read_write.c:483 [inline]
>  __vfs_write+0xa5a/0xca0 fs/read_write.c:496
>  vfs_write+0x44a/0x8f0 fs/read_write.c:558
>  ksys_write+0x267/0x450 fs/read_write.c:611
>  __do_sys_write fs/read_write.c:623 [inline]
>  __se_sys_write+0x92/0xb0 fs/read_write.c:620
>  __x64_sys_write+0x4a/0x70 fs/read_write.c:620
>  do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> =====================================================

> static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
>                      struct packet_type *pt, struct net_device *orig_dev)
> {
>         struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
> 
>         if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU ||
>                      cfd->len > CANFD_MAX_DLEN)) {
>                 pr_warn_once("PF_CAN: dropped non conform CAN FD skbuf: dev type %d, len %d, datalen %d\n",
>                              dev->type, skb->len, cfd->len);
                                                    ^^^^^^^^

If the skb is to short, we'll access the skb->data out of bounds, when
dereferencing cfd. I think we have to remove the "datalen" from the
warning message.

>                 kfree_skb(skb);
>                 return NET_RX_DROP;
>         }
> 
>         can_receive(skb, dev);
>         return NET_RX_SUCCESS;
> }

Marc

-- 
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
