Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC065CC2F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 10:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfGBIqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 04:46:25 -0400
Received: from linuxlounge.net ([88.198.164.195]:46120 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGBIqZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 04:46:25 -0400
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1562057182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=HcrU3xHf2es9K1eWmG8nbhDoxCTyXkGXB9fNsN37JPM=;
        b=cpOxtmSaP4trU3ozqBS66YZqBZWhUwjWDFuCuUs9XDb55dKzLjizVEO9O2JeTgOhFskerw
        IinNen6G4pMYKhk0XtE6GbHHBvu2IBjIMPTPZLmOUfLO8qc7svfe4VJhoL6uiyxZc4Aa3u
        EOuyYNmZ3JRSgRJrPNuAVkqg4TXOJUo=
Cc:     netdev@vger.kernel.org
References: <41ac3aa3-cbf7-1b7b-d847-1fb308334931@linuxlounge.net>
 <E0170D52-C181-4F0F-B5F8-F1801C2A8F5A@cumulusnetworks.com>
 <21ab085f-0f7f-88bc-b661-af74dd9eeea2@linuxlounge.net>
 <cc232ed3-9e02-ebb4-4901-9d617013abb8@cumulusnetworks.com>
 <3fcf8b05-e1ad-ac97-10bf-bd2b6354424c@linuxlounge.net>
 <908e9e90-70cc-7bbe-f83f-0810c9ef3925@cumulusnetworks.com>
 <5e43ba82-de32-e419-efc3-5dfca8291973@linuxlounge.net>
 <6dc6e89b-8b40-7dac-ec69-f4223d5dc147@cumulusnetworks.com>
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
Message-ID: <c66cd547-6cbe-40bf-e42c-d307956644fa@linuxlounge.net>
Date:   Tue, 2 Jul 2019 10:46:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
In-Reply-To: <6dc6e89b-8b40-7dac-ec69-f4223d5dc147@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

On 7/2/19 12:37 AM, Nikolay Aleksandrov wrote:
> On 7/2/19 1:17 AM, Martin Weinelt wrote:
>> Hi again,
>>
>> On 7/1/19 7:37 PM, Nikolay Aleksandrov wrote:
>>> I see, thanks for clarifying this. So on the KASAN could you please try the attached patch ?
>>> Also could you please run the br_multicast_rcv+xxx addresses through
>>> linux/scripts/faddr2line for your kernel/bridge:
>>> usage: faddr2line [--list] <object file> <func+offset> <func+offset>...
>>>
>>> Thanks,
>>>  Nik
>>>
>>
>> back with a new report. This is 5.2.0-rc7 + your patch.
>>
>> Best,
>>   Martin
>>
> 
> Thanks! Aaargh.. I made a stupid mistake hurrying to send the patch, apologies.
> Here's the fixed version, please give it a go. This report is because
> of my change, not because of the previous bug that should've been fixed.
> 

I applied your latest patch against 5.2.0-rc7 and it seems to have fixed the issue as,
after 6 hours of uptime, the KASAN report isn't coming up anymore.

Also there are currently no kmemleak results coming up on 5.2.0-rc7, so I'll be
looking at the v4.19.x series next.

Thank you!

Best
  Martin
