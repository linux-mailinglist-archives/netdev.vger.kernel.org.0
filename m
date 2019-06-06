Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5045036916
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfFFBPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:15:15 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43378 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfFFBPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:15:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so710954edb.10;
        Wed, 05 Jun 2019 18:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LQqlBhHTmz8x0FhJ39lBoK4w2qCKDb/ThTtYwto9ACI=;
        b=g8Ri3zij5o7vM+S3/dBGE3ZjRAtRQRnXddtn8tC5NUdADPnKpR7i4AnHKp4S7l5dQs
         aoekfrtZGVXTAXwkm4Ij3eZmDcKAOoeaQixbPDNKHkLtApJEzBvTsNKfIKy9LVh7i/RE
         rCgPhWvjTO7yxxoKPCRuDEcmDkPoLB3N0HPwECiiB0sLkG/dIYn05icc1q0ItNqxQXq0
         GOYi7H/vYslYCH4qqyB53cUiWuNtb8XnfU6JauzXFcKQfsUJEKWgqPRNUTPUlQUEAir3
         602K1dAiml4FwbOHHbI01xXhLFgHQ7ofFL9ZzV7rr5fOOzk9vjB0y/GjksBIujPmT6Jm
         ju2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LQqlBhHTmz8x0FhJ39lBoK4w2qCKDb/ThTtYwto9ACI=;
        b=IzbUckydSVFMiGASjL3jsEy9oB4remh6uMu8paXNiD4Cx3ntZ65CTCeKnHZ/x+D5xY
         8FRgattC9QHOKK9pPVWdR94Uq/P8He13CLgWcRqaQdPVL+gLY59Bfiyv0rhMi3JPNpxe
         WiKIPukxPTm9mgaw1x2WG5xOnOAm1s5LTmOxXNOSAIYmvw9bsrY7SQZ6pWoeFLgTppyi
         ov7Ozjv0+lNqko+0FinqCSX6xFwL1DuSXxA7riKhXfjK9Khik/wbrjvzaWKoBOJ0+MWi
         TMw3ZRF5CsCJ5H3LmylzHKGzUZiCgwkuVIBFXQ41hGSDztMuOxFuzWa7QH4GQ9Zvl52f
         KDDg==
X-Gm-Message-State: APjAAAURHoiuMt+UfXEe9N7NJKUegB3pkEgv15QF4XBVYKB8ffJkY3Lf
        dDe3S4j25nXInXU4EydnyVZFjMl6rF2IoxY3P4s=
X-Google-Smtp-Source: APXvYqy2f8KwfmdxXdh1l6viqoO3HclEr1IG+M3FHJZqFBvsaZcsHyHPdwTKzWU0EeXu5e3EAhW6muJmxSZTxALBjIk=
X-Received: by 2002:a17:906:6552:: with SMTP id u18mr5857012ejn.300.1559783711809;
 Wed, 05 Jun 2019 18:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190529221222.19276-1-olteanv@gmail.com> <20190606010429.GP29853@dragon>
In-Reply-To: <20190606010429.GP29853@dragon>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 6 Jun 2019 04:15:00 +0300
Message-ID: <CA+h21hr1ykigbEhVuqMMgcxNaiqDhiNuZiNURwHqOwEooU6jDQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: dts: Introduce the NXP LS1021A-TSN board
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 at 04:04, Shawn Guo <shawnguo@kernel.org> wrote:
>
> On Thu, May 30, 2019 at 01:12:22AM +0300, Vladimir Oltean wrote:
> > The LS1021A-TSN is a development board built by VVDN/Argonboards in
> > partnership with NXP.
> >
> > It features the LS1021A SoC and the first-generation SJA1105T Ethernet
> > switch for prototyping implementations of a subset of IEEE 802.1 TSN
> > standards.
> >
> > It has two regular Ethernet ports and four switched, TSN-capable ports.
> >
> > It also features:
> > - One Arduino header
> > - One expansion header
> > - Two USB 3.0 ports
> > - One mini PCIe slot
> > - One SATA interface
> > - Accelerometer, gyroscope, temperature sensors
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> > Changes from v1:
> > - Applied Shawn's feedback
> > - Introduced QSPI flash node
> >
> > v1 patch available at:
> > https://patchwork.kernel.org/patch/10930451/
> >
> >  arch/arm/boot/dts/Makefile        |   1 +
> >  arch/arm/boot/dts/ls1021a-tsn.dts | 288 ++++++++++++++++++++++++++++++
> >  2 files changed, 289 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/ls1021a-tsn.dts
> >
> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > index dab2914fa293..a4eb4ca5e148 100644
> > --- a/arch/arm/boot/dts/Makefile
> > +++ b/arch/arm/boot/dts/Makefile
> > @@ -602,6 +602,7 @@ dtb-$(CONFIG_SOC_IMX7ULP) += \
> >  dtb-$(CONFIG_SOC_LS1021A) += \
> >       ls1021a-moxa-uc-8410a.dtb \
> >       ls1021a-qds.dtb \
> > +     ls1021a-tsn.dtb \
> >       ls1021a-twr.dtb
> >  dtb-$(CONFIG_SOC_VF610) += \
> >       vf500-colibri-eval-v3.dtb \
> > diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
> > new file mode 100644
> > index 000000000000..b05774eac92e
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/ls1021a-tsn.dts
> > @@ -0,0 +1,288 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright 2016-2018 NXP Semiconductors
> > + * Copyright 2019 Vladimir Oltean <olteanv@gmail.com>
> > + */
> > +
> > +/dts-v1/;
> > +#include "ls1021a.dtsi"
> > +
> > +/ {
> > +     model = "NXP LS1021A-TSN Board";
> > +
> > +     sys_mclk: clock-mclk {
> > +             compatible = "fixed-clock";
> > +             #clock-cells = <0>;
> > +             clock-frequency = <24576000>;
> > +     };
> > +
> > +     reg_vdda_codec: regulator-3V3 {
> > +             compatible = "regulator-fixed";
> > +             regulator-name = "3P3V";
> > +             regulator-min-microvolt = <3300000>;
> > +             regulator-max-microvolt = <3300000>;
> > +             regulator-always-on;
> > +     };
> > +
> > +     reg_vddio_codec: regulator-2V5 {
> > +             compatible = "regulator-fixed";
> > +             regulator-name = "2P5V";
> > +             regulator-min-microvolt = <2500000>;
> > +             regulator-max-microvolt = <2500000>;
> > +             regulator-always-on;
> > +     };
> > +};
> > +
> > +&enet0 {
> > +     tbi-handle = <&tbi0>;
> > +     phy-handle = <&sgmii_phy2>;
> > +     phy-mode = "sgmii";
> > +     status = "okay";
> > +};
> > +
> > +&enet1 {
> > +     tbi-handle = <&tbi1>;
> > +     phy-handle = <&sgmii_phy1>;
> > +     phy-mode = "sgmii";
> > +     status = "okay";
> > +};
> > +
> > +/* RGMII delays added via PCB traces */
> > +&enet2 {
> > +     phy-mode = "rgmii";
> > +     status = "okay";
> > +
> > +     fixed-link {
> > +             speed = <1000>;
> > +             full-duplex;
> > +     };
> > +};
> > +
> > +&dspi0 {
> > +     bus-num = <0>;
> > +     status = "okay";
> > +
> > +     /* ADG704BRMZ 1:4 mux/demux */
> > +     sja1105: ethernet-switch@1 {
> > +             reg = <0x1>;
> > +             #address-cells = <1>;
> > +             #size-cells = <0>;
> > +             compatible = "nxp,sja1105t";
> > +             /* 12 MHz */
> > +             spi-max-frequency = <12000000>;
> > +             /* Sample data on trailing clock edge */
> > +             spi-cpha;
> > +             fsl,spi-cs-sck-delay = <1000>;
> > +             fsl,spi-sck-cs-delay = <1000>;
> > +
> > +             ports {
> > +                     #address-cells = <1>;
> > +                     #size-cells = <0>;
> > +
> > +                     port@0 {
> > +                             /* ETH5 written on chassis */
> > +                             label = "swp5";
> > +                             phy-handle = <&rgmii_phy6>;
> > +                             phy-mode = "rgmii-id";
> > +                             reg = <0>;
> > +                     };
> > +
> > +                     port@1 {
> > +                             /* ETH2 written on chassis */
> > +                             label = "swp2";
> > +                             phy-handle = <&rgmii_phy3>;
> > +                             phy-mode = "rgmii-id";
> > +                             reg = <1>;
> > +                     };
> > +
> > +                     port@2 {
> > +                             /* ETH3 written on chassis */
> > +                             label = "swp3";
> > +                             phy-handle = <&rgmii_phy4>;
> > +                             phy-mode = "rgmii-id";
> > +                             reg = <2>;
> > +                     };
> > +
> > +                     port@3 {
> > +                             /* ETH4 written on chassis */
> > +                             label = "swp4";
> > +                             phy-handle = <&rgmii_phy5>;
> > +                             phy-mode = "rgmii-id";
> > +                             reg = <3>;
> > +                     };
> > +
> > +                     port@4 {
> > +                             /* Internal port connected to eth2 */
> > +                             ethernet = <&enet2>;
> > +                             phy-mode = "rgmii";
> > +                             reg = <4>;
> > +
> > +                             fixed-link {
> > +                                     speed = <1000>;
> > +                                     full-duplex;
> > +                             };
> > +                     };
> > +             };
> > +     };
> > +};
> > +
> > +&mdio0 {
> > +     /* AR8031 */
> > +     sgmii_phy1: ethernet-phy@1 {
> > +             reg = <0x1>;
> > +     };
> > +
> > +     /* AR8031 */
> > +     sgmii_phy2: ethernet-phy@2 {
> > +             reg = <0x2>;
> > +     };
> > +
> > +     /* BCM5464 quad PHY */
> > +     rgmii_phy3: ethernet-phy@3 {
> > +             reg = <0x3>;
> > +     };
> > +
> > +     rgmii_phy4: ethernet-phy@4 {
> > +             reg = <0x4>;
> > +     };
> > +
> > +     rgmii_phy5: ethernet-phy@5 {
> > +             reg = <0x5>;
> > +     };
> > +
> > +     rgmii_phy6: ethernet-phy@6 {
> > +             reg = <0x6>;
> > +     };
> > +
> > +     /* SGMII PCS for enet0 */
> > +     tbi0: tbi-phy@1f {
> > +             reg = <0x1f>;
> > +             device_type = "tbi-phy";
> > +     };
> > +};
> > +
> > +&mdio1 {
> > +     /* SGMII PCS for enet1 */
> > +     tbi1: tbi-phy@1f {
> > +             reg = <0x1f>;
> > +             device_type = "tbi-phy";
> > +     };
> > +};
> > +
> > +&i2c0 {
> > +     status = "okay";
> > +
> > +     /* 3 axis accelerometer */
> > +     accelerometer@1e {
> > +             compatible = "fsl,fxls8471";
> > +             position = <0>;
> > +             reg = <0x1e>;
> > +     };
> > +
> > +     /* Audio codec (SAI2) */
> > +     codec@2a {
>
> audio-codec for node name.
>
> > +             compatible = "fsl,sgtl5000";
> > +             VDDIO-supply = <&reg_vddio_codec>;
> > +             VDDA-supply = <&reg_vdda_codec>;
> > +             #sound-dai-cells = <0>;
> > +             clocks = <&sys_mclk>;
> > +             reg = <0x2a>;
> > +     };
> > +
> > +     /* Current sensing circuit for 1V VDDCORE PMIC rail */
> > +     current-sensor@44 {
> > +             compatible = "ti,ina220";
> > +             shunt-resistor = <1000>;
> > +             reg = <0x44>;
> > +     };
> > +
> > +     /* Current sensing circuit for 12V VCC rail */
> > +     current-sensor@45 {
> > +             compatible = "ti,ina220";
> > +             shunt-resistor = <1000>;
> > +             reg = <0x45>;
> > +     };
> > +
> > +     /* Thermal monitor - case */
> > +     temperature-sensor@48 {
> > +             compatible = "national,lm75";
> > +             reg = <0x48>;
> > +     };
> > +
> > +     /* Thermal monitor - chip */
> > +     temperature-sensor@4c {
> > +             compatible = "ti,tmp451";
> > +             reg = <0x4c>;
> > +     };
> > +
> > +     eeprom@51 {
> > +             compatible = "atmel,24c32";
> > +             reg = <0x51>;
> > +     };
> > +
> > +     /* Unsupported devices:
> > +      * - FXAS21002C Gyroscope at 0x20
> > +      * - TI ADS7924 4-channel ADC at 0x49
> > +      */
> > +};
> > +
> > +&qspi {
> > +     status = "okay";
> > +
> > +     flash@0 {
> > +             /* Rev. A uses 64MB flash, Rev. B & C use 32MB flash */
> > +             compatible = "jedec,spi-nor", "s25fl256s1", "s25fl512s";
> > +             spi-max-frequency = <20000000>;
> > +             #address-cells = <1>;
> > +             #size-cells = <1>;
> > +             reg = <0>;
> > +
> > +             partitions {
> > +                     compatible = "fixed-partitions";
> > +                     #address-cells = <1>;
> > +                     #size-cells = <1>;
> > +
> > +                     partition@0 {
> > +                             label = "RCW";
> > +                             reg = <0x0 0x40000>;
> > +                     };
> > +
> > +                     partition@40000 {
> > +                             label = "U-Boot";
> > +                             reg = <0x40000 0x300000>;
> > +                     };
> > +
> > +                     partition@340000 {
> > +                             label = "U-Boot Env";
> > +                             reg = <0x340000 0x100000>;
> > +                     };
> > +             };
> > +     };
> > +};
> > +
> > +&ifc {
>
> Please sort all these labelling nodes alphabetically.
>

Hi Shawn,

It's not entirely clear to me which nodes you mean.

Regards,
-Vladimir

> Shawn
>
> > +     status = "disabled";
> > +};
> > +
> > +&esdhc {
> > +     status = "okay";
> > +};
> > +
> > +&uart0 {
> > +     status = "okay";
> > +};
> > +
> > +&lpuart0 {
> > +     status = "okay";
> > +};
> > +
> > +&lpuart3 {
> > +     status = "okay";
> > +};
> > +
> > +&sai2 {
> > +     status = "okay";
> > +};
> > +
> > +&sata {
> > +     status = "okay";
> > +};
> > --
> > 2.17.1
> >
