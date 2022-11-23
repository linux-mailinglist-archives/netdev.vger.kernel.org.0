Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0D5634C8C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiKWBNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiKWBMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:12:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67918E0DE4;
        Tue, 22 Nov 2022 17:11:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AA5DB81CBD;
        Wed, 23 Nov 2022 01:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDB5C433D6;
        Wed, 23 Nov 2022 01:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669165887;
        bh=ADbZq4YwW1C+91LIdQtYbccEDrGI/iE1NCMBgSuxYyc=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=mcNBGmmaNNNKqJjI81qBoU1BnHKL/Od65PEiCM5eFS6rB3FMDGHuSwiR2KIVbhE/L
         7dF6XJbD2xB42+q+79Hj+uKuOsQEZ2NZVw3F3KY5WGdOWwKOH+MDJvbY6NNaq2ebZe
         OhmSGXztCFZsqwDD4yPnkHiXlKTER0HV9ALchzxPzIqjFWx3BoaWYwoPCydWpzZ1nt
         VJVMq7NkiDRF/lqctbrNTB0LNvK+kQdYINT2J+igN+zulIsY6oTbHdQJLwyoJ5a29q
         u974j5yATKuTF2SI4fgGfHzwI0SI22L4R/m02aMeH0OJeBZf6JsinR5AbhUTI2iu0w
         MLwWiuRxgGUoQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221121110615.97962-7-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org> <20221121110615.97962-7-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v2 6/9] dt-bindings: drop redundant part of title (end, part three)
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
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
Date:   Tue, 22 Nov 2022 17:11:25 -0800
User-Agent: alot/0.10
Message-Id: <20221123011127.BBDB5C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Krzysztof Kozlowski (2022-11-21 03:06:12)
> The Devicetree bindings document does not have to say in the title that
> it is a "binding", but instead just describe the hardware.
>=20
> Drop trailing "bindings" in various forms (also with trailling full
> stop):
>=20
>   find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
>     -not -name 'trivial-devices.yaml' \
>     -exec sed -i -e 's/^title: \(.*\) [bB]indings\?\.\?$/title: \1/' {} \;
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org> # clk
