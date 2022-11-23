Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC1A6364B0
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238946AbiKWPuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbiKWPuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:50:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E2FC604D;
        Wed, 23 Nov 2022 07:49:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94278B820D2;
        Wed, 23 Nov 2022 15:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5620C433C1;
        Wed, 23 Nov 2022 15:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669218581;
        bh=T0mf0ijZQTzNBNeBPF5fkFm6qTXOYlAmsvGjPYhocZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QYvvVVFg3xABYgJQEwfoWni/oYrfqNnbcqqcQVrcp6uxcLqxAT3Hv4qpUOukDjTs/
         0p7LoCYEfkSeEAiiX+7nrXQkbqjw1137EJi8AGbebG+uSGbSuFWy6ItixRDZdgYjzd
         wI4+oGGgg+c8KPKVUQ5ZdWR+K+nR9Wh8y+eMc16I0PC838GB+J3v6zlQjhWOtg1c1c
         6e5RsTLcd6FqRQaHdPekbba0bcco/SKnkdwTGzLKgRh+Lpo1he1WOZKJOaw2ZEIIXQ
         GRY+SoMl3sj6Xk7pnSLZNQi8V4EhDNugotUmyQAc8a1pA6HLWIGeNLAtS34DQuw57+
         eXjalnxk49wTQ==
Date:   Wed, 23 Nov 2022 15:49:30 +0000
From:   Mark Brown <broonie@kernel.org>
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
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v2 7/9] dt-bindings: drop redundant part of title
 (beginning)
Message-ID: <Y35BCpD/tr/7prMh@sirena.org.uk>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uLB1Llf0h2iQ6rin"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
X-Cookie: I'm rated PG-34!!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uLB1Llf0h2iQ6rin
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2022 at 12:06:13PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding", but instead just describe the hardware.

Acked-by: Mark Brown <broonie@kernel.org>

--uLB1Llf0h2iQ6rin
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN+QQkACgkQJNaLcl1U
h9C5lAf8Dpp6enFuhrAPv0ZsgsZe6xWsOHu4pelgjbPEH8V7tDwUPWITXN5vLI3+
RuqFuOP0hYHIa9rUjaI4dZX0sPV7cFMF2BdyjTFdczyAizXljoNVh2r23soCG0RX
66rxbmsNE++z+1DObKtZgJoutGaB/ZAqMpW0t0XJERPq1KbjBGmy8D/fIq8lvoy/
4297MfYX3okBCVVhPRX/v+unG3sVqED0Bhdjpo/bwY0150YItakf4eVUXwFxfvTK
25XCxunGEShq5zi//+/abs2X89ZjhqLTfJtYtUVnj1xtSfEqoRb6mf82WrkieRvA
dYORYgupqLBXMecamcwbhHMcJBNZ3w==
=hyWV
-----END PGP SIGNATURE-----

--uLB1Llf0h2iQ6rin--
