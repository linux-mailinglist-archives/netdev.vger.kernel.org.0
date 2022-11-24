Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8535637BFC
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiKXOyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKXOx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:53:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA1311A737;
        Thu, 24 Nov 2022 06:53:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A26F62180;
        Thu, 24 Nov 2022 14:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F372C433C1;
        Thu, 24 Nov 2022 14:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669301606;
        bh=unIV7Ik3dkhviLx7pqEUl7Hj+P8gzwLYsPUrycbdr2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bjiga38QWyzLlfhROr4+WaCyo1J6wcTkIZj/mwam3dWvx1Hx5xajOxzVB7myXCa9N
         WNBAdzWlxBlBs+KppJLdJyV66PPHOF5WPs6Mou2/YQUFWDhxzmXFlw/QhsRkqhAbvM
         IKZb4468eQJJDEnwbqI3IOZWGOuAGFvAZoZxBeBNa28SexV/3o2GKds11UG+j34jMn
         qFVJwi+/7WO3rd5ejlO/fFF8/Xvu1SgSJacWq2/ZXhnbl5m/YnXscTIWOW5JF6sv2/
         7AIFZSfR+8FP0gVVdcX2vRVTsiUKBtO1qb0RumfwgoMEoegx4yHbgmeuc5IR3fUnJ3
         WdioSmYng4A7g==
Received: by mercury (Postfix, from userid 1000)
        id E481A106092A; Thu, 24 Nov 2022 15:53:23 +0100 (CET)
Date:   Thu, 24 Nov 2022 15:53:23 +0100
From:   Sebastian Reichel <sre@kernel.org>
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
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v2 1/9] dt-bindings: drop redundant part of title of
 shared bindings
Message-ID: <20221124145323.tevilddtr7ajdd7l@mercury.elektranox.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kmrqy5oh67vgmowj"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-2-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kmrqy5oh67vgmowj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 21, 2022 at 12:06:07PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "binding", but instead just describe the hardware.  For shared
> (re-usable) schemas, name them all as "common properties".
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Guenter Roeck <linux@roeck-us.net> # watchdog
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # IIO
> Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  .../devicetree/bindings/power/reset/restart-handler.yaml        | 2 +-

=2E..

> diff --git a/Documentation/devicetree/bindings/power/reset/restart-handle=
r.yaml b/Documentation/devicetree/bindings/power/reset/restart-handler.yaml
> index 1f9a2aac53c0..378b404af7fd 100644
> --- a/Documentation/devicetree/bindings/power/reset/restart-handler.yaml
> +++ b/Documentation/devicetree/bindings/power/reset/restart-handler.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/reset/restart-handler.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Restart and shutdown handler generic binding
> +title: Restart and Shutdown Handler Common Properties
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--kmrqy5oh67vgmowj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmN/hVMACgkQ2O7X88g7
+pqhwA/+M2Nr4azK150ufJYwasgPUHr+IvgiGG6zZbVydz4jcsik67ma/TlLQV0F
e576CX8Tqzz90OcmpIPWvWr/+Ev0QWetfOvG+4+Io9Zh+w7Er6dnLWZuv3DbPDD8
b5KbXY0fKBBc30RQVk7T0uhq0Qd/gJ38fOALFl7nymMSzekfDuYm+HNn9gURaxuK
C3EKJDXCLhT05/DBQK4rx+CVy6tMk8oiQOrrESyGeHRrRv/7va6TjIKRqXoekdAx
GEA6CF1jXwzX0TnUppKNjGdVeBw8UkflkU8lJrBozSSpo+IzaaT333jOhsX2ROKB
uDDWkC4CAOVIXnLhUBSNJGm9ifZm906c/zyoZ77EzYNtsFESq5znEyTryuOfzjiS
ykyxB/WkNLxxJf5Wcu4gqGks0KrnM7aE+pfV+cqViSgGi8ykIUwEjrbY15w34I4M
1etdToVgbUEaL+ThZaymJ9xWhcWq2NHBTTHIgL2AA34rSqaJe1f990424jUT/SYZ
7N4jCoDiJPK56gJJe5NRPSvz4LjlFa8bTB3rXioMA4Ep21+e4VrBT6TqERx/Jkaa
RdEjPVIF6pkxOepaBigKGkjvwDj4AvwdIglKaIXcccH+I55OxMOyPj3FXgaOLB+5
o6kJsJkqqpyU0tWJqBmeQED3yqn/Zz7XZZ4SunfkjJLBqxop5Ec=
=r+Zg
-----END PGP SIGNATURE-----

--kmrqy5oh67vgmowj--
