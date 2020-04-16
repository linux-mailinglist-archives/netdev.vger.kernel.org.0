Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667981AC1A1
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 14:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636163AbgDPMom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 08:44:42 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:33886 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2636077AbgDPMoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 08:44:17 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 924AA80487;
        Thu, 16 Apr 2020 14:44:00 +0200 (CEST)
Date:   Thu, 16 Apr 2020 14:43:59 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
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
Message-ID: <20200416124359.GB5785@ravnborg.org>
References: <20200416005549.9683-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416005549.9683-1-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=XpTUx2N9 c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10
        a=xJWM5Xtqm7-vkBAKM1YA:9 a=bxeknKLoBf6BnO7k:21 a=StjP_oZuoJ7ca4eH:21
        a=CjuIK1q_8ugA:10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob.

On Wed, Apr 15, 2020 at 07:55:48PM -0500, Rob Herring wrote:
> Fix various inconsistencies in schema indentation. Most of these are
> list indentation which should be 2 spaces more than the start of the
> enclosing keyword. This doesn't matter functionally, but affects running
> scripts which do transforms on the schema files.

Are there any plans to improve the tooling so we get warnigns for this?
Otherwise I am afraid we will see a lot of patches that gets this wrong.

As a follow-up patch it would be good if example-schema.yaml
could gain some comments about the correct indentions.

Some comments in the following.

> diff --git a/Documentation/devicetree/bindings/arm/altera.yaml b/Documentation/devicetree/bindings/arm/altera.yaml
> index 49e0362ddc11..b388c5aa7984 100644
> --- a/Documentation/devicetree/bindings/arm/altera.yaml
> +++ b/Documentation/devicetree/bindings/arm/altera.yaml
> @@ -13,8 +13,8 @@ properties:
>    compatible:
>      items:
>        - enum:
> -        - altr,socfpga-cyclone5
> -        - altr,socfpga-arria5
> -        - altr,socfpga-arria10
> +          - altr,socfpga-cyclone5
> +          - altr,socfpga-arria5
> +          - altr,socfpga-arria10
>        - const: altr,socfpga

So here "- enum" do not need the extra indent.
Is it because this is not a list?

>  ...
> diff --git a/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml b/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
> index 66213bd95e6e..6cc74523ebfd 100644
> --- a/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
> +++ b/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
> @@ -25,7 +25,7 @@ select:
> 
>  properties:
>    compatible:
> -   items:
> +    items:
>        - const: amlogic,meson-gx-ao-secure
>        - const: syscon

This is something I had expected the tooling to notice.
I had expected the two "- const" to be indented with 4 spaces, not two.
So there is something I do not understand.


> diff --git a/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml b/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
> index 07f39d3eee7e..f7f024910e71 100644
> --- a/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
> +++ b/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
> @@ -17,9 +17,8 @@ properties:
>            - nxp,lpc3230
>            - nxp,lpc3240
>        - items:
> -        - enum:
> -            - ea,ea3250
> -            - phytec,phy3250
> -        - const: nxp,lpc3250
> -
> +          - enum:
> +              - ea,ea3250
> +              - phytec,phy3250
> +          - const: nxp,lpc3250
>  ...

And here "- enum" receive extra indent.

I trust you know what you are doing - but I do not get it.

Some pointers or examples for the correct indention would be great.
I cannot review this patch as long as I do not know the rules.

My request to update example-schema.yaml was one way to teach me.
(Some people will say that is difficult/impossible to teach me,
but thats another story:-) ).

	Sam
