Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43133D0ADC
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 10:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhGUIHG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Jul 2021 04:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbhGUHxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 03:53:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB069C061767
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 01:33:46 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m67f8-0007Mj-OA; Wed, 21 Jul 2021 10:33:06 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m67f0-0007mW-Ha; Wed, 21 Jul 2021 10:32:58 +0200
Message-ID: <8343dfe9d1af1ad4ab806104b74a95819c765dea.camel@pengutronix.de>
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ramesh Shanmugasundaram <rashanmu@gmail.com>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        Dilip Kota <eswara.kota@linux.intel.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Olivier Moysan <olivier.moysan@st.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        alsa-devel@alsa-project.org
Date:   Wed, 21 Jul 2021 10:32:58 +0200
In-Reply-To: <20210720172025.363238-1-robh@kernel.org>
References: <20210720172025.363238-1-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Tue, 2021-07-20 at 11:20 -0600, Rob Herring wrote:
> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).

Is this documented somewhere? If not, should it be? (Maybe in writing-
schema.rst -> Schema Contents -> examples?)
 
> Enabling qca,ar71xx causes a warning, so let's fix the node names:
> 
> Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: phy@3: '#phy-cells' is a required property
>         From schema: schemas/phy/phy-provider.yaml
> 
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Rui Miguel Silva <rmfrfs@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Robert Marko <robert.marko@sartura.hr>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Ramesh Shanmugasundaram <rashanmu@gmail.com>
> Cc: "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: ChiYuan Huang <cy_huang@richtek.com>
> Cc: Wei Xu <xuwei5@hisilicon.com>
> Cc: Dilip Kota <eswara.kota@linux.intel.com>
> Cc: Karol Gugala <kgugala@antmicro.com>
> Cc: Mateusz Holenko <mholenko@antmicro.com>
> Cc: Olivier Moysan <olivier.moysan@st.com>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-rtc@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../display/allwinner,sun8i-a83t-dw-hdmi.yaml |  2 --
>  .../display/panel/boe,tv101wum-nl6.yaml       |  1 -
>  .../bindings/media/nxp,imx7-mipi-csi2.yaml    |  2 --
>  .../bindings/media/renesas,drif.yaml          |  1 -
>  .../bindings/net/intel,dwmac-plat.yaml        |  2 --
>  .../bindings/net/intel,ixp4xx-ethernet.yaml   |  2 --
>  .../bindings/net/nfc/samsung,s3fwrn5.yaml     |  3 ---
>  .../devicetree/bindings/net/qca,ar71xx.yaml   | 25 ++++---------------
>  .../regulator/richtek,rt6245-regulator.yaml   |  1 -
>  .../regulator/vqmmc-ipq4019-regulator.yaml    |  1 -
>  .../reset/hisilicon,hi3660-reset.yaml         |  1 -
>  .../bindings/reset/intel,rcu-gw.yaml          |  1 -
[...]

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
