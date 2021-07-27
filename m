Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6803D7517
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 14:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhG0Mep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 08:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhG0Meo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 08:34:44 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3D2C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 05:34:44 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id y200so15827211iof.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 05:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tx9WvkWlXQvIsbgtedpwBAlQFYtHs5upNNRDEpjIglQ=;
        b=vO5XZU9BXnHptTBM+WggVXH2CaX0yV5LKBqx88pts1JAm04TVUlSPL5LyfY9UWGvyQ
         eM5Hd9bznmo2b9FGabQmJA84kYQ8E8y8juU6PVKXYjc6KeJNeJcIRZCZKXhzictTjwsz
         GhQxybF/4wZCgNvwn028rw42lIoR20IfP/o1h5qYnBbj7KG8WZFsm/mPE8WROnyQXCYu
         k2Su1QiyfSJs4uj7cIN6H7fHDm+kRjrD+LQwr4ruk0GJ+F75AiXMLz1PAUzctB7k2VGl
         +XR7TT06Sb7zxP4v8Hxz2THiHUCJpsiMDbTt/ByEzMQzN4cilLYSGrIbB9ehYTOmKFLS
         6RRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tx9WvkWlXQvIsbgtedpwBAlQFYtHs5upNNRDEpjIglQ=;
        b=Imx0kycbasox05J8VaeuZr42kQ780367M1Txg0TVHHOgQ3BVvhohJOHutYDEqEojxf
         Lq3ByUIkkXh+9mC4Gh2pwzv2QZkRfI4cobIU1yLmuTKQ0o5MPbwUcJKlHMk5XZ7TFCna
         4I6rrEjbMdnJSGD59hD9EyS7HO7K96R/tdL5jrtjdlKXFY45ox2Mh0iwnSfXYWTtBeGt
         CfrEKFwkUzy/nvNPqDYuaYtBik0cK3Bz6QY0GkqWr3AlMVxJwHA0IydROeNiUBK11baO
         c3jNX4Z/YVKDCRs1/Wnc3q11iVVk6R8Sbie5UM1o7rxRJXVp/NgqUSVCvnU26z+Kpx7U
         +LCA==
X-Gm-Message-State: AOAM530jQqjt1KSNL4435kStfkNUHe4gSusb0E87IM6eEieHHwMe6USO
        oqVbJOg3j8I8Qcy2ApJLLhr7FQ==
X-Google-Smtp-Source: ABdhPJyhYcnf1iI72d0MzaCwlF0xDi4eWkQRYB2e0zDRTTkBeNa/R02wqQIJbwGPLox7L09kzjTdLw==
X-Received: by 2002:a6b:794b:: with SMTP id j11mr18708688iop.129.1627389282964;
        Tue, 27 Jul 2021 05:34:42 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id c1sm1769461ils.21.2021.07.27.05.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 05:34:42 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: ipa: kill IPA_VALIDATION
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210726174010.396765-1-elder@linaro.org>
 <YP/rFwvIHOvIwMNO@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <5b97f7b1-f65f-617e-61b4-2fdc5f08bc3e@linaro.org>
Date:   Tue, 27 Jul 2021 07:34:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YP/rFwvIHOvIwMNO@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 6:16 AM, Leon Romanovsky wrote:
> On Mon, Jul 26, 2021 at 12:40:06PM -0500, Alex Elder wrote:
>> A few months ago I proposed cleaning up some code that validates
>> certain things conditionally, arguing that doing so once is enough,
>> thus doing so always should not be necessary.
>>   https://lore.kernel.org/netdev/20210320141729.1956732-1-elder@linaro.org/
>> Leon Romanovsky felt strongly that this was a mistake, and in the
>> end I agreed to change my plans.
> 
> <...>
> 
>> The second patch fixes a bug that wasn't normally exposed because of
>> the conditional compilation (a reason Leon was right about this).
> 
> Thanks Alex,
> 
> If you want another anti pattern that is very popular in netdev, the following pattern is
> wrong by definition :):
> if (WARN_ON(...))
>   return ...

I understand this reasoning.

I had it return an error if the WARN_ON() condition was true in cases
where the function returned a value and callers already handled errors.
I looked back at the patch and here is one of those cases:

gsi_channel_trans_alloc()
- If too many TREs are requested we do not want to allocate them
  from the pool, or it will cause further breakage.  By returning
  early, no transaction will be filled or committed, and an error
  message will (often) be reported, which will indicate the source
  of the error.  If any error occurs during initialization, we fail
  that whole process and everything should be cleaned up.  So in
  this case at least, returning if this ever occurred is better
  than allowing control to continue into the function.

In any case I take your point.  I will now add to my task list
a review of these spots.  I'd like to be sure an error message
*is* reported at an appropriate level up the chain of callers so
I can always identify the culprit in the a WARN_ON() fires (even
though it should never
 happen).  And in each case I'll evaluate
whether returning is better than not.

Thanks.

					-Alex

> The WARN_*() macros are intended catch impossible flows, something that
> shouldn't exist. The idea that printed stack to dmesg and return to the
> caller will fix the situation is a very naive one. That stack already
> says that something very wrong in the system.
> 
> If such flow can be valid use "if(...) return ..", if not use plain
> WARN_ON(...).
> 
> Thanks
> 

