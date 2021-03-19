Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FD13420FE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCSPdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhCSPcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:32:52 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F7AC06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:32:52 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id n198so6517445iod.0
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/d8jBikz4p9w6ETospv3vL+NArFRppIkKIX3Ap4QrNQ=;
        b=M7GvJw0+1b/2/mB1jBTYbZyw7RZbfQ+UqcGnDKQI91bupJHSY2Ka+q0sEGwY/Dk6On
         Xlbf42NJ0mm6OZDJmUwAQofbv6ydTBFZ0VvQWbVARELURPIqzi3btWye/Bp9JLsOAENl
         PWAWL24u6NynXFoTEuhQfV4WpvLdWA9vv3q9ozIFARZsHlS70v3Sesm1rytu5fc2s+ri
         Kx7ZE/PWHhE4tiILYiZrfNPBLLnPvOjwdM27DYk/rELk5YVWUnFUaiSkCG9mk8hgzq++
         q6cWIdiVNFLt6WRn2KmJBMX84YxCpmPfVcDLDXi7eRW+zkM7CEpKoiOSMTcybRpD1cGK
         ZQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/d8jBikz4p9w6ETospv3vL+NArFRppIkKIX3Ap4QrNQ=;
        b=aM/QnpMEHVk/OwoFM5Vq1kvMhnY9uHr+kKlrY5xm+iaaDJsSFVZ/h97vUDfop6Jfbm
         kDLIw697Blsg5H2CIEsJ7FuHzA/QW+5fSRHFjaWEMi7wVWBzuvqMwzLTXVumv8Fob3Qp
         cThgS+HO7fgUYWY7+5WWOB22Hb3lfuNUWzkbSQwExut7OHF2GWoXcCCy7eM/yNFnF0Yb
         AtkBLpR21Svfn0ZJZDXi/M5LN3TRCaAiBiGu8rdrlVbnNoLAr5d6/KirBfonbPBQ1vP9
         ftu/F/+rO2toiQGlll1dsfOKWGHQ7LnyQrGGcqPVvRzLx0dIerPPnEg1t7qpaOGrTdXQ
         8ByQ==
X-Gm-Message-State: AOAM531U9i4WI5x8QlAQbrDIhFVBPPNBofa0dlAg5QzF5SQm3IqU6xh2
        iIbVkny8oZDH6MJqDd4u3Q7+7w==
X-Google-Smtp-Source: ABdhPJz4qNqmvLX7BgQZdVkCbdxOELKmhNIBBtsd+kcg5a5qZPfq0mcbtVaEBZ/OrRGFKJtaf85Dcw==
X-Received: by 2002:a5e:cb4b:: with SMTP id h11mr3259993iok.108.1616167971664;
        Fri, 19 Mar 2021 08:32:51 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id c18sm2815457ild.37.2021.03.19.08.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 08:32:51 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: ipa: activate some commented assertions
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-5-elder@linaro.org> <YFQwAYL15nEkfNf7@unreal>
 <7520639c-f08b-cb25-1a62-7e3d69981f95@linaro.org> <YFTAn7tHBAG2PO78@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <69647805-7ace-442d-2268-aa7c4800ab6e@linaro.org>
Date:   Fri, 19 Mar 2021 10:32:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFTAn7tHBAG2PO78@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 10:17 AM, Leon Romanovsky wrote:
>>>> @@ -212,7 +213,7 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
>>>>    			BCR_HOLB_DROP_L2_IRQ_FMASK |
>>>>    			BCR_DUAL_TX_FMASK;
>>>> -	/* assert(version != IPA_VERSION_4_5); */
>>>> +	ipa_assert(NULL, version != IPA_VERSION_4_5);
>>> This assert will fire for IPA_VERSION_4_2, I doubt that this is
>>> something you want.
>> No, it will only fail if version == IPA_VERSION_4_5.
>> The logic of an assertion is the opposite of BUG_ON().
>> It fails only if the asserted condition yields false.
> ok, this ipa_reg_bcr_val() is called in only one place and has a
> protection from IPA_VERSION_4_5, why don't you code it at the same
> .c file instead of adding useless assert?

As I mentioned in my other message, the purpose of an
assertion is *communicating with the reader*.  The
fact that an assertion may expand to code that ensures
the assertion is true is secondary.

This particular assertion says that the version will never
be 4.5.  While looking at this function, you don't need to
see if the caller ensures that, the assertion *tells* you.

Whether an assertion is warranted is really subjective.
You may not appreciate the value of that, but I do.

					-Alex
