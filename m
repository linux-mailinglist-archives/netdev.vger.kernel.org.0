Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237A33380DB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCKWsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:48:45 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:38704 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhCKWsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 17:48:08 -0500
Received: by mail-pg1-f171.google.com with SMTP id q5so1947313pgk.5;
        Thu, 11 Mar 2021 14:48:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yp/zf/TAjp/DgsBtmkn2h95rlPfAql88KAJ1HBTmgds=;
        b=N/FxOEVl779PVlBHxLIMSqM/0lYSVxxKhk5nWz7vvVtBEIinSimCAOMd0XDNNhdZc4
         FjsTkq5t5mC4fNIHQs9lSHt5DXDKAV/nqU7BYWSmRYN6LJQf/gd5B/FVtr4/11ThrpJT
         fLP83HYaHUCYz+ULRt+ZZ2yPoTmaysNyMk8KbLh1aisCSHlQ4t6/igqqP2v4QhINy2pI
         LJ0IyDyge3TjkeWHu0tz7Wqln5B+Vg1oZXnTAAbPZl3oTQvTUAlFPUw/ZlEnPp4Azu7Z
         AHhXGL6aiDIR6wDIJdSe1HhQRcTB4NmL1SlZ90QOtcZvMmA1rB2/CU33L1xsUSFfGoD+
         x+iw==
X-Gm-Message-State: AOAM533U+cqap7tLjD9Fad6tnML5dqvl7Ls5JhPC+6sbRVt2bhzJMmPK
        UboDfrRDzAvtuJ51WXH1CVk=
X-Google-Smtp-Source: ABdhPJz8cvoO7cjx+Ydi2AzXzvDOKfJqCw7+rk33vFgwXIa9cNT/DNeCu3LAtFW6UsvUmJpd+zx4VQ==
X-Received: by 2002:a63:5c1e:: with SMTP id q30mr8763269pgb.259.1615502887491;
        Thu, 11 Mar 2021 14:48:07 -0800 (PST)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id n10sm3227074pgk.91.2021.03.11.14.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 14:48:06 -0800 (PST)
Date:   Thu, 11 Mar 2021 14:48:05 -0800
From:   Moritz Fischer <mdf@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Russell King <linux@armlinux.org.uk>,
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
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
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
Subject: Re: [PATCH v3 12/15] fpga: altera: use ARCH_INTEL_SOCFPGA also for
 32-bit ARM SoCs
Message-ID: <YEqeJSFnQJVV15P1@epycbox.lan>
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
 <20210311152735.1318487-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311152735.1318487-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Thu, Mar 11, 2021 at 04:27:35PM +0100, Krzysztof Kozlowski wrote:
> ARCH_SOCFPGA is being renamed to ARCH_INTEL_SOCFPGA so adjust the
> 32-bit ARM drivers to rely on new symbol.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/fpga/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index fd325e9c5ce6..b1026c6fb119 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -14,13 +14,13 @@ if FPGA
>  
>  config FPGA_MGR_SOCFPGA
>  	tristate "Altera SOCFPGA FPGA Manager"
> -	depends on ARCH_SOCFPGA || COMPILE_TEST
> +	depends on ARCH_INTEL_SOCFPGA || COMPILE_TEST
>  	help
>  	  FPGA manager driver support for Altera SOCFPGA.
>  
>  config FPGA_MGR_SOCFPGA_A10
>  	tristate "Altera SoCFPGA Arria10"
> -	depends on ARCH_SOCFPGA || COMPILE_TEST
> +	depends on ARCH_INTEL_SOCFPGA || COMPILE_TEST
>  	select REGMAP_MMIO
>  	help
>  	  FPGA manager driver support for Altera Arria10 SoCFPGA.
> @@ -99,7 +99,7 @@ config FPGA_BRIDGE
>  
>  config SOCFPGA_FPGA_BRIDGE
>  	tristate "Altera SoCFPGA FPGA Bridges"
> -	depends on ARCH_SOCFPGA && FPGA_BRIDGE
> +	depends on ARCH_INTEL_SOCFPGA && FPGA_BRIDGE
>  	help
>  	  Say Y to enable drivers for FPGA bridges for Altera SOCFPGA
>  	  devices.
> -- 
> 2.25.1
> 
Thanks,
Moritz
