Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739EB55AC88
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 22:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiFYURa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 16:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiFYUR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 16:17:29 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE53614D37
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 13:17:27 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eo8so7925996edb.0
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 13:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=amdozWDTBW4nPW/TB1vNSE3aSyOSymWjl0xCncL2e5o=;
        b=F0g++A1Y/eQo02URGKIJk9BaVk/w/aRYH0E8r9LCM+cHUw3azQ0UWjd9Uekx656Chu
         Uf0pz/33ycAd7JH/ZbeL4V/Mpk8A0sbfs4W0q1dgmnT1Lkn0GfB/fgSnjdaQ9+nR8/cH
         Yo8mILDLgU9Bt6p1HsjcmLt7mdP7H6rxOvSJq7ftpOzlWa370v3k6J/ll30nYAEwrr0p
         Krx+hQdIJDHuzDcDPKW1vShfmkJldSiVLhInY4qPan2zaMOR+WGK66tUjRiiCPceOsK2
         b4k+5JvQia4anX1M95Xvt4et/aE6ZWPEQfvCR9nv7w5KUPuf196YbqM66Xdva0gZaVLK
         HSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=amdozWDTBW4nPW/TB1vNSE3aSyOSymWjl0xCncL2e5o=;
        b=H7haBZcJdysYZne5s1+7NJaR/mQ3nrpN9kbcyYweUQwbCCI+gSK3/kPSQqCiVtvIEW
         IGRandfYKzbcuBp1femrE5BaaiVKGZNxbhlWuPeIWfDA0oNP/ssRc8O9Yw1j+CkwaYb0
         aoyCm1XQOk4fhvQ5qRchJMANp6V/X7N2XCY/nVQhAC8J5oroKtJ5em/crNv0e65Rn/fD
         iH9659qXsmrLCeCs5gbaS6oDdNuuFM9n+pyhYZrxrdJpgcSDHI66/ny/Qc19ioJdU1xG
         vTPWfHlMNjDO1lxkLuU49NtwtG9DR3s8LkjT1ytq8wT56BwNHowDy0p2A7Wupiz+10TG
         koqw==
X-Gm-Message-State: AJIora9+6+HpbZDe1AcAfMB7MY85k817mPQeDXRS7Y9s3IPYOVozI8ke
        TmvgNWkMYDckreTbBL5G6FmjjQ==
X-Google-Smtp-Source: AGRyM1vJaTxphPLX88QmNPkoVNnp2tPE2GUrqm0eYWRQmkkPOKowlJOUbINXeXsMde+IJPsq4n/h3w==
X-Received: by 2002:aa7:cb83:0:b0:435:9170:8e3b with SMTP id r3-20020aa7cb83000000b0043591708e3bmr7190848edt.144.1656188246288;
        Sat, 25 Jun 2022 13:17:26 -0700 (PDT)
Received: from [192.168.0.239] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id r1-20020a17090638c100b007219c20dcd8sm2967138ejd.196.2022.06.25.13.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jun 2022 13:17:25 -0700 (PDT)
Message-ID: <000ca74c-16e1-754b-3398-8c9a65faee0b@linaro.org>
Date:   Sat, 25 Jun 2022 22:17:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: (subset) [PATCH net-next v1 4/9] memory: tegra: Add MGBE memory
 clients for Tegra234
Content-Language: en-US
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, vbhadram@nvidia.com,
        treding@nvidia.com, robh+dt@kernel.org, catalin.marinas@arm.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        jonathanh@nvidia.com, will@kernel.org
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-4-vbhadram@nvidia.com>
 <165608679241.23612.16454571226827958210.b4-ty@linaro.org>
 <YrXlQJ1qzsZZrx7Q@orome>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YrXlQJ1qzsZZrx7Q@orome>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/06/2022 18:24, Thierry Reding wrote:
> On Fri, Jun 24, 2022 at 06:06:35PM +0200, Krzysztof Kozlowski wrote:
>> On Thu, 23 Jun 2022 13:16:10 +0530, Bhadram Varka wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> Tegra234 has multiple network interfaces with each their own memory
>>> clients and stream IDs to allow for proper isolation.
>>>
>>>
>>
>> Applied, thanks!
>>
>> [4/9] memory: tegra: Add MGBE memory clients for Tegra234
>>       https://git.kernel.org/krzk/linux-mem-ctrl/c/6b36629c85dc7d4551e57e92a3e970d099333e4e
> 
> Ah yes, you'll need the dt-bindings header for this driver bit as well.
> If you don't mind I could pick all of these up into the Tegra tree and
> resolve the dependencies there, then send a pull request for the memory
> tree that incorporates the dt-bindings branch as a dependency.
> 
> That way you don't have to worry about this at all. We might also get
> another set of similar changes for PCI or USB during this cycle, so it'd
> certainly be easier to collect all of these in a central place.

I cannot take DTS patches to the driver tree, so it's easier if you take
it and handle the dependencies.

Best regards,
Krzysztof
