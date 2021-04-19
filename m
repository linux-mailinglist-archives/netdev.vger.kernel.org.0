Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D3F36390F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 03:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhDSBXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 21:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235958AbhDSBXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 21:23:34 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52781C06174A;
        Sun, 18 Apr 2021 18:23:05 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id k25so33967770oic.4;
        Sun, 18 Apr 2021 18:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LC1unaHSXRoqGKgvVKA19fS5y935zmftweCmhzGJtC4=;
        b=bzQcR5l8T1JQnjP/fCAwd7W7tmzGH+NM7+8YmTPz3W9E7Yt/AuLJQuK4z2nb5x3q+V
         Nvn/1oFV7gDTw3d2FA7XV+fdepwMVS0Y9Q/sb0ym0PsRjNzygFuCL73XV8co3vOIO291
         p7MH2l7pfjTtS81A2mjVs9Fm4uH+LP+35frujQiXzdjjbz+4x+fSayQWC9re8b1VqUyg
         FO+/J5nniPGM8LNY8Bjt2Wlf4LiPctyWgbowfg65cCcCyw5PlI8gAkxOMAcqs4oVQIDS
         3V0A2BTSvcILCxTS/KW6zHP4E95qSI3NvlHqgE77eg7CCc9mkJUpLwqZl6ZhaN6PBQyI
         M8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LC1unaHSXRoqGKgvVKA19fS5y935zmftweCmhzGJtC4=;
        b=R9uRTT8Xdwp7tcBg8v5iUKmuoS0rwjjVpQwcIAI0MUoFuADNd68P0C+X/GOBcheLfK
         1RrZ5TrpajUL4SSAbhmvSanszx1veqDZbnyauJAp+bcwu8iCLjgy4js/J0UVtuo5Efbe
         K+vTROCNsU0VQwa2kADPM1xxEtEs9Jt3OFfzLxeWPmTjhxkBzjrmsvJewOHt6Uzzj6Jq
         QX0AlGqT+5pStk83Lo/fmHyuzCbyaTPm55Bgl9bXIrfBsMqvQ601uKOvd22G9jB0g9+V
         NhFRb6QcFm4XyEo1f/IvrSnICXXnKw4twaVsuefROLGz7sOLCFJIycK4S8yEBSGD/pFo
         KM2w==
X-Gm-Message-State: AOAM531DAMHRzF7yhAP2v3uH0/ACRvD96sIGICeeMkN/n2K4W1yLvd5T
        bUZ6rRlB5FDeDfmXEvxkq0U=
X-Google-Smtp-Source: ABdhPJyRS7uIZU6aE923TIad+hYN2PcOzAMtl0Qwj/qW1D49aJOR4w3oefkJPzhLgg1pzi01Xa5oGg==
X-Received: by 2002:aca:c487:: with SMTP id u129mr5867810oif.67.1618795384601;
        Sun, 18 Apr 2021 18:23:04 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id j8sm3160731otr.28.2021.04.18.18.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 18:23:03 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
To:     Pkshih <pkshih@realtek.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
 <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
 <1617763692.9857.7.camel@realtek.com>
 <1dc7e487-b97b-8584-47f7-37f3385c7bf9@lwfinger.net>
 <15737dcf-95ac-1ce6-a681-94ff5db968e4@maciej.szmigiero.name>
 <c5556a207c5c40ac849c6a0e1919baca@realtek.com>
 <220c4fe4-c9e1-347a-8cef-cd91d31c56df@maciej.szmigiero.name>
 <cfcc2988-3f20-3588-2f76-f04d09043811@maciej.szmigiero.name>
 <35249c6028f645a79c4186c9689ba8aa@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <52f89f4f-568e-f04e-5c3e-e31f4a9e0910@lwfinger.net>
Date:   Sun, 18 Apr 2021 20:23:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <35249c6028f645a79c4186c9689ba8aa@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/21 7:32 PM, Pkshih wrote:
> 
>> -----Original Message-----
>> From: Maciej S. Szmigiero [mailto:mail@maciej.szmigiero.name]
>> Sent: Sunday, April 18, 2021 2:08 AM
>> To: Pkshih
>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> johannes@sipsolutions.net; kvalo@codeaurora.org; Larry Finger
>> Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
>>
>> On 08.04.2021 21:04, Maciej S. Szmigiero wrote:
>>> On 08.04.2021 06:42, Pkshih wrote:
>>>>> -----Original Message-----
>>>>> From: Maciej S. Szmigiero [mailto:mail@maciej.szmigiero.name]
>>>>> Sent: Thursday, April 08, 2021 4:53 AM
>>>>> To: Larry Finger; Pkshih
>>>>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>>> johannes@sipsolutions.net; kvalo@codeaurora.org
>>>>> Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
>>>>>
>>> (...)
>>>>>> Maceij,
>>>>>>
>>>>>> Does this patch fix the problem?
>>>>>
>>>>> The beacon seems to be updating now and STAs no longer get stuck in PS
>>>>> mode.
>>>>> Although sometimes (every 2-3 minutes with continuous 1s interval pings)
>>>>> there is around 5s delay in updating the transmitted beacon - don't know
>>>>> why, maybe the NIC hardware still has the old version in queue?
>>>>
>>>> Since USB device doesn't update every beacon, dtim_count isn't updated neither.
>>>> It leads STA doesn't awake properly. Please try to fix dtim_period=1 in
>>>> hostapd.conf, which tells STA awakes every beacon interval.
>>>
>>> The situation is the same with dtim_period=1.
>>>
>> (...)
>>
>> Ping-Ke,
>> are you going to submit your set_tim() patch so at least the AP mode is
>> usable with PS STAs or are you waiting for a solution to the delayed
>> beacon update issue?
>>
> 
> I'm still trying to get a 8192cu, and then I can reproduce the symptom you
> met. However, I'm busy now; maybe I have free time two weeks later.
> 
> Do you think I submit the set_tim() patch with your Reported-by and Tested-by first?

PK,

I would say yes. Get the fix in as soon as possible.

Larry

