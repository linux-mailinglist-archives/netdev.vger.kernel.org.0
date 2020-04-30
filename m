Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77711C07AF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgD3UTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3UTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:19:16 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD58C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:19:16 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id c18so2639587ile.5
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+8UFUcn40kmgjU1KoP0U1kBruPgRMiFD5ebAagaZuyY=;
        b=Nxrv+vCGlgLRE5JAa24KHwvWMVYOJOBw2PL3IZt7a0mWvVN3tmJpJzOkI31yz+toex
         ujHR2f/NJJIjjF5vGlDc0s6Ens8Wz0dBX5Wt+BmOYz84K3+OBLy2jtxYvvaQy9gWup6z
         5P/6SvMuHEXI3MMc0ILO3bDmk+sppo590f+Evj1yBI2mYH9+QidcycXq1qMaC0gt40jk
         T3+eTpNfdphIlmrqlIJ6r3gptW6d7y1LpmIQTo+y9x244L365n5CKsOp7hyX8nukuieK
         FlM6rcohQwa7GgTkG2z5rgalT6BUHnOwPPX3BEB1v1yIiKK2OREAFYdLu/kHOIrFu6e0
         C4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+8UFUcn40kmgjU1KoP0U1kBruPgRMiFD5ebAagaZuyY=;
        b=rGZaPN7H3SIQtEn/oMrJB2U8TQoOW87CDgSUOTxWYkoAAYZYVf5/Nu7ZYvlQOYuPEp
         zKNhgvHOUZObkFr+4iAZ0mQ/bj8K5Zq0APicilXHe7onjuwH5gR8UBNQFveOPPa74qkK
         13MNZKA5Ms65I1kxYCIW228gM2fPr7XWm4T6ueN02tJM4knZl2m5lZED+Irsb6dg7CAd
         hvFbAe8YIm0wHPb8feKzeSHl/h1PkqR3TmhVaOw/bPxklKakoJW/3CMgzRNEEXdSYEec
         xfGBPudS8AhPtrWowOgQop1SjGG5b2/1hasqcEBds29tQFrFGHIyVE7WtEkkqnICcBXY
         rb9Q==
X-Gm-Message-State: AGi0PuYdksblcqdx44nilqJHUvMqZlpjl11R/xXNSGYB/lIRpTmig3Bg
        RlO58YbXczRgjHzxJRM4jE4K56AG
X-Google-Smtp-Source: APiQypJjymH1UvC3eubtRP7CdZqr0kbfayDFxX9XOpCt7szfLEM4I0J851I3mPRchneObaD8ViGNoQ==
X-Received: by 2002:a92:194f:: with SMTP id e15mr180100ilm.78.1588277954358;
        Thu, 30 Apr 2020 13:19:14 -0700 (PDT)
Received: from [10.67.49.116] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u21sm179547iot.5.2020.04.30.13.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:19:13 -0700 (PDT)
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, cphealy@gmail.com,
        davem@davemloft.net, hkallweit1@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc> <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
 <61eb35f8-3264-117d-59c2-22f0fdc36e96@gmail.com>
 <9caef9bbfaed5c75e72e083db8a552fd@walle.cc> <20200430194143.GF107658@lunn.ch>
 <0b157250-2b06-256f-5f48-533233b22d60@gmail.com>
 <b63498f01e64c55124c2c710fffb1047@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <c52e7043-cbd5-8fa0-96e6-e29e783d3a5f@gmail.com>
Date:   Thu, 30 Apr 2020 13:19:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <b63498f01e64c55124c2c710fffb1047@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 1:13 PM, Michael Walle wrote:
> Am 2020-04-30 22:04, schrieb Florian Fainelli:
>> On 4/30/20 12:41 PM, Andrew Lunn wrote:
>>>> ECD. The registers looks exactly like the one from the Marvell PHYs,
>>>> which makes me wonder if both have the same building block or if one
>>>> imitated the registers of the other. There are subtle differences
>>>> like one bit in the broadcom PHY is "break link" and is self-clearing,
>>>> while the bit on the Marvell PHY is described as "perform diagnostics
>>>> on link break".
>>>
>>> Should we be sharing code between the two drivers?
>>
>> Yes, I am amazed how how identical they are, nearly on a bit level
>> identical, the coincidence is uncanny. The expansion registers are also
>> 0x10 - 0x15 just in the reverse order,
> 
> At what PHY are you looking? I've just found some datasheets where they
> are at 0xC0 to 0xC5.

BCM54810 because that's what I have on my desk right now, but 0x10 would
be the offset relative to the expansion register space, which would
translate into this:

https://github.com/ffainelli/linux/commits/broadcom-cable-tests

(sorry for the mess it is a patchwork of tests on various platforms,
based on an earlier branch from Andrew).

> 
>> you know, so as to make it not
>> too obvious this looks about the same ;) I wonder if we managed to find
>> something here.
>>
>>>
>>>> What do you mean by calibrate it?
>>>
>>> Some of the Marvell documentation talks about calibrating for losses
>>> on the PCB. Run a diagnostics with no cable plugged in, and get the
>>> cable length to the 'fault'. This gives you the distance to the RJ45
>>> socket. You should then subtract that from all subsequent results.
>>> But since this is board design specific, i decided to ignore it. I
>>> suppose it could be stuffed into a DT property, but i got the feeling
>>> it is not worth it, given the measurement granularity of 80cm.
>>
>> OK, accuracy is different here, they are said to be +/- 5m accurate for
>> cable faults and +/- 10m accurate for good cables.
> 
> Accuracy != granularity. But yes, if one digit correspond to 80cm it
> doesn't really make sense to remove the PCB trace error if you assume
> that it might add just one digit at most.

One of the test racks that I use has very short cables, but I guess it
does not matter if they get reported as 80cm or 160cm...
-- 
Florian
