Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0919162E675
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240637AbiKQVJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240624AbiKQVJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:09:25 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCA87722F;
        Thu, 17 Nov 2022 13:08:04 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4969620007;
        Thu, 17 Nov 2022 21:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668719281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72JrUM6NacHh18cxNPJTokOPFIy2MlvUmUZu6AVg77s=;
        b=kQ3WnKEHtW817TTGo/51w1BLV9fElm+d4PRny19l0Xo5WVvRKUWbYa4RLUCeb4hzAu+blU
        gN78c5WiYd88yo78Tac1K8UgLdjF8sGEUg2eG4K4KIGZ2aSd/NCisT3pEqKgpi8MG9t8wo
        Mhed7VoKwoPF1Ad6rnk8zscQKUda7EVdabBo89uHsVUfKLNbVRCzBabKqvqOG3TKdkeI5N
        elXTmNOrt8pOHvUy7n2mYZBmGVFue71mi4Gp0X7blRdSkQQj+FNRIx2l1Hm3E/1dFZjljQ
        ITXz8XlIez/SUSB6b7UDZFkg18YUByW5VovCJRgF+828mYPwuo2FHFq7f7zwSg==
Date:   Thu, 17 Nov 2022 22:07:56 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [RFC PATCH 1/9] dt-bindings: drop redundant part of title of
 shared bindings
Message-ID: <20221117220756.7a1bf734@xps-13>
In-Reply-To: <20221117123850.368213-2-krzysztof.kozlowski@linaro.org>
References: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
        <20221117123850.368213-2-krzysztof.kozlowski@linaro.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

krzysztof.kozlowski@linaro.org wrote on Thu, 17 Nov 2022 13:38:42 +0100:

> The Devicetree bindings document does not have to say in the title that
> it is a "binding", but instead just describe the hardware.  For shared
> (re-usable) schemas, name them all as "common properties".
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/clock/qcom,gcc.yaml         | 2 +-
>  Documentation/devicetree/bindings/dma/dma-common.yaml         | 2 +-
>  Documentation/devicetree/bindings/dma/dma-controller.yaml     | 4 ++--
>  Documentation/devicetree/bindings/dma/dma-router.yaml         | 4 ++--
>  Documentation/devicetree/bindings/iio/adc/adc.yaml            | 2 +-
>  .../devicetree/bindings/media/video-interface-devices.yaml    | 2 +-
>  Documentation/devicetree/bindings/media/video-interfaces.yaml | 2 +-
>  Documentation/devicetree/bindings/mmc/mmc-controller.yaml     | 2 +-
>  Documentation/devicetree/bindings/mtd/nand-chip.yaml          | 2 +-
>  Documentation/devicetree/bindings/mtd/nand-controller.yaml    | 2 +-
>  .../bindings/net/bluetooth/bluetooth-controller.yaml          | 2 +-
>  Documentation/devicetree/bindings/net/can/can-controller.yaml | 2 +-
>  .../devicetree/bindings/net/ethernet-controller.yaml          | 2 +-
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml       | 2 +-
>  Documentation/devicetree/bindings/net/mdio.yaml               | 2 +-
>  Documentation/devicetree/bindings/opp/opp-v2-base.yaml        | 2 +-
>  .../devicetree/bindings/power/reset/restart-handler.yaml      | 2 +-
>  Documentation/devicetree/bindings/rtc/rtc.yaml                | 2 +-
>  .../devicetree/bindings/soundwire/soundwire-controller.yaml   | 2 +-
>  Documentation/devicetree/bindings/spi/spi-controller.yaml     | 2 +-
>  Documentation/devicetree/bindings/watchdog/watchdog.yaml      | 2 +-
>  21 files changed, 23 insertions(+), 23 deletions(-)
>=20

[...]

> diff --git a/Documentation/devicetree/bindings/mtd/nand-chip.yaml b/Docum=
entation/devicetree/bindings/mtd/nand-chip.yaml
> index 97ac3a3fbb52..20b195ef9b70 100644
> --- a/Documentation/devicetree/bindings/mtd/nand-chip.yaml
> +++ b/Documentation/devicetree/bindings/mtd/nand-chip.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/mtd/nand-chip.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: NAND Chip and NAND Controller Generic Binding
> +title: NAND Chip and NAND Controller common properties

I only see this now but the title should be

	"NAND chip common properties"

> =20
>  maintainers:
>    - Miquel Raynal <miquel.raynal@bootlin.com>
> diff --git a/Documentation/devicetree/bindings/mtd/nand-controller.yaml b=
/Documentation/devicetree/bindings/mtd/nand-controller.yaml
> index 359a015d4e5a..a004efc42842 100644
> --- a/Documentation/devicetree/bindings/mtd/nand-controller.yaml
> +++ b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/mtd/nand-controller.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: NAND Chip and NAND Controller Generic Binding
> +title: NAND Chip and NAND Controller common properties

And here just "NAND controller..."

Of course the original purpose of your series is more to clean those
titles rather than fixing them and if you disagree I am fine doing it
myself aside, but if you could at the same time make the title more
accurate that would be perfect.

Either ways:

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

Cheers,
Miqu=C3=A8l
