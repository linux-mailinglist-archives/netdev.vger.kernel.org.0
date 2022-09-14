Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7805B84E8
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiINJZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiINJYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:24:42 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C675B7A2;
        Wed, 14 Sep 2022 02:14:50 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id f20-20020a9d7b54000000b006574e21f1b6so1383739oto.5;
        Wed, 14 Sep 2022 02:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=yHtslchOcjCr/mPzc6No9Ng0yS/x6URBWNqybFN6UX8=;
        b=lpFRvI14pZrA3nhxcP5Pytv8cwHN5jLKDCCTyeAGW7Ke6DjUsfY2X6KKpTUJvwt4Jj
         cDKlnKoiEmkVhPpepLGwd/5iJT1BVDyTFrBXPVGwdEFLw2YRnUxBkht0lOU7rvcc+TIN
         kEUj3fkVmF/IMBTBNiYV8ZdidCK79q9D4LdtxlhbQIqMSSe2JoowaHgHQChPGgiB2RTu
         dmPks9oOSYwWkWX3GRLAaB2kz7Y3hxKSZZJHRQInk4ew3ihE8I9cUCr3A8nhInKQS9YY
         OqT+/qFAHS8DPRx3WBIXqK54c4FPelsY4ifWjuxMwjIvSlSuEATk9roWavt72iWDcV6r
         kkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yHtslchOcjCr/mPzc6No9Ng0yS/x6URBWNqybFN6UX8=;
        b=7cmH9mWcIuG+yvVqnq4WV15KryU2QvBRFAY1TPv8BLh88Q8+hCaojNCDEUc2I1jUwp
         IVMQDjqh/8diGfnrUzwfQzDt+OJeZU3RhVwsKk2eJxqhTzYO1qdtC3OM50VzyCbhN/TR
         oXV0XDyQdgXepj1Vo/U0sCiUyhLL5k73t/yt6yK21+kVnrTci/eQrO1BDyGuFtrGds8j
         aE/++EnxpCjverOhezP1DGg4B7n/dRT6s8LeT3IiF7QTPwSwNtpwvE7RNKYnF31vDU/0
         gxiqLruyOhik3HVXAaGJTl2mT5MlWYb68fVIW99Xh6p2PJJmJtkLUG52zpW8PyFeHnvz
         zFUQ==
X-Gm-Message-State: ACgBeo3S36VVFb90ocrlJyF/YpHjywfGtyMmPS3x1ArKXznuL2kQwlPK
        ixHgR9bEYYmFFkI0Kn0lr6PN7gqYMWKMmM8+jKgSJgWHL+/cSs35
X-Google-Smtp-Source: AA6agR6bSUjbG85ucJC+q130oxkWDdbx3NlNWV+Lm2VEA+oAwqsTSs/izz/Nr1azE9VSB7RldC5hXoimcL+bqTwAJmE=
X-Received: by 2002:a9d:7550:0:b0:655:bcdc:f546 with SMTP id
 b16-20020a9d7550000000b00655bcdcf546mr8764477otl.304.1663146874070; Wed, 14
 Sep 2022 02:14:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-6-arinc.unal@arinc9.com>
In-Reply-To: <20220914085451.11723-6-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Wed, 14 Sep 2022 11:14:22 +0200
Message-ID: <CAMhs-H9pj+qEdOCEhkyCJPvbFonLuhgSHgL4L6kkhO3YRh52vw@mail.gmail.com>
Subject: Re: [PATCH 05/10] mips: dts: ralink: mt7621: fix some dtc warnings
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arinc,

On Wed, Sep 14, 2022 at 10:55 AM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arin=
c9.com> wrote:
>
> Fix the dtc warnings below.
>
> /cpus/cpu@0: failed to match any schema with compatible: ['mips,mips1004K=
c']
> /cpus/cpu@1: failed to match any schema with compatible: ['mips,mips1004K=
c']
> uartlite@c00: $nodename:0: 'uartlite@c00' does not match '^serial(@.*)?$'
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/serial/8250.yaml
> uartlite@c00: Unevaluated properties are not allowed ('clock-names' was u=
nexpected)
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/serial/8250.yaml
> sdhci@1e130000: $nodename:0: 'sdhci@1e130000' does not match '^mmc(@.*)?$=
'
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/mmc/mtk-sd.yaml
> sdhci@1e130000: Unevaluated properties are not allowed ('bus-width', 'cap=
-mmc-highspeed', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'vmmc-s=
upply', 'vqmmc-supply' were unexpected)
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/mmc/mtk-sd.yaml
> xhci@1e1c0000: $nodename:0: 'xhci@1e1c0000' does not match '^usb(@.*)?'
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/usb/mediatek,mtk-xhci.yaml
> xhci@1e1c0000: compatible: ['mediatek,mt8173-xhci'] is too short
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/usb/mediatek,mtk-xhci.yaml
> switch0@0: $nodename:0: 'switch0@0' does not match '^(ethernet-)?switch(@=
.*)?$'
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/net/dsa/mediatek,mt7530.yaml
> port@1: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>         From schema: /home/arinc9/.local/lib/python3.10/site-packages/dts=
chema/schemas/dt-core.yaml
> port@2: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>         From schema: /home/arinc9/.local/lib/python3.10/site-packages/dts=
chema/schemas/dt-core.yaml
> port@3: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>         From schema: /home/arinc9/.local/lib/python3.10/site-packages/dts=
chema/schemas/dt-core.yaml
>
> - Remove "mips,mips1004Kc" compatible string from the cpu nodes. This
> doesn't exist anywhere.
> - Change "memc: syscon@5000" to "memc: memory-controller@5000".
> - Change "uartlite: uartlite@c00" to "serial0: serial@c00" and remove the
> aliases node.
> - Remove "clock-names" from the serial0 node. The property doesn't exist =
on
> the 8250.yaml schema.
> - Change "sdhci: sdhci@1e130000" to "mmc: mmc@1e130000".
> - Change "xhci: xhci@1e1c0000" to "usb: usb@1e1c0000".
> - Add "mediatek,mtk-xhci" as the second compatible string on the usb node=
.
> - Change "switch0: switch0@0" to "switch0: switch@0"
> - Change "off" to "disabled" for disabled nodes.
>
> Remaining warnings are caused by the lack of json-schema documentation.
>
> /cpuintc: failed to match any schema with compatible: ['mti,cpu-interrupt=
-controller']
> /palmbus@1e000000/wdt@100: failed to match any schema with compatible: ['=
mediatek,mt7621-wdt']
> /palmbus@1e000000/i2c@900: failed to match any schema with compatible: ['=
mediatek,mt7621-i2c']
> /palmbus@1e000000/spi@b00: failed to match any schema with compatible: ['=
ralink,mt7621-spi']
> /ethernet@1e100000: failed to match any schema with compatible: ['mediate=
k,mt7621-eth']
>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts  |  2 +-
>  .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts  |  2 +-
>  arch/mips/boot/dts/ralink/mt7621.dtsi         | 32 +++++++------------
>  3 files changed, 14 insertions(+), 22 deletions(-)
>
> diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts b/arch/mi=
ps/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
> index 24eebc5a85b1..6ecb8165efe8 100644
> --- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
> +++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
> @@ -53,7 +53,7 @@ system {
>         };
>  };
>
> -&sdhci {
> +&mmc {
>         status =3D "okay";
>  };
>
> diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts b/arch/mi=
ps/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
> index 34006e667780..2e534ea5bab7 100644
> --- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
> +++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
> @@ -37,7 +37,7 @@ key-reset {
>         };
>  };
>
> -&sdhci {
> +&mmc {
>         status =3D "okay";
>  };
>
> diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/r=
alink/mt7621.dtsi
> index ee46ace0bcc1..9302bdc04510 100644
> --- a/arch/mips/boot/dts/ralink/mt7621.dtsi
> +++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
> @@ -15,13 +15,11 @@ cpus {
>
>                 cpu@0 {
>                         device_type =3D "cpu";
> -                       compatible =3D "mips,mips1004Kc";
>                         reg =3D <0>;
>                 };
>
>                 cpu@1 {
>                         device_type =3D "cpu";
> -                       compatible =3D "mips,mips1004Kc";
>                         reg =3D <1>;
>                 };
>         };

Instead of removing this, since compatible is correct here, I think a
cpus yaml file needs to be added to properly define mips CPU's but
compatible strings using all around the sources are a bit messy. Take
a look of how is this done for arm [0]

> @@ -33,11 +31,6 @@ cpuintc: cpuintc {
>                 compatible =3D "mti,cpu-interrupt-controller";
>         };
>
> -       aliases {
> -               serial0 =3D &uartlite;
> -       };
> -
> -
>         mmc_fixed_3v3: regulator-3v3 {
>                 compatible =3D "regulator-fixed";
>                 regulator-name =3D "mmc_power";
> @@ -110,17 +103,16 @@ i2c: i2c@900 {
>                         pinctrl-0 =3D <&i2c_pins>;
>                 };
>
> -               memc: syscon@5000 {
> +               memc: memory-controller@5000 {
>                         compatible =3D "mediatek,mt7621-memc", "syscon";
>                         reg =3D <0x5000 0x1000>;
>                 };
>

I think syscon nodes need to use 'syscon' in the node name, but I am
not 100% sure.

> -               uartlite: uartlite@c00 {
> +               serial0: serial@c00 {
>                         compatible =3D "ns16550a";
>                         reg =3D <0xc00 0x100>;
>
>                         clocks =3D <&sysc MT7621_CLK_UART1>;
> -                       clock-names =3D "uart1";
>
>                         interrupt-parent =3D <&gic>;
>                         interrupts =3D <GIC_SHARED 26 IRQ_TYPE_LEVEL_HIGH=
>;
> @@ -236,7 +228,7 @@ pinmux {
>                 };
>         };
>
> -       sdhci: sdhci@1e130000 {
> +       mmc: mmc@1e130000 {
>                 status =3D "disabled";
>
>                 compatible =3D "mediatek,mt7620-mmc";
> @@ -262,8 +254,8 @@ sdhci: sdhci@1e130000 {
>                 interrupts =3D <GIC_SHARED 20 IRQ_TYPE_LEVEL_HIGH>;
>         };
>
> -       xhci: xhci@1e1c0000 {
> -               compatible =3D "mediatek,mt8173-xhci";
> +       usb: usb@1e1c0000 {
> +               compatible =3D "mediatek,mt8173-xhci", "mediatek,mtk-xhci=
";
>                 reg =3D <0x1e1c0000 0x1000
>                        0x1e1d0700 0x0100>;
>                 reg-names =3D "mac", "ippc";
> @@ -338,7 +330,7 @@ fixed-link {
>                 gmac1: mac@1 {
>                         compatible =3D "mediatek,eth-mac";
>                         reg =3D <1>;
> -                       status =3D "off";
> +                       status =3D "disabled";
>                         phy-mode =3D "rgmii-rxid";
>                 };
>
> @@ -346,7 +338,7 @@ mdio: mdio-bus {
>                         #address-cells =3D <1>;
>                         #size-cells =3D <0>;
>
> -                       switch0: switch0@0 {
> +                       switch0: switch@0 {
>                                 compatible =3D "mediatek,mt7621";
>                                 reg =3D <0>;
>                                 mediatek,mcm;
> @@ -362,31 +354,31 @@ ports {
>                                         #size-cells =3D <0>;
>
>                                         port@0 {
> -                                               status =3D "off";
> +                                               status =3D "disabled";
>                                                 reg =3D <0>;
>                                                 label =3D "lan0";
>                                         };
>
>                                         port@1 {
> -                                               status =3D "off";
> +                                               status =3D "disabled";
>                                                 reg =3D <1>;
>                                                 label =3D "lan1";
>                                         };
>
>                                         port@2 {
> -                                               status =3D "off";
> +                                               status =3D "disabled";
>                                                 reg =3D <2>;
>                                                 label =3D "lan2";
>                                         };
>
>                                         port@3 {
> -                                               status =3D "off";
> +                                               status =3D "disabled";
>                                                 reg =3D <3>;
>                                                 label =3D "lan3";
>                                         };
>
>                                         port@4 {
> -                                               status =3D "off";
> +                                               status =3D "disabled";
>                                                 reg =3D <4>;
>                                                 label =3D "lan4";
>                                         };
> --
> 2.34.1
>

Best regards,
    Sergio Paracuellos

[0]: https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicet=
ree/bindings/arm/cpus.yaml
