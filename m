Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62E53D4218
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhGWUiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:38:06 -0400
Received: from mail-il1-f178.google.com ([209.85.166.178]:46623 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWUiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 16:38:05 -0400
Received: by mail-il1-f178.google.com with SMTP id r5so2730879ilc.13;
        Fri, 23 Jul 2021 14:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CKG+SIFOLcCaYKwd2tEvLAZD7WaQ/IHSvWAesLjHfew=;
        b=CEaUDY2BFU+hC09pvJQc9Q3JSElps/2BDAddKB3n/wvQoZmIA5qafBEzQoijFBACWL
         RhX8paZvh6TUHiXsLB58OoHVJ/GgIRrBTGe66agHPjDq0lk7taUMf4ZqaHEiq4+5ODrT
         9ouT5GAgm8qBVoYIKPhijY6G6eXDKH2yAZNotsLDhcw732euBHW2N9ABJHV3Nc/HgPOa
         0XAmsOqpUJzVuWb0BtWz/EWDgxwqKZ0AM5NrLLa8BIScAXWJ1LOxCzpWIsYzhsa8kmlL
         PlcPGoKhlkkvq5yurcwGfL0/hRk1RtnrsqMkGDBPMB+oOTb21Cgx3l36Uj0zMvNNUWno
         H2OA==
X-Gm-Message-State: AOAM530uR/cpOrMT1K1NElOeB536K5QIAmmFHExv742BFTCn41Gqc0FL
        0/p32M+Ykk8Bc0IQlH5fRw==
X-Google-Smtp-Source: ABdhPJyOIbF9rq5B3bw9Tx2y/wvm92OqGc0Be5P5cyYWmK3oh5EqS+J3TTa94Os0/ICItRZB++DE4A==
X-Received: by 2002:a05:6e02:190d:: with SMTP id w13mr4883804ilu.53.1627075117897;
        Fri, 23 Jul 2021 14:18:37 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id l11sm19496837ios.8.2021.07.23.14.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:18:37 -0700 (PDT)
Received: (nullmailer pid 2602448 invoked by uid 1000);
        Fri, 23 Jul 2021 21:18:32 -0000
Date:   Fri, 23 Jul 2021 15:18:32 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wei Xu <xuwei5@hisilicon.com>,
        Dilip Kota <eswara.kota@linux.intel.com>,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Karol Gugala <kgugala@antmicro.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-rtc@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ramesh Shanmugasundaram <rashanmu@gmail.com>,
        alsa-devel@alsa-project.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Olivier Moysan <olivier.moysan@st.com>
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples
Message-ID: <20210723211832.GA2602340@robh.at.kernel.org>
References: <20210720172025.363238-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720172025.363238-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Jul 2021 11:20:25 -0600, Rob Herring wrote:
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
>  .../bindings/net/intel,dwmac-plat.yaml        |  2 --
>  .../bindings/net/intel,ixp4xx-ethernet.yaml   |  2 --
>  .../bindings/net/nfc/samsung,s3fwrn5.yaml     |  3 ---
>  .../devicetree/bindings/net/qca,ar71xx.yaml   | 25 ++++---------------
>  .../regulator/richtek,rt6245-regulator.yaml   |  1 -
>  .../regulator/vqmmc-ipq4019-regulator.yaml    |  1 -
>  .../reset/hisilicon,hi3660-reset.yaml         |  1 -
>  .../bindings/reset/intel,rcu-gw.yaml          |  1 -
>  .../bindings/rtc/microcrystal,rv3032.yaml     |  1 -
>  .../soc/litex/litex,soc-controller.yaml       |  1 -
>  .../bindings/sound/st,stm32-sai.yaml          |  2 --
>  .../bindings/sound/ti,j721e-cpb-audio.yaml    |  2 --
>  .../sound/ti,j721e-cpb-ivi-audio.yaml         |  2 --
>  17 files changed, 5 insertions(+), 45 deletions(-)
> 

Applied, thanks!
