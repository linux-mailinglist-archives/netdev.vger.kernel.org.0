Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5F3D00EC
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhGTRKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhGTRIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 13:08:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C8361004;
        Tue, 20 Jul 2021 17:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626803367;
        bh=rr5DyOF74U0H7iKb0m9zjXCsuqsP8q1pI+d5NX2axk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VEsgFDZvIXjcoaGpPEoA0Lu9YRxM0Dj90aWqsnbErQ2UUMNfFjiL3KKy2ihSuQKA8
         DpJfkpmYcVJtchYg4JZ0xVl4g2Mg2o7fCdXq98nn/PAwMTFoWJ250/salXXOhJJg55
         abW/iC3f5GUZpAEMSlUl/XMmPNxf0dbMFp9c17FIFUFh6aPXTQv17aO0FFf2m4m8ho
         FzpeQH9QYcsgshAwYqEOKnzQKiefkbesH4vObWgtP6wKthPFfdBb/jqahxbI+okmue
         fOLCT92FxMSaj5N+ZOIj1PAxbFu2Oagsxe6Rc6uhcjBjL97r/vUbkyUju8PW712k3f
         K0QVogmSx6JEw==
Date:   Tue, 20 Jul 2021 19:49:17 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Philipp Zabel <p.zabel@pengutronix.de>,
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
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples
Message-ID: <20210720194917.576b7d70@coco.lan>
In-Reply-To: <20210720172025.363238-1-robh@kernel.org>
References: <20210720172025.363238-1-robh@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 20 Jul 2021 11:20:25 -0600
Rob Herring <robh@kernel.org> escreveu:

> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).
> 
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

Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org> # For media


Thanks,
Mauro
