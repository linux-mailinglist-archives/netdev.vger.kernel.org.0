Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816665D01E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfGBNF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:05:59 -0400
Received: from linuxlounge.net ([88.198.164.195]:59580 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfGBNF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 09:05:58 -0400
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1562072736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:openpgp:openpgp:autocrypt:autocrypt;
        bh=GfDl2A6DBmtP9D33ntHFCfV7+2kGepjvE3THSUI1gXQ=;
        b=Xfxjw+YX8omkQZZi0vcGwj/C2qSyNwliuzFnWFDP36+Q2Nql5K8bMT9q1SwXgM0W1LkXbm
        4d+SGa9rTqYmTkPHZ+r1Ge4ec2HIutup27yQOUuuvAYhpyRPogdI/ayim9dbNpII3fRXQw
        JXPKMP0+oLksWsnjo9oO5ocb2IWtUa0=
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
Subject: Memory leaks in IPv6 ndisc on v4.19.56
Message-ID: <8fadeb22-2a9b-6038-01f9-bf32b5055965@linuxlounge.net>
Date:   Tue, 2 Jul 2019 15:05:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
Content-Type: multipart/mixed;
 boundary="------------3141603C746A06B34402B855"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------3141603C746A06B34402B855
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi everyone,

I've been experiencing memory leaks on the v4.19 series. I've started
seeing them on Debian with v4.19.16 and I can reproduce them on v4.19.56
using Debians kernel config. I was unable to reproduce this on 
v5.2.0-rc6/rc7.

  [ 1899.380321] kmemleak: 1138 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

On the machines in question we're running routers for a mesh networking
setup based on the batman-adv kmod. Our setup consists of KVM guests 
running Debian, with each router having 18 bridges with the following
master/slave relationship:

  bridge -> batman-adv -> {L2 tunnel, virtio net device}

I've attached the output of kmemleak and I've looked up the top-most
function offsets below:

Best,
  Martin


$ ./faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux ndisc_recv_ns+0x356/0x5f0
ndisc_recv_ns+0x356/0x5f0:
__neigh_lookup at include/net/neighbour.h:513
(inlined by) ndisc_recv_ns at net/ipv6/ndisc.c:916

$ ./faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux ndisc_router_discovery+0x4ab/0xae0
ndisc_router_discovery+0x4ab/0xae0:
__neigh_lookup at include/net/neighbour.h:513
(inlined by) ndisc_router_discovery at net/ipv6/ndisc.c:1387

$ ./faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux ndisc_recv_rs+0x173/0x1b0
ndisc_recv_rs+0x173/0x1b0:
ndisc_recv_rs at net/ipv6/ndisc.c:1095

$ ./faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux ip6_finish_output2+0x211/0x570
ip6_finish_output2+0x211/0x570:
ip6_finish_output2 at net/ipv6/ip6_output.c:117


--------------3141603C746A06B34402B855
Content-Type: text/x-log;
 name="kmemleak.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="kmemleak.log"

unreferenced object 0xffff98375ae00c00 (size 512):
  comm "softirq", pid 0, jiffies 4294901048 (age 1909.144s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 3d 67 36 37 98 ff ff 34 21 06 00 01 00 00 00  .=3Dg67...4!......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
    [<000000001883f191>] virtqueue_napi_complete+0x2a/0x70 [virtio_net]
    [<000000000ca44d09>] virtnet_poll+0x2e8/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000007f340de2>] __raw_callee_save___pv_queued_spin_unlock+0xc/0x=
12
unreferenced object 0xffff98375ad72200 (size 512):
  comm "softirq", pid 0, jiffies 4294901959 (age 1905.504s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 ca 60 57 37 98 ff ff 43 26 06 00 01 00 00 00  ..`W7...C&......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
    [<000000001883f191>] virtqueue_napi_complete+0x2a/0x70 [virtio_net]
    [<000000000ca44d09>] virtnet_poll+0x2e8/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
unreferenced object 0xffff9837582e6400 (size 512):
  comm "softirq", pid 0, jiffies 4294902618 (age 1902.868s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff b7 31 06 00 01 00 00 00  @.zZ7....1......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983754b0a000 (size 512):
  comm "softirq", pid 0, jiffies 4294913978 (age 1857.456s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff 0b 2a 06 00 01 00 00 00  ...W7....*......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff98373491fa00 (size 512):
  comm "softirq", pid 0, jiffies 4294916608 (age 1846.936s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff 05 22 06 00 01 00 00 00  ...W7...."......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983739883800 (size 512):
  comm "softirq", pid 0, jiffies 4294930657 (age 1790.744s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 66 24 06 00 01 00 00 00  .."Y7...f$......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837586fe000 (size 512):
  comm "softirq", pid 0, jiffies 4294931109 (age 1788.964s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 80 27 06 00 01 00 00 00  .."Y7....'......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983756c78000 (size 512):
  comm "softirq", pid 0, jiffies 4294939933 (age 1753.668s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 e3 d3 5a 37 98 ff ff 85 35 06 00 01 00 00 00  ...Z7....5......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983739963c00 (size 512):
  comm "softirq", pid 0, jiffies 4294949652 (age 1714.792s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff c0 36 06 00 01 00 00 00  ...Z7....6......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983756901200 (size 512):
  comm "softirq", pid 0, jiffies 4295002377 (age 1503.920s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 ca 60 57 37 98 ff ff c4 1f 06 00 01 00 00 00  ..`W7...........
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837586fa000 (size 512):
  comm "softirq", pid 0, jiffies 4295012439 (age 1463.672s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 46 27 06 00 01 00 00 00  .."Y7...F'......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff98375505aa00 (size 512):
  comm "softirq", pid 0, jiffies 4295037334 (age 1364.096s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 81 25 06 00 01 00 00 00  .."Y7....%......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983756fe1e00 (size 512):
  comm "softirq", pid 0, jiffies 4295096153 (age 1128.848s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 23 86 5a 37 98 ff ff 25 34 06 00 01 00 00 00  .#.Z7...%4......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983754b4ae00 (size 512):
  comm "softirq", pid 0, jiffies 4295133073 (age 981.168s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 ca 60 57 37 98 ff ff 07 28 06 00 01 00 00 00  ..`W7....(......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<0000000052e95d04>] do_softirq_own_stack+0x2a/0x40
    [<00000000187c49ad>] do_softirq.part.21+0x56/0x60
    [<0000000099f41204>] __local_bh_enable_ip+0x60/0x70
    [<0000000088ac3dd6>] tun_get_user+0xefc/0x1290 [tun]
    [<000000000656b60d>] tun_chr_write_iter+0x4d/0x70 [tun]
unreferenced object 0xffff983759ed0a00 (size 512):
  comm "softirq", pid 0, jiffies 4295140166 (age 952.796s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 3d 67 36 37 98 ff ff 67 2b 06 00 01 00 00 00  .=3Dg67...g+......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983756fe4200 (size 512):
  comm "softirq", pid 0, jiffies 4295142167 (age 944.824s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 23 86 5a 37 98 ff ff 66 35 06 00 01 00 00 00  .#.Z7...f5......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983739842200 (size 512):
  comm "softirq", pid 0, jiffies 4295159170 (age 876.812s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 f3 b2 35 37 98 ff ff 02 35 06 00 01 00 00 00  ...57....5......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837561fd000 (size 512):
  comm "softirq", pid 0, jiffies 4295205914 (age 689.836s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 e3 d3 5a 37 98 ff ff 89 1f 06 00 01 00 00 00  ...Z7...........
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983754be8c00 (size 512):
  comm "softirq", pid 0, jiffies 4295223732 (age 618.612s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 b3 60 36 37 98 ff ff d7 1e 06 00 01 00 00 00  ..`67...........
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837561fb000 (size 512):
  comm "softirq", pid 0, jiffies 4295239563 (age 555.288s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 46 27 06 00 01 00 00 00  .."Y7...F'......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff9837348ec200 (size 512):
  comm "softirq", pid 0, jiffies 4295244948 (age 533.748s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 4a 2c 06 00 01 00 00 00  @.`67...J,......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837591e5e00 (size 512):
  comm "softirq", pid 0, jiffies 4295246653 (age 526.972s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 b3 60 36 37 98 ff ff dc 22 06 00 01 00 00 00  ..`67...."......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff98375a74c200 (size 512):
  comm "softirq", pid 0, jiffies 4295253896 (age 498.000s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff 10 28 06 00 01 00 00 00  ...W7....(......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983739987400 (size 512):
  comm "softirq", pid 0, jiffies 4295255208 (age 492.752s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff 43 2b 06 00 01 00 00 00  ..`W7...C+......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837549f6a00 (size 512):
  comm "softirq", pid 0, jiffies 4295258262 (age 480.564s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff c2 37 06 00 01 00 00 00  .."Y7....7......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000007c48391f>] ip6_send_skb+0x1e/0x60
    [<00000000a44fce26>] udp_v6_send_skb.isra.27+0x1ba/0x3c0
    [<00000000fe92efdd>] udpv6_sendmsg+0x9e3/0xd90
    [<00000000f3fbe7f1>] sock_sendmsg+0x36/0x40
    [<000000008b40250b>] ___sys_sendmsg+0x2e9/0x300
    [<00000000cdb023dc>] __sys_sendmsg+0x63/0xa0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff
unreferenced object 0xffff98375505ca00 (size 512):
  comm "softirq", pid 0, jiffies 4295277593 (age 403.240s)
  hex dump (first 32 bytes):
    00 fa 3f 59 37 98 ff ff c0 ca ae 92 ff ff ff ff  ..?Y7...........
    00 b3 60 36 37 98 ff ff cd 20 06 00 01 00 00 00  ..`67.... ......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98375a5c5a00 (size 512):
  comm "softirq", pid 0, jiffies 4295280780 (age 390.492s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff 87 22 06 00 01 00 00 00  ..`W7...."......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837349cca00 (size 512):
  comm "softirq", pid 0, jiffies 4295281078 (age 389.300s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff 83 22 06 00 01 00 00 00  ...Z7...."......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000007c48391f>] ip6_send_skb+0x1e/0x60
    [<00000000a44fce26>] udp_v6_send_skb.isra.27+0x1ba/0x3c0
    [<00000000fe92efdd>] udpv6_sendmsg+0x9e3/0xd90
    [<00000000f3fbe7f1>] sock_sendmsg+0x36/0x40
    [<000000008b40250b>] ___sys_sendmsg+0x2e9/0x300
    [<00000000cdb023dc>] __sys_sendmsg+0x63/0xa0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff
unreferenced object 0xffff98375ae00000 (size 512):
  comm "softirq", pid 0, jiffies 4295281926 (age 385.952s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 85 33 06 00 01 00 00 00  .."Y7....3......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000007c48391f>] ip6_send_skb+0x1e/0x60
    [<00000000a44fce26>] udp_v6_send_skb.isra.27+0x1ba/0x3c0
    [<00000000fe92efdd>] udpv6_sendmsg+0x9e3/0xd90
    [<00000000f3fbe7f1>] sock_sendmsg+0x36/0x40
    [<000000008b40250b>] ___sys_sendmsg+0x2e9/0x300
    [<00000000cdb023dc>] __sys_sendmsg+0x63/0xa0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff
unreferenced object 0xffff983759182400 (size 512):
  comm "softirq", pid 0, jiffies 4295282498 (age 383.664s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff c6 3b 06 00 01 00 00 00  .."Y7....;......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983754b0bc00 (size 512):
  comm "softirq", pid 0, jiffies 4295284213 (age 376.804s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff c3 22 06 00 01 00 00 00  .."Y7...."......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
    [<000000001883f191>] virtqueue_napi_complete+0x2a/0x70 [virtio_net]
    [<000000000ca44d09>] virtnet_poll+0x2e8/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
unreferenced object 0xffff983758b9de00 (size 512):
  comm "softirq", pid 0, jiffies 4295294800 (age 334.488s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 ca 60 57 37 98 ff ff 70 26 06 00 01 00 00 00  ..`W7...p&......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff98375ad71c00 (size 512):
  comm "softirq", pid 0, jiffies 4295296358 (age 328.260s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 f3 b2 35 37 98 ff ff 99 23 06 00 01 00 00 00  ...57....#......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983734a5b600 (size 512):
  comm "softirq", pid 0, jiffies 4295297984 (age 321.756s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 85 2f 06 00 01 00 00 00  @.`67..../......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98373997dc00 (size 512):
  comm "softirq", pid 0, jiffies 4295299225 (age 316.820s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 13 39 06 00 01 00 00 00  @.`67....9......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983756ef4400 (size 512):
  comm "softirq", pid 0, jiffies 4295300990 (age 309.760s)
  hex dump (first 32 bytes):
    00 52 8a 34 37 98 ff ff c0 ca ae 92 ff ff ff ff  .R.47...........
    c0 e3 d3 5a 37 98 ff ff e9 2d 06 00 01 00 00 00  ...Z7....-......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98375ad72400 (size 512):
  comm "softirq", pid 0, jiffies 4295301181 (age 308.996s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 74 b7 58 37 98 ff ff 08 b3 05 00 01 00 00 00  .t.X7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983734a10000 (size 512):
  comm "softirq", pid 0, jiffies 4295303368 (age 300.280s)
  hex dump (first 32 bytes):
    00 22 d7 5a 37 98 ff ff c0 ca ae 92 ff ff ff ff  .".Z7...........
    00 a6 22 59 37 98 ff ff a6 1f 06 00 01 00 00 00  .."Y7...........
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983739be9c00 (size 512):
  comm "softirq", pid 0, jiffies 4295307933 (age 282.020s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 9c 23 06 00 01 00 00 00  .."Y7....#......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000007c48391f>] ip6_send_skb+0x1e/0x60
    [<00000000a44fce26>] udp_v6_send_skb.isra.27+0x1ba/0x3c0
    [<00000000fe92efdd>] udpv6_sendmsg+0x9e3/0xd90
    [<00000000f3fbe7f1>] sock_sendmsg+0x36/0x40
    [<000000008b40250b>] ___sys_sendmsg+0x2e9/0x300
    [<00000000cdb023dc>] __sys_sendmsg+0x63/0xa0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff
unreferenced object 0xffff983758a28000 (size 512):
  comm "softirq", pid 0, jiffies 4295311612 (age 267.304s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 80 3e 06 00 01 00 00 00  .."Y7....>......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983758a29a00 (size 512):
  comm "softirq", pid 0, jiffies 4295312579 (age 263.436s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 01 3a 06 00 01 00 00 00  .."Y7....:......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000007c48391f>] ip6_send_skb+0x1e/0x60
    [<00000000a44fce26>] udp_v6_send_skb.isra.27+0x1ba/0x3c0
    [<00000000fe92efdd>] udpv6_sendmsg+0x9e3/0xd90
    [<00000000f3fbe7f1>] sock_sendmsg+0x36/0x40
    [<000000008b40250b>] ___sys_sendmsg+0x2e9/0x300
    [<00000000cdb023dc>] __sys_sendmsg+0x63/0xa0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff
unreferenced object 0xffff98375523ee00 (size 512):
  comm "softirq", pid 0, jiffies 4295317166 (age 245.116s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff 59 33 06 00 01 00 00 00  ...W7...Y3......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375589cc00 (size 512):
  comm "softirq", pid 0, jiffies 4295323691 (age 219.016s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff c1 27 06 00 01 00 00 00  .."Y7....'......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837359c7800 (size 512):
  comm "softirq", pid 0, jiffies 4295324204 (age 216.964s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff cb 26 06 00 01 00 00 00  ...W7....&......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98375661a000 (size 512):
  comm "softirq", pid 0, jiffies 4295325551 (age 211.604s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 f3 b2 35 37 98 ff ff 59 30 06 00 01 00 00 00  ...57...Y0......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983754b43400 (size 512):
  comm "softirq", pid 0, jiffies 4295329624 (age 195.312s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 82 32 06 00 01 00 00 00  .."Y7....2......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983739962000 (size 512):
  comm "softirq", pid 0, jiffies 4295330522 (age 191.720s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 e3 d3 5a 37 98 ff ff 4f 22 06 00 01 00 00 00  ...Z7...O"......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff9837587d7400 (size 512):
  comm "softirq", pid 0, jiffies 4295331809 (age 186.608s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 e3 d3 5a 37 98 ff ff 05 2d 06 00 01 00 00 00  ...Z7....-......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983755530c00 (size 512):
  comm "softirq", pid 0, jiffies 4295334190 (age 177.084s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 44 3d 06 00 01 00 00 00  @.`67...D=3D......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983734b66600 (size 512):
  comm "softirq", pid 0, jiffies 4295335285 (age 172.704s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff ed 1e 06 00 01 00 00 00  .."Y7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000007c48391f>] ip6_send_skb+0x1e/0x60
    [<00000000a44fce26>] udp_v6_send_skb.isra.27+0x1ba/0x3c0
    [<00000000fe92efdd>] udpv6_sendmsg+0x9e3/0xd90
    [<00000000f3fbe7f1>] sock_sendmsg+0x36/0x40
    [<000000008b40250b>] ___sys_sendmsg+0x2e9/0x300
    [<00000000cdb023dc>] __sys_sendmsg+0x63/0xa0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff
unreferenced object 0xffff98373498e000 (size 512):
  comm "softirq", pid 0, jiffies 4295336672 (age 167.196s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 81 f6 05 00 01 00 00 00  .."Y7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98375586b000 (size 512):
  comm "softirq", pid 0, jiffies 4295336682 (age 167.156s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff 71 27 06 00 01 00 00 00  @.zZ7...q'......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837565a9800 (size 512):
  comm "softirq", pid 0, jiffies 4295337744 (age 162.908s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 e6 d9 54 37 98 ff ff 83 20 06 00 01 00 00 00  ...T7.... ......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000007c48391f>] ip6_send_skb+0x1e/0x60
    [<00000000a44fce26>] udp_v6_send_skb.isra.27+0x1ba/0x3c0
    [<00000000fe92efdd>] udpv6_sendmsg+0x9e3/0xd90
    [<00000000f3fbe7f1>] sock_sendmsg+0x36/0x40
    [<000000008b40250b>] ___sys_sendmsg+0x2e9/0x300
    [<00000000cdb023dc>] __sys_sendmsg+0x63/0xa0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff
unreferenced object 0xffff9837580b7600 (size 512):
  comm "softirq", pid 0, jiffies 4295338512 (age 159.872s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff 32 36 06 00 01 00 00 00  ..`W7...26......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98375968e200 (size 512):
  comm "softirq", pid 0, jiffies 4295341272 (age 148.832s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff a9 23 06 00 01 00 00 00  @.zZ7....#......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983739a32000 (size 512):
  comm "softirq", pid 0, jiffies 4295341962 (age 146.072s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 e3 d3 5a 37 98 ff ff c3 20 06 00 01 00 00 00  ...Z7.... ......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983739886000 (size 512):
  comm "softirq", pid 0, jiffies 4295343162 (age 141.312s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 21 3e 06 00 01 00 00 00  @.`67...!>......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983757de4600 (size 512):
  comm "softirq", pid 0, jiffies 4295346178 (age 129.248s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 58 31 06 00 01 00 00 00  @.`67...X1......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375a9af200 (size 512):
  comm "softirq", pid 0, jiffies 4295346718 (age 127.092s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff b0 3a 06 00 01 00 00 00  ...W7....:......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98375a9af800 (size 512):
  comm "softirq", pid 0, jiffies 4295347135 (age 125.460s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff c7 3a 06 00 01 00 00 00  @.zZ7....:......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff9837585fc200 (size 512):
  comm "softirq", pid 0, jiffies 4295348247 (age 121.012s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 3d 67 36 37 98 ff ff 43 20 06 00 01 00 00 00  .=3Dg67...C ......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837348a1e00 (size 512):
  comm "softirq", pid 0, jiffies 4295349003 (age 117.988s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 10 2e 06 00 01 00 00 00  .."Y7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983739987200 (size 512):
  comm "softirq", pid 0, jiffies 4295349435 (age 116.300s)
  hex dump (first 32 bytes):
    00 f8 9a 5a 37 98 ff ff c0 ca ae 92 ff ff ff ff  ...Z7...........
    00 a6 22 59 37 98 ff ff 4f 3c 06 00 01 00 00 00  .."Y7...O<......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837575b7800 (size 512):
  comm "softirq", pid 0, jiffies 4295349911 (age 114.396s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 23 86 5a 37 98 ff ff ef 43 06 00 01 00 00 00  .#.Z7....C......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983734965600 (size 512):
  comm "softirq", pid 0, jiffies 4295351123 (age 109.548s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff d8 27 06 00 01 00 00 00  @.`67....'......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff9837586fb400 (size 512):
  comm "softirq", pid 0, jiffies 4295351438 (age 108.328s)
  hex dump (first 32 bytes):
    00 5c 68 5a 37 98 ff ff c0 ca ae 92 ff ff ff ff  .\hZ7...........
    80 74 b7 58 37 98 ff ff 92 20 06 00 01 00 00 00  .t.X7.... ......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff98375480fe00 (size 512):
  comm "softirq", pid 0, jiffies 4295351685 (age 107.340s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff cb 2f 06 00 01 00 00 00  @.`67..../......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983754ee8600 (size 512):
  comm "softirq", pid 0, jiffies 4295351813 (age 106.828s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff 67 25 06 00 01 00 00 00  @.zZ7...g%......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
    [<000000001883f191>] virtqueue_napi_complete+0x2a/0x70 [virtio_net]
    [<000000000ca44d09>] virtnet_poll+0x2e8/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<0000000062b3e9d8>] run_ksoftirqd+0x26/0x40
    [<00000000ff833423>] smpboot_thread_fn+0x10e/0x160
    [<0000000041e7c5ae>] kthread+0xf8/0x130
    [<00000000106c780b>] ret_from_fork+0x35/0x40
unreferenced object 0xffff983756970400 (size 512):
  comm "softirq", pid 0, jiffies 4295353005 (age 102.100s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff 01 20 06 00 01 00 00 00  @.zZ7.... ......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983755c12c00 (size 512):
  comm "softirq", pid 0, jiffies 4295353061 (age 101.876s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff a4 23 06 00 01 00 00 00  .."Y7....#......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983755276c00 (size 512):
  comm "softirq", pid 0, jiffies 4295353199 (age 101.324s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff 9f 28 06 00 01 00 00 00  ...W7....(......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983739987a00 (size 512):
  comm "softirq", pid 0, jiffies 4295353300 (age 100.956s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 2a 75 5d 37 98 ff ff cc 3d 06 00 01 00 00 00  .*u]7....=3D......
  backtrace:
    [<00000000060cd6fe>] ndisc_recv_ns+0x356/0x5f0
    [<000000007b12d262>] ndisc_rcv+0xfb/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
unreferenced object 0xffff983755283200 (size 512):
  comm "softirq", pid 0, jiffies 4295353571 (age 99.872s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff d9 2b 06 00 01 00 00 00  .."Y7....+......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375ae78c00 (size 512):
  comm "softirq", pid 0, jiffies 4295353962 (age 98.308s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 b3 60 36 37 98 ff ff d2 ab 05 00 01 00 00 00  ..`67...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98373491f400 (size 512):
  comm "softirq", pid 0, jiffies 4295354519 (age 96.116s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 97 3d 06 00 01 00 00 00  .."Y7....=3D......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff98375a5c6e00 (size 512):
  comm "softirq", pid 0, jiffies 4295358678 (age 79.484s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 e3 d3 5a 37 98 ff ff 3e be 05 00 01 00 00 00  ...Z7...>.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff9837348ecc00 (size 512):
  comm "softirq", pid 0, jiffies 4295359540 (age 76.036s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 9c c1 05 00 01 00 00 00  @.`67...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
    [<00000000141420d3>] virtnet_poll+0xdf/0x333 [virtio_net]
    [<000000002023c758>] net_rx_action+0x297/0x400
    [<00000000fe5448ed>] __do_softirq+0x10d/0x2c3
    [<00000000813230c9>] irq_exit+0xc2/0xd0
    [<000000006fcf95ee>] do_IRQ+0x52/0xe0
    [<00000000153d314b>] ret_from_intr+0x0/0x1d
    [<000000009939f71b>] native_safe_halt+0xe/0x10
    [<000000005d90bc13>] default_idle+0x1c/0x140
unreferenced object 0xffff983758a39c00 (size 512):
  comm "softirq", pid 0, jiffies 4295360525 (age 72.132s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 75 c5 05 00 01 00 00 00  @.`67...u.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983758a39000 (size 512):
  comm "softirq", pid 0, jiffies 4295360658 (age 71.600s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff fa c5 05 00 01 00 00 00  .."Y7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983758a38000 (size 512):
  comm "softirq", pid 0, jiffies 4295360727 (age 71.324s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff 3f c6 05 00 01 00 00 00  ..`W7...?.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
unreferenced object 0xffff9837580b6600 (size 512):
  comm "softirq", pid 0, jiffies 4295360772 (age 71.184s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff 6c c6 05 00 01 00 00 00  @.zZ7...l.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983754ba8800 (size 512):
  comm "softirq", pid 0, jiffies 4295360792 (age 71.104s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 f3 b2 35 37 98 ff ff 80 c6 05 00 01 00 00 00  ...57...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff9837580b7000 (size 512):
  comm "softirq", pid 0, jiffies 4295360795 (age 71.092s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 23 86 5a 37 98 ff ff 83 c6 05 00 01 00 00 00  .#.Z7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983754ba8000 (size 512):
  comm "softirq", pid 0, jiffies 4295360801 (age 71.104s)
  hex dump (first 32 bytes):
    00 9a a2 58 37 98 ff ff c0 ca ae 92 ff ff ff ff  ...X7...........
    80 ca 60 57 37 98 ff ff 89 c6 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983758294000 (size 512):
  comm "softirq", pid 0, jiffies 4295360866 (age 70.844s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff ca c6 05 00 01 00 00 00  ...W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983758294600 (size 512):
  comm "softirq", pid 0, jiffies 4295360892 (age 70.740s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 6a b5 59 37 98 ff ff e4 c6 05 00 01 00 00 00  .j.Y7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98375928f200 (size 512):
  comm "softirq", pid 0, jiffies 4295361036 (age 70.200s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 74 c7 05 00 01 00 00 00  .."Y7...t.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98375589ce00 (size 512):
  comm "softirq", pid 0, jiffies 4295361045 (age 70.164s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 7d c7 05 00 01 00 00 00  .."Y7...}.......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837561fa000 (size 512):
  comm "softirq", pid 0, jiffies 4295361056 (age 70.120s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 ca 60 57 37 98 ff ff 88 c7 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983758295400 (size 512):
  comm "softirq", pid 0, jiffies 4295361122 (age 69.888s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff ca c7 05 00 01 00 00 00  ...W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983758294a00 (size 512):
  comm "softirq", pid 0, jiffies 4295361226 (age 69.472s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 32 c8 05 00 01 00 00 00  @.`67...2.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983739add400 (size 512):
  comm "softirq", pid 0, jiffies 4295361230 (age 69.456s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 b3 60 36 37 98 ff ff 36 c8 05 00 01 00 00 00  ..`67...6.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983754b4a400 (size 512):
  comm "softirq", pid 0, jiffies 4295361276 (age 69.304s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff 64 c8 05 00 01 00 00 00  ..`W7...d.......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837561fbc00 (size 512):
  comm "softirq", pid 0, jiffies 4295361329 (age 69.092s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 99 c8 05 00 01 00 00 00  .."Y7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000007c48391f>] ip6_send_skb+0x1e/0x60
    [<00000000a44fce26>] udp_v6_send_skb.isra.27+0x1ba/0x3c0
    [<00000000fe92efdd>] udpv6_sendmsg+0x9e3/0xd90
    [<00000000f3fbe7f1>] sock_sendmsg+0x36/0x40
    [<000000008b40250b>] ___sys_sendmsg+0x2e9/0x300
    [<00000000cdb023dc>] __sys_sendmsg+0x63/0xa0
unreferenced object 0xffff98375936d800 (size 512):
  comm "softirq", pid 0, jiffies 4295361395 (age 68.828s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff db c8 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983739adde00 (size 512):
  comm "softirq", pid 0, jiffies 4295361419 (age 68.764s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 ca 60 57 37 98 ff ff f3 c8 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983739add600 (size 512):
  comm "softirq", pid 0, jiffies 4295361491 (age 68.476s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff 3b c9 05 00 01 00 00 00  @.zZ7...;.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983735888000 (size 512):
  comm "softirq", pid 0, jiffies 4295361494 (age 68.464s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 3e c9 05 00 01 00 00 00  @.`67...>.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98373497bc00 (size 512):
  comm "softirq", pid 0, jiffies 4295361552 (age 68.264s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff 78 c9 05 00 01 00 00 00  ...W7...x.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98373497b200 (size 512):
  comm "softirq", pid 0, jiffies 4295361560 (age 68.232s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 e3 d3 5a 37 98 ff ff 80 c9 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98373491d200 (size 512):
  comm "softirq", pid 0, jiffies 4295361580 (age 68.152s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 3d 67 36 37 98 ff ff 94 c9 05 00 01 00 00 00  .=3Dg67...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98373497a800 (size 512):
  comm "softirq", pid 0, jiffies 4295361593 (age 68.132s)
  hex dump (first 32 bytes):
    00 e4 98 34 37 98 ff ff c0 ca ae 92 ff ff ff ff  ...47...........
    00 a6 22 59 37 98 ff ff a1 c9 05 00 01 00 00 00  .."Y7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff9837348d9400 (size 512):
  comm "softirq", pid 0, jiffies 4295361648 (age 67.912s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff d8 c9 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98373491d000 (size 512):
  comm "softirq", pid 0, jiffies 4295361680 (age 67.784s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff f8 c9 05 00 01 00 00 00  @.`67...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837348d9e00 (size 512):
  comm "softirq", pid 0, jiffies 4295361924 (age 66.840s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff ec ca 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98373497b600 (size 512):
  comm "softirq", pid 0, jiffies 4295361929 (age 66.820s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 e6 d9 54 37 98 ff ff f1 ca 05 00 01 00 00 00  ...T7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98373491c200 (size 512):
  comm "softirq", pid 0, jiffies 4295362075 (age 66.236s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 83 cb 05 00 01 00 00 00  @.`67...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98372cd3a000 (size 512):
  comm "softirq", pid 0, jiffies 4295362144 (age 65.988s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 da 5b 37 98 ff ff c8 cb 05 00 01 00 00 00  ...[7...........
  backtrace:
    [<000000001d633335>] ndisc_router_discovery+0x4ab/0xae0
    [<000000002cb0a773>] ndisc_rcv+0xaf/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98372cd3ae00 (size 512):
  comm "softirq", pid 0, jiffies 4295362145 (age 65.988s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 da 5b 37 98 ff ff c9 cb 05 00 01 00 00 00  ...[7...........
  backtrace:
    [<000000001d633335>] ndisc_router_discovery+0x4ab/0xae0
    [<000000002cb0a773>] ndisc_rcv+0xaf/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98372cd3b600 (size 512):
  comm "softirq", pid 0, jiffies 4295362146 (age 65.984s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 da 5b 37 98 ff ff ca cb 05 00 01 00 00 00  ...[7...........
  backtrace:
    [<000000001d633335>] ndisc_router_discovery+0x4ab/0xae0
    [<000000002cb0a773>] ndisc_rcv+0xaf/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375a685600 (size 512):
  comm "softirq", pid 0, jiffies 4295362147 (age 66.008s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff cb cb 05 00 01 00 00 00  @.zZ7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375a3e7c00 (size 512):
  comm "softirq", pid 0, jiffies 4295362147 (age 66.008s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 da 5b 37 98 ff ff cb cb 05 00 01 00 00 00  ...[7...........
  backtrace:
    [<000000001d633335>] ndisc_router_discovery+0x4ab/0xae0
    [<000000002cb0a773>] ndisc_rcv+0xaf/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983759029400 (size 512):
  comm "softirq", pid 0, jiffies 4295362155 (age 65.976s)
  hex dump (first 32 bytes):
    00 fc 97 5b 37 98 ff ff c0 ca ae 92 ff ff ff ff  ...[7...........
    80 b7 c1 5a 37 98 ff ff d3 cb 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983734a10400 (size 512):
  comm "softirq", pid 0, jiffies 4295362275 (age 65.528s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 e3 d3 5a 37 98 ff ff 4b cc 05 00 01 00 00 00  ...Z7...K.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983734b14200 (size 512):
  comm "softirq", pid 0, jiffies 4295362283 (age 65.496s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 53 cc 05 00 01 00 00 00  @.`67...S.......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983734a11c00 (size 512):
  comm "softirq", pid 0, jiffies 4295362313 (age 65.376s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 71 cc 05 00 01 00 00 00  .."Y7...q.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
unreferenced object 0xffff98373491da00 (size 512):
  comm "softirq", pid 0, jiffies 4295362406 (age 65.036s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff ce cc 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983754b8ae00 (size 512):
  comm "softirq", pid 0, jiffies 4295362517 (age 64.592s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff 3d cd 05 00 01 00 00 00  @.zZ7...=3D.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
unreferenced object 0xffff983759029a00 (size 512):
  comm "softirq", pid 0, jiffies 4295362542 (age 64.492s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff d1 21 06 00 01 00 00 00  ...Z7....!......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983756ae7600 (size 512):
  comm "softirq", pid 0, jiffies 4295362853 (age 63.280s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 ca 60 57 37 98 ff ff 8d ce 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983739adbc00 (size 512):
  comm "softirq", pid 0, jiffies 4295363005 (age 62.672s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 b8 60 36 37 98 ff ff 25 cf 05 00 01 00 00 00  @.`67...%.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
unreferenced object 0xffff983739842a00 (size 512):
  comm "softirq", pid 0, jiffies 4295363128 (age 62.180s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 f3 b2 35 37 98 ff ff a0 cf 05 00 01 00 00 00  ...57...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983739adb000 (size 512):
  comm "softirq", pid 0, jiffies 4295363185 (age 61.984s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff d9 cf 05 00 01 00 00 00  @.zZ7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98373491c000 (size 512):
  comm "softirq", pid 0, jiffies 4295363241 (age 61.760s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff 11 d0 05 00 01 00 00 00  ...W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983734b66800 (size 512):
  comm "softirq", pid 0, jiffies 4295363255 (age 61.704s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 ca 60 57 37 98 ff ff 9a d4 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98373497a400 (size 512):
  comm "softirq", pid 0, jiffies 4295363280 (age 61.636s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff be 20 06 00 01 00 00 00  .."Y7.... ......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983759a76e00 (size 512):
  comm "softirq", pid 0, jiffies 4295363385 (age 61.216s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 13 02 57 37 98 ff ff a1 d0 05 00 01 00 00 00  ...W7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837349cdc00 (size 512):
  comm "softirq", pid 0, jiffies 4295363389 (age 61.200s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff a5 d0 05 00 01 00 00 00  @.zZ7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983756c79200 (size 512):
  comm "softirq", pid 0, jiffies 4295363509 (age 60.752s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff 1d d1 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983734b66200 (size 512):
  comm "softirq", pid 0, jiffies 4295363521 (age 60.704s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 e6 d9 54 37 98 ff ff a9 d5 05 00 01 00 00 00  ...T7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837398e3a00 (size 512):
  comm "softirq", pid 0, jiffies 4295363640 (age 60.228s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 74 b7 58 37 98 ff ff a0 d1 05 00 01 00 00 00  .t.X7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98375869c400 (size 512):
  comm "softirq", pid 0, jiffies 4295363685 (age 60.076s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff cd d1 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983755cda200 (size 512):
  comm "softirq", pid 0, jiffies 4295363692 (age 60.048s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff d4 d1 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983759a76800 (size 512):
  comm "softirq", pid 0, jiffies 4295363722 (age 59.928s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 cf 60 57 37 98 ff ff f2 d1 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98373497a600 (size 512):
  comm "softirq", pid 0, jiffies 4295363754 (age 59.832s)
  hex dump (first 32 bytes):
    00 1a a0 54 37 98 ff ff c0 ca ae 92 ff ff ff ff  ...T7...........
    80 ca 60 57 37 98 ff ff 12 d2 05 00 01 00 00 00  ..`W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff9837348dd600 (size 512):
  comm "softirq", pid 0, jiffies 4295363808 (age 59.616s)
  hex dump (first 32 bytes):
    00 5e 98 5a 37 98 ff ff c0 ca ae 92 ff ff ff ff  .^.Z7...........
    80 b7 c1 5a 37 98 ff ff 48 d2 05 00 01 00 00 00  ...Z7...H.......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837575b7c00 (size 512):
  comm "softirq", pid 0, jiffies 4295363834 (age 59.512s)
  hex dump (first 32 bytes):
    00 ea 91 34 37 98 ff ff c0 ca ae 92 ff ff ff ff  ...47...........
    80 b7 c1 5a 37 98 ff ff a1 d6 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375869cc00 (size 512):
  comm "softirq", pid 0, jiffies 4295363957 (age 59.052s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 2a 75 5d 37 98 ff ff dd d2 05 00 01 00 00 00  .*u]7...........
  backtrace:
    [<000000001d633335>] ndisc_router_discovery+0x4ab/0xae0
    [<000000002cb0a773>] ndisc_rcv+0xaf/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983739be8400 (size 512):
  comm "softirq", pid 0, jiffies 4295363974 (age 58.984s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 23 86 5a 37 98 ff ff ee d2 05 00 01 00 00 00  .#.Z7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983739be9000 (size 512):
  comm "softirq", pid 0, jiffies 4295364037 (age 58.732s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff 2d d3 05 00 01 00 00 00  @.zZ7...-.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff9837593ff000 (size 512):
  comm "softirq", pid 0, jiffies 4295364055 (age 58.688s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    c0 f3 b2 35 37 98 ff ff 3f d3 05 00 01 00 00 00  ...57...?.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98375c3a2600 (size 512):
  comm "softirq", pid 0, jiffies 4295364064 (age 58.652s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 74 b7 58 37 98 ff ff 48 d3 05 00 01 00 00 00  .t.X7...H.......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff9837581a6a00 (size 512):
  comm "softirq", pid 0, jiffies 4295364091 (age 58.544s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 63 d3 05 00 01 00 00 00  .."Y7...c.......
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983759160200 (size 512):
  comm "softirq", pid 0, jiffies 4295364180 (age 58.216s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff bc d3 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375869c200 (size 512):
  comm "softirq", pid 0, jiffies 4295364197 (age 58.148s)
  hex dump (first 32 bytes):
    00 76 ae 56 37 98 ff ff c0 ca ae 92 ff ff ff ff  .v.V7...........
    40 b8 60 36 37 98 ff ff 45 20 06 00 01 00 00 00  @.`67...E ......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983759161e00 (size 512):
  comm "softirq", pid 0, jiffies 4295364205 (age 58.116s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff d5 d3 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983754a02600 (size 512):
  comm "softirq", pid 0, jiffies 4295364270 (age 57.884s)
  hex dump (first 32 bytes):
    00 40 5c 5a 37 98 ff ff c0 ca ae 92 ff ff ff ff  .@\Z7...........
    40 e8 7a 5a 37 98 ff ff 16 d4 05 00 01 00 00 00  @.zZ7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff983756f0c400 (size 512):
  comm "softirq", pid 0, jiffies 4295364337 (age 57.616s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 23 86 5a 37 98 ff ff 59 d4 05 00 01 00 00 00  .#.Z7...Y.......
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375523e600 (size 512):
  comm "softirq", pid 0, jiffies 4295364497 (age 56.976s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff f9 d4 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983754be8a00 (size 512):
  comm "softirq", pid 0, jiffies 4295364521 (age 56.904s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff 11 d5 05 00 01 00 00 00  @.zZ7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375523f000 (size 512):
  comm "softirq", pid 0, jiffies 4295364532 (age 56.860s)
  hex dump (first 32 bytes):
    00 66 04 56 37 98 ff ff c0 ca ae 92 ff ff ff ff  .f.V7...........
    40 b8 60 36 37 98 ff ff 1c d5 05 00 01 00 00 00  @.`67...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<00000000ba6754e4>] napi_gro_flush+0x9d/0xf0
    [<00000000d19e9454>] napi_complete_done+0x8c/0x110
unreferenced object 0xffff983754be8600 (size 512):
  comm "softirq", pid 0, jiffies 4295364654 (age 56.372s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 23 86 5a 37 98 ff ff 96 d5 05 00 01 00 00 00  .#.Z7...........
  backtrace:
    [<000000005facc9a7>] ndisc_recv_rs+0x173/0x1b0
    [<000000009600c5ca>] ndisc_rcv+0xe1/0x110
    [<0000000062b7960c>] icmpv6_rcv+0x3c9/0x5b0
    [<000000000904ed80>] ip6_input_finish+0xea/0x440
    [<00000000216e9e49>] ip6_input+0x3b/0xb0
    [<00000000c9fcd6da>] ip6_mc_input+0xcf/0x210
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<0000000080274b94>] br_pass_frame_up+0xc8/0x150 [bridge]
    [<00000000c91c8dcb>] br_handle_frame_finish+0x239/0x410 [bridge]
    [<00000000e91ebfe6>] br_handle_frame+0x198/0x310 [bridge]
    [<00000000519039e9>] __netif_receive_skb_core+0x3c2/0xce0
    [<00000000a653de4d>] __netif_receive_skb_one_core+0x36/0x70
    [<00000000e15f603d>] process_backlog+0x9f/0x160
    [<000000002023c758>] net_rx_action+0x297/0x400
unreferenced object 0xffff98375523fa00 (size 512):
  comm "softirq", pid 0, jiffies 4295364672 (age 56.328s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    80 b7 c1 5a 37 98 ff ff a8 d5 05 00 01 00 00 00  ...Z7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983756051200 (size 512):
  comm "softirq", pid 0, jiffies 4295364675 (age 56.316s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 e6 d9 54 37 98 ff ff ab d5 05 00 01 00 00 00  ...T7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff98375869d600 (size 512):
  comm "softirq", pid 0, jiffies 4295364699 (age 56.220s)
  hex dump (first 32 bytes):
    00 78 97 59 37 98 ff ff c0 ca ae 92 ff ff ff ff  .x.Y7...........
    00 13 02 57 37 98 ff ff c3 d5 05 00 01 00 00 00  ...W7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff9837561fce00 (size 512):
  comm "softirq", pid 0, jiffies 4295364911 (age 55.400s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    00 a6 22 59 37 98 ff ff 97 d6 05 00 01 00 00 00  .."Y7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]
unreferenced object 0xffff983756c9d400 (size 512):
  comm "softirq", pid 0, jiffies 4295364969 (age 55.168s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 ca ae 92 ff ff ff ff  ................
    40 e8 7a 5a 37 98 ff ff d1 d6 05 00 01 00 00 00  @.zZ7...........
  backtrace:
    [<000000007f5e7474>] ip6_finish_output2+0x211/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<0000000080a59070>] ndisc_send_skb+0x288/0x300
    [<00000000d169f013>] ndisc_send_ns+0x143/0x210
    [<00000000ca5097ee>] ndisc_solicit+0xd1/0x180
    [<000000006f6d1cec>] neigh_probe+0x48/0x60
    [<0000000024d549ac>] __neigh_event_send+0x1b2/0x260
    [<00000000db69d35b>] neigh_resolve_output+0x122/0x1b0
    [<0000000023e12196>] ip6_finish_output2+0x1c6/0x570
    [<00000000e80b4fdd>] ip6_output+0x6c/0x120
    [<000000005d48f32c>] ip6_forward+0x4d8/0x910
    [<00000000821d6d2b>] ipv6_rcv+0x64/0xe0
    [<0000000039708f5c>] __netif_receive_skb_one_core+0x52/0x70
    [<0000000062d09bf2>] netif_receive_skb_internal+0x34/0xe0
    [<000000004b947c86>] napi_gro_receive+0xb8/0xe0
    [<000000008a158bfb>] receive_buf+0x3fe/0x14a0 [virtio_net]

--------------3141603C746A06B34402B855--
