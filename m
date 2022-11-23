Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834DA6360BB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiKWN5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbiKWN4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:56:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBB3101F;
        Wed, 23 Nov 2022 05:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED9E961CEC;
        Wed, 23 Nov 2022 13:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70F3C433D6;
        Wed, 23 Nov 2022 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669211504;
        bh=yn6IQg9xUUV9CgWL40Zq6y52rg1mn5sa8oD03o5v7Xs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UKfpNKKUztgIyNLf4JyG/Wh9x1SnC70ZZ6CMkTeLD14mkOzGlAm4+qghDz9TTaJEY
         oavU1DO373ElaIHQhIEpVZi9OKHf+AB7y5AZ3a0QM4K6Mda5mlxZI6uj77Y+34o3+z
         tC1+zaqNCkF1IRGWjNnvY9xTloZLlUjIwvwDNzzHVs6iAjJgjo18LVCElB+Z+suDGy
         RWQBO44v5C47KQUPl5LJXsrQ6VqWTj1W9The96h2CM4sfIP1b0DOy3ZhTq1Wp6bXDL
         C50DRWElKcd6PEaRVrgU5hEWY/A3MmvIZ+aqD+I2bHVUKaydHWSJ+FVF1rDhM8vyJp
         Av8NqbWSqNyRA==
Date:   Wed, 23 Nov 2022 13:51:32 +0000
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
Subject: Re: [PATCH v2 1/9] dt-bindings: drop redundant part of title of
 shared bindings
Message-ID: <Y34lZFSBEwuI6G+a@sirena.org.uk>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sez8m7aAndejrS5d"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-2-krzysztof.kozlowski@linaro.org>
X-Cookie: I'm rated PG-34!!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sez8m7aAndejrS5d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2022 at 12:06:07PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "binding", but instead just describe the hardware.  For shared
> (re-usable) schemas, name them all as "common properties".

Acked-by: Mark Brown <broonie@kernel.org>

--sez8m7aAndejrS5d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN+JWMACgkQJNaLcl1U
h9CJ0gf/ajSRpLgN3RoHR7wLxFr99y5vWRywVoOaKU+lLq3UY2O6a9ssY8wOblzx
J9LbUP4Acep2fofTZCX1Ks2sTUHXNBB95SaeCwpSD/MX2HltHr0QvTGh8Lc9EfRf
f4l/ayjov4DbVsOJ019O7MKSgyuKezLb6Rj/5S38OrqdREbbzDoFe2ah8rSxpA8m
OQPEsY4eAbVfELEo/JQ86QYXN8gT6p3qA0+8IxDb0D+iLi3JCIz3GTrn+ZCudWRS
DkbD00vhGbeEaAbI/ufYp/KUWT0wfIoONENSAdGhmGMd+deqbmOt1Ryt+YoEt49j
pRMeSDCxuBZIpBjQfw7H+5ofOT8jsg==
=hoZL
-----END PGP SIGNATURE-----

--sez8m7aAndejrS5d--
