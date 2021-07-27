Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3862D3D76FB
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbhG0Nkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhG0Nkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:40:43 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F51C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 06:40:44 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id 10so12058322ill.10
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 06:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QJojNdCNRZdeObtsdoaPzzj/IMsZp6P9O1kQugt1wqE=;
        b=XO6Dflo3jfQxB+ZjvaKObEax0uqfNoBdNWv4uPuHWMz3JVC94vavSgNOZfwad7WFK+
         6BqDKAPrvF5NbnboVNkt/ucxU9z0ncfICAFLEwMye6SlkKgkx2/de5SPelrUQU0cPKv/
         UDw655RUl31r9icQLn45hsNbqVw45T/psE3HhU8Eq0pcOay0J56ZJiRWPhKmaTwMOmbZ
         nRDMZ2CY2fK2pUufh6Ja0307DNBHFZBl56DRDboTaHRDyxQ0CnLJukYZRg31tAfxirCN
         wWp7CK2i2KpJtYIWKzxtX2wCpXkjc3ymzRjLgoCPDRU97fhDkEutDe1MG4BuhIKPZo2q
         LSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJojNdCNRZdeObtsdoaPzzj/IMsZp6P9O1kQugt1wqE=;
        b=qme+/VfWoq+qGeGw3W2Tn7mJbcpyg1JQoBbEsLhoMMyd87EBopx5TDfdBTS/PPsnKg
         29VcTfHdDD/MqMqYzh4gSF2GHV7X8VXjh8nepLWUAZl1smVWk4yDcCKZZ+Yd7XCzm7TM
         AeJssEeMlaAHvnLocBIQpuBvr57D36JfvLzx13wokR38T8+k1yckVHSEquOS/Q7LJMre
         ZCb3yu0MZNnI7sXGRAFCc4IXHF36jqYS9RDGIrolPqrvwd/IYQuFIWJPQoFuZKtIxthS
         O8Y44c9TBD/HVj/8QmxYHM2ikLSSwIqzvB3/iB6SR0ga5+Rv0uRiBvR/hrEMi1c6Z36F
         7pFg==
X-Gm-Message-State: AOAM531a9FrbX6CoiPkHPRBG3AIK6HYf1cHnTiG1NnbzXKszRm8btBEU
        sHg65zMpK4lSZ1Z5J/jvGL1bww==
X-Google-Smtp-Source: ABdhPJyWOJJLJx2IeJbv+UMqbCtDpwaYJjnSAw1w2Y1nSyjQpBYZbTvHwYh1lpSqHhwjPVAQnG7nDA==
X-Received: by 2002:a05:6e02:12ab:: with SMTP id f11mr17030876ilr.200.1627393243454;
        Tue, 27 Jul 2021 06:40:43 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r198sm2342266ior.7.2021.07.27.06.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:40:42 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: ipa: kill IPA_VALIDATION
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210726174010.396765-1-elder@linaro.org>
 <YP/rFwvIHOvIwMNO@unreal> <5b97f7b1-f65f-617e-61b4-2fdc5f08bc3e@linaro.org>
 <YQACaxKhxDFZSCF3@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <07765bd2-eade-ee52-fa18-56f2e573461a@linaro.org>
Date:   Tue, 27 Jul 2021 08:40:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQACaxKhxDFZSCF3@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 7:56 AM, Leon Romanovsky wrote:
>> In any case I take your point.  I will now add to my task list
>> a review of these spots.  I'd like to be sure an error message
>> *is*  reported at an appropriate level up the chain of callers so
>> I can always identify the culprit in the a WARN_ON() fires (even
>> though it should never
>>   happen).  And in each case I'll evaluate
>> whether returning is better than not.
> You can, but users don't :). So if it is valid but error flow, that
> needs user awareness, simply print something to the dmesg with *_err()
> prints.

For some reason you seem to care about users.

I guess the WARN stack trace tells me where it comes from.
This would be an invalid error flow, and should never happen.

I'll still plan to review each of these again.

> BTW, I'm trying to untangle some of the flows in net/core/devlink.c
> and such if(WARN()) pattern is even harmful, because it is very hard to
> understand when that error is rare/non-exist/real.

That's what assert() is for, but we've already had that
discussion :)

					-Alex
