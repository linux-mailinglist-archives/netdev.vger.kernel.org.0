Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD71026339
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 13:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfEVLvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 07:51:08 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32803 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfEVLvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 07:51:07 -0400
Received: by mail-lf1-f65.google.com with SMTP id x132so1476226lfd.0;
        Wed, 22 May 2019 04:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=0ynUYONVcMiVbkrkcaIw584jgiD0pTwFWZg9Gin77bo=;
        b=pCIXG2apP2eP17dxL3Fcc9s1Po4HcUjSyZOLarAaiah2CRKo092uOOzwoS8W+89Yoq
         91OoZsgbqvKnGDCfmKFV150MeQygCfkDdxUH8Cti/NmOUmJwLO+zWIZTzZ2azXlcKUkw
         yUwbmGmQkb5/YooUExPckSyPQG1+05oBe4i5+wfRTO584laJEGpbOy224XB+cxOqpxuz
         ytlY1hevwI1YzM+s9v+C9I3e/zs1gvAj5dF0e1fYZ9+lrddjjPvIq1oQHnI6cYTp+7nI
         aLmR45Is1Rt9j2qEz2hVcZIPKuKVrGDHn8Ap3EeOWK49nBg9kTmNDMmKCsqCNf5FB9pU
         RL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=0ynUYONVcMiVbkrkcaIw584jgiD0pTwFWZg9Gin77bo=;
        b=VKnWv7PrNYFTbCDLkXnNKJIohRMuSmbVJd+gVGekE1LkUm2HelUtQjhQ4wJBxqJSP6
         U/Ogps9nMtgSrtFoE5CCVORAoRAgav67SbSsPS2MgPR54qxljYFVNYuhnXycnAPlDX+Z
         SAPU2XsJKi146385VGwjfZc2Imesh2oElZlf9aSuMH9Ii6Uyar+JQUyi6tmLscJ+4U5P
         1NBBk8dTJuG9tf3kotZ7CCUcZGRMUwuV009B95XiHKbatS+NEzz2oEHX1Ag71ADE3Crm
         zaMxuoeosAENyriG6lVoHmNT+kEBUhZ8Lm4vNU1IFbDsmoffBJXKuhYs0QT+/m9FhPHo
         7s+Q==
X-Gm-Message-State: APjAAAV/92+ZyC5mf+sY6GnCEetOrXDxpyfBmPJ9mzJMTWfukt3+DCJV
        biCZbHl/3UbgaZR00s9l/Pw=
X-Google-Smtp-Source: APXvYqy2S4Tw15COferEzBGg+gYLtPOE26SWc436EPB7s/SfCOmOTSDqz+ruUjxlnOAUBK2I43Jfnw==
X-Received: by 2002:a19:7d05:: with SMTP id y5mr9179157lfc.40.1558525864270;
        Wed, 22 May 2019 04:51:04 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id h10sm6193902ljm.9.2019.05.22.04.51.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 04:51:03 -0700 (PDT)
Subject: Re: ARM router NAT performance affected by random/unrelated commits
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, John Crispin <john@phrozen.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Jo-Philipp Wich <jo@mein.io>, Felix Fietkau <nbd@nbd.name>
References: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com>
 <20190521104512.2r67fydrgniwqaja@shell.armlinux.org.uk>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <de262f71-748f-d242-f1d4-ea10188a0438@gmail.com>
Date:   Wed, 22 May 2019 13:51:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20190521104512.2r67fydrgniwqaja@shell.armlinux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------1DD6FAD97BC7F1875FD92211"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------1DD6FAD97BC7F1875FD92211
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21.05.2019 12:45, Russell King - ARM Linux admin wrote:> On Tue, May 21, 2019 at 12:28:48PM +0200, Rafał Miłecki wrote:
 >> I work on home routers based on Broadcom's Northstar SoCs. Those devices
 >> have ARM Cortex-A9 and most of them are dual-core.
 >>
 >> As for home routers, my main concern is network performance. That CPU
 >> isn't powerful enough to handle gigabit traffic so all kind of
 >> optimizations do matter. I noticed some unexpected changes in NAT
 >> performance when switching between kernels.
 >>
 >> My hardware is BCM47094 SoC (dual core ARM) with integrated network
 >> controller and external BCM53012 switch.
 >
 > Guessing, I'd say it's to do with the placement of code wrt cachelines.
 > You could try aligning some of the cache flushing code to a cache line
 > and see what effect that has.

Is System.map a good place to check for functions code alignment?

With Linux 4.19 + OpenWrt mtd patches I have:
(...)
c010ea94 t v7_dma_inv_range
c010eae0 t v7_dma_clean_range
(...)
c02ca3d0 T blk_mq_update_nr_hw_queues
c02ca69c T blk_mq_alloc_tag_set
c02ca94c T blk_mq_release
c02ca9b4 T blk_mq_free_queue
c02caa88 T blk_mq_update_nr_requests
c02cab50 T blk_mq_unique_tag
(...)

After cherry-picking 9316a9ed6895 ("blk-mq: provide helper for setting
up an SQ queue and tag set"):
(...)
c010ea94 t v7_dma_inv_range
c010eae0 t v7_dma_clean_range
(...)
c02ca3d0 T blk_mq_update_nr_hw_queues
c02ca69c T blk_mq_alloc_tag_set
c02ca94c T blk_mq_init_sq_queue <-- NEW
c02ca9c0 T blk_mq_release <-- Different address of this & all below
c02caa28 T blk_mq_free_queue
c02caafc T blk_mq_update_nr_requests
c02cabc4 T blk_mq_unique_tag
(...)

As you can see blk_mq_init_sq_queue has appeared in the System.map and
it affected addresses of ~30000 symbols. I can believe some frequently
used symbols got luckily aligned and that improved overall performance.

Interestingly v7_dma_inv_range() and v7_dma_clean_range() were not
relocated.

*****

I followed Russell's suggestion and added .align 5 to cache-v7.S (see
two attached diffs).

1) v4.19 + OpenWrt mtd patches
 > egrep -B 1 -A 1 "v7_dma_(inv|clean)_range" System.map
c010ea58 T v7_flush_kern_dcache_area
c010ea94 t v7_dma_inv_range
c010eae0 t v7_dma_clean_range
c010eb18 T b15_dma_flush_range

2) v4.19 + OpenWrt mtd patches + two .align 5 in cache-v7.S
c010ea6c T v7_flush_kern_dcache_area
c010eac0 t v7_dma_inv_range
c010eb20 t v7_dma_clean_range
c010eb58 T b15_dma_flush_range
(actually 15 symbols above v7_dma_inv_range were replaced)

This method seems to be somehow working (at least affects addresses in
System.map).

*****

I run 2 tests for each combination of changes. Each test consisted of
10 sequences of: 30 seconds iperf session + reboot.


 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
Test #1: 738 Mb/s
Test #2: 737 Mb/s

 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
patch -p1 < v7_dma_clean_range-align.diff
Test #1: 746 Mb/s
Test #2: 747 Mb/s

 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
 > patch -p1 < v7_dma_inv_range-align.diff
Test #1: 745 Mb/s
Test #2: 746 Mb/s

 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
 > patch -p1 < v7_dma_clean_range-align.diff
 > patch -p1 < v7_dma_inv_range-align.diff
Test #1: 762 Mb/s
Test #2: 761 Mb/s

As you can see I got a quite nice performance improvement after aligning
both: v7_dma_clean_range() and v7_dma_inv_range().

It still wasn't as good as with 9316a9ed6895 cherry-picked but pretty
close.


 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
 > git cherry-pick -x 9316a9ed6895
Test #1: 770 Mb/s
Test #2: 766 Mb/s

 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
 > git cherry-pick -x 9316a9ed6895
 > patch -p1 < v7_dma_clean_range-align.diff
Test #1: 756 Mb/s
Test #2: 759 Mb/s

 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
 > git cherry-pick -x 9316a9ed6895
 > patch -p1 < v7_dma_inv_range-align.diff
Test #1: 758 Mb/s
Test #2: 759 Mb/s

 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
 > git cherry-pick -x 9316a9ed6895
 > patch -p1 < v7_dma_clean_range-align.diff
 > patch -p1 < v7_dma_inv_range-align.diff
Test #1: 767 Mb/s
Test #2: 763 Mb/s

Now you can see how unpredictable it is. If I cherry-pick 9316a9ed6895
and do an extra alignment of v7_dma_clean_range() and v7_dma_inv_range()
that extra alignment can actually *hurt* NAT performance.

My guess is that:
1) 9316a9ed6895 provides alignment of some very important function(s)
2) DMA alignments on top ^^ provide some gain but also break some align

*****

SUMMARY

It seems that for Linux 4.19 + my .config I can get a very lucky &
optimal alignment of functions by cherry-picking 9316a9ed6895.

I thought of checking functions reported by the "perf" tool with CPU
usage of 2%+.

All following functions keep their original address with 9316a9ed6895:
__irqentry_text_end
arch_cpu_idle
l2c210_clean_range
l2c210_inv_range
v7_dma_clean_range
v7_dma_inv_range

Remaining 3 functions got reallocated:
-c03e5038 t __netif_receive_skb_core
+c03e50b0 t __netif_receive_skb_core
-c03c8b1c t bcma_host_soc_read32
+c03c8b94 t bcma_host_soc_read32
-c0475620 T fib_table_lookup
+c0475698 T fib_table_lookup

I tried aligning all 3 above functions using:
__attribute__((aligned(32)))
and got 756 Mb/s. It's better but still not ~770 Mb/s.

Is there any easy way of identifying which of function alignments got
such a big impact on NAT performance? I'd like to get those functions
explicitly aligned using assembler/__attribute__/something.

What I'm also afraid are false positives. I may end up aligning some
unrelated function that just happens to align other ones. Just like
cherry-picking 9316a9ed6895 having side-effects and not really fixing
anything explicitly.

--------------1DD6FAD97BC7F1875FD92211
Content-Type: text/x-patch;
 name="v7_dma_clean_range-align.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v7_dma_clean_range-align.diff"

diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 215df435bfb9..c60046cd34aa 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -373,6 +373,8 @@ v7_dma_inv_range:
 	ret	lr
 ENDPROC(v7_dma_inv_range)
 
+	.align	5
+
 /*
  *	v7_dma_clean_range(start,end)
  *	- start   - virtual start address of region

--------------1DD6FAD97BC7F1875FD92211
Content-Type: text/x-patch;
 name="v7_dma_inv_range-align.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v7_dma_inv_range-align.diff"

diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 215df435bfb9..0c3999f219ab 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -340,6 +340,8 @@ ENTRY(v7_flush_kern_dcache_area)
 	ret	lr
 ENDPROC(v7_flush_kern_dcache_area)
 
+	.align	5
+
 /*
  *	v7_dma_inv_range(start,end)
  *

--------------1DD6FAD97BC7F1875FD92211--
