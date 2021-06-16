Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4813A9797
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhFPKhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhFPKhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:37:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 998E661107;
        Wed, 16 Jun 2021 10:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623839691;
        bh=uJEv3OvJMqswalWvG2rx1DCmioR+VtUOrO7CZGR2Ajw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6wsFevRhS9CeafwlT529v2rV3Gm9GGwn4GGkmYDghQBgvSltNdLhA2d1VwUgm9YV
         V+BZ/Z7dkVuRC9jA+aF8uUIN4oppwPSoc0YE3UC/NPxsGiCugwhXT7XZEbbeh2pmB/
         M4rdDOJ4s0X9LmiRn4axjJlxF+T4B+Wd1HYLAz0MgEG64RvZ+ZZaXxAxnqcCDwPJej
         pW3zx7fe6lsVprl/vQScwg/OlH7/cEN61iAlussljsV2mRmi/pOkb0n3FbRiUdCHAK
         H6X3SZGPBKP1nePHfXCLHq/6yaW3vQZyt5NRvZBipljaN3xhgyRVkvGP83STRQZ1Xh
         jhhQBOeaewbeQ==
Date:   Wed, 16 Jun 2021 16:04:47 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, dmaengine@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, iommu@lists.linux-foundation.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] dt-bindings: Drop redundant minItems/maxItems
Message-ID: <YMnTx4GqTWu75o2n@vkoul-mobl>
References: <20210615191543.1043414-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615191543.1043414-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15-06-21, 13:15, Rob Herring wrote:
> If a property has an 'items' list, then a 'minItems' or 'maxItems' with the
> same size as the list is redundant and can be dropped. Note that is DT
> schema specific behavior and not standard json-schema behavior. The tooling
> will fixup the final schema adding any unspecified minItems/maxItems.
> 
> This condition is partially checked with the meta-schema already, but
> only if both 'minItems' and 'maxItems' are equal to the 'items' length.
> An improved meta-schema is pending.

>  .../devicetree/bindings/dma/renesas,rcar-dmac.yaml          | 1 -

>  Documentation/devicetree/bindings/phy/brcm,sata-phy.yaml    | 1 -
>  Documentation/devicetree/bindings/phy/mediatek,tphy.yaml    | 2 --
>  .../devicetree/bindings/phy/phy-cadence-sierra.yaml         | 2 --
>  .../devicetree/bindings/phy/phy-cadence-torrent.yaml        | 4 ----
>  .../devicetree/bindings/phy/qcom,ipq806x-usb-phy-hs.yaml    | 1 -
>  .../devicetree/bindings/phy/qcom,ipq806x-usb-phy-ss.yaml    | 1 -
>  Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml     | 1 -
>  Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml   | 2 --
>  Documentation/devicetree/bindings/phy/renesas,usb2-phy.yaml | 2 --
>  Documentation/devicetree/bindings/phy/renesas,usb3-phy.yaml | 1 -

Acked-By: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
