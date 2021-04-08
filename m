Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405BB358C1A
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhDHSWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbhDHSWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:22:53 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA6BC061760;
        Thu,  8 Apr 2021 11:22:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x15so3152666wrq.3;
        Thu, 08 Apr 2021 11:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7TAxbFgp4EueLLfJHLyzRnfJptywMygGVE2WRaLE8QA=;
        b=oM2taPRNjGFwjyzfnm0YwBZtcI6+UyXJz41SOtgaetq9uU+UUpTtUmIAgz9plS13f8
         /ACVodUN6yrqWIyL4I8iYN0AtTD9OIidoq+7vrgH3HLQW9wiv840OsW0YKneAon67JX/
         sBsuJEsf8XmeaJ2DvqsqkM9WegZy8SKSfmJMVQtWeudVbDl4+aeu/ucuXTMbTkSEMq+n
         Mu9o32Cjo7f+ogOI4Be6Hi9v+Pb5mo3cCUN3xjHHWAx9Jb8iIWsslDBNUAu5P+KrCNiv
         KXy8Qw59BJKq89baIqAK/RPPNXngAk87JNW7D519b466PLknlJBNccWQIEkTVZuSENRj
         M+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7TAxbFgp4EueLLfJHLyzRnfJptywMygGVE2WRaLE8QA=;
        b=pRje+DBGuyGCM1xlTYZLbGukWQIePJ8cOH4f7dGM5Ck3FU5MeKUCULH4GASmhYDmeZ
         KtIUQsI+0ISVcs1ZLLF9jPSrzKlPQzU484o547GRDa7lK2K5n0WNJZPV4FJ/nILdsN0+
         6ZZmL/nBl83NyT3FtsiEyhSnE8HygXSbcM71CT7YpPDJgkwst7dKJQctM2mqa43EM2KY
         QWUII6OWlK389K1/OvhYfVVgqqbIkk3JywKIn+Zpq6wBdyuOMtbE4Idxm3rnwbTHwfq4
         3rkIbB9L0PYtGdGr38EJZLuSI7fmf/GGQRXbeKPgKYiBr8jOaCQO9sApnE4P1rsqxU8c
         e/Sg==
X-Gm-Message-State: AOAM533enveQq4yI3vHek04l9GDUEL7OthtfBP/7xxbw8NKJAKD3uR7A
        Rso+/nGrMDqlrEX++11wEFCGe56+CTK7VQ==
X-Google-Smtp-Source: ABdhPJxOacZ/XZ4VH2AkeUeZXQxzbd+qUSZMZ7QAwhU1EiWBpJ95DlmKhgM/XCizEgaJDdaeaUtQXw==
X-Received: by 2002:a05:6000:544:: with SMTP id b4mr13782124wrf.352.1617906159797;
        Thu, 08 Apr 2021 11:22:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744? (p200300ea8f3846006dfecdb3c4f92744.dip0.t-ipconnect.de. [2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744])
        by smtp.googlemail.com with ESMTPSA id w7sm110919wro.43.2021.04.08.11.22.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 11:22:39 -0700 (PDT)
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     George McCollister <george.mccollister@gmail.com>,
        Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210408172353.21143-1-TheSven73@gmail.com>
 <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
 <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com>
Date:   Thu, 8 Apr 2021 20:22:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.04.2021 20:00, George McCollister wrote:
> On Thu, Apr 8, 2021 at 12:46 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>>
>> Hi George,
>>
>> On Thu, Apr 8, 2021 at 1:36 PM George McCollister
>> <george.mccollister@gmail.com> wrote:
>>>
>>> Can you explain the difference in behavior with what I was observing
>>> on the LAN7431?
>>
>> I'm not using DSA in my application, so I cannot test or replicate
>> what you were observing. It would be great if we could work together
>> and settle on a solution that is acceptable to both of us.
> 
> Sounds good.
> 
>>
>>> I'll retest but if this is reverted I'm going to start
>>> seeing 2 extra bytes on the end of frames and it's going to break DSA
>>> with the LAN7431 again.
>>>
>>
>> Seen from my point of view, your patch is a regression. But perhaps my
>> patch set is a regression for you? Catch 22...
>>
>> Would you be able to identify which patch broke your DSA behaviour?
>> Was it one of mine? Perhaps we can start from there.
> 
> Yes, first I'm going to confirm that what is in the net branch still
> works (unlikely but perhaps something else could have broken it since
> last I tried it).
> Then I'll confirm the patch which I believe broke it actually did and
> report back.
> 
>>
>> Sven

Just an idea:
RX_HEAD_PADDING is an alias for NET_IP_ALIGN that can have two values:
0 and 2
The two systems you use may have different NET_IP_ALIGN values.
This could explain the behavior. Then what I proposed should work
for both of you: frame_length - ETH_FCS_LEN
