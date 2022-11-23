Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B8B634CA3
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiKWBN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiKWBN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:13:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FFCE3D3B;
        Tue, 22 Nov 2022 17:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9197B6199F;
        Wed, 23 Nov 2022 01:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACF5C433D6;
        Wed, 23 Nov 2022 01:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669165935;
        bh=b4lFQBJuE6E5nzM4uZRkyZngXj37aTtlWv6pt98Ral4=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=YnKK/Cra0JtvnIKJARfKziOYN414MerZu6PUoHIOWpuUNiyK1L9awWhP6TaUzexyE
         yraYSJIA3TPiPSppXaaJHrdxalNvCmBPZxQTKQoJA5FQv+lIoabMprAKO0Ap7CZKcZ
         OALpLx2qpy2t4FkvkUMBd707omeudCxo9bIGjrNdNiIP/DaPNhHv3aXBILwfwTKcQI
         4Im6+9PZo0Ph40oJmi0KRqGv+Nz5Of+Pag75DmXiJpSvrBjDdI7iXI0mNx87P4G2fC
         Uoxs2iDXMllbPSQ3hzs8srOANRRiLFITFR3KXiKFWCahDsZEN0jbWLVvOjtj0bDsyD
         DMufxFuXFWKRg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org> <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v2 7/9] dt-bindings: drop redundant part of title (beginning)
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
Date:   Tue, 22 Nov 2022 17:12:12 -0800
User-Agent: alot/0.10
Message-Id: <20221123011214.DACF5C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Krzysztof Kozlowski (2022-11-21 03:06:13)
> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding", but instead just describe the hardware.
>=20
> Drop beginning "Devicetree bindings" in various forms:
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [dD]evice[ -]\?[tT]ree [bB]indings\? for \=
([tT]he \)\?\(.*\)$/title: \u\2/' {} \;
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [bB]indings\? for \([tT]he \)\?\(.*\)$/tit=
le: \u\2/' {} \;
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -exec sed -i -e 's/^title: [dD][tT] [bB]indings\? for \([tT]he \)\?\(=
.*\)$/title: \u\2/' {} \;
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml     | 2 +-
>  Documentation/devicetree/bindings/clock/fixed-clock.yaml        | 2 +-
>  Documentation/devicetree/bindings/clock/fixed-factor-clock.yaml | 2 +-
>  Documentation/devicetree/bindings/clock/fixed-mmio-clock.yaml   | 2 +-
>  Documentation/devicetree/bindings/clock/idt,versaclock5.yaml    | 2 +-
>  Documentation/devicetree/bindings/clock/renesas,9series.yaml    | 2 +-
>  Documentation/devicetree/bindings/clock/ti/ti,clksel.yaml       | 2 +-

Acked-by: Stephen Boyd <sboyd@kernel.org> # clk
