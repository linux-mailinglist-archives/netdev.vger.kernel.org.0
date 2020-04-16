Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936F71ABCA0
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391109AbgDPJQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441116AbgDPIHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 04:07:15 -0400
Received: from localhost (unknown [223.235.195.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F85206E9;
        Thu, 16 Apr 2020 08:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587024434;
        bh=6kwbxJH2RDveXqsZesbfmy1W3FzqE56YVY6CxJmBpFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O1d6NWlKFfnyKMYlp3FSfoZyP6WL58llnMOPAcukWE4NK15IAgUmTc9Oy1CJfBrQJ
         FzFh77ntmk81ok6QNhBa7Fsxt0mRWxySPBmmQLISyBFjZXKruM2zAQoNUgGwtCZMXr
         hATzQxclu6p7VFesf/GI28sOVbjEiU4zdOe4G2WA=
Date:   Thu, 16 Apr 2020 13:37:10 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: Clean-up schema indentation formatting
Message-ID: <20200416080710.GI72691@vkoul-mobl>
References: <20200416005549.9683-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416005549.9683-1-robh@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15-04-20, 19:55, Rob Herring wrote:
> Fix various inconsistencies in schema indentation. Most of these are
> list indentation which should be 2 spaces more than the start of the
> enclosing keyword. This doesn't matter functionally, but affects running
> scripts which do transforms on the schema files.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/arm/altera.yaml       |  6 +-
>  .../amlogic/amlogic,meson-gx-ao-secure.yaml   |  2 +-
>  .../devicetree/bindings/arm/bitmain.yaml      |  2 +-
>  .../devicetree/bindings/arm/nxp/lpc32xx.yaml  |  9 ++-
>  .../bindings/arm/socionext/uniphier.yaml      | 26 ++++----
>  .../bindings/arm/stm32/st,mlahb.yaml          |  2 +-
>  .../bindings/arm/stm32/st,stm32-syscon.yaml   |  6 +-
>  .../bindings/ata/faraday,ftide010.yaml        |  4 +-
>  .../bindings/bus/allwinner,sun8i-a23-rsb.yaml |  4 +-
>  .../clock/allwinner,sun4i-a10-gates-clk.yaml  |  8 +--
>  .../devicetree/bindings/clock/fsl,plldig.yaml | 17 +++--
>  .../devicetree/bindings/clock/qcom,mmcc.yaml  | 16 ++---
>  .../bindings/connector/usb-connector.yaml     |  6 +-
>  .../crypto/allwinner,sun4i-a10-crypto.yaml    | 14 ++--
>  .../bindings/crypto/allwinner,sun8i-ce.yaml   | 16 ++---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   |  2 +-
>  .../display/allwinner,sun4i-a10-hdmi.yaml     | 40 ++++++------
>  .../display/allwinner,sun4i-a10-tcon.yaml     | 58 ++++++++---------
>  .../display/allwinner,sun6i-a31-mipi-dsi.yaml | 28 ++++----
>  .../display/allwinner,sun8i-a83t-dw-hdmi.yaml | 10 +--
>  .../bindings/display/bridge/lvds-codec.yaml   | 18 +++---
>  .../display/panel/sony,acx424akp.yaml         |  2 +-
>  .../display/panel/xinpeng,xpp055c272.yaml     |  4 +-
>  .../bindings/display/renesas,cmm.yaml         | 16 ++---
>  .../devicetree/bindings/dma/ti/k3-udma.yaml   |  8 +--

Acked-By: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
