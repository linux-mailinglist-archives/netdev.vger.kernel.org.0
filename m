Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D7929F22F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgJ2QvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbgJ2Quz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 12:50:55 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA67CC0613D7
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 09:50:54 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y20so4277885iod.5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 09:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LZKbbPLE+8OZ/9n3/DJPLFxY62N+W2iweISXRaZy22Y=;
        b=Lp9qSgGtP4hrCXDbBPB1xjFjIZv0aXCrh81MFC5gEnJNopFRPXAVXJu9VJq3eUTAqK
         zmKdU92/LVV5vo0CeLXv00MBPJb8pQshc3R40KRkiVoVecfKIixnNgVKAjUbSCYYE2p1
         Zms3URSWINMI4gSzDIbBLZZ96uobm3M96X28ZUhvyYFGgsHDE20czx1L1HUeiIH6xh9A
         NTTs+3otYI6ssOLB3lwfx+zYzNgVp3xtbnwkQRQ8umjVnvGpXqWP9/mhrfcxPHtYP1S1
         fgTV/IdAWnQi5aCwk/fOanEFtyFO2lmBXnSCHu81e06t8qjzEkiu0g5TsZw9wZ382daI
         9LpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LZKbbPLE+8OZ/9n3/DJPLFxY62N+W2iweISXRaZy22Y=;
        b=tz4WySPjiXNQmCL0PrCu7PsLHPVWD5GCdIK2Y8+XY3clne1E3A25TGU3zd9AM8fbKq
         wA/lPOILfk3CrdOMX4ulZ2W+HJ+aVDEqqIfYCgrLapFAeQX25CKr8xsqmJNc5mO0v8fl
         DPtW5hGHiWmTHQSUMoDPr0cLe1Ke5qMzWcyGo80zr4vtPrdfRcUJux7erNLsdrCj3fvT
         5wgg+zNd7GqxC8cYKPSeyIgMx0X1SkiYo7OGKkGwEDGjy0cpVbpkBw68A5pg+9sRX8VD
         joEze8HORA90o7IAS5eGGKRO1q4sRktvnszRZt5m33uotGwhVBor8/FSeHTvsiD2I0TS
         iFZQ==
X-Gm-Message-State: AOAM530ErsEMvJpE4znGG9Qb3HBoMzSNS4TTKonHJ+j+HLSlrLse2qKo
        qV4CInxJ16eM/iG5BWbt/FealttUh5Q+qRsr
X-Google-Smtp-Source: ABdhPJz0/7qjEbasqiXqo7CdZj8NPTm0soE2DrHijyL12QAKUU5Eh3906W9XULBl3U4nmT2D6WEN0w==
X-Received: by 2002:a05:6602:228f:: with SMTP id d15mr4243688iod.10.1603990254247;
        Thu, 29 Oct 2020 09:50:54 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id f77sm3083651ilf.40.2020.10.29.09.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 09:50:53 -0700 (PDT)
Subject: Re: [PATCH v2 net 0/5] net: ipa: minor bug fixes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201028194148.6659-1-elder@linaro.org>
 <20201029091137.1ea13ecb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <2f62dbe1-a1b3-a5f9-8cba-82cd8061ff9b@linaro.org>
Date:   Thu, 29 Oct 2020 11:50:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029091137.1ea13ecb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/20 11:11 AM, Jakub Kicinski wrote:
> On Wed, 28 Oct 2020 14:41:43 -0500 Alex Elder wrote:
>> This series fixes several bugs.  They are minor, in that the code
>> currently works on supported platforms even without these patches
>> applied, but they're bugs nevertheless and should be fixed.
> 
> By which you mean "it seems to work just fine most of the time" or "the
> current code does not exercise this paths/functionally these bugs don't
> matter for current platforms".

The latter, although for patch 3 I'm not 100% sure.

Case by case:
Patch 1:
   It works.  I inquired what the consequence of passing this
   wrong buffer pointer was, and for the way we are using IPA
   it seems it's fine--the memory pointer we were assigning is
   not used, so it's OK.  But we're assigning the wrong pointer.
Patch 2:
   It works.  Even though the bit field is 1 bit wide (not two)
   we never actually write a value greater than 1, so we don't
   cause a problem.  But the definition is incorrect.
Patch 3:
   It works, but on the SDM845 we should be assigning the endpoints
   to use resource group 1 (they are 0 by default).  The way we
   currently use this upstream we don't have other endpoints
   competing for resources, so I think this is fine.  SC7180 we
   will assign endpoints to resource group 0, which is the default.
Patch 4:
   It works.  This is like patch 2; we define the number of these
   things incorrectly, but the way we currently use them we never
   exceed the limit in a broken way.
Patch 5:
   It works.  The maximum number of supported groups is even,
   and if a (smaller) odd number are used the remainder are
   programmed with 0, which is appropriate for undefined
   fields.

If you have any concerns about back-porting these fixes I
think I'm comfortable posting them for net-next instead.
I debated that before sending them out.  Please request that
if it's what you think would be best.

					-Alex
