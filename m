Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A1F24CAD
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 12:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfEUK2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 06:28:54 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41094 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEUK2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 06:28:54 -0400
Received: by mail-lf1-f66.google.com with SMTP id d8so12637385lfb.8;
        Tue, 21 May 2019 03:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language;
        bh=mpYXtdsUWNbeccAIywEl4UaSAhjl4gBKJ90NkZlAKFw=;
        b=mxi3uyzHog1AqUJCb2xTatuk6bjh6QFENd50GvwbRhU+suirammKro2Gxn8c19UWJm
         3X4fnIOEcU5WMYJiFomcyn2UkT0zLVtppjypSesmUpidS2gl5uJZ2laclG10u/kv8nES
         7kjBa3bhP3lp4wpnbbXNHA1fWJIB4oxaQlToNKr4YinlXOTB3Hz3uGOyZtGZAOx6NCsC
         NXVTq+YGh3c3Gxq7jmBdIpfxHcRiS3rp5zIjktB49DiEdR78N3KO/tE/f7UQhyNLiX6K
         TDeqdc8W0BoLAHoVXJK7j8UX9EfssqgO3et7BQA1JibXQTziBgJHcDEr87ikJMdP0oUI
         w1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language;
        bh=mpYXtdsUWNbeccAIywEl4UaSAhjl4gBKJ90NkZlAKFw=;
        b=PD6wIsAgK6Ipk2iJFbbtQVN86Yn6A+ij62lxPdGW2rCSlh9JF8mw/XveQa8DaAj6Jn
         AH7HGAiFWopP9HpgndfrG2tBtsm7WR4OtVm1StQlOkYcCUnpXQrOChZ5vgw5fzg5mkyM
         iCI7Wd0jfkjTDINnThK8BuRvmjehvfNmZoYVyvgj3Zr9pVwupkPeabgNGvYmSpsQnqTm
         Glcilx5VJ4ZBk1KutCP95lPW0OJmWrLIOiFgEneuzsGFEkRpmJkUNUyIgGgr0YJLsfhE
         9aGmbZ/Fh0TNKvcV5UKZT1VR8rl/5qUYgoICc0JWDkVVFuu78LMIrQE55Uh1wK5h/97n
         3X1g==
X-Gm-Message-State: APjAAAXFups4/i3nHHgbjV+y+T4J8rk0LB3bXvZv/PstfR5kXXmUWlLY
        YRHvtTgG78jZ9nfTml7bgqc=
X-Google-Smtp-Source: APXvYqyxPJbnSyCXfS1uLADdjWVLErha9YuAb8d/3tZPiV9maoDIZv0yZlIGHwPo4n2XSTm3jg51aw==
X-Received: by 2002:ac2:51de:: with SMTP id u30mr32843332lfm.42.1558434531477;
        Tue, 21 May 2019 03:28:51 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id v2sm4283760ljg.6.2019.05.21.03.28.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 03:28:50 -0700 (PDT)
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: ARM router NAT performance affected by random/unrelated commits
To:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     linux-block@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Jo-Philipp Wich <jo@mein.io>, John Crispin <john@phrozen.org>
Message-ID: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com>
Date:   Tue, 21 May 2019 12:28:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------1044F4275EEC14C287F51DC5"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------1044F4275EEC14C287F51DC5
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I work on home routers based on Broadcom's Northstar SoCs. Those devices
have ARM Cortex-A9 and most of them are dual-core.

As for home routers, my main concern is network performance. That CPU
isn't powerful enough to handle gigabit traffic so all kind of
optimizations do matter. I noticed some unexpected changes in NAT
performance when switching between kernels.

My hardware is BCM47094 SoC (dual core ARM) with integrated network
controller and external BCM53012 switch.

Relevant setup:
* SoC network controller is wired to the hardware switch
* Switch passes 802.1q frames with VID 1 to four LAN ports
* Switch passes 802.1q frames with VID 2 to WAN port
* Linux does NAT for LAN (eth0.1) to WAN (eth0.2)
* Linux uses pfifo and "echo 2 > rps_cpus"
* Ryzen 5 PRO 2500U (x86_64) laptop connected to a LAN port
* Intel i7-2670QM laptop connected to a WAN port

*****

I found a very nice example of commit that does /nothing/ yet it affects
NAT performance: 9316a9ed6895 ("blk-mq: provide helper for setting up an
SQ queue and tag set")
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9316a9ed6895c4ad2f0cde171d486f80c55d8283
All it does is exporting an unused symbol (function).

Let me share some numbers (I use iperf for testing):

git reset --hard v4.19
git am OpenWrt-mtd-chages.patch
[  3]  0.0-30.0 sec  2.60 GBytes   745 Mbits/sec
[  3]  0.0-30.0 sec  2.60 GBytes   745 Mbits/sec
[  3]  0.0-30.0 sec  2.60 GBytes   744 Mbits/sec
[  3]  0.0-30.0 sec  2.59 GBytes   742 Mbits/sec
[  3]  0.0-30.0 sec  2.59 GBytes   740 Mbits/sec
[  3]  0.0-30.0 sec  2.59 GBytes   740 Mbits/sec
[  3]  0.0-30.0 sec  2.58 GBytes   738 Mbits/sec
[  3]  0.0-30.0 sec  2.58 GBytes   738 Mbits/sec
[  3]  0.0-30.0 sec  2.58 GBytes   738 Mbits/sec
[  3]  0.0-30.0 sec  2.57 GBytes   735 Mbits/sec
Average: 741 Mb/s

git reset --hard v4.19
git am OpenWrt-mtd-chages.patch
git cherry-pick -x 9316a9ed6895
[  3]  0.0-30.0 sec  2.73 GBytes   780 Mbits/sec
[  3]  0.0-30.0 sec  2.72 GBytes   777 Mbits/sec
[  3]  0.0-30.0 sec  2.71 GBytes   775 Mbits/sec
[  3]  0.0-30.0 sec  2.70 GBytes   773 Mbits/sec
[  3]  0.0-30.0 sec  2.70 GBytes   771 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   771 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   771 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   770 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   769 Mbits/sec
[  3]  0.0-30.0 sec  2.68 GBytes   768 Mbits/sec
Average: 773 Mb/s

As you can see cherry-picking (on top of Linux 4.19) a single commit
that does /nothing/ can improve NAT performance by 4,5%.

*****

I was hoping to learn something from profiling kernel with the "perf"
tool. Eanbling CONFIG_PERF_EVENTS resulted in smaller NAT performance
gain: 741 Mb/s → 750 Mb/s. I tried it anyway.

Without cherry-picking I got:
+    9,04%  swapper          [kernel.kallsyms]  [k] v7_dma_inv_range
+    5,54%  swapper          [kernel.kallsyms]  [k] __irqentry_text_end
+    5,12%  swapper          [kernel.kallsyms]  [k] l2c210_inv_range
+    4,30%  ksoftirqd/1      [kernel.kallsyms]  [k] v7_dma_clean_range
+    4,02%  swapper          [kernel.kallsyms]  [k] bcma_host_soc_read32
+    3,13%  swapper          [kernel.kallsyms]  [k] arch_cpu_idle
+    2,88%  ksoftirqd/1      [kernel.kallsyms]  [k] __netif_receive_skb_core
+    2,51%  ksoftirqd/1      [kernel.kallsyms]  [k] l2c210_clean_range
+    1,88%  ksoftirqd/1      [kernel.kallsyms]  [k] fib_table_lookup
(741 Mb/s while *not* running perf)

With cherry-picked 9316a9ed6895 I got:
+    9,16%  swapper          [kernel.kallsyms]  [k] v7_dma_inv_range
+    5,64%  swapper          [kernel.kallsyms]  [k] __irqentry_text_end
+    5,05%  swapper          [kernel.kallsyms]  [k] l2c210_inv_range
+    4,25%  ksoftirqd/1      [kernel.kallsyms]  [k] v7_dma_clean_range
+    4,10%  swapper          [kernel.kallsyms]  [k] bcma_host_soc_read32
+    3,35%  ksoftirqd/1      [kernel.kallsyms]  [k] __netif_receive_skb_core
+    3,17%  swapper          [kernel.kallsyms]  [k] arch_cpu_idle
+    2,49%  ksoftirqd/1      [kernel.kallsyms]  [k] l2c210_clean_range
+    2,03%  ksoftirqd/1      [kernel.kallsyms]  [k] fib_table_lookup
(750 Mb/s while *not* running perf)

Changes seem quite minimal and I'm not sure if they tell what is causing
that NAT performance change at all.

*****

I also tried running cachestat but didn't get anything interesting:
Counting cache functions... Output every 1 seconds.
TIME         HITS   MISSES  DIRTIES    RATIO   BUFFERS_MB   CACHE_MB
10:06:59     1020        5        0    99.5%            0          2
10:07:00     1029        0        0   100.0%            0          2
10:07:01     1013        0        0   100.0%            0          2
10:07:02     1029        0        0   100.0%            0          2
10:07:03     1029        0        0   100.0%            0          2
10:07:04      997        0        0   100.0%            0          2
10:07:05     1013        0        0   100.0%            0          2
(I started iperf at 10:07:00).

*****

There were more situations with such unexpected performance changes.
Another example: cherry-picking 5b0890a97204 ("flow_dissector: Parse
batman-adv unicast headers")
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5b0890a97204627d75a333fc30f29f737e2bfad6
to some Linux 4.14.x release was lowering NAT performance by 55 Mb/s.

The tricky part is there aren't any ETH_P_BATMAN packets in my traffic.
Extra tests revealed that any __skb_flow_dissect() modification was
lowering my NAT performance (e.g. commenting out ETH_P_TIPC or
ETH_P_FCOE switch cases).

*****

I would like every kernel to provide a maximum NAT performance, no
matter what random commits it contains.

Suffering from such a random changes makes it also really hard to notice
a real performance regression.

Do you have any idea what is causing those performance changes? Can I
provide any extra info to help debugging this?

--------------1044F4275EEC14C287F51DC5
Content-Type: text/plain; charset=UTF-8;
 name="openwrt-mtd-patches.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="openwrt-mtd-patches.txt"

MDQ3LXY0LjIxLW10ZC1rZWVwLW9yaWdpbmFsLWZsYWdzLWZvci1ldmVyeS1zdHJ1Y3QtbXRk
X2luZm8ucGF0Y2gKMDQ4LXY0LjIxLW10ZC1pbXByb3ZlLWNhbGN1bGF0aW5nLXBhcnRpdGlv
bi1ib3VuZGFyaWVzLXdoZW4tY2gucGF0Y2gKMDgwLXY1LjEtMDAwMS1iY21hLWtlZXAtYS1k
aXJlY3QtcG9pbnRlci10by10aGUtc3RydWN0LWRldmljZS5wYXRjaAowODAtdjUuMS0wMDAy
LWJjbWEtdXNlLWRldl8tcHJpbnRpbmctZnVuY3Rpb25zLnBhdGNoCjA5NS1BbGxvdy1jbGFz
cy1lLWFkZHJlc3MtYXNzaWdubWVudC12aWEtaWZjb25maWctaW9jdGwucGF0Y2gKCjE0MC1q
ZmZzMi11c2UtLnJlbmFtZTItYW5kLWFkZC1SRU5BTUVfV0hJVEVPVVQtc3VwcG9ydC5wYXRj
aAoxNDEtamZmczItYWRkLVJFTkFNRV9FWENIQU5HRS1zdXBwb3J0LnBhdGNoCjQwMC1tdGQt
YWRkLXJvb3Rmcy1zcGxpdC1zdXBwb3J0LnBhdGNoCjQwMS1tdGQtYWRkLXN1cHBvcnQtZm9y
LWRpZmZlcmVudC1wYXJ0aXRpb24tcGFyc2VyLXR5cGVzLnBhdGNoCjQwMi1tdGQtdXNlLXR5
cGVkLW10ZC1wYXJzZXJzLWZvci1yb290ZnMtYW5kLWZpcm13YXJlLXNwbGl0LnBhdGNoCjQw
My1tdGQtaG9vay1tdGRzcGxpdC10by1LYnVpbGQucGF0Y2gKNDA0LW10ZC1hZGQtbW9yZS1o
ZWxwZXItZnVuY3Rpb25zLnBhdGNoCjQzMS1tdGQtYmNtNDd4eHBhcnQtY2hlY2stZm9yLWJh
ZC1ibG9ja3Mtd2hlbi1jYWxjdWxhdGluLnBhdGNoCjQzMi1tdGQtYmNtNDd4eHBhcnQtZGV0
ZWN0LVRfTWV0ZXItcGFydGl0aW9uLnBhdGNoCjQ4MC1tdGQtc2V0LXJvb3Rmcy10by1iZS1y
b290LWRldi5wYXRjaAo0OTAtdWJpLWF1dG8tYXR0YWNoLW10ZC1kZXZpY2UtbmFtZWQtdWJp
LW9yLWRhdGEtb24tYm9vdC5wYXRjaAo0OTEtdWJpLWF1dG8tY3JlYXRlLXViaWJsb2NrLWRl
dmljZS1mb3Itcm9vdGZzLnBhdGNoCjQ5Mi10cnktYXV0by1tb3VudGluZy11YmkwLXJvb3Rm
cy1pbi1pbml0LWRvX21vdW50cy5jLnBhdGNoCjQ5My11Ymktc2V0LVJPT1RfREVWLXRvLXVi
aWJsb2NrLXJvb3Rmcy1pZi11bnNldC5wYXRjaAo1MzAtamZmczJfbWFrZV9sem1hX2F2YWls
YWJsZS5wYXRjaAo1MzItamZmczJfZW9mZGV0ZWN0LnBhdGNoCjUwMC12NC4yMC11Ymlmcy1G
aXgtZGVmYXVsdC1jb21wcmVzc2lvbi1zZWxlY3Rpb24taW4tdWJpZnMucGF0Y2gKNTUzLXVi
aWZzLUFkZC1vcHRpb24tdG8tY3JlYXRlLVVCSS1GUy12ZXJzaW9uLTQtb24tZW1wdHkucGF0
Y2gKCjcwMC1zd2NvbmZpZ19zd2l0Y2hfZHJpdmVycy5wYXRjaAo3MDItcGh5X2FkZF9hbmVn
X2RvbmVfZnVuY3Rpb24ucGF0Y2gKNzIxLXBoeV9wYWNrZXRzLnBhdGNoCjc3My1iZ21hYy1h
ZGQtc3JhYi1zd2l0Y2gucGF0Y2gKOTEwLWtvYmplY3RfdWV2ZW50LnBhdGNoCjkxMS1rb2Jq
ZWN0X2FkZF9icm9hZGNhc3RfdWV2ZW50LnBhdGNoCg==
--------------1044F4275EEC14C287F51DC5--
