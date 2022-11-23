Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80D63641D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbiKWPjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238047AbiKWPjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:39:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C71B23174;
        Wed, 23 Nov 2022 07:39:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 064E0B8208E;
        Wed, 23 Nov 2022 15:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9DFC433D7;
        Wed, 23 Nov 2022 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669217954;
        bh=pCgyV6URGkswg9KKfkXhBda5Iki1k2lO8qrKykFSEt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F3k9sXYZXMZbJL2KgSGmWiPRXMvHRdfTCIP9VQmjXd650/uUYXwTHEqUWxxttSOWT
         hB9b2sL956S0bUti6tuHTy2XEt5HjAbHeCo+axvVAD2rZcRJx2sPwnWchFDK3MrGxa
         yAlYOmKN8Mg4CXN+fkDD7QVG2+Cel0JnNA0akTveOPTARV97+qqsyEi6hpO6vdCsSE
         LSyr4JBajkK5pYVRAYm5iecBZGybtYAXBVbkB+5aKcTmslEywj8Jzp0bx/0VpZMrY2
         D5rI9GA2AAWuXzKpflAIq18/MHA6MmSTayBSrTtAwCYcKH0rMZJiTAzR77dwqComaB
         rsQQ9HVyYiq1w==
Date:   Wed, 23 Nov 2022 15:39:00 +0000
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
Subject: Re: [PATCH v2 5/9] dt-bindings: drop redundant part of title (end,
 part two)
Message-ID: <Y34+lGKAxewL8B1w@sirena.org.uk>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-6-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3A/ckh57FM2wa6K8"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-6-krzysztof.kozlowski@linaro.org>
X-Cookie: I'm rated PG-34!!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3A/ckh57FM2wa6K8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2022 at 12:06:11PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "binding", but instead just describe the hardware.

Acked-by: Mark Brown <broonie@kernel.org>

--3A/ckh57FM2wa6K8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN+PpQACgkQJNaLcl1U
h9D31gf/diT1M+7KeH7O9XMaZE9GvQx7EpNfWPd6EPxvzUkePN6w8u24ztB2s1gn
LKqFnrfx5FQwvbCsjmuHqePIJ6kdBJHpd8zn0XYx/cJQJlR/lFm5FPbdjhDnfcCC
lH4+dPqm7Tms/Dmlw8z49shzkjbAkN5O81QNFCdqvgYfp94E6kUVysgHobbu7DzT
8dtk4IMR8dgd1gsVYd3RlfLDv7zlhti06pOwAYvL7I/+ELvcFRXtGgOq8p8EMd//
e9dFGh61GX0//8+cYUSUG2Qb/npn7nA2mFko17JRUU21NrTgMn1qbJvntYvhfKqj
AqDREqKbfhSeQVkKulAfyfkiBA4hNg==
=SxY0
-----END PGP SIGNATURE-----

--3A/ckh57FM2wa6K8--
