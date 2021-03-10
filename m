Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1BF334123
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhCJPFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:05:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51908 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhCJPFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 10:05:25 -0500
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lK0Oq-0000Kj-M2
        for netdev@vger.kernel.org; Wed, 10 Mar 2021 15:05:24 +0000
Received: by mail-wm1-f72.google.com with SMTP id c9so1166033wme.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:05:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6O6+tOduwR48d8zZ29bwhvehUqmwn5KZAJpghN9/ZFw=;
        b=WE5m/Q/wJ1TTF+eKx5YsV/Y/iPFWQiHGVMm9iKRaMUQuI1RmsShqXgw4eJ/YUyXr55
         ycTg4HTvcUmph053GHXpJkofCHPF0Wfc6AaWmjWTYCKEVjIDgIDbjQlyj/enw0Qdk5q4
         P0l0IQOjtLWsRLrhqpR7oP6zpE9yYCMJcv7QBd2kLYBdcEGf0+SkuM+OA1pD1XCSAV01
         6gfvziMMr+2iGAktvJRVwVi+R0oX/1/Zexo0xgV1UmlPKt8Xpb/5N31AmXlJ475NUdl8
         MoirQY7khGtJSoYpX6lLZlA9imdULUxTMUO4fFtg/aES4xOHatiHzA9mK6zyPLNyM6Wu
         Ur4A==
X-Gm-Message-State: AOAM530kwm2B3VvNSJdpin+Er1HctkaLh4q6uZUkqrRgrnFrpTBsdvEJ
        PiSestlqstnlpwOPf1usH4lgBUR9OwDeUEsFyaBZK1CU6oc3kz8yhARQJ2QcmYeg/ks/3JeqPPw
        d3f5EWo7Rgui4oFqAU8qWEWOXvLWxIU76lQ==
X-Received: by 2002:adf:f303:: with SMTP id i3mr3936415wro.67.1615388724221;
        Wed, 10 Mar 2021 07:05:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzGJJurjVb7EYp0bgYqxrECEX4ZhpKbOThOV2/LSr/fZ3VGeNkWRh86xSztb8QWNx4T9B9Jfg==
X-Received: by 2002:adf:f303:: with SMTP id i3mr3936156wro.67.1615388721715;
        Wed, 10 Mar 2021 07:05:21 -0800 (PST)
Received: from [192.168.1.116] (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id c26sm32188982wrb.87.2021.03.10.07.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 07:05:21 -0800 (PST)
Subject: Re: [RFC v2 3/5] arm64: socfpga: rename ARCH_STRATIX10 to
 ARCH_SOCFPGA64
To:     Tom Rix <trix@redhat.com>, Lee Jones <lee.jones@linaro.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        arm@kernel.org, soc@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
References: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
 <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
 <20210310094527.GA701493@dell>
 <35c39c81-08e4-24c8-f683-2fa7a7ea71de@redhat.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <1c06cb74-f0b0-66e5-a594-ed1ee9bc876e@canonical.com>
Date:   Wed, 10 Mar 2021 16:05:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <35c39c81-08e4-24c8-f683-2fa7a7ea71de@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2021 15:45, Tom Rix wrote:
> 
> On 3/10/21 1:45 AM, Lee Jones wrote:
>> On Wed, 10 Mar 2021, Krzysztof Kozlowski wrote:
>>
>>> Prepare for merging Stratix 10, Agilex and N5X into one arm64
>>> architecture by first renaming the ARCH_STRATIX10 into ARCH_SOCFPGA64.
>>>
>>> The existing ARCH_SOCFPGA (in ARMv7) Kconfig symbol cannot be used
>>> because altera_edac driver builds differently between them (with
>>> ifdefs).
>>>
>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>> ---
>>>  arch/arm64/Kconfig.platforms                |  7 ++++---
>>>  arch/arm64/boot/dts/altera/Makefile         |  2 +-
>>>  arch/arm64/configs/defconfig                |  2 +-
>>>  drivers/clk/Makefile                        |  2 +-
>>>  drivers/clk/socfpga/Kconfig                 |  4 ++--
>>>  drivers/edac/Kconfig                        |  2 +-
>>>  drivers/edac/altera_edac.c                  | 10 +++++-----
>>>  drivers/firmware/Kconfig                    |  2 +-
>>>  drivers/fpga/Kconfig                        |  2 +-
>>>  drivers/mfd/Kconfig                         |  2 +-
>> If it's okay with everyone else, it'll be okay with me:
>>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> I think the name is too broad, from the description in the config
> 
> +	bool "Intel's SoCFPGA ARMv8 Families"
> 
> A better name would be ARCH_INTEL_SOCFPGA64
> 
> So other vendors like Xilinx could do their own thing.

Many other architectures do not have vendor prefix (TEGRA, EXYNOS,
ZYNQMP etc). I would call it the same as in ARMv7 - ARCH_SOCFPGA - but
the Altera EDAC driver depends on these symbols to be different.
Anyway, I don't mind using something else for the name.

Best regards,
Krzysztof
