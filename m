Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1465925A2E
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 23:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfEUVub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 17:50:31 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:39929 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfEUVua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 17:50:30 -0400
Received: by mail-it1-f196.google.com with SMTP id 9so174835itf.4
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 14:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1OupP25mMGwFqJcJKJ12E8XFXuf/nqLNTbxoqsS9YDw=;
        b=oVlwmMfk5Htqsru5OZGx2/+Q/LT5k0ny7vzAzXGLoOZtOgs+7uf8BrhBXWI2aMleKA
         FVCZLI1TjZEIH8+GwfM8wDT8cVx9Yv/betWHPJMPKRummXvuCagepBNN7U+1R0TvwCO3
         DRfc3tLVZxcmJUh03EPVm/fxbmBbewo7j6Ot04wIIt+iYhlROG37ILhk2ue7RJMMhKsr
         8KyY+3LrnN5kpr8nguJv8afr9+gQmEOzbdsBRYoxECmSKSDph94lxZr78tKlH3VS9kVT
         wQxD40qkc/A8AO9qlbLYw14TYSw6Hetmg2LsOwwi/zWgIGECd6KTaeXqXr6DCnajOZok
         T5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1OupP25mMGwFqJcJKJ12E8XFXuf/nqLNTbxoqsS9YDw=;
        b=ODhiAwdIKqNbthgTBVRDFn+Ayim4wtViHpY3Mwqxq+DGR9KBoww4vCaBhEWY1MgA3L
         p9PtAxHsrEZe7rQNcCMhG1cDUsK3di4+Hm2e8XLqpaa+oXtK226wQhs5JPAs+wZJ39Uo
         +H8H9NKzKBRFI6NtAUvp1YJ6DxyUmPaX0jSs3DxBkH0yrLwD2Sj2dbH7fqb4kHXQaFm8
         cY/FFvkEGTG9iNIrW6lYMrBTeMTkmmRyS0AfU9rnLCZAS74QMmUvmO2upeLgGHnuZ+2t
         tNye37I+bauVp6Eaii4FxcywQTJyLTs8grw9AhEhG0CRVeB0RgdyfpqjrRmTTUNCR6Ut
         u58g==
X-Gm-Message-State: APjAAAXHay+Ao9DyMnc26VOX61ndv7TDbwzN5M9bUQFPBXDjM4zkR8bI
        uiwi020LmnC5Rl8YYVm5hPKSRlcLJV4=
X-Google-Smtp-Source: APXvYqxf27Aj8QTcVXnmvo9UrDR7MP8gAlVPM8GO1isQV5wCkQpbenL26C3Bi/Tvmy7NVrAJlVh2sA==
X-Received: by 2002:a24:6583:: with SMTP id u125mr5901756itb.168.1558475429316;
        Tue, 21 May 2019 14:50:29 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id v139sm2591860itb.25.2019.05.21.14.50.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 14:50:28 -0700 (PDT)
Subject: Re: [PATCH RFC] net: qualcomm: rmnet: Move common struct definitions
 to include
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
References: <1558467302-17072-1-git-send-email-subashab@codeaurora.org>
 <CAK8P3a0JpCnV59uWmrot7KeLPCOq_FqPb--xD_fMpaPd7x0zRg@mail.gmail.com>
 <20190521210804.GR31438@minitux>
From:   Alex Elder <elder@linaro.org>
Message-ID: <e1b27721-19ff-2ae9-2885-90a7948f774f@linaro.org>
Date:   Tue, 21 May 2019 16:50:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190521210804.GR31438@minitux>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/19 4:08 PM, Bjorn Andersson wrote:
> On Tue 21 May 13:45 PDT 2019, Arnd Bergmann wrote:
> 
>> On Tue, May 21, 2019 at 9:35 PM Subash Abhinov Kasiviswanathan
>> <subashab@codeaurora.org> wrote:
>>>
>>> Create if_rmnet.h and move the rmnet MAP packet structs to this
>>> common include file. To account for portability, add little and
>>> big endian bitfield definitions similar to the ip & tcp headers.
>>>
>>> The definitions in the headers can now be re-used by the
>>> upcoming ipa driver series as well as qmi_wwan.
>>>
>>> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
>>> ---
>>> This patch is an alternate implementation of the series posted by Elder.
>>> This eliminates the changes needed in the rmnet packet parsing
>>> while maintaining portability.
>>> ---
>>
>> I think I'd just duplicate the structure definitions then, to avoid having
>> the bitfield definitions in a common header and using them in the new
>> driver.
>>
> 
> Doing would allow each driver to represent the bits as suitable, at the
> cost of some duplication and confusion. Confusion, because it doesn't
> resolve the question of what the right bit order actually is.

I have exchanged a few private messages with Subash.  He has said
that it is the high-order bit that indicates whether a QMAP packet
contains a command (1) or data (0).  That bit might be extracted
this way:

    u8 byte = *(u8 *)skb->data;
    bool command = !!(byte & 0x80);

Subash, if you don't mind, please acknowledge that again here
so everyone knows.

What this means is that the first patch in my series is wrong,
because I misinterpreted the documentation, which indicated
bit 0 was the command/data bit.  (I presume this is the first
bit that travels over the wire, and is not referring to the
conventionally-understood lowest bit position in the first byte.)

My plan is, as I said in a previous message:
- Remove the first patch (that switches the bit-fields)
- Adjust the subsequent patches to use correct field masks
- Re-send the series as v2, with Bjorn's Reviewed-by.

> Subash stated yesterday that bit 0 is "CD", which in the current struct
> is represented as the 8th bit, while Alex's patch changes the definition
> so that this bit is the lsb. I.e. I read Subash answer as confirming
> that patch 1/8 from Alex is correct.

I'm not sure about that but I don't want to confuse things further.

> Subash, as we're not addressing individual bits in this machine, so
> given a pointer map_hdr to a struct rmnet_map_header, which of the
> following ways would give you the correct value of pad_len:
> 
> u8 p = *(char*)map_hdr;
> pad_len = p & 0x3f;
> 
> or:
> 
> u8 p = *(char*)map_hdr;
> pad_len = p >> 2;

My new understanding is it's the latter.

> PS. I do prefer the two drivers share the definition of these
> structures...

I agree with you completely.  I don't think it makes sense to
have two definitions of the same structure.  Subash wants to
reduce the impact my changes have on the "rmnet" driver, but
duplicating things makes things worse, not better.  The IPA
driver *assumes* it is talking to the rmnet driver; their
interface definition should be common...

					-Alex

> Regards,
> Bjorn
> 

