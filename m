Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57327169
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbfEVVMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:12:18 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37943 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbfEVVMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:12:17 -0400
Received: by mail-lj1-f194.google.com with SMTP id 14so3438640ljj.5;
        Wed, 22 May 2019 14:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g1JDwv6DsF/R2W3Hhi+fRQf2Wpp35+okn4+cO0Bor4E=;
        b=CpcVdY8gtYjb6P8gpIw0BmeeElTuj0Hhd7ZWfUbFtQh6nRggZpzCg8VDfzZfdDbGKY
         pj41HkhH1UzqHQwstKCkJiCUarMb7jxu8gbPsQRq9hKkEYRzWjn/JBRFreTnFZkSbazt
         l32yq9PFS20Iiy1PnyXBEOibLcc3ziZylXznA7vkFRSwovtHxHXybxTCb0WKYlGW9/qo
         tOyxS/ZKwn9pQsAgz9nRGGy72rxrq9xE4TerGZ/lyYtyTzNlKPXOgpIoGs/8+3nsrI2Q
         g5/ZupjYXqOrGyks2oIxgd5O7Kl24Wuh4EEVH9G1jRFGug+dsbOCHL2uOdSOVCUeXaZf
         Q8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g1JDwv6DsF/R2W3Hhi+fRQf2Wpp35+okn4+cO0Bor4E=;
        b=EouD06qbCr0xioBKodrIhEVYrM5JMr4HJJ5UYvNofyHNEFm8AgUJQ5IOYuvXgyzEkh
         R1h4gLLPrqjCg+KDROLvnjwhW7Ql5cGWd5Uw4gn4n5ZzMJIczs9ms0VmrV6OOgd20bcN
         ZMFmKBZr6zA8IlXSuexnms2rcAtFiDDEIP8p2t2+DtM4bqVjgPQAihIFocHxeoslaxdM
         1lsvSWOH/MZEcISFnLpKtoz2duPnjV3FRAi3Ok+sSzUlc7g0739fwa8hCMvDTGYjvDcQ
         fYeVjlpLw/qRnjQA8b2v/wjKdwMweIKMV2wHoAcZdSXZ4ZvWpFpv3HuybxHBaxjfQ9S8
         Zu4Q==
X-Gm-Message-State: APjAAAXlos3lv7Hs4jvcvQGJA7iRx0tnMFAZbfZ9qDgv++MOtWssMKv+
        O4N/pY9yldd6WSf93onZWQU=
X-Google-Smtp-Source: APXvYqxHtRvDgngbiW+UmX4FEmTGxfk64Oa5UkQ+bxX8hf5+g9A0o8XZGm9SJRHhtch1fwU7a324Zw==
X-Received: by 2002:a2e:5515:: with SMTP id j21mr20462954ljb.198.1558559534455;
        Wed, 22 May 2019 14:12:14 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id h2sm5670744lfm.17.2019.05.22.14.12.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 14:12:13 -0700 (PDT)
Subject: Re: ARM router NAT performance affected by random/unrelated commits
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, John Crispin <john@phrozen.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Jo-Philipp Wich <jo@mein.io>
References: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com>
 <20190521104512.2r67fydrgniwqaja@shell.armlinux.org.uk>
 <de262f71-748f-d242-f1d4-ea10188a0438@gmail.com>
 <20190522121730.fhswxkw4gbflkhei@shell.armlinux.org.uk>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <d0d67f85-01e9-037a-3a18-6282a8bfce5c@gmail.com>
Date:   Wed, 22 May 2019 23:12:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20190522121730.fhswxkw4gbflkhei@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.05.2019 14:17, Russell King - ARM Linux admin wrote:
> On Wed, May 22, 2019 at 01:51:01PM +0200, Rafał Miłecki wrote:
>> On 21.05.2019 12:45, Russell King - ARM Linux admin wrote:> On Tue, May 21, 2019 at 12:28:48PM +0200, Rafał Miłecki wrote:
>>>> I work on home routers based on Broadcom's Northstar SoCs. Those devices
>>>> have ARM Cortex-A9 and most of them are dual-core.
>>>>
>>>> As for home routers, my main concern is network performance. That CPU
>>>> isn't powerful enough to handle gigabit traffic so all kind of
>>>> optimizations do matter. I noticed some unexpected changes in NAT
>>>> performance when switching between kernels.
>>>>
>>>> My hardware is BCM47094 SoC (dual core ARM) with integrated network
>>>> controller and external BCM53012 switch.
>>>
>>> Guessing, I'd say it's to do with the placement of code wrt cachelines.
>>> You could try aligning some of the cache flushing code to a cache line
>>> and see what effect that has.
>>
>> Is System.map a good place to check for functions code alignment?
>>
>> With Linux 4.19 + OpenWrt mtd patches I have:
>> (...)
>> c010ea94 t v7_dma_inv_range
>> c010eae0 t v7_dma_clean_range
>> (...)
>> c02ca3d0 T blk_mq_update_nr_hw_queues
>> c02ca69c T blk_mq_alloc_tag_set
>> c02ca94c T blk_mq_release
>> c02ca9b4 T blk_mq_free_queue
>> c02caa88 T blk_mq_update_nr_requests
>> c02cab50 T blk_mq_unique_tag
>> (...)
>>
>> After cherry-picking 9316a9ed6895 ("blk-mq: provide helper for setting
>> up an SQ queue and tag set"):
>> (...)
>> c010ea94 t v7_dma_inv_range
>> c010eae0 t v7_dma_clean_range
>> (...)
>> c02ca3d0 T blk_mq_update_nr_hw_queues
>> c02ca69c T blk_mq_alloc_tag_set
>> c02ca94c T blk_mq_init_sq_queue <-- NEW
>> c02ca9c0 T blk_mq_release <-- Different address of this & all below
>> c02caa28 T blk_mq_free_queue
>> c02caafc T blk_mq_update_nr_requests
>> c02cabc4 T blk_mq_unique_tag
>> (...)
>>
>> As you can see blk_mq_init_sq_queue has appeared in the System.map and
>> it affected addresses of ~30000 symbols. I can believe some frequently
>> used symbols got luckily aligned and that improved overall performance.
>>
>> Interestingly v7_dma_inv_range() and v7_dma_clean_range() were not
>> relocated.
>>
>> *****
>>
>> I followed Russell's suggestion and added .align 5 to cache-v7.S (see
>> two attached diffs).
>>
>> 1) v4.19 + OpenWrt mtd patches
>>> egrep -B 1 -A 1 "v7_dma_(inv|clean)_range" System.map
>> c010ea58 T v7_flush_kern_dcache_area
>> c010ea94 t v7_dma_inv_range
>> c010eae0 t v7_dma_clean_range
>> c010eb18 T b15_dma_flush_range
>>
>> 2) v4.19 + OpenWrt mtd patches + two .align 5 in cache-v7.S
>> c010ea6c T v7_flush_kern_dcache_area
>> c010eac0 t v7_dma_inv_range
>> c010eb20 t v7_dma_clean_range
>> c010eb58 T b15_dma_flush_range
>> (actually 15 symbols above v7_dma_inv_range were replaced)
>>
>> This method seems to be somehow working (at least affects addresses in
>> System.map).
>>
>> *****
>>
>> I run 2 tests for each combination of changes. Each test consisted of
>> 10 sequences of: 30 seconds iperf session + reboot.
>>
>>
>>> git reset --hard v4.19
>>> git am OpenWrt-mtd-chages.patch
>> Test #1: 738 Mb/s
>> Test #2: 737 Mb/s
>>
>>> git reset --hard v4.19
>>> git am OpenWrt-mtd-chages.patch
>> patch -p1 < v7_dma_clean_range-align.diff
>> Test #1: 746 Mb/s
>> Test #2: 747 Mb/s
>>
>>> git reset --hard v4.19
>>> git am OpenWrt-mtd-chages.patch
>>> patch -p1 < v7_dma_inv_range-align.diff
>> Test #1: 745 Mb/s
>> Test #2: 746 Mb/s
>>
>>> git reset --hard v4.19
>>> git am OpenWrt-mtd-chages.patch
>>> patch -p1 < v7_dma_clean_range-align.diff
>>> patch -p1 < v7_dma_inv_range-align.diff
>> Test #1: 762 Mb/s
>> Test #2: 761 Mb/s
>>
>> As you can see I got a quite nice performance improvement after aligning
>> both: v7_dma_clean_range() and v7_dma_inv_range().
> 
> This is an improvement of about 3.3%.
> 
>> It still wasn't as good as with 9316a9ed6895 cherry-picked but pretty
>> close.
>>
>>
>>> git reset --hard v4.19
>>> git am OpenWrt-mtd-chages.patch
>>> git cherry-pick -x 9316a9ed6895
>> Test #1: 770 Mb/s
>> Test #2: 766 Mb/s
>>
>>> git reset --hard v4.19
>>> git am OpenWrt-mtd-chages.patch
>>> git cherry-pick -x 9316a9ed6895
>>> patch -p1 < v7_dma_clean_range-align.diff
>> Test #1: 756 Mb/s
>> Test #2: 759 Mb/s
>>
>>> git reset --hard v4.19
>>> git am OpenWrt-mtd-chages.patch
>>> git cherry-pick -x 9316a9ed6895
>>> patch -p1 < v7_dma_inv_range-align.diff
>> Test #1: 758 Mb/s
>> Test #2: 759 Mb/s
>>
>>> git reset --hard v4.19
>>> git am OpenWrt-mtd-chages.patch
>>> git cherry-pick -x 9316a9ed6895
>>> patch -p1 < v7_dma_clean_range-align.diff
>>> patch -p1 < v7_dma_inv_range-align.diff
>> Test #1: 767 Mb/s
>> Test #2: 763 Mb/s
>>
>> Now you can see how unpredictable it is. If I cherry-pick 9316a9ed6895
>> and do an extra alignment of v7_dma_clean_range() and v7_dma_inv_range()
>> that extra alignment can actually *hurt* NAT performance.
> 
> You have a maximum variance of 4Mb/s in your tests which is around
> 0.5%, and this shows a reduction of 3Mb/s, or 0.4%.
> 
> If we look at it a different way:
> - Without the alignment patches, there is a difference of 4% in
>    performance depending on whether 9316a9ed6895 is applied.
> - With the alignment patches, there is a difference of 0.4% in
>    performance depending on whether 9316a9ed6895 is applied.
> 
> How can this not be beneficial?

Aligning v7_dma_clean_range() and v7_dma_inv_range() is definitely
beneficial! I'm sorry I wasn't clear enough.

I redid testing of 2 most important setups with few more iterations.

 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
 > git cherry-pick -x 9316a9ed6895
[  3]  0.0-30.0 sec  2.71 GBytes   776 Mbits/sec
[  3]  0.0-30.0 sec  2.71 GBytes   775 Mbits/sec
[  3]  0.0-30.0 sec  2.70 GBytes   774 Mbits/sec
[  3]  0.0-30.0 sec  2.70 GBytes   774 Mbits/sec
[  3]  0.0-30.0 sec  2.70 GBytes   773 Mbits/sec
[  3]  0.0-30.0 sec  2.70 GBytes   773 Mbits/sec
[  3]  0.0-30.0 sec  2.70 GBytes   773 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   771 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   771 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   771 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   771 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   770 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   770 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   770 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   770 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   769 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   769 Mbits/sec
[  3]  0.0-30.0 sec  2.68 GBytes   768 Mbits/sec
[  3]  0.0-30.0 sec  2.68 GBytes   768 Mbits/sec
[  3]  0.0-30.0 sec  2.68 GBytes   767 Mbits/sec
[  3]  0.0-30.0 sec  2.68 GBytes   767 Mbits/sec
[  3]  0.0-30.0 sec  2.68 GBytes   767 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   765 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   765 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   764 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   763 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   763 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   762 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   760 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   760 Mbits/sec
Average: 769 Mb/s (+4,10%)
Previous results: 773 Mb/s, 770 Mb/s, 766 Mb/s

 > git reset --hard v4.19
 > git am OpenWrt-mtd-chages.patch
 > patch -p1 < v7_dma_clean_range-align.diff
 > patch -p1 < v7_dma_inv_range-align.diff
[  3]  0.0-30.0 sec  2.69 GBytes   769 Mbits/sec
[  3]  0.0-30.0 sec  2.69 GBytes   769 Mbits/sec
[  3]  0.0-30.0 sec  2.68 GBytes   767 Mbits/sec
[  3]  0.0-30.0 sec  2.68 GBytes   766 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   766 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   765 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   765 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   765 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   764 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   763 Mbits/sec
[  3]  0.0-30.0 sec  2.67 GBytes   763 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   762 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   762 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   762 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   762 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   761 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   761 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   760 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   760 Mbits/sec
[  3]  0.0-30.0 sec  2.66 GBytes   760 Mbits/sec
[  3]  0.0-30.0 sec  2.65 GBytes   760 Mbits/sec
[  3]  0.0-30.0 sec  2.65 GBytes   759 Mbits/sec
[  3]  0.0-30.0 sec  2.65 GBytes   759 Mbits/sec
[  3]  0.0-30.0 sec  2.65 GBytes   758 Mbits/sec
[  3]  0.0-30.0 sec  2.65 GBytes   758 Mbits/sec
[  3]  0.0-30.0 sec  2.65 GBytes   757 Mbits/sec
[  3]  0.0-30.0 sec  2.65 GBytes   757 Mbits/sec
[  3]  0.0-30.0 sec  2.65 GBytes   757 Mbits/sec
[  3]  0.0-30.0 sec  2.64 GBytes   757 Mbits/sec
[  3]  0.0-30.0 sec  2.64 GBytes   756 Mbits/sec
Average: 762 Mb/s (+3,16%)
Previous results: 767 Mb/s, 763 Mb/s

So let me explain why I keep researching on this. There are two reasons:

1) Realignment done by cherry-picking 9316a9ed6895 was providing a
*marginally* better performance than aligning v7_dma_clean_range() and
v7_dma_inv_range(). It's a *very* minimal difference but I can't stop
thinking I can still do better.

2) Cherry-picking 9316a9ed6895 doesn't change v7_dma_clean_range or
v7_dma_inv_range addresses at all. Yet it still improves NAT
performance. That makes me believe there are more functions that (if
properly aligned) can bump NAT performance.
I hope that aligning all:
* v7_dma_clean_range
* v7_dma_inv_range
* [some unrevealed functions]
could result in even better NAT performance.
