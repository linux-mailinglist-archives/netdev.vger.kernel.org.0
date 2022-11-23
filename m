Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6B56363FA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbiKWPhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238825AbiKWPh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:37:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FF0626A;
        Wed, 23 Nov 2022 07:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DB27B8216D;
        Wed, 23 Nov 2022 15:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47180C433D6;
        Wed, 23 Nov 2022 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669217845;
        bh=UanCtzyfyh7s6GC+lB/BgGuUYEuJMVRrxquRNUED7QE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m6P+8V1/dZMe1Sdy38Jer2Kq0kWOQcWPpch/6FCsgX7mogbRiZx+nRYmaqo4cOT5c
         2VBhRCgyAp1QZeQHA3EETx8HSmmQjCOuPPa172HaY1MAN9akX9CNVq37lxVTz8BMr8
         BBLccHPaIU6D7mYb41M582jELquyQZxntjmwvKYXyotA//5tW/2MbJATyer9nFW/f0
         ufcjB46KzIThaQo20IBXLl20DeebxUayijZK5CPRM4y+7O6LBfTdsu4RRUcLHP5KOK
         b4r/lHFcNKfmA5EJjEfSCvbMR52QJimK5ICXr91dLn0KonGcS4j6q3bU+aNI+8DhYx
         YzSjHFJvVHfAg==
Date:   Wed, 23 Nov 2022 15:37:13 +0000
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
Subject: Re: [PATCH v2 4/9] dt-bindings: drop redundant part of title (end)
Message-ID: <Y34+KaMMI5H/qBlI@sirena.org.uk>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-5-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c3/TYdFfqHAXL0OZ"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-5-krzysztof.kozlowski@linaro.org>
X-Cookie: I'm rated PG-34!!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c3/TYdFfqHAXL0OZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2022 at 12:06:10PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding", but instead just describe the hardware.

Acked-by: Mark Brown <broonie@kernel.org>

--c3/TYdFfqHAXL0OZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN+PikACgkQJNaLcl1U
h9Axvwf9HW9i1/TYYTLxyy8fUtu5a3P9a9v1aqZ5Vk5GOoY4gLBJ+Nn6TQz4e3WA
B/mLs0ELXPm3nJVTGPQfpqgCN3STLaUwDcVJIskltCSFn08YUWFcyfkQWyBkAWym
cNTiF+sk8z6Aw5orSNcjJFWhpEZejA/1yQ+eBJbfm3d44vR/G2D5tMGJXmbE3rEA
bRa98QZef1l34JDi6+gadC0w7LX4jj8Q41K/mjRuLqdmV6BUstQvCsKC/8YIeoua
G3jLmit5vd8KXG2eEiqK2lY2t5FBYlNLXqLoaE2yjZFcmvABd6Vh/2JDcOOFeBpK
sPr6SAIesrsLQzCHS/nuT/saF9E/UA==
=p0qY
-----END PGP SIGNATURE-----

--c3/TYdFfqHAXL0OZ--
