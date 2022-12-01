Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7931863E9AC
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLAGOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLAGO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:14:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F10A6B65
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 22:14:27 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p0cot-0005vD-4h; Thu, 01 Dec 2022 07:13:15 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p0coe-0002BZ-Us; Thu, 01 Dec 2022 07:13:00 +0100
Date:   Thu, 1 Dec 2022 07:13:00 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        soc@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Stefan Agner <stefan@agner.ch>,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tim Harvey <tharvey@gateworks.com>,
        Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-rockchip@lists.infradead.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/5] dt-bindings: net: qca,ar71xx: remove label = "cpu"
 from examples
Message-ID: <20221201061300.GD19642@pengutronix.de>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <20221130141040.32447-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221130141040.32447-2-arinc.unal@arinc9.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 05:10:36PM +0300, Arınç ÜNAL wrote:
> This is not used by the DSA dt-binding, so remove it from the examples.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thx!

> ---
>  Documentation/devicetree/bindings/net/qca,ar71xx.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
> index 1ebf9e8c8a1d..89f94b31b546 100644
> --- a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
> +++ b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
> @@ -123,7 +123,6 @@ examples:
>  
>                      switch_port0: port@0 {
>                          reg = <0x0>;
> -                        label = "cpu";
>                          ethernet = <&eth1>;
>  
>                          phy-mode = "gmii";
> -- 
> 2.34.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
