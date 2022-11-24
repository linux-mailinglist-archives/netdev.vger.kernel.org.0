Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233F4637C16
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiKXOzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKXOzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:55:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7E7A1A0;
        Thu, 24 Nov 2022 06:55:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48639B8283A;
        Thu, 24 Nov 2022 14:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C289BC433C1;
        Thu, 24 Nov 2022 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669301706;
        bh=S3xYwGQuP1zkeAOUdEdt9aQxCaHG1tpwe3PTQbwPO30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r0tfM3KXFq8k8dKdKgCyfe0VqkbG+aSVkOzM9rQig5SJnlW4pG8A9wbar7Uad2Eer
         erd/sBiYLcZdK67QfsCyxaKSBLZhO58ulwkqoCk28Ny9GnxH61LQVZFc5HueoQogaE
         CS+Q6cLAOrlQPiuOBYeFpv5HPB0bJs0s7iEKHQs7qqSRZ//HsO1qoC2lyHDuTAn9+D
         o035g2hgwLpT2kmGykDx2rMhldFJ7UN7ULem4MSTcVezL0KlrMkmXz5Ovl5KidGrtn
         JOl8xhddKpDWye2PFI5/wXspCDb0bNhouFBGvmHqJjokfG04TYCDIju1kP9KMHfZyZ
         ZAJfdZyFaAkCw==
Received: by mercury (Postfix, from userid 1000)
        id 82F7D106092A; Thu, 24 Nov 2022 15:55:03 +0100 (CET)
Date:   Thu, 24 Nov 2022 15:55:03 +0100
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
Subject: Re: [PATCH v2 4/9] dt-bindings: drop redundant part of title (end)
Message-ID: <20221124145503.ir4n5qjonowpyhdz@mercury.elektranox.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-5-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ksnzyadj7qk2pape"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-5-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ksnzyadj7qk2pape
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 21, 2022 at 12:06:10PM +0100, Krzysztof Kozlowski wrote:
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

=2E..

>  .../devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml      | 2 +-
>  .../devicetree/bindings/power/supply/maxim,ds2760.yaml          | 2 +-
>  .../devicetree/bindings/power/supply/maxim,max14656.yaml        | 2 +-

=2E..

> diff --git a/Documentation/devicetree/bindings/power/reset/xlnx,zynqmp-po=
wer.yaml b/Documentation/devicetree/bindings/power/reset/xlnx,zynqmp-power.=
yaml
> index 46de35861738..11f1f98c1cdc 100644
> --- a/Documentation/devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml
> +++ b/Documentation/devicetree/bindings/power/reset/xlnx,zynqmp-power.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/reset/xlnx,zynqmp-power.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Xilinx Zynq MPSoC Power Management Device Tree Bindings
> +title: Xilinx Zynq MPSoC Power Management
> =20
>  maintainers:
>    - Michal Simek <michal.simek@xilinx.com>
> diff --git a/Documentation/devicetree/bindings/power/supply/maxim,ds2760.=
yaml b/Documentation/devicetree/bindings/power/supply/maxim,ds2760.yaml
> index c838efcf7e16..5faa2418fe2f 100644
> --- a/Documentation/devicetree/bindings/power/supply/maxim,ds2760.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/maxim,ds2760.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/maxim,ds2760.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Maxim DS2760 DT bindings
> +title: Maxim DS2760
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>
> diff --git a/Documentation/devicetree/bindings/power/supply/maxim,max1465=
6.yaml b/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
> index 070ef6f96e60..711066b8cdb9 100644
> --- a/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/maxim,max14656.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/power/supply/maxim,max14656.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
> =20
> -title: Maxim MAX14656 DT bindings
> +title: Maxim MAX14656
> =20
>  maintainers:
>    - Sebastian Reichel <sre@kernel.org>

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--ksnzyadj7qk2pape
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmN/hccACgkQ2O7X88g7
+ppHEw/+Ofnx5vLl+V2sXB4VCd7c5T9abMJs0VA3LSQVJMpmCEWW5XvhGEnmu2bA
pe/8cmzFUNEal3JsF6Pun9+s8oVlQbtbXgQqqxocYGD0uNtePzX3IGizBN9mod8c
SB1U/oUlAw3ixwqcW5ZtbvPG1lAAc++86GtlPhulX7wCUFqbSMlbHXO2x8N1pa2+
cpOUmML55ELsk9srGIh7D88sV+n7hQQ8fMBI3HJt8gpZp1vpSG4mO941XAamkGgQ
hxEH9NP7AZl0ACiU1hRr3snxA+Yt3zg0mqyvk7OEwZnH85a/rlUqW74AlYeI2htX
+lSqy5fLCEAUifNJqotbU0xNOsiYKoFAcZAcfe89ePJYQoyg/wzPbptF8WK6uPQn
+k6HAHgIKHEd9h8o8LtU5MexYnGJix6nm6nkTOyq9u0PiHfsi75epi6lfw1xXX6Z
XYXxos+ohbeTUt/yW44aGw3jQ940mpr0f0gnVkudCiqfh4pV8gvWX8YoZH+K2BJa
C4natf1/bbwe0fTrA92dFqc3iwZB6FdCmdhE/cJ69GAW8araN8PelXTe2WgjmSOi
GZ6VtLaEi+lDktvqKCb/mw2GvrHW0y/EpRAvctJqNTR2uknOLyncBS9PiseoklUj
zmMw9e8xCv0ZXkroHdPqE8sDSQSB7gBINlSYEKk6wubHJwWdiyM=
=rY9T
-----END PGP SIGNATURE-----

--ksnzyadj7qk2pape--
