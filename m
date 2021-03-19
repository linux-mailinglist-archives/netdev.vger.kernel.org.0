Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F74342896
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhCSWP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhCSWOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:14:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDC2C06175F
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 15:14:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w11so3580040ply.6
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 15:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HIQyubWmPbtf0zUSWsFvYW4cAg2NTkQCm96ISxXzv+Q=;
        b=sK86y7QEkJAfMH1nTgPrqyiZpi9o2+ZACIOrCTJsZUN28Cp1+qUBmiuhz71oEcKP7L
         Pq49wC+mWlVPubYCfwa67yP1Cq4QWA2nN4sEkZumwudQpezBDMuCXruaM2LF+WJF84IG
         6yDTuZ9L2KyR7d2cLn3mr/2z0k3F7AhnYahrs1VZgzMcp4C0HMNjUFhooLzXFtlTmGx3
         O53cDycH8jnramgb6eZbBVYKuEfcI1sVrBAskL8NoWZFgNF5Gz4wOnapoIDLxrbQIvUK
         KPsMm5LIL6yYr4bElqavf3Ek35Pr0apPVqEPyZ+N40iiuT473cG0nXL6aFlvInC0U58W
         RAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HIQyubWmPbtf0zUSWsFvYW4cAg2NTkQCm96ISxXzv+Q=;
        b=nhIn6V5stoYZhx3AycNNot9gmtSj26KPE6Od0X+6jv4Dcyx2qRwodr0MMELsw3WDu8
         NBu001s1SHl5jGsxoB4fhM+U7lNtbrpISdVbuQc/muK0wBDy7pRtIpG0M4ApptPOcD0f
         5B2wHEIzsHqWofq3Him4Ogf2YtzbdAJdJrkgH9teJrVpxoDcQhxdNKV6/FDfBhCD8TED
         d/0Wsgv7fpFrGN9hkYEehj9ZGLCQcDhwkjNJVic623cW2ttohgKBCca9Gro45rB6Iow+
         P/q2BpTYWlwcLTndZopMzqSZs2EnrJc6/3j1OaXolZ0fy6ucjXwbOknX15JICAPEjITr
         4qNA==
X-Gm-Message-State: AOAM532NSWxV5s964AXYhkN1i0uPY+JpKRWYGW5RRCW1a+AavHb+AS6k
        p4BtwAiUMSkxswpyaS1SWKY=
X-Google-Smtp-Source: ABdhPJz7A8uZdldPi2Rh8ycZ/Xh46jmiubuI1d4SJZXMpiiTnr45q8NUZ3g3HfD9nzWcxRInDf66zw==
X-Received: by 2002:a17:902:e84e:b029:e6:cbe6:34b5 with SMTP id t14-20020a170902e84eb02900e6cbe634b5mr13824671plg.42.1616192094864;
        Fri, 19 Mar 2021 15:14:54 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z18sm6135264pfa.39.2021.03.19.15.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:14:54 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: cosmetic fix
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20210319143149.823-1-kabel@kernel.org>
 <20210319185820.h5afsvzm4fqfsezm@skbuf> <20210319204732.320582ef@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e6bfbd22-aee7-eaba-46cd-50853d243c78@gmail.com>
Date:   Fri, 19 Mar 2021 15:14:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210319204732.320582ef@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/2021 12:47 PM, Marek Behún wrote:
> On Fri, 19 Mar 2021 20:58:20 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
>> On Fri, Mar 19, 2021 at 03:31:49PM +0100, Marek Behún wrote:
>>> We know that the `lane == MV88E6393X_PORT0_LANE`, so we can pass `lane`
>>> to mv88e6390_serdes_read() instead of MV88E6393X_PORT0_LANE.
>>>
>>> All other occurances in this function are using the `lane` variable.
>>>
>>> It seems I forgot to change it at this one place after refactoring.
>>>
>>> Signed-off-by: Marek Behún <kabel@kernel.org>
>>> Fixes: de776d0d316f7 ("net: dsa: mv88e6xxx: add support for ...")
>>> ---  
>>
>> Either do the Fixes tag according to the documented convention:
>> git show de776d0d316f7 --pretty=fixes
> 
> THX, did not know about this.
> 
>> Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
>>
>> or even better, drop it.
> 
> Why better to drop it?

To differentiate an essential/functional fix from a cosmetic fix. If all
cosmetic fixes got Fixes: tag that would get out of hands quickly.
-- 
Florian
