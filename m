Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2BF2CAADC
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392278AbgLAShP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392246AbgLAShO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:37:14 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C730C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 10:36:34 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id d8so2621776ioc.13
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 10:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CRRh4gmCZpqCwwrsNrjNS8FDU6nBF/6A0Gt8Me2fWgA=;
        b=N9GXOOYYMdmoTPfMl6Scwdw59P+r8p9HlZeoRBNXo6pQPx7Me/XvkmzRiUXRAjYdqB
         VVV+i+CP0QPeHvCVHeGv7MWdrGC57TaW3z2VZcE7Ol2tBcS7d2jC0aBJ3N37bJbav1K5
         q3WiAU93BCyUhQ/aXZ9KEytM9FS5Zg8yPpqwFa001LjZFQ8RxRVMiLm5oLXtPQxlcuHS
         kC4CfFiihPo25yLzRHR3aOi0MapWK9sUFYGLX6VkDKBFYJaeMhBgcJZAr2rwXT0qp1lx
         OwcYpFGbnzvZdYcnCatzNY/EqPcZWr2K5Enl2ayfpdp3755Y/+q3x45WAJ0/sygAkSvx
         vCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CRRh4gmCZpqCwwrsNrjNS8FDU6nBF/6A0Gt8Me2fWgA=;
        b=LLA0vJWQrZtacSTw6prxk9lLw7HkzZtiPDd+kZABIqCfaIfU2ktOhwJPrBHHVrWllu
         0PUteH/KexmWPza+MikYUrX0Hp4iVjeFQ84k8xeVB4QnU3XlBGpcNOOJWyb5Cw/bhAe2
         sFO5zrnYtPQhC5Mq35PVDdaWR7YItXgnL1SfKOXDCKuv44Kt62pB6vQrj5+FGdcJ3yYQ
         L2JACvMzAkVZhOZnApr6RnFZwoVKvhcSr7Y1SwUQCCLMTlZdRPT88umpQs4y5q2VYVbl
         3hMZmuC8j6BABBBKQWVIpGuFb1RB6Zq4qTSy6E/LJEKBaferzvtG1RHIEyfRHYKnKVAq
         RLdw==
X-Gm-Message-State: AOAM5303RmsbpNgRXDlnho44Zb4IR6LDkx9zEuV6cje3IrYjUm+rxE+d
        V2wEI+Jk/pdDaQtuIBDIMh31Mg==
X-Google-Smtp-Source: ABdhPJzoMMXA2fF9ohu/9lVDAzQo9yIFP8uuGQvGcMCR7GT3h24W4lFY04F5YsiGwEG0kfdwuyqWKg==
X-Received: by 2002:a6b:6d10:: with SMTP id a16mr3440229iod.186.1606847793872;
        Tue, 01 Dec 2020 10:36:33 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id x23sm221386ioh.28.2020.12.01.10.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 10:36:33 -0800 (PST)
Subject: Re: [PATCH net-next 4/6] net: ipa: add support to code for IPA v4.5
To:     Jon Hunter <jonathanh@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20201125204522.5884-1-elder@linaro.org>
 <20201125204522.5884-5-elder@linaro.org>
 <5b5d9d40-94d5-5dad-b861-fd9bef8260e2@nvidia.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <66089c0e-7591-a74f-79db-e8a38ea2d56a@linaro.org>
Date:   Tue, 1 Dec 2020 12:36:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <5b5d9d40-94d5-5dad-b861-fd9bef8260e2@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20 12:11 PM, Jon Hunter wrote:
> 
> On 25/11/2020 20:45, Alex Elder wrote:
>> Update the IPA code to make use of the updated IPA v4.5 register
>> definitions.  Generally what this patch does is, if IPA v4.5
>> hardware is in use:
>>    - Ensure new registers or fields in IPA v4.5 are updated where
>>      required
>>    - Ensure registers or fields not supported in IPA v4.5 are not
>>      examined when read, or are set to 0 when written
>> It does this while preserving the existing functionality for IPA
>> versions lower than v4.5.
>>
>> The values to program for QSB_MAX_READS and QSB_MAX_WRITES and the
>> source and destination resource counts are updated to be correct for
>> all versions through v4.5 as well.
>>
>> Note that IPA_RESOURCE_GROUP_SRC_MAX and IPA_RESOURCE_GROUP_DST_MAX
>> already reflect that 5 is an acceptable number of resources (which
>> IPA v4.5 implements).
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> 
> This change is generating the following build error on ARM64 ...

Sorry about that.  Thank you for reporting this, I will investigate.

					-Alex

> In file included from drivers/net/ipa/ipa_main.c:9:0:
> In function ‘u32_encode_bits’,
>      inlined from ‘ipa_hardware_config_qsb.isra.7’ at drivers/net/ipa/ipa_main.c:286:6,
>      inlined from ‘ipa_hardware_config’ at drivers/net/ipa/ipa_main.c:363:2,
>      inlined from ‘ipa_config.isra.12’ at drivers/net/ipa/ipa_main.c:555:2,
>      inlined from ‘ipa_probe’ at drivers/net/ipa/ipa_main.c:835:6:
> ./include/linux/bitfield.h:131:3: error: call to ‘__field_overflow’ declared with attribute error: value doesn't fit into mask
>     __field_overflow();     \
>     ^~~~~~~~~~~~~~~~~~
> ./include/linux/bitfield.h:151:2: note: in expansion of macro ‘____MAKE_OP’
>    ____MAKE_OP(u##size,u##size,,)
>    ^~~~~~~~~~~
> ./include/linux/bitfield.h:154:1: note: in expansion of macro ‘__MAKE_OP’
>   __MAKE_OP(32)
>   ^~~~~~~~~
> 
> Cheers
> Jon
> 

