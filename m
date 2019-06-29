Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CB45AAA3
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 14:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfF2MFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 08:05:13 -0400
Received: from linuxlounge.net ([88.198.164.195]:52834 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfF2MFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 08:05:13 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jun 2019 08:05:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1561809350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:resent-cc:
         resent-from:resent-message-id:openpgp:openpgp:autocrypt:autocrypt;
        bh=K8SkvK23rxnJCbNhKHlL7+FkuFf6K/rRGr7z7WQxE34=;
        b=vhYAFZbtpWws7zP+gxe/dIbQlqHOvlwr1O4PxXp5lKokBm37OMBhQ+dGSv3Ps0Ja/SSc+5
        p4/BxhuSra5ADtwc7UR/nE9RK5z450e8gekfEqOO9CimKFIVAcZnyM6NQcXuK9hRbQUesy
        gbO54ptHw9y8dPGPdz43ZtjE7tIH6S4=
To:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org
Cc:     netdev@vger.kernel.or
From:   Martin Weinelt <martin@linuxlounge.net>
Openpgp: preference=signencrypt
Autocrypt: addr=martin@linuxlounge.net; prefer-encrypt=mutual; keydata=
 mQENBEv1rfkBCADFlzzmynjVg8L5ok/ef2Jxz8D96PtEAP//3U612b4QbHXzHC6+C2qmFEL6
 5kG1U1a7PPsEaS/A6K9AUpDhT7y6tX1IxAkSkdIEmIgWC5Pu2df4+xyWXarJfqlBeJ82biot
 /qETntfo01wm0AtqfJzDh/BkUpQw0dbWBSnAF6LytoNEggIGnUGmzvCidrEEsTCO6YlHfKIH
 cpz7iwgVZi4Ajtsky8v8P8P7sX0se/ce1L+qX/qN7TnXpcdVSfZpMnArTPkrmlJT4inBLhKx
 UeDMQmHe+BQvATa21fhcqi3BPIMwIalzLqVSIvRmKY6oYdCbKLM2TZ5HmyJepusl2Gi3ABEB
 AAG0J01hcnRpbiBXZWluZWx0IDxtYXJ0aW5AbGludXhsb3VuZ2UubmV0PokBWAQTAQoAQgIb
 IwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUC
 W/RuFQUJEd/znAAKCRC9SqBSj2PxfpfDCACDx6BYz6cGMiweQ96lXi+ihx7RBaXsfPp2KxUo
 eHilrDPqknq62XJibCyNCJiYGNb+RUS5WfDUAqxdl4HuNxQMC/sYlbP4b7p9Y1Q9QiTP4f6M
 8+Uvpicin+9H/lye5hS/Gp2KUiVI/gzqW68WqMhARUYw00lVSlJHy+xHEGVuQ0vmeopjU81R
 0si4+HhMX2HtILTxoUcvm67AFKidTHYMJKwNyMHiLLvSK6wwiy+MXaiqrMVTwSIOQhLgLVcJ
 33GNJ2Emkgkhs6xcaiN8xTjxDmiU7b5lXW4JiAsd1rbKINajcA7DVlZ/evGfpN9FczyZ4W6F
 Rf21CxSwtqv2SQHBuQENBEv1rfkBCADJX6bbb5LsXjdxDeFgqo+XRUvW0bzuS3SYNo0fuktM
 5WYMCX7TzoF556QU8A7C7bDUkT4THBUzfaA8ZKIuneYW2WN1OI0zRMpmWVeZcUQpXncWWKCg
 LBNYtk9CCukPE0OpDFnbR+GhGd1KF/YyemYnzwW2f1NOtHjwT3iuYnzzZNlWoZAR2CRSD02B
 YU87Mr2CMXrgG/pdRiaD+yBUG9RxCUkIWJQ5dcvgrsg81vOTj6OCp/47Xk/457O0pUFtySKS
 jZkZN6S7YXl/t+8C9g7o3N58y/X95VVEw/G3KegUR2SwcLdok4HaxgOy5YHiC+qtGNZmDiQn
 NXN7WIN/oof7ABEBAAGJATwEGAEKACYCGwwWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUCW/Ru
 GAUJEd/znwAKCRC9SqBSj2PxfpzMCACH55MVYTVykq+CWj1WMKHex9iFg7M9DkWQCF/Zl+0v
 QmyRMEMZnFW8GdX/Qgd4QbZMUTOGevGxFPTe4p0PPKqKEDXXXxTTHQETE/Hl0jJvyu+MgTxG
 E9/KrWmsmQC7ogTFCHf0vvVY3UjWChOqRE19Buk4eYpMbuU1dYefLNcD15o4hGDhohYn3SJr
 q9eaoO6rpnNIrNodeG+1vZYG1B2jpEdU4v354ziGcibt5835IONuVdvuZMFQJ4Pn2yyC+qJe
 ekXwZ5f4JEt0lWD9YUxB2cU+xM9sbDcQ2b6+ypVFzMyfU0Q6LzYugAqajZ10gWKmeyjisgyq
 sv5UJTKaOB/t
Subject: Use-after-free in br_multicast_rcv
Message-ID: <41ac3aa3-cbf7-1b7b-d847-1fb308334931@linuxlounge.net>
Date:   Sat, 29 Jun 2019 13:54:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

we've recently been experiencing memory leaks on our Linux-based routers,
at least as far back as v4.19.16.

After rebuilding with KASAN it found a use-after-free in 
br_multicast_rcv which I could reproduce on v5.2.0-rc6. 

Please find the KASAN report below, I'm not sure what else to provide so
feel free to ask.

Best,
  Martin


==================================================================
BUG: KASAN: use-after-free in br_multicast_rcv+0x480c/0x4ad0 [bridge]
Read of size 2 at addr ffff8880421302b4 by task ksoftirqd/1/16

CPU: 1 PID: 16 Comm: ksoftirqd/1 Tainted: G           OE     5.2.0-rc6+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
Call Trace:
 dump_stack+0x71/0xab
 print_address_description+0x6a/0x280
 ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
 __kasan_report+0x152/0x1aa
 ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
 ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
 kasan_report+0xe/0x20
 br_multicast_rcv+0x480c/0x4ad0 [bridge]
 ? br_multicast_disable_port+0x150/0x150 [bridge]
 ? ktime_get_with_offset+0xb4/0x150
 ? __kasan_kmalloc.constprop.6+0xa6/0xf0
 ? __netif_receive_skb+0x1b0/0x1b0
 ? br_fdb_update+0x10e/0x6e0 [bridge]
 ? br_handle_frame_finish+0x3c6/0x11d0 [bridge]
 br_handle_frame_finish+0x3c6/0x11d0 [bridge]
 ? br_pass_frame_up+0x3a0/0x3a0 [bridge]
 ? virtnet_probe+0x1c80/0x1c80 [virtio_net]
 br_handle_frame+0x731/0xd90 [bridge]
 ? select_idle_sibling+0x25/0x7d0
 ? br_handle_frame_finish+0x11d0/0x11d0 [bridge]
 __netif_receive_skb_core+0xced/0x2d70
 ? virtqueue_get_buf_ctx+0x230/0x1130 [virtio_ring]
 ? do_xdp_generic+0x20/0x20
 ? virtqueue_napi_complete+0x39/0x70 [virtio_net]
 ? virtnet_poll+0x94d/0xc78 [virtio_net]
 ? receive_buf+0x5120/0x5120 [virtio_net]
 ? __netif_receive_skb_one_core+0x97/0x1d0
 __netif_receive_skb_one_core+0x97/0x1d0
 ? __netif_receive_skb_core+0x2d70/0x2d70
 ? _raw_write_trylock+0x100/0x100
 ? __queue_work+0x41e/0xbe0
 process_backlog+0x19c/0x650
 ? _raw_read_lock_irq+0x40/0x40
 net_rx_action+0x71e/0xbc0
 ? __switch_to_asm+0x40/0x70
 ? napi_complete_done+0x360/0x360
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 ? __schedule+0x85e/0x14d0
 __do_softirq+0x1db/0x5f9
 ? takeover_tasklets+0x5f0/0x5f0
 run_ksoftirqd+0x26/0x40
 smpboot_thread_fn+0x443/0x680
 ? sort_range+0x20/0x20
 ? schedule+0x94/0x210
 ? __kthread_parkme+0x78/0xf0
 ? sort_range+0x20/0x20
 kthread+0x2ae/0x3a0
 ? kthread_create_worker_on_cpu+0xc0/0xc0
 ret_from_fork+0x35/0x40

The buggy address belongs to the page:
page:ffffea0001084c00 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0
flags: 0xffffc000000000()
raw: 00ffffc000000000 ffffea0000cfca08 ffffea0001098608 0000000000000000
raw: 0000000000000000 0000000000000003 00000000ffffff7f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888042130180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888042130200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888042130280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                     ^
 ffff888042130300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888042130380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
Disabling lock debugging due to kernel taint
