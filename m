Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7695C592
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfGAWRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:17:32 -0400
Received: from linuxlounge.net ([88.198.164.195]:43554 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbfGAWRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 18:17:32 -0400
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1562019450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=DwNFjazVnIK588WKFSaXZYS1+AURuG9fAkaq+GSIDF8=;
        b=t9RmcZrvjuNgS3sXd4QuAfQtZHhvzaiCOU0lpo2DZ3rR9i1BeNJR7vbPwJI4DNWMgD06EF
        vbrN7XB4WzkFwoegBoHnun+8e2Q/GDIxR5OVTJKg5fHA04XKKwpjULNiPVnJGgftaHo3w9
        ddZbhv4sgr1bRQGqKVM1Slrnr8cgDus=
Cc:     netdev@vger.kernel.org
References: <41ac3aa3-cbf7-1b7b-d847-1fb308334931@linuxlounge.net>
 <E0170D52-C181-4F0F-B5F8-F1801C2A8F5A@cumulusnetworks.com>
 <21ab085f-0f7f-88bc-b661-af74dd9eeea2@linuxlounge.net>
 <cc232ed3-9e02-ebb4-4901-9d617013abb8@cumulusnetworks.com>
 <3fcf8b05-e1ad-ac97-10bf-bd2b6354424c@linuxlounge.net>
 <908e9e90-70cc-7bbe-f83f-0810c9ef3925@cumulusnetworks.com>
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
Subject: Re: Use-after-free in br_multicast_rcv
Message-ID: <5e43ba82-de32-e419-efc3-5dfca8291973@linuxlounge.net>
Date:   Tue, 2 Jul 2019 00:17:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
In-Reply-To: <908e9e90-70cc-7bbe-f83f-0810c9ef3925@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again,

On 7/1/19 7:37 PM, Nikolay Aleksandrov wrote:
> I see, thanks for clarifying this. So on the KASAN could you please try the attached patch ?
> Also could you please run the br_multicast_rcv+xxx addresses through
> linux/scripts/faddr2line for your kernel/bridge:
> usage: faddr2line [--list] <object file> <func+offset> <func+offset>...
> 
> Thanks,
>  Nik
> 

back with a new report. This is 5.2.0-rc7 + your patch.

Best,
  Martin

$ ./faddr2line /usr/lib/debug/lib/modules/5.2.0-rc7+/kernel/net/bridge/bridge.ko br_multicast_rcv+0x4d0/0x4b00
br_multicast_rcv+0x4d0/0x4b00:
__skb_header_pointer at /home/hexa/git/linux/./include/linux/skbuff.h:3476
(inlined by) skb_header_pointer at /home/hexa/git/linux/./include/linux/skbuff.h:3486
(inlined by) br_ip6_multicast_mld2_report at /home/hexa/git/linux/net/bridge/br_multicast.c:998
(inlined by) br_multicast_ipv6_rcv at /home/hexa/git/linux/net/bridge/br_multicast.c:1694
(inlined by) br_multicast_rcv at /home/hexa/git/linux/net/bridge/br_multicast.c:1729


[  329.723036] ==================================================================
[  329.732244] BUG: KASAN: stack-out-of-bounds in skb_copy_bits+0x33e/0x730
[  329.738974] Write of size 8 at addr ffff888050f09860 by task swapper/4/0
[  329.745754]
[  329.749528] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G           OE     5.2.0-rc7+ #2
[  329.756304] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[  329.764062] Call Trace:
[  329.768281]  <IRQ>
[  329.772037]  dump_stack+0x71/0xab
[  329.776015]  print_address_description+0x6a/0x280
[  329.780840]  ? skb_copy_bits+0x33e/0x730
[  329.784817]  __kasan_report+0x152/0x1aa
[  329.788623]  ? skb_copy_bits+0x33e/0x730
[  329.792398]  ? skb_copy_bits+0x33e/0x730
[  329.796231]  kasan_report+0xe/0x20
[  329.800250]  memcpy+0x34/0x50
[  329.803716]  skb_copy_bits+0x33e/0x730
[  329.807736]  br_multicast_rcv+0x4d0/0x4b00 [bridge]
[  329.811579]  ? netif_receive_skb_internal+0x84/0x1a0
[  329.815197]  ? br_multicast_disable_port+0x150/0x150 [bridge]
[  329.819164]  ? netif_receive_skb+0x1b/0x1e0
[  329.823374]  ? br_pass_frame_up+0x25b/0x3a0 [bridge]
[  329.828084]  ? br_handle_local_finish+0x20/0x20 [bridge]
[  329.832960]  ? br_fdb_update+0x10e/0x6e0 [bridge]
[  329.837599]  ? br_handle_frame_finish+0x3c6/0x11d0 [bridge]
[  329.843090]  br_handle_frame_finish+0x3c6/0x11d0 [bridge]
[  329.848091]  ? br_pass_frame_up+0x3a0/0x3a0 [bridge]
[  329.853063]  ? _raw_write_trylock+0x100/0x100
[  329.857660]  ? update_load_avg+0x1c4/0x1890
[  329.861863]  ? virtnet_probe+0x1c80/0x1c80 [virtio_net]
[  329.866355]  br_handle_frame+0x731/0xd90 [bridge]
[  329.870343]  ? rcu_irq_exit+0x72/0x1c0
[  329.873708]  ? br_handle_frame_finish+0x11d0/0x11d0 [bridge]
[  329.878333]  ? do_IRQ+0x71/0x160
[  329.881667]  ? __update_load_avg_cfs_rq+0x2aa/0x980
[  329.885859]  ? common_interrupt+0xa/0xf
[  329.889588]  ? __update_load_avg_cfs_rq+0x2aa/0x980
[  329.894482]  __netif_receive_skb_core+0xced/0x2d70
[  329.900915]  ? napi_complete_done+0x10/0x360
[  329.905743]  ? virtqueue_get_buf_ctx+0x271/0x1130 [virtio_ring]
[  329.909920]  ? do_xdp_generic+0x20/0x20
[  329.912854]  ? virtqueue_napi_complete+0x39/0x70 [virtio_net]
[  329.916242]  ? virtnet_poll+0x94d/0xc78 [virtio_net]
[  329.919606]  ? receive_buf+0x5120/0x5120 [virtio_net]
[  329.924068]  ? __netif_receive_skb_one_core+0x97/0x1d0
[  329.929248]  ? account_entity_enqueue+0x340/0x4c0
[  329.933515]  __netif_receive_skb_one_core+0x97/0x1d0
[  329.937323]  ? __netif_receive_skb_core+0x2d70/0x2d70
[  329.941076]  ? _raw_write_trylock+0x100/0x100
[  329.944515]  process_backlog+0x19c/0x650
[  329.947618]  ? update_cfs_group+0x10b/0x380
[  329.950863]  net_rx_action+0x71e/0xbc0
[  329.953899]  ? napi_complete_done+0x360/0x360
[  329.957240]  ? handle_irq_event_percpu+0xeb/0x140
[  329.960485]  ? _raw_spin_lock+0x7a/0xd0
[  329.962980]  ? _raw_write_trylock+0x100/0x100
[  329.965598]  __do_softirq+0x1db/0x5f9
[  329.968022]  irq_exit+0x123/0x150
[  329.970338]  do_IRQ+0x71/0x160
[  329.972599]  common_interrupt+0xf/0xf
[  329.975034]  </IRQ>
[  329.977167] RIP: 0010:native_safe_halt+0xe/0x10
[  329.979783] Code: 09 f9 fe 48 8b 04 24 e9 12 ff ff ff e9 07 00 00 00 0f 00 2d d4 60 52 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d c4 60 52 00 fb f4 <c3> 90 66 66 66 66 90 41 56 41 55 41 54 55 53 e8 7e 05 ba fe 65 44
[  329.987611] RSP: 0018:ffff888050347d98 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffd1
[  329.991311] RAX: ffffffffa3d1ad00 RBX: 0000000000000004 RCX: ffffffffa28bbbd6
[  329.994903] RDX: 1ffff1100a05c5b8 RSI: 0000000000000004 RDI: ffff888050f33f38
[  329.998432] RBP: ffffed100a05c5b8 R08: ffffed100a1e67e8 R09: ffffed100a1e67e7
[  330.002025] R10: ffff888050f33f3b R11: ffffed100a1e67e8 R12: ffffffffa4c604c0
[  330.005736] R13: 0000000000000004 R14: 0000000000000000 R15: ffff8880502e2dc0
[  330.010074]  ? ldsem_down_write+0x590/0x590
[  330.012905]  ? rcu_idle_enter+0x106/0x150
[  330.016130]  ? tsc_verify_tsc_adjust+0x96/0x2a0
[  330.019068]  default_idle+0x1f/0x280
[  330.021710]  do_idle+0x2d8/0x3e0
[  330.024246]  ? arch_cpu_idle_exit+0x40/0x40
[  330.027089]  cpu_startup_entry+0x19/0x20
[  330.030120]  start_secondary+0x316/0x3f0
[  330.032770]  ? set_cpu_sibling_map+0x19c0/0x19c0
[  330.035625]  secondary_startup_64+0xa4/0xb0
[  330.038485]
[  330.040559] The buggy address belongs to the page:
[  330.043525] page:ffffea000143c240 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
[  330.047223] flags: 0xffffc000001000(reserved)
[  330.050063] raw: 00ffffc000001000 ffffea000143c248 ffffea000143c248 0000000000000000
[  330.053806] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
[  330.057765] page dumped because: kasan: bad access detected
[  330.060927]
[  330.063115] Memory state around the buggy address:
[  330.066036]  ffff888050f09700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  330.069509]  ffff888050f09780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  330.073066] >ffff888050f09800: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 02 f4 f4 f4
[  330.076586]                                                        ^
[  330.079861]  ffff888050f09880: f2 f2 f2 f2 04 f4 f4 f4 f2 f2 f2 f2 00 00 04 f4
[  330.083397]  ffff888050f09900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  330.086923] ==================================================================
[  330.090465] Disabling lock debugging due to kernel taint

