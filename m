Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11145C1FB
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfGARb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:31:28 -0400
Received: from linuxlounge.net ([88.198.164.195]:56452 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbfGARb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:31:28 -0400
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1562002285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=aWKgJMb+TS/EjABfNXN1Y47POkRjcI6nGrOk4+90WBc=;
        b=GzyNN9RBVda1v2iAyUMcf/nzNrKuBOTw/Is50W9TQgzB8iRZMdAhPHcRVddSsTdEFKbnWi
        ZsPxY7zMYT3disSGqC3KP6V0Gp3NtmjCiARZwsxRSDbfR5xfTT6SlC8VJ8Bdu3mppYCo37
        f77BlsKHKA2Iu+Wy0zqV+z3VxQaypjU=
Cc:     netdev@vger.kernel.org
References: <41ac3aa3-cbf7-1b7b-d847-1fb308334931@linuxlounge.net>
 <E0170D52-C181-4F0F-B5F8-F1801C2A8F5A@cumulusnetworks.com>
 <21ab085f-0f7f-88bc-b661-af74dd9eeea2@linuxlounge.net>
 <cc232ed3-9e02-ebb4-4901-9d617013abb8@cumulusnetworks.com>
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
Message-ID: <3fcf8b05-e1ad-ac97-10bf-bd2b6354424c@linuxlounge.net>
Date:   Mon, 1 Jul 2019 19:31:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
In-Reply-To: <cc232ed3-9e02-ebb4-4901-9d617013abb8@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

On 7/1/19 7:03 PM, Nikolay Aleksandrov wrote:
> Hi Martin,
> 
> On 01/07/2019 19:53, Martin Weinelt wrote:
>> Hi Nik,
>>
>> more info below.
>>
>> On 6/29/19 3:11 PM, nikolay@cumulusnetworks.com wrote:
>>> On 29 June 2019 14:54:44 EEST, Martin Weinelt <martin@linuxlounge.net> wrote:
>>>> Hello,
>>>>
>>>> we've recently been experiencing memory leaks on our Linux-based
>>>> routers,
>>>> at least as far back as v4.19.16.
>>>>
>>>> After rebuilding with KASAN it found a use-after-free in 
>>>> br_multicast_rcv which I could reproduce on v5.2.0-rc6. 
>>>>
>>>> Please find the KASAN report below, I'm anot sure what else to provide
>>>> so
>>>> feel free to ask.
>>>>
>>>> Best,
>>>>  Martin
>>>>
>>>>
>>>
>>> Hi Martin, 
>>> I'll look into this, are there any specific steps to reproduce it? 
>>>
>>> Thanks, 
>>>    Nik
>>>>  
>> Each server is a KVM Guest and has 18 bridges with the same master/slave
>> relationships:
>>
>>   bridge -> batman-adv -> {l2 tunnel, virtio device}
>>
>> Linus Lüssing from the batman-adv asked me to apply this patch to help
>> debugging.
>>
>> v5.2-rc6-170-g728254541ebc with this patch yielded the following KASAN 
>> report, not sure if the additional information at the end is a result of
>> the added patch though.
>>
>> Best,
>>   Martin
>>
> 
> I see a couple of issues that can cause out-of-bounds accesses in br_multicast.c
> more specifically there're pskb_may_pull calls and accesses to stale skb pointers.
> I've had these on my "to fix" list for some time now, will prepare, test the fixes and
> send them for review. In a few minutes I'll send a test patch for you.
> That being said, I thought you said you've been experiencing memory leaks, but below
> reports are for out-of-bounds accesses, could you please clarify if you were
> speaking about these or is there another issue as well ?
> If you're experiencing memory leaks, are you sure they're related to the bridge ?
> You could try kmemleak for those.
> 
> Thank you,
>  Nik
> 

we had been experiencing memory leaks on v4.19.37, thats why we started to turn on
KASAN and kmemleak in the first place. This is when we found this use-after-free.

The memory leak exists, and is a separate issue. Apparently kmemleak does not work,
I suspect the early log size is too small

root@gw02:~# echo scan > /sys/kernel/debug/kmemleak                                                                                                                                                                                 -bash: echo: write error: Device or resource busy

CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y

I'll increase the early log size with the next build to try and get more information
on the memory leak, I'll open a separate thread for that then.

Thanks,
  Martin
