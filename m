Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C333340A2
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 15:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhCJOqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 09:46:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232799AbhCJOp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 09:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615387559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qe7vnreao5ThhJBhWOb2yAQo6akg/BiUCkUWjObNy9A=;
        b=jAQEJb0XW/eBEz+KnlZaNF1G8qQYLiWlKJ/yjS2yJC17t9GJJK8qIa7nWSijsQjMlR2Is1
        +HfoTiSWHZfMLWctwkjF/pOo33Jq7FuM1pCoCfYPY6Sk8uZv/dCygPi8mxgqI08ELaZSkY
        fa5vmZwVVK0TSi5I4GO9nK2Zl98tr78=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-JSW_rIipNBejYMaweABS8A-1; Wed, 10 Mar 2021 09:45:55 -0500
X-MC-Unique: JSW_rIipNBejYMaweABS8A-1
Received: by mail-qk1-f198.google.com with SMTP id a137so9214363qkb.20
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 06:45:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Qe7vnreao5ThhJBhWOb2yAQo6akg/BiUCkUWjObNy9A=;
        b=NjmdxFDbBrMep8jl1B4CEUX7gfgiOTLt5PdqhPvXW9WwQDOq+U/Q0jyKp4flxaETh+
         yUUrx/uNlvRyVOqQm2qs7R6HTAAffwfyWtYcyeZ+QOOS8HBX5E3YCVqhlbdfZM0qNTd2
         jnMrRw3ofboNsppzw+uVgihlGsR9Kdjz/jIYU2yVl5I0g4Q7rk78bF4Ixx63eRMWcH02
         BgA6zDTFODSay2pGr147u8oznaWLeKgmYKPvYd0YYsdiGudMhqHosn61TqZgovBKgsCR
         XB3kkKhQBju4HYsc1TVe2hkxpq2wKj3N3ZPDWzyIdMEODwmAlYKqnJe/EGNFRxFHVXnl
         QP1A==
X-Gm-Message-State: AOAM530wkkAkaht+Z9QyS7WBD7iPs7oLgnslKQtmoS6ThfzVuvckd244
        FAROSBT8nW3I9YXM2d/BBQuohuFcU5DOn1rlK/FK8P53hI+Pn2UvVmrquEeKuEcrFtL9bbMCVKI
        7yUk/jAwOLuiqHpRM
X-Received: by 2002:a0c:8ec7:: with SMTP id y7mr3256309qvb.9.1615387555276;
        Wed, 10 Mar 2021 06:45:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlNoVM9BzWQNjpadCXVlfERPTQuROOGObYqvdAhHPCzlyHzhNVdnm6DSobOhCibwSlI7/4+g==
X-Received: by 2002:a0c:8ec7:: with SMTP id y7mr3256274qvb.9.1615387555052;
        Wed, 10 Mar 2021 06:45:55 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id d2sm12859520qkk.42.2021.03.10.06.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 06:45:54 -0800 (PST)
Subject: Re: [RFC v2 3/5] arm64: socfpga: rename ARCH_STRATIX10 to
 ARCH_SOCFPGA64
To:     Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
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
From:   Tom Rix <trix@redhat.com>
Message-ID: <35c39c81-08e4-24c8-f683-2fa7a7ea71de@redhat.com>
Date:   Wed, 10 Mar 2021 06:45:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210310094527.GA701493@dell>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/10/21 1:45 AM, Lee Jones wrote:
> On Wed, 10 Mar 2021, Krzysztof Kozlowski wrote:
>
>> Prepare for merging Stratix 10, Agilex and N5X into one arm64
>> architecture by first renaming the ARCH_STRATIX10 into ARCH_SOCFPGA64.
>>
>> The existing ARCH_SOCFPGA (in ARMv7) Kconfig symbol cannot be used
>> because altera_edac driver builds differently between them (with
>> ifdefs).
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>>  arch/arm64/Kconfig.platforms                |  7 ++++---
>>  arch/arm64/boot/dts/altera/Makefile         |  2 +-
>>  arch/arm64/configs/defconfig                |  2 +-
>>  drivers/clk/Makefile                        |  2 +-
>>  drivers/clk/socfpga/Kconfig                 |  4 ++--
>>  drivers/edac/Kconfig                        |  2 +-
>>  drivers/edac/altera_edac.c                  | 10 +++++-----
>>  drivers/firmware/Kconfig                    |  2 +-
>>  drivers/fpga/Kconfig                        |  2 +-
>>  drivers/mfd/Kconfig                         |  2 +-
> If it's okay with everyone else, it'll be okay with me:
>
> Acked-by: Lee Jones <lee.jones@linaro.org>

I think the name is too broad, from the description in the config

+	bool "Intel's SoCFPGA ARMv8 Families"

A better name would be ARCH_INTEL_SOCFPGA64

So other vendors like Xilinx could do their own thing.

Tom

>
>>  drivers/net/ethernet/stmicro/stmmac/Kconfig |  4 ++--
>>  drivers/reset/Kconfig                       |  2 +-
>>  12 files changed, 21 insertions(+), 20 deletions(-)

