Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3518C6C227F
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjCTUXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjCTUWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:22:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA54034008;
        Mon, 20 Mar 2023 13:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7910ACE13E7;
        Mon, 20 Mar 2023 20:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E190CC4339C;
        Mon, 20 Mar 2023 20:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679343762;
        bh=DsQcH8xwycCkHIQ8QfvnCvZGiwQiVzM3IGKlFw3c6vs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=C0iv1Wn2Pa5vHsqdFDR6zw0f6xRpMK70/N1T2glolnKQ3YLIxVa9NLi/VD/MuIgDD
         AMlrJgSTLVgGIpOVJF1+Ghunoe4Mbsb67QPp53znrKW3xqS69cxFryb/04xLE/z2UL
         cYlidr2lmoh4xOWy5u90QTZdPEyL7HL6T0jBjSwd5lfJMMfoBUHFNLgIBWf0S+srxu
         QZQgZ6OIkcxVFR1EjRm8zUOSHLQaN3IU6e6CbVR9+h6qLlj6H177msFp2UNHRvKiJl
         8K9FZ0cUgUsllPY3vklbGfqakT/9Rif52mfARdFAsLbORk70Elf2bjYltEQCF1V5q6
         z2BOKHQPJU6XQ==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-544787916d9so244339317b3.13;
        Mon, 20 Mar 2023 13:22:42 -0700 (PDT)
X-Gm-Message-State: AO0yUKViLwnhnSTssDtvD243PVLOWIq9eYqLY0+Uc0eKx4e8fgxyNqRe
        xpJchmn/BgvPRbOhWHGE1YhIkIgoEbGhJLyk1w==
X-Google-Smtp-Source: AK7set9FJ+m1VwanpiAMfxA818L7HV/dPyhWg6DYQSadevXyKErLiGfJvZlidEnREDYwVbhCFXXRZvTZAhJh0VfOM4I=
X-Received: by 2002:a1f:28c4:0:b0:436:2fa4:e25d with SMTP id
 o187-20020a1f28c4000000b004362fa4e25dmr363729vko.3.1679343741554; Mon, 20 Mar
 2023 13:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230317233605.3967621-1-robh@kernel.org>
In-Reply-To: <20230317233605.3967621-1-robh@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 20 Mar 2023 15:22:10 -0500
X-Gmail-Original-Message-ID: <CAL_JsqK+Q5HS=0PqnA60gV43O7ymxhPH-WHKFJKpQMYe5KfEfg@mail.gmail.com>
Message-ID: <CAL_JsqK+Q5HS=0PqnA60gV43O7ymxhPH-WHKFJKpQMYe5KfEfg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: Drop unneeded quotes
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-aspeed@lists.ozlabs.org,
        linux-can@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 6:36=E2=80=AFPM Rob Herring <robh@kernel.org> wrote=
:
>
> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
> checking for this can be enabled in yamllint.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/net/actions,owl-emac.yaml  |  2 +-
>  .../bindings/net/allwinner,sun4i-a10-emac.yaml     |  2 +-
>  .../bindings/net/allwinner,sun4i-a10-mdio.yaml     |  2 +-
>  .../devicetree/bindings/net/altr,tse.yaml          |  2 +-
>  .../bindings/net/aspeed,ast2600-mdio.yaml          |  2 +-
>  .../devicetree/bindings/net/brcm,amac.yaml         |  2 +-
>  .../devicetree/bindings/net/brcm,systemport.yaml   |  2 +-
>  .../bindings/net/broadcom-bluetooth.yaml           |  2 +-
>  .../devicetree/bindings/net/can/xilinx,can.yaml    |  6 +++---
>  .../devicetree/bindings/net/dsa/brcm,sf2.yaml      |  2 +-
>  .../devicetree/bindings/net/dsa/qca8k.yaml         |  2 +-
>  .../devicetree/bindings/net/engleder,tsnep.yaml    |  2 +-
>  .../devicetree/bindings/net/ethernet-phy.yaml      |  2 +-
>  .../bindings/net/fsl,qoriq-mc-dpmac.yaml           |  2 +-
>  .../bindings/net/intel,ixp4xx-ethernet.yaml        |  8 ++++----
>  .../devicetree/bindings/net/intel,ixp4xx-hss.yaml  | 14 +++++++-------
>  .../devicetree/bindings/net/marvell,mvusb.yaml     |  2 +-
>  .../devicetree/bindings/net/mdio-gpio.yaml         |  2 +-
>  .../devicetree/bindings/net/mediatek,net.yaml      |  2 +-
>  .../bindings/net/mediatek,star-emac.yaml           |  2 +-
>  .../bindings/net/microchip,lan966x-switch.yaml     |  2 +-
>  .../bindings/net/microchip,sparx5-switch.yaml      |  4 ++--
>  .../devicetree/bindings/net/mscc,miim.yaml         |  2 +-
>  .../devicetree/bindings/net/nfc/marvell,nci.yaml   |  2 +-
>  .../devicetree/bindings/net/nfc/nxp,pn532.yaml     |  2 +-
>  .../bindings/net/pse-pd/podl-pse-regulator.yaml    |  2 +-
>  .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml |  2 +-
>  .../devicetree/bindings/net/qcom,ipq8064-mdio.yaml |  2 +-
>  .../devicetree/bindings/net/rockchip,emac.yaml     |  2 +-
>  .../devicetree/bindings/net/snps,dwmac.yaml        |  2 +-
>  .../devicetree/bindings/net/stm32-dwmac.yaml       |  4 ++--
>  .../devicetree/bindings/net/ti,cpsw-switch.yaml    | 10 +++++-----
>  .../devicetree/bindings/net/ti,davinci-mdio.yaml   |  2 +-
>  .../devicetree/bindings/net/ti,dp83822.yaml        |  2 +-
>  .../devicetree/bindings/net/ti,dp83867.yaml        |  2 +-
>  .../devicetree/bindings/net/ti,dp83869.yaml        |  2 +-
>  36 files changed, 53 insertions(+), 53 deletions(-)

Sending a v2 as there are a few more cases with $id and $schema quoted.

Rob
