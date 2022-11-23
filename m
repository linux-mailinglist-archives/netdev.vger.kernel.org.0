Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78101634C48
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbiKWBJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbiKWBJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:09:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F9DE0749;
        Tue, 22 Nov 2022 17:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38D2461962;
        Wed, 23 Nov 2022 01:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4D2C433B5;
        Wed, 23 Nov 2022 01:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669165781;
        bh=qMUCJkHDKODpGOuGW51S9S+Wc9pKi7k3jRdHTL7atTY=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=kqxTAzpSMsIFSOhKLHbuvGS3YhP4Ghan+L7rtN516xt08X55sIuaOEBB8Qbq4+rRi
         5CVzboyxCV2G+AU+PT1p5KRUronWwFHZjTrZUGaMUXsVjwYJAoXcbcwRcI2FU4Lgx9
         zL3uJIsO6hTYNQqNDUSNFjcUcJRpIdjWYeb+lIrhoMH65aVMlBoJ7veI4IQjIwBxX2
         R8eWvVLZRvpqSzNMXVd+0kyfJ1ypml1zqGvVGS0n4j52fenoMAMuYXNN45BuFZsRKb
         Bz9wCekpWMZk+m9CAyej743woVYbY2pYdM4eG5zWyoCH1UyEzuXxLmY3bhphXOw5Hk
         6lGfcIjp49aAA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221121110615.97962-5-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org> <20221121110615.97962-5-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v2 4/9] dt-bindings: drop redundant part of title (end)
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-can@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Date:   Tue, 22 Nov 2022 17:09:39 -0800
User-Agent: alot/0.10
Message-Id: <20221123010941.7C4D2C433B5@smtp.kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Krzysztof Kozlowski (2022-11-21 03:06:10)
> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding", but instead just describe the hardware.
>=20
> Drop trailing "Devicetree bindings" in various forms (also with
> trailling full stop):
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -not -name 'trivial-devices.yaml' \
>     -exec sed -i -e 's/^title: \(.*\) [dD]evice[ -]\?[tT]ree [bB]indings\=
?\.\?$/title: \1/' {} \;
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -not -name 'trivial-devices.yaml' \
>     -exec sed -i -e 's/^title: \(.*\) [dD]evice[ -]\?[nN]ode [bB]indings\=
?\.\?$/title: \1/' {} \;
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -not -name 'trivial-devices.yaml' \
>     -exec sed -i -e 's/^title: \(.*\) [dD][tT] [bB]indings\?\.\?$/title: =
\1/' {} \;
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # IIO
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  Documentation/devicetree/bindings/clock/ingenic,cgu.yaml        | 2 +-
>  .../devicetree/bindings/clock/renesas,versaclock7.yaml          | 2 +-

> diff --git a/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml b/D=
ocumentation/devicetree/bindings/clock/ingenic,cgu.yaml
> index df256ebcd366..9e733b10c392 100644
> --- a/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml
> +++ b/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/clock/ingenic,cgu.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Ingenic SoCs CGU devicetree bindings
> +title: Ingenic SoCs CGU
> =20
>  description: |
>    The CGU in an Ingenic SoC provides all the clocks generated on-chip. It
> diff --git a/Documentation/devicetree/bindings/clock/renesas,versaclock7.=
yaml b/Documentation/devicetree/bindings/clock/renesas,versaclock7.yaml
> index 8d4eb4475fc8..b339f1f9f072 100644
> --- a/Documentation/devicetree/bindings/clock/renesas,versaclock7.yaml
> +++ b/Documentation/devicetree/bindings/clock/renesas,versaclock7.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/clock/renesas,versaclock7.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Renesas Versaclock7 Programmable Clock Device Tree Bindings
> +title: Renesas Versaclock7 Programmable Clock
> =20
>  maintainers:
>    - Alex Helms <alexander.helms.jy@renesas.com>

Acked-by: Stephen Boyd <sboyd@kernel.org> # clk
