Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9B2634CD5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbiKWBPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiKWBOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:14:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0323E122B;
        Tue, 22 Nov 2022 17:14:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B83861990;
        Wed, 23 Nov 2022 01:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4865C433C1;
        Wed, 23 Nov 2022 01:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669166047;
        bh=zTIEHGwbmaOUDyrFquKdXCAjwyHAbKSqMbl1KSejD2g=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=eaqRSV6gh2g8+WVKDH/rSd6EIzEqzis9/feCSBijzsbchaDY16DVRXkr5SjQuLDxC
         7fFsAiTlHOtbCQobJA9rIus3yeEH05iQ5b+/eWR8Cy/6qg0a6USR5sTCYd3kvCn8em
         qT8U9JmY/0vhbBd5HDBe8OI/firQwaWsAvppdD+im72NdeZS2tjv2zaJ6cI9JBkgim
         j8qGtcznNz9LDH6vGVds1wI6vrnqGGvZ3NT10jY/uiOdHiWLqyF5Nh/64+3Tp7RqMo
         SItZwvNGid1/Zq1R/Mvtl11rtcOt1bTpsEe5A+U+frR0T4LcVH9Is4s6YqT0uz48or
         Xm/gSZNYXPrpw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221121110615.97962-10-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org> <20221121110615.97962-10-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v2 9/9] dt-bindings: drop redundant part of title (manual)
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
Date:   Tue, 22 Nov 2022 17:14:05 -0800
User-Agent: alot/0.10
Message-Id: <20221123011407.C4865C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Krzysztof Kozlowski (2022-11-21 03:06:15)
> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding" or a "schema", but instead just describe
> the hardware.
>=20
> Manual updates to various binding titles, including capitalizing them.
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml   | 2 +-
>  Documentation/devicetree/bindings/clock/fsl,scu-clk.yaml        | 2 +-
>  .../devicetree/bindings/clock/qcom,dispcc-sc8280xp.yaml         | 2 +-

Acked-by: Stephen Boyd <sboyd@kernel.org> # clk
