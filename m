Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB6E1A3E0F
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 04:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgDJCPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 22:15:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33062 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgDJCPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 22:15:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id c138so461030pfc.0
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 19:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=d7TfN17oK8F2t6OALSAXlrRz8ePlocQcOt3Tf7Trm+w=;
        b=IAv54bR49HatWrnIw+HDgyEN9L0d+xo2Xv+gqO9biP9UAG4TQxLCmG7iTpbSCq+NuC
         0eAR4r4KUVa6eR6XU7d3tZ5fOUaNT6Wg4F97lpYfpU8MSjA8SlYyhx+b4yh9uNhsbG4n
         oNawBTi8CBRoYEvBS4wq84IRWkzfMxdsNljhCX1BARiGTmfgxw2N4TkfQs4duPM6QRsC
         +daKrgaq3RS/hpXvWAQJFLUKT7QBBqjbgFTKz8Z3KRYGMMv2EvUymel++H5RKt+zsyd6
         f8RHaCLC6Lghb4Nbso62VAu3g8UE9aQ8Yv6ZVW9+JjeIw9YffkFE9T6mZb2/j2IDS2WA
         XF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=d7TfN17oK8F2t6OALSAXlrRz8ePlocQcOt3Tf7Trm+w=;
        b=Z+v+hhb96j7vqM0oWn1HO7ZO0HcROp8fz1OO0dTBJwYYe0YS1FeIcYCIzkLuXcq1Wt
         SHwzeSHjMSgO1PUk+HyRNmP/wiXdzp/JkcTXZ9LVirT7ZiNbV01wMPNy7bRXs+QmIJWc
         N9b6Cmo+hnGW5e4WwTv+SzGzhJLmXeTjwGu6DEOs5khcUkyOyJXRt/6+nt+gc41Ca5zf
         lVff/T3+NuxwcnmEaC+zeEbKgBVp7bryGj7N0T32gEFcd40IrItMjoxG/ih2PzyLe0e6
         eo0KQ40pgWn77gTvqk2no3E9LIKUZxwOWSG1l8lcODBGNBzI7NH6M7QfSzWPWLNq2Lgw
         IhEw==
X-Gm-Message-State: AGi0PuY9na0T4AnvTJpY0o2SkpvjJMoKxnOKE5KcVP49tkkqT1pY/ga0
        GsEDW9w8Gud5FrcxBB1rF5U7ZQ==
X-Google-Smtp-Source: APiQypJ9lhmlgi5PbLI3Ia4+q4YouJOhuN2AbjSX8A9OMK0E/D5AZg24FRtaKX79pzagH8HcG/UleQ==
X-Received: by 2002:a65:424b:: with SMTP id d11mr2245592pgq.17.1586484921064;
        Thu, 09 Apr 2020 19:15:21 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id e26sm388588pff.167.2020.04.09.19.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 19:15:20 -0700 (PDT)
Date:   Thu, 9 Apr 2020 19:15:28 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Nuno S? <nuno.sa@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Mark Brown <broonie@kernel.org>, linux-hwmon@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix dtc warnings on reg and ranges in
 examples
Message-ID: <20200410021528.GY20625@builder.lan>
References: <20200409202458.24509-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200409202458.24509-1-robh@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 09 Apr 13:24 PDT 2020, Rob Herring wrote:

> A recent update to dtc and changes to the default warnings introduced
> some new warnings in the DT binding examples:
> 
> Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.example.dts:23.13-61:
>  Warning (dma_ranges_format): /example-0/dram-controller@1c01000:dma-ranges: "dma-ranges" property has invalid length (12 bytes) (parent #address-cells == 1, child #address-cells == 2, #size-cells == 1)
> Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.example.dts:17.22-28.11:
>  Warning (unit_address_vs_reg): /example-0/fpga-axi@0: node has a unit name, but no reg or ranges property
> Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.example.dts:34.13-54:
>  Warning (dma_ranges_format): /example-0/memory-controller@2c00000:dma-ranges: "dma-ranges" property has invalid length (24 bytes) (parent #address-cells == 1, child #address-cells == 2, #size-cells == 2)
> Documentation/devicetree/bindings/mfd/st,stpmic1.example.dts:19.15-79.11:
>  Warning (unit_address_vs_reg): /example-0/i2c@0: node has a unit name, but no reg or ranges property
> Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dts:28.23-31.15:
>  Warning (unit_address_vs_reg): /example-0/mdio@37000000/switch@10: node has a unit name, but no reg or ranges property
> Documentation/devicetree/bindings/rng/brcm,bcm2835.example.dts:17.5-21.11:
>  Warning (unit_address_vs_reg): /example-0/rng: node has a reg or ranges property, but no unit name
> Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.example.dts:20.20-43.11:
>  Warning (unit_address_vs_reg): /example-0/soc@0: node has a unit name, but no reg or ranges property
> Documentation/devicetree/bindings/usb/ingenic,musb.example.dts:18.28-21.11:
>  Warning (unit_address_vs_reg): /example-0/usb-phy@0: node has a unit name, but no reg or ranges property
> 
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: "Nuno Sá" <nuno.sa@analog.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Ray Jui <rjui@broadcom.com>
> Cc: Scott Branden <sbranden@broadcom.com>
> Cc: bcm-kernel-feedback-list@broadcom.com
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-hwmon@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: linux-arm-msm@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-spi@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
> Will take this via the DT tree.
> 
> Rob
> 
>  .../arm/sunxi/allwinner,sun4i-a10-mbus.yaml   |  6 +++
>  .../bindings/hwmon/adi,axi-fan-control.yaml   |  2 +-
>  .../nvidia,tegra186-mc.yaml                   | 41 +++++++++++--------
>  .../devicetree/bindings/mfd/st,stpmic1.yaml   |  2 +-
>  .../bindings/net/qcom,ipq8064-mdio.yaml       |  1 +
>  .../devicetree/bindings/rng/brcm,bcm2835.yaml |  2 +-
>  .../bindings/spi/qcom,spi-qcom-qspi.yaml      |  2 +-
>  .../devicetree/bindings/usb/ingenic,musb.yaml |  2 +-
>  8 files changed, 35 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
> index aa0738b4d534..e713a6fe4cf7 100644
> --- a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
> +++ b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
> @@ -42,6 +42,10 @@ properties:
>      description:
>        See section 2.3.9 of the DeviceTree Specification.
>  
> +  '#address-cells': true
> +
> +  '#size-cells': true
> +
>  required:
>    - "#interconnect-cells"
>    - compatible
> @@ -59,6 +63,8 @@ examples:
>          compatible = "allwinner,sun5i-a13-mbus";
>          reg = <0x01c01000 0x1000>;
>          clocks = <&ccu CLK_MBUS>;
> +        #address-cells = <1>;
> +        #size-cells = <1>;
>          dma-ranges = <0x00000000 0x40000000 0x20000000>;
>          #interconnect-cells = <1>;
>      };
> diff --git a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> index 57a240d2d026..29bb2c778c59 100644
> --- a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> @@ -47,7 +47,7 @@ required:
>  
>  examples:
>    - |
> -    fpga_axi: fpga-axi@0 {
> +    fpga_axi: fpga-axi {
>              #address-cells = <0x2>;
>              #size-cells = <0x1>;
>  
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
> index 12516bd89cf9..611bda38d187 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
> @@ -97,30 +97,35 @@ examples:
>      #include <dt-bindings/clock/tegra186-clock.h>
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
> -    memory-controller@2c00000 {
> -        compatible = "nvidia,tegra186-mc";
> -        reg = <0x0 0x02c00000 0x0 0xb0000>;
> -        interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
> -
> +    bus {
>          #address-cells = <2>;
>          #size-cells = <2>;
>  
> -        ranges = <0x0 0x02c00000 0x02c00000 0x0 0xb0000>;
> +        memory-controller@2c00000 {
> +            compatible = "nvidia,tegra186-mc";
> +            reg = <0x0 0x02c00000 0x0 0xb0000>;
> +            interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
> +
> +            #address-cells = <2>;
> +            #size-cells = <2>;
> +
> +            ranges = <0x0 0x02c00000 0x0 0x02c00000 0x0 0xb0000>;
>  
> -        /*
> -         * Memory clients have access to all 40 bits that the memory
> -         * controller can address.
> -         */
> -        dma-ranges = <0x0 0x0 0x0 0x0 0x100 0x0>;
> +            /*
> +             * Memory clients have access to all 40 bits that the memory
> +             * controller can address.
> +             */
> +            dma-ranges = <0x0 0x0 0x0 0x0 0x100 0x0>;
>  
> -        external-memory-controller@2c60000 {
> -            compatible = "nvidia,tegra186-emc";
> -            reg = <0x0 0x02c60000 0x0 0x50000>;
> -            interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
> -            clocks = <&bpmp TEGRA186_CLK_EMC>;
> -            clock-names = "emc";
> +            external-memory-controller@2c60000 {
> +                compatible = "nvidia,tegra186-emc";
> +                reg = <0x0 0x02c60000 0x0 0x50000>;
> +                interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks = <&bpmp TEGRA186_CLK_EMC>;
> +                clock-names = "emc";
>  
> -            nvidia,bpmp = <&bpmp>;
> +                nvidia,bpmp = <&bpmp>;
> +            };
>          };
>      };
>  
> diff --git a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> index d9ad9260e348..f88d13d70441 100644
> --- a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> +++ b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> @@ -274,7 +274,7 @@ examples:
>    - |
>      #include <dt-bindings/mfd/st,stpmic1.h>
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
> -    i2c@0 {
> +    i2c {
>        #address-cells = <1>;
>        #size-cells = <0>;
>        pmic@33 {
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> index b9f90081046f..67df3fe861ee 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> @@ -48,6 +48,7 @@ examples:
>  
>          switch@10 {
>              compatible = "qca,qca8337";
> +            reg = <0x10>;
>              /* ... */
>          };
>      };
> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> index 89ab67f20a7f..c147900f9041 100644
> --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> @@ -39,7 +39,7 @@ additionalProperties: false
>  
>  examples:
>    - |
> -    rng {
> +    rng@7e104000 {
>          compatible = "brcm,bcm2835-rng";
>          reg = <0x7e104000 0x10>;
>          interrupts = <2 29>;
> diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
> index 0cf470eaf2a0..5c16cf59ca00 100644
> --- a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
> +++ b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
> @@ -61,7 +61,7 @@ examples:
>      #include <dt-bindings/clock/qcom,gcc-sdm845.h>
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
> -    soc: soc@0 {
> +    soc: soc {
>          #address-cells = <2>;
>          #size-cells = <2>;
>  
> diff --git a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> index 1d6877875077..c2d2ee43ba67 100644
> --- a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> +++ b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> @@ -56,7 +56,7 @@ additionalProperties: false
>  examples:
>    - |
>      #include <dt-bindings/clock/jz4740-cgu.h>
> -    usb_phy: usb-phy@0 {
> +    usb_phy: usb-phy {
>        compatible = "usb-nop-xceiv";
>        #phy-cells = <0>;
>      };
> -- 
> 2.20.1
> 
