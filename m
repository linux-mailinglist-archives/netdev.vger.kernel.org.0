Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09176337CA5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhCKS0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:26:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhCKS0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:26:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615487199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/wSGYLh9BUQ/m4VK2E3Iu8L1K7AWw+HwFDDXH/P7x4=;
        b=Dt56iO4QJuJA+k3BrHjVi7X4akcMO+fRI3Op/0Vlc4YS1d0fSliXBiTt5M6YPh81npUeAo
        DONzHVH3vUzM3i7Q/rhj6Wb86BvX9R713O30qm86eYnTVWaw712H2o2v2ckbvL/zzFODWg
        NXs61CYptcr97lCFNI+HveKAq/RCz64=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-DBEQwzUsOQWmVDZr9ZnDdg-1; Thu, 11 Mar 2021 13:26:37 -0500
X-MC-Unique: DBEQwzUsOQWmVDZr9ZnDdg-1
Received: by mail-qk1-f200.google.com with SMTP id i188so16228119qkd.7
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 10:26:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7/wSGYLh9BUQ/m4VK2E3Iu8L1K7AWw+HwFDDXH/P7x4=;
        b=A9hGhgUi4zcuO7CX8IQr/yULSE7uv2oAry3N2r321Y+Zt8lD8btHaeOVWaWIiuoPNG
         YvfqxJQ986rCv+TcFu3K22dLNYo/huweOoIp4UPE4CyBs/4OIwi7SfXwe6c6ZnDd6ciz
         z8Ak6jmax59H7eIUQBShTTGDe+cxTundujVOQsiNdvaaHNhiLbWBKVPit59smKhi1y+N
         9fKvN9pNStRwuYpnNS8kewKkbdkmqmxZ5KlrwfNVc0+6GmuugoKLN7w2qPWPyP16qzP7
         91W12Bgf3rn5O/ISnhRazu+mix7oHlcVF7WP1538lRjZ66HEoOzhwawYid0utYf53eLt
         vkOQ==
X-Gm-Message-State: AOAM530EalnoKFEKyQPOwzAq09Fp4FS7+K6DRlR3V93ZOQP3gtM1IVpG
        ib6y1eCXeI4wj5246IJeKot9cl4Yl02xxUh8dxBiCA5uv0PeB3LFIANIkLLUt4FRygxrernLNhn
        uTQ3qkPggBap2xXTN
X-Received: by 2002:ac8:68d:: with SMTP id f13mr8512362qth.300.1615487197329;
        Thu, 11 Mar 2021 10:26:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykrRpLf1VdnWeXfJOmyNvXTcgKB/EbD8MxyP146EU0lCHJTfc5M6K1GGvBKnS5gI4cz7i4ig==
X-Received: by 2002:ac8:68d:: with SMTP id f13mr8512326qth.300.1615487197076;
        Thu, 11 Mar 2021 10:26:37 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id 77sm2571571qko.48.2021.03.11.10.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 10:26:36 -0800 (PST)
Subject: Re: [PATCH v3 00/15] arm64 / clk: socfpga: simplifying, cleanups and
 compile testing
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <f0b90916-9047-d5da-5cde-75d4330cf041@redhat.com>
Date:   Thu, 11 Mar 2021 10:26:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/11/21 7:25 AM, Krzysztof Kozlowski wrote:
> Hi,
>
> All three Intel arm64 SoCFPGA architectures (Agilex, N5X and Stratix 10)
> are basically flavors/platforms of the same architecture.  At least from
> the Linux point of view.  Up to a point that N5X and Agilex share DTSI.
> Having three top-level architectures for the same one barely makes
> sense and complicates driver selection.
>
> Additionally it was pointed out that ARCH_SOCFPGA name is too generic.
> There are other vendors making SoC+FPGA designs, so the name should be
> changed to have real vendor (currently: Intel).
>
>
> Dependencies / merging
> ======================
> 1. Patch 1 is used as base, so other changes depend on its hunks.
>    I put it at beginning as it is something close to a fix, so candidate
>    for stable (even though I did not mark it like that).
> 2. Patch 2: everything depends on it.
>
> 3. 64-bit path:
> 3a. Patches 3-7: depend on patch 2, from 64-bit point of view.
> 3b. Patch 8: depends on 2-7 as it finally removes 64-bit ARCH_XXX
>     symbols.
>
> 4. 32-bit path:
> 4a. Patches 9-14: depend on 2, from 32-bit point of view.
> 4b. Patch 15: depends on 9-14 as it finally removes 32-bit ARCH_SOCFPGA
>     symbol.
>
> If the patches look good, proposed merging is via SoC tree (after
> getting acks from everyone). Sharing immutable branches is also a way.
>
>
> Changes since v2
> ================
> 1. Several new patches and changes.
> 2. Rename ARCH_SOCFPGA to ARCH_INTEL_SOCFPGA on 32-bit and 64-bit.
> 3. Enable compile testing of 32-bit socfpga clock drivers.
> 4. Split changes per subsystems for easier review.
> 5. I already received an ack from Lee Jones, but I did not add it as
>    there was big refactoring.  Please kindly ack one more time if it
>    looks good.
>
> Changes since v1
> ================
> 1. New patch 3: arm64: socfpga: rename ARCH_STRATIX10 to ARCH_SOCFPGA64.
> 2. New patch 4: arm64: intel: merge Agilex and N5X into ARCH_SOCFPGA64.
> 3. Fix build is.sue reported by kernel test robot (with ARCH_STRATIX10
>    and COMPILE_TEST but without selecting some of the clocks).
>
>
> RFT
> ===
> I tested compile builds on few configurations, so I hope kbuild 0-day
> will check more options (please give it few days on the lists).
> I compare the generated autoconf.h and found no issues.  Testing on real
> hardware would be appreciated.
>
> Best regards,
> Krzysztof
>
> Krzysztof Kozlowski (15):
>   clk: socfpga: allow building N5X clocks with ARCH_N5X
>   ARM: socfpga: introduce common ARCH_INTEL_SOCFPGA
>   mfd: altera: merge ARCH_SOCFPGA and ARCH_STRATIX10
>   net: stmmac: merge ARCH_SOCFPGA and ARCH_STRATIX10
>   clk: socfpga: build together Stratix 10, Agilex and N5X clock drivers
>   clk: socfpga: merge ARCH_SOCFPGA and ARCH_STRATIX10
>   EDAC: altera: merge ARCH_SOCFPGA and ARCH_STRATIX10
>   arm64: socfpga: merge Agilex and N5X into ARCH_INTEL_SOCFPGA
>   clk: socfpga: allow compile testing of Stratix 10 / Agilex clocks
>   clk: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs (and
>     compile test)
>   dmaengine: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
>   fpga: altera: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
>   i2c: altera: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
>   reset: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
>   ARM: socfpga: drop ARCH_SOCFPGA
>
>  arch/arm/Kconfig                            |  2 +-
>  arch/arm/Kconfig.debug                      |  6 +++---
>  arch/arm/Makefile                           |  2 +-
>  arch/arm/boot/dts/Makefile                  |  2 +-
>  arch/arm/configs/multi_v7_defconfig         |  2 +-
>  arch/arm/configs/socfpga_defconfig          |  2 +-
>  arch/arm/mach-socfpga/Kconfig               |  4 ++--
>  arch/arm64/Kconfig.platforms                | 17 ++++-------------
>  arch/arm64/boot/dts/altera/Makefile         |  2 +-
>  arch/arm64/boot/dts/intel/Makefile          |  6 +++---
>  arch/arm64/configs/defconfig                |  3 +--
>  drivers/clk/Kconfig                         |  1 +
>  drivers/clk/Makefile                        |  4 +---
>  drivers/clk/socfpga/Kconfig                 | 19 +++++++++++++++++++
>  drivers/clk/socfpga/Makefile                | 11 +++++------
>  drivers/dma/Kconfig                         |  2 +-
>  drivers/edac/Kconfig                        |  2 +-
>  drivers/edac/altera_edac.c                  | 17 +++++++++++------
>  drivers/firmware/Kconfig                    |  2 +-
>  drivers/fpga/Kconfig                        |  8 ++++----
>  drivers/i2c/busses/Kconfig                  |  2 +-
>  drivers/mfd/Kconfig                         |  4 ++--
>  drivers/net/ethernet/stmicro/stmmac/Kconfig |  4 ++--
>  drivers/reset/Kconfig                       |  6 +++---
>  24 files changed, 71 insertions(+), 59 deletions(-)
>  create mode 100644 drivers/clk/socfpga/Kconfig
>
Thanks for changing the config name.

Please review checkpatch --strict on this set, the typical complaint is

clk: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs (and compile test)    
WARNING: please write a paragraph that describes the config symbol fully
#35: FILE: drivers/clk/socfpg/Kconfig:11:                       
+config CLK_INTEL_SOCFPGA32

Tom

