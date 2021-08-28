Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EEE3FA2F3
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 03:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhH1BjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 21:39:09 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]:41573 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhH1BjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 21:39:05 -0400
Received: by mail-qk1-f176.google.com with SMTP id bk29so9186242qkb.8;
        Fri, 27 Aug 2021 18:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ua+fuqzEHppErfSy5gmk+2Gv9jQWnpiCWR2VKICzRo=;
        b=tGOvbyAtSTh5wW9w4UC6JayZvVlNObSnK/2SpvBUnP9Ivgg16siJ6aYxKnhlVwr8vz
         XLx/2HyDhTP9cxAfyunwT6WyuwpfzoD0L0YaQ9FPpwLCBL2Cvr7Ol/HchgSPlOxFt1RF
         TbX59ruftp7SFGoqV3nCs2N6ADMjFFxJe6zmhrKSU/JQfD+yQ/BbJ4o8xiijMLK69ixB
         zAOsI9PqbAAXtYyvqjzvs6mTklaXymZ5fgAyacNtdChN9017yoC+CGaYqWaqUoP2TciH
         MKvlmWZtII7fod+OUf9Pdg+tJTK1AUrtT7K4SYGCHLq5cwQ6wa/qMChfRq4BBy967u6g
         rjug==
X-Gm-Message-State: AOAM533rCJBY8NX+k0mwlWHBsGu+Gl3LXxzFi2sn3nGuIKQT+aUEwpTQ
        4FevEtbPjh/h7fou6bfaoB7Y4yL9ybayuw==
X-Google-Smtp-Source: ABdhPJxERZZre8rFjs86dwB2d83W3WY69ctkVgFH7lEF4f8TvTzgz5RPcyFBCHHcyglboDpUKG1WOA==
X-Received: by 2002:a05:620a:2012:: with SMTP id c18mr11780777qka.312.1630114694737;
        Fri, 27 Aug 2021 18:38:14 -0700 (PDT)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com. [209.85.219.42])
        by smtp.gmail.com with ESMTPSA id h13sm5649110qkk.67.2021.08.27.18.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 18:38:14 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id s16so3236679qvt.13;
        Fri, 27 Aug 2021 18:38:14 -0700 (PDT)
X-Received: by 2002:ad4:5bc4:: with SMTP id t4mr6002823qvt.37.1630114693818;
 Fri, 27 Aug 2021 18:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210827202722.2567687-1-vladimir.oltean@nxp.com> <20210827202722.2567687-2-vladimir.oltean@nxp.com>
In-Reply-To: <20210827202722.2567687-2-vladimir.oltean@nxp.com>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Fri, 27 Aug 2021 20:38:02 -0500
X-Gmail-Original-Message-ID: <CADRPPNQg052Nradvyoiw9Yqe4HiRtWs8-yna87R2VUwwH8GPeg@mail.gmail.com>
Message-ID: <CADRPPNQg052Nradvyoiw9Yqe4HiRtWs8-yna87R2VUwwH8GPeg@mail.gmail.com>
Subject: Re: [PATCH devicetree 2/2] arm64: dts: add device tree for the
 LX2160A on the NXP BlueBox3 board
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Wasim Khan <wasim.khan@nxp.com>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Kuldeep Singh <kuldeep.singh@nxp.com>,
        Florin Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Biwen Li <biwen.li@nxp.com>,
        Heinz Wrobel <Heinz.Wrobel@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 3:28 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> From: Wasim Khan <wasim.khan@nxp.com>
>
> The NXP BlueBox3 is a prototyping board for high-performance autonomous
> driving systems. It contains two Linux systems, on running on the
> LX2160A and the other on the S32G2 SoC. This patch adds the device tree
> support for the LX2160A SoC.
>
> In terms of networking from the LX2160A's perspective, there are:
>
> - 4 RJ45 10G ports using Aquantia copper PHYs which are attached
>   directly to DPAA2 ports on the LX2160A
>
> - 3 NXP SJA1110 automotive Ethernet switches. First two are managed by
>   the LX2160A (each switch has a host port towards a dpmac), the third
>   switch is managed by the S32G2. All 3 switches are interconnected
>   through on-board SERDES lanes. The cascade ports between the 2
>   switches managed by LX2160A form a DSA link, the cascade ports between
>   the LX2160A and the S32G2 domain form user ports (the "to_sw3" net
>   device).
>
> - 2 RJ45 1G ports using Atheros copper PHYs which are attached directly
>   to NXP SJA1110 switches
>
> - 12 automotive 100base-T1 single-pair Ethernet ports routed from the
>   SJA1110 internal PHY ports (TJA1103)
>
> - One SGMII SERDES lane towards an internal connector, attached to one
>   of the SJA1110 switch ports
>
> On board rev A, the AR8035 RGMII PHY addresses were different than on
> rev B and later. This patch introduces a separate device tree for rev A.
> The main device tree is supposed to cover rev B and later.
>
> Signed-off-by: Wasim Khan <wasim.khan@nxp.com>
> Co-developed-by: Vabhav Sharma <vabhav.sharma@nxp.com>
> Signed-off-by: Vabhav Sharma <vabhav.sharma@nxp.com>
> Co-developed-by: Kuldeep Singh <kuldeep.singh@nxp.com>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@nxp.com>
> Co-developed-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
> Signed-off-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
> Co-developed-by: Biwen Li <biwen.li@nxp.com>
> Signed-off-by: Biwen Li <biwen.li@nxp.com>
> Co-developed-by: Heinz Wrobel <Heinz.Wrobel@nxp.com>
> Signed-off-by: Heinz Wrobel <Heinz.Wrobel@nxp.com>
> Co-developed-by: Yangbo Lu <yangbo.lu@nxp.com>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Li Yang <leoyang.li@nxp.com>

> ---
>  arch/arm64/boot/dts/freescale/Makefile        |   2 +
>  .../freescale/fsl-lx2160a-bluebox3-rev-a.dts  |  34 +
>  .../dts/freescale/fsl-lx2160a-bluebox3.dts    | 658 ++++++++++++++++++
>  3 files changed, 694 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3-rev-a.dts
>  create mode 100644 arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
>
> diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
> index db9e36ebe932..ecf74464705f 100644
> --- a/arch/arm64/boot/dts/freescale/Makefile
> +++ b/arch/arm64/boot/dts/freescale/Makefile
> @@ -25,6 +25,8 @@ dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls2080a-rdb.dtb
>  dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls2080a-simu.dtb
>  dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls2088a-qds.dtb
>  dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls2088a-rdb.dtb
> +dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-bluebox3.dtb
> +dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-bluebox3-rev-a.dtb
>  dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-clearfog-cx.dtb
>  dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-honeycomb.dtb
>  dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2160a-qds.dtb
> diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3-rev-a.dts b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3-rev-a.dts
> new file mode 100644
> index 000000000000..15d273c93154
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3-rev-a.dts
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +//
> +// Device Tree file for LX2160A BLUEBOX3
> +//
> +// Copyright 2020-2021 NXP
> +
> +/dts-v1/;
> +
> +#include "fsl-lx2160a-bluebox3.dts"
> +
> +/ {
> +       compatible = "fsl,lx2160a-bluebox3-rev-a", "fsl,lx2160a";
> +};
> +
> +/* The RGMII PHYs have a different MDIO address */
> +&emdio1 {
> +       /delete-node/ ethernet-phy@5;
> +
> +       sw1_mii3_phy: ethernet-phy@1 {
> +               /* AR8035 */
> +               compatible = "ethernet-phy-id004d.d072";
> +               reg = <0x1>;
> +               interrupts-extended = <&extirq 6 IRQ_TYPE_LEVEL_LOW>;
> +       };
> +
> +       /delete-node/ ethernet-phy@6;
> +
> +       sw2_mii3_phy: ethernet-phy@2 {
> +               /* AR8035 */
> +               compatible = "ethernet-phy-id004d.d072";
> +               reg = <0x2>;
> +               interrupts-extended = <&extirq 7 IRQ_TYPE_LEVEL_LOW>;
> +       };
> +};
> diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
> new file mode 100644
> index 000000000000..be7d01630a6f
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
> @@ -0,0 +1,658 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +//
> +// Device Tree file for LX2160A BLUEBOX3
> +//
> +// Copyright 2020-2021 NXP
> +
> +/dts-v1/;
> +
> +#include "fsl-lx2160a.dtsi"
> +
> +/ {
> +       model = "NXP Layerscape LX2160ABLUEBOX3";
> +       compatible = "fsl,lx2160a-bluebox3", "fsl,lx2160a";
> +
> +       aliases {
> +               crypto = &crypto;
> +               serial0 = &uart0;
> +               mmc0 = &esdhc0;
> +               mmc1 = &esdhc1;
> +       };
> +
> +       chosen {
> +               stdout-path = "serial0:115200n8";
> +       };
> +
> +       sb_3v3: regulator-sb3v3 {
> +               compatible = "regulator-fixed";
> +               regulator-name = "MC34717-3.3VSB";
> +               regulator-min-microvolt = <3300000>;
> +               regulator-max-microvolt = <3300000>;
> +               regulator-boot-on;
> +               regulator-always-on;
> +       };
> +};
> +
> +&can0 {
> +       status = "okay";
> +
> +       can-transceiver {
> +               max-bitrate = <5000000>;
> +       };
> +};
> +
> +&can1 {
> +       status = "okay";
> +
> +       can-transceiver {
> +               max-bitrate = <5000000>;
> +       };
> +};
> +
> +&crypto {
> +       status = "okay";
> +};
> +
> +&dpmac5 {
> +       phy-handle = <&aqr113c_phy1>;
> +       phy-mode = "usxgmii";
> +       managed = "in-band-status";
> +};
> +
> +&dpmac6 {
> +       phy-handle = <&aqr113c_phy2>;
> +       phy-mode = "usxgmii";
> +       managed = "in-band-status";
> +};
> +
> +&dpmac9 {
> +       phy-handle = <&aqr113c_phy3>;
> +       phy-mode = "usxgmii";
> +       managed = "in-band-status";
> +};
> +
> +&dpmac10 {
> +       phy-handle = <&aqr113c_phy4>;
> +       phy-mode = "usxgmii";
> +       managed = "in-band-status";
> +};
> +
> +&dpmac17 {
> +       phy-mode = "rgmii";
> +       status = "okay";
> +
> +       fixed-link {
> +               speed = <1000>;
> +               full-duplex;
> +       };
> +};
> +
> +&dpmac18 {
> +       phy-mode = "rgmii";
> +       status = "okay";
> +
> +       fixed-link {
> +               speed = <1000>;
> +               full-duplex;
> +       };
> +};
> +
> +&emdio1 {
> +       status = "okay";
> +
> +       aqr113c_phy2: ethernet-phy@0 {
> +               compatible = "ethernet-phy-ieee802.3-c45";
> +               reg = <0x0>;
> +               /* IRQ_10G_PHY2 */
> +               interrupts-extended = <&extirq 3 IRQ_TYPE_LEVEL_LOW>;
> +       };
> +
> +       aqr113c_phy1: ethernet-phy@8 {
> +               compatible = "ethernet-phy-ieee802.3-c45";
> +               reg = <0x8>;
> +               /* IRQ_10G_PHY1 */
> +               interrupts-extended = <&extirq 2 IRQ_TYPE_LEVEL_LOW>;
> +       };
> +
> +       sw1_mii3_phy: ethernet-phy@5 {
> +               /* AR8035 */
> +               compatible = "ethernet-phy-id004d.d072";
> +               reg = <0x5>;
> +               interrupts-extended = <&extirq 6 IRQ_TYPE_LEVEL_LOW>;
> +       };
> +
> +       sw2_mii3_phy: ethernet-phy@6 {
> +               /* AR8035 */
> +               compatible = "ethernet-phy-id004d.d072";
> +               reg = <0x6>;
> +               interrupts-extended = <&extirq 7 IRQ_TYPE_LEVEL_LOW>;
> +       };
> +};
> +
> +&emdio2 {
> +       status = "okay";
> +
> +       aqr113c_phy4: ethernet-phy@0 {
> +               compatible = "ethernet-phy-ieee802.3-c45";
> +               reg = <0x0>;
> +               /* IRQ_10G_PHY4 */
> +               interrupts-extended = <&extirq 5 IRQ_TYPE_LEVEL_LOW>;
> +       };
> +
> +       aqr113c_phy3: ethernet-phy@8 {
> +               compatible = "ethernet-phy-ieee802.3-c45";
> +               reg = <0x8>;
> +               /* IRQ_10G_PHY3 */
> +               interrupts-extended = <&extirq 4 IRQ_TYPE_LEVEL_LOW>;
> +       };
> +};
> +
> +&esdhc0 {
> +       sd-uhs-sdr104;
> +       sd-uhs-sdr50;
> +       sd-uhs-sdr25;
> +       sd-uhs-sdr12;
> +       status = "okay";
> +};
> +
> +&esdhc1 {
> +       mmc-hs200-1_8v;
> +       mmc-hs400-1_8v;
> +       bus-width = <8>;
> +       status = "okay";
> +};
> +
> +&fspi {
> +       status = "okay";
> +
> +       mt35xu512aba0: flash@0 {
> +               compatible = "jedec,spi-nor";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               reg = <0>;
> +               m25p,fast-read;
> +               spi-max-frequency = <50000000>;
> +               spi-rx-bus-width = <8>;
> +               spi-tx-bus-width = <8>;
> +       };
> +
> +       mt35xu512aba1: flash@1 {
> +               compatible = "jedec,spi-nor";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               reg = <1>;
> +               m25p,fast-read;
> +               spi-max-frequency = <50000000>;
> +               spi-rx-bus-width = <8>;
> +               spi-tx-bus-width = <8>;
> +       };
> +};
> +
> +&i2c0 {
> +       status = "okay";
> +
> +       i2c-mux@77 {
> +               compatible = "nxp,pca9547";
> +               reg = <0x77>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               i2c@2 {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       reg = <0x2>;
> +
> +                       power-monitor@40 {
> +                               compatible = "ti,ina220";
> +                               reg = <0x40>;
> +                               shunt-resistor = <500>;
> +                       };
> +               };
> +
> +               i2c@3 {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       reg = <0x3>;
> +
> +                       temp2: temperature-sensor@48 {
> +                               compatible = "nxp,sa56004";
> +                               reg = <0x48>;
> +                               vcc-supply = <&sb_3v3>;
> +                               #thermal-sensor-cells = <1>;
> +                       };
> +
> +                       temp1: temperature-sensor@4c {
> +                               compatible = "nxp,sa56004";
> +                               reg = <0x4c>;
> +                               vcc-supply = <&sb_3v3>;
> +                               #thermal-sensor-cells = <1>;
> +                       };
> +               };
> +
> +               i2c@4 {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       reg = <0x4>;
> +
> +                       rtc@51 {
> +                               compatible = "nxp,pcf2129";
> +                               reg = <0x51>;
> +                               interrupts-extended = <&extirq 11 IRQ_TYPE_LEVEL_LOW>;
> +                       };
> +               };
> +
> +               i2c@7 {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       reg = <0x7>;
> +
> +                       i2c-mux@75 {
> +                               compatible = "nxp,pca9547";
> +                               reg = <0x75>;
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +
> +                               i2c@0 {
> +                                       #address-cells = <1>;
> +                                       #size-cells = <0>;
> +                                       reg = <0x0>;
> +
> +                                       spi_bridge: spi@28 {
> +                                               compatible = "nxp,sc18is602b";
> +                                               reg = <0x28>;
> +                                               #address-cells = <1>;
> +                                               #size-cells = <0>;
> +                                       };
> +                               };
> +                       };
> +               };
> +       };
> +};
> +
> +&i2c5 {
> +       status = "okay";
> +
> +       i2c-mux@77 {
> +               compatible = "nxp,pca9846";
> +               reg = <0x77>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               i2c@1 {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       reg = <0x1>;
> +
> +                       /* The I2C multiplexer and temperature sensors are on
> +                        * the T6 riser card.
> +                        */
> +                       i2c-mux@70 {
> +                               compatible = "nxp,pca9548";
> +                               reg = <0x70>;
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +
> +                               i2c@6 {
> +                                       #address-cells = <1>;
> +                                       #size-cells = <0>;
> +                                       reg = <0x6>;
> +
> +                                       q12: temperature-sensor@4c {
> +                                               compatible = "nxp,sa56004";
> +                                               reg = <0x4c>;
> +                                               vcc-supply = <&sb_3v3>;
> +                                               #thermal-sensor-cells = <1>;
> +                                       };
> +                               };
> +
> +                               i2c@7 {
> +                                       #address-cells = <1>;
> +                                       #size-cells = <0>;
> +                                       reg = <0x7>;
> +
> +                                       q11: temperature-sensor@4c {
> +                                               compatible = "nxp,sa56004";
> +                                               reg = <0x4c>;
> +                                               vcc-supply = <&sb_3v3>;
> +                                               #thermal-sensor-cells = <1>;
> +                                       };
> +
> +                                       q13: temperature-sensor@48 {
> +                                               compatible = "nxp,sa56004";
> +                                               reg = <0x48>;
> +                                               vcc-supply = <&sb_3v3>;
> +                                               #thermal-sensor-cells = <1>;
> +                                       };
> +
> +                                       q14: temperature-sensor@4a {
> +                                               compatible = "nxp,sa56004";
> +                                               reg = <0x4a>;
> +                                               vcc-supply = <&sb_3v3>;
> +                                               #thermal-sensor-cells = <1>;
> +                                       };
> +                               };
> +                       };
> +               };
> +       };
> +};
> +
> +&pcs_mdio5 {
> +       status = "okay";
> +};
> +
> +&pcs_mdio6 {
> +       status = "okay";
> +};
> +
> +&pcs_mdio9 {
> +       status = "okay";
> +};
> +
> +&pcs_mdio10 {
> +       status = "okay";
> +};
> +
> +&spi_bridge {
> +       sw1: ethernet-switch@0 {
> +               compatible = "nxp,sja1110a";
> +               reg = <0>;
> +               spi-max-frequency = <4000000>;
> +               spi-cpol;
> +               dsa,member = <0 0>;
> +
> +               ethernet-ports {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       /* Microcontroller port */
> +                       port@0 {
> +                               reg = <0>;
> +                               status = "disabled";
> +                       };
> +
> +                       /* SW1_P1 */
> +                       port@1 {
> +                               reg = <1>;
> +                               label = "con_2x20";
> +                               phy-mode = "sgmii";
> +
> +                               fixed-link {
> +                                       speed = <1000>;
> +                                       full-duplex;
> +                               };
> +                       };
> +
> +                       port@2 {
> +                               reg = <2>;
> +                               ethernet = <&dpmac17>;
> +                               phy-mode = "rgmii-id";
> +
> +                               fixed-link {
> +                                       speed = <1000>;
> +                                       full-duplex;
> +                               };
> +                       };
> +
> +                       port@3 {
> +                               reg = <3>;
> +                               label = "1ge_p1";
> +                               phy-mode = "rgmii-id";
> +                               phy-handle = <&sw1_mii3_phy>;
> +                       };
> +
> +                       sw1p4: port@4 {
> +                               reg = <4>;
> +                               link = <&sw2p1>;
> +                               phy-mode = "sgmii";
> +
> +                               fixed-link {
> +                                       speed = <1000>;
> +                                       full-duplex;
> +                               };
> +                       };
> +
> +                       port@5 {
> +                               reg = <5>;
> +                               label = "trx1";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw1_port5_base_t1_phy>;
> +                       };
> +
> +                       port@6 {
> +                               reg = <6>;
> +                               label = "trx2";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw1_port6_base_t1_phy>;
> +                       };
> +
> +                       port@7 {
> +                               reg = <7>;
> +                               label = "trx3";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw1_port7_base_t1_phy>;
> +                       };
> +
> +                       port@8 {
> +                               reg = <8>;
> +                               label = "trx4";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw1_port8_base_t1_phy>;
> +                       };
> +
> +                       port@9 {
> +                               reg = <9>;
> +                               label = "trx5";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw1_port9_base_t1_phy>;
> +                       };
> +
> +                       port@a {
> +                               reg = <10>;
> +                               label = "trx6";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw1_port10_base_t1_phy>;
> +                       };
> +               };
> +
> +               mdios {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       mdio@0 {
> +                               compatible = "nxp,sja1110-base-t1-mdio";
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +                               reg = <0>;
> +
> +                               sw1_port5_base_t1_phy: ethernet-phy@1 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x1>;
> +                               };
> +
> +                               sw1_port6_base_t1_phy: ethernet-phy@2 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x2>;
> +                               };
> +
> +                               sw1_port7_base_t1_phy: ethernet-phy@3 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x3>;
> +                               };
> +
> +                               sw1_port8_base_t1_phy: ethernet-phy@4 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x4>;
> +                               };
> +
> +                               sw1_port9_base_t1_phy: ethernet-phy@5 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x5>;
> +                               };
> +
> +                               sw1_port10_base_t1_phy: ethernet-phy@6 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x6>;
> +                               };
> +                       };
> +               };
> +       };
> +
> +       sw2: ethernet-switch@2 {
> +               compatible = "nxp,sja1110a";
> +               reg = <2>;
> +               spi-max-frequency = <4000000>;
> +               spi-cpol;
> +               dsa,member = <0 1>;
> +
> +               ethernet-ports {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       /* Microcontroller port */
> +                       port@0 {
> +                               reg = <0>;
> +                               status = "disabled";
> +                       };
> +
> +                       sw2p1: port@1 {
> +                               reg = <1>;
> +                               link = <&sw1p4>;
> +                               phy-mode = "sgmii";
> +
> +                               fixed-link {
> +                                       speed = <1000>;
> +                                       full-duplex;
> +                               };
> +                       };
> +
> +                       port@2 {
> +                               reg = <2>;
> +                               ethernet = <&dpmac18>;
> +                               phy-mode = "rgmii-id";
> +
> +                               fixed-link {
> +                                       speed = <1000>;
> +                                       full-duplex;
> +                               };
> +                       };
> +
> +                       port@3 {
> +                               reg = <3>;
> +                               label = "1ge_p2";
> +                               phy-mode = "rgmii-id";
> +                               phy-handle = <&sw2_mii3_phy>;
> +                       };
> +
> +                       port@4 {
> +                               reg = <4>;
> +                               label = "to_sw3";
> +                               phy-mode = "2500base-x";
> +
> +                               fixed-link {
> +                                       speed = <2500>;
> +                                       full-duplex;
> +                               };
> +                       };
> +
> +                       port@5 {
> +                               reg = <5>;
> +                               label = "trx7";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw2_port5_base_t1_phy>;
> +                       };
> +
> +                       port@6 {
> +                               reg = <6>;
> +                               label = "trx8";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw2_port6_base_t1_phy>;
> +                       };
> +
> +                       port@7 {
> +                               reg = <7>;
> +                               label = "trx9";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw2_port7_base_t1_phy>;
> +                       };
> +
> +                       port@8 {
> +                               reg = <8>;
> +                               label = "trx10";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw2_port8_base_t1_phy>;
> +                       };
> +
> +                       port@9 {
> +                               reg = <9>;
> +                               label = "trx11";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw2_port9_base_t1_phy>;
> +                       };
> +
> +                       port@a {
> +                               reg = <10>;
> +                               label = "trx12";
> +                               phy-mode = "internal";
> +                               phy-handle = <&sw2_port10_base_t1_phy>;
> +                       };
> +               };
> +
> +               mdios {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       mdio@0 {
> +                               compatible = "nxp,sja1110-base-t1-mdio";
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +                               reg = <0>;
> +
> +                               sw2_port5_base_t1_phy: ethernet-phy@1 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x1>;
> +                               };
> +
> +                               sw2_port6_base_t1_phy: ethernet-phy@2 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x2>;
> +                               };
> +
> +                               sw2_port7_base_t1_phy: ethernet-phy@3 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x3>;
> +                               };
> +
> +                               sw2_port8_base_t1_phy: ethernet-phy@4 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x4>;
> +                               };
> +
> +                               sw2_port9_base_t1_phy: ethernet-phy@5 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x5>;
> +                               };
> +
> +                               sw2_port10_base_t1_phy: ethernet-phy@6 {
> +                                       compatible = "ethernet-phy-ieee802.3-c45";
> +                                       reg = <0x6>;
> +                               };
> +                       };
> +               };
> +       };
> +};
> +
> +&uart0 {
> +       status = "okay";
> +};
> +
> +&uart1 {
> +       status = "okay";
> +};
> +
> +&usb0 {
> +       status = "okay";
> +};
> +
> +&usb1 {
> +       status = "okay";
> +};
> --
> 2.25.1
>
