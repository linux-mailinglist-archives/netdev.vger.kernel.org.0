Return-Path: <netdev+bounces-3050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F497053EF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:33:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B80B1C20F0F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52588825;
	Tue, 16 May 2023 16:33:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9860634CD4
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:33:31 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22141BCD;
	Tue, 16 May 2023 09:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
	t=1684254733; i=j.neuschaefer@gmx.net;
	bh=fhB7hXqPlLyhvg8cmuKZg4nTLKqqIf4hFaLjTAmDR8E=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WCKv0kSCq8cZdcodj3bzJzACl4VUx0N8jIRRLDx6AZWncDeaknHBQ5nP0eVYnCTxp
	 6fsbLxswW3YliTBP2l+jyje57qJGgPy81P3h231K9Wp8Y0nyU8CVCoxcD3tatY5bu7
	 FfGSz1VbwzQtNSTW63A+AAmbzuU5zRdOeMKg8S63XdKKPLRuHqQYu4nhaWKGUmOlRh
	 2wm3hFDjfV8vnq7vnoX++qTaeehQG1WstXLXkrAp+sNV2llu33a3OvtCcG2IM4FTB4
	 hGp2yJajFlFUXH+JElvq6qMEZ1iu56Hooa6evB3SyqoDt4iJDtsdnyQg097NKKYS+L
	 vQquKptUrnA8g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.59.32]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M6Udt-1q5HFt3Faz-006u37; Tue, 16
 May 2023 18:32:12 +0200
Date: Tue, 16 May 2023 18:32:09 +0200
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>, Wolfram Sang <wsa@kernel.org>,
	Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
	linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v4 4/7] pinctrl: wpcm450: elax return value check for IRQ
 get
Message-ID: <ZGOwCSPH68DJN/NC@probook>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
 <2d89de999a1d142efbd5eb10ff31cca12309e66d.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WrLvMy0clVxWGHYm"
Content-Disposition: inline
In-Reply-To: <2d89de999a1d142efbd5eb10ff31cca12309e66d.1684220962.git.mazziesaccount@gmail.com>
X-Provags-ID: V03:K1:kb9Ha+Yx98MCgnViJRbJ5mV8EzgVqSMWDyckGXEBHPEckS2yxtX
 WLxGHbQHHyww6R6Ovfb1I6+MLs6unjVXcHPN9cTB2qUyLT2OCQV4a0EnroagIj69QDhNiwQ
 +/Vn/78OKHy4brwPcnbpJc03GQ7dSWBsQWsx+Fe8NIAEyAT9HzZ3hdQy/WQNO1Ec+/rSljD
 BU7HzvqPeijKqg+zAILnw==
UI-OutboundReport: notjunk:1;M01:P0:eqLG+MfPsvo=;dsn+3nEr9xMgnpHyFWJxZLNYN5d
 GY31/ESf0RyFHD0Wsp5dR+6FvUvf8ls2+02yNc1I2OnqO2S6w+9e/u7Qsm3ag2yMUuidMmHZe
 MrPhjAT2f2zHNIqKcehCtR7r4DZiPS4PxM1pl5J470ceF/tu+JZM+F6MMdtg14K+qSIGQlutQ
 5xt8LAjzsKAlC3PqG8lw2hu2tB1mAuFsZfzw30NulhTGl1PvfesyWE9eSoLCk7oi85iJgKMTi
 yX50PkGycHbQ4CxFjMCbqPypmZt1W+tvEOBDTadB+HuQn6XPevTpezXUlgyqwxndqX7L/bwWO
 PlEfuD270YU708j3ci6G5HldGNA+bMgF40SFGDCbUzEGDezwqTiuVXJNulxdVq1ldILAmygiM
 lXSfJCjR8r1O3Djv6vssLn02B4NtgPa0mLAtCQ0qHFxV27VbCFxTyhSAY2Cp/yEOZ+A1DwCvO
 iKIfSyBPQropa3WL8AKS6EuF175T5xPOzUJHtjhP4+OZgsIPQVbYmozwTnXUbDSwSI7L5JoZg
 qCD37EJqugrU2l874OdAy9M1yVK8Ju9HsPeLxU2Tvl3bnLZ1oLWEeFxhGGu+TxenEdz8ZefMM
 pVc2VtXX4y6dZKbFv25tzyY4JWgxnCITXQfQcDFy8oPsRucV3DVXwmRnbBu8RpS2z4M9hYGaY
 QWJdFql4bakNJzQ03Fky11IDGzakxsCSlSTV9zvg2ZSLU9LA2F4hqjTcP0F9PbQlGkpQFswY8
 V61c8E3mMNh8Nwx9acEZX731LSLhNHST2xA47cI5nKlsLKCkMTmHEa5oqHwenSq856CLVG/z+
 uXjIksinveoOI/IsthUbBTEUy+5PZhl774qIjlxgacPc5ovl4zxUOh/qJGJ0ratCbtsvYVG4c
 gl2sL6cFa1cJq8BZrlu6Bnwkt7SnTGiIpUclJ8hvqyB+vymjLCUmmHu7pAJENNej8JcvaLCBH
 G92iqg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--WrLvMy0clVxWGHYm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

> [PATCH v4 4/7] pinctrl: wpcm450: elax return value check for IRQ get

Typo ("elax") in the subject line.

>
On Tue, May 16, 2023 at 10:13:14AM +0300, Matti Vaittinen wrote:
> fwnode_irq_get[_byname]() were changed to not return 0 anymore. The
> special error case where device-tree based IRQ mapping fails can't no
> longer be reliably detected from this return value. This yields a
> functional change in the driver where the mapping failure is treated as
> an error.
>=20
> The mapping failure can occur for example when the device-tree IRQ
> information translation call-back(s) (xlate) fail, IRQ domain is not
> found, IRQ type conflicts, etc. In most cases this indicates an error in
> the device-tree and special handling is not really required.
>=20
> One more thing to note is that ACPI APIs do not return zero for any
> failures so this special handling did only apply on device-tree based
> systems.
>=20
> Drop the special (no error, just skip the IRQ) handling for DT mapping
> failures as these can no longer be separated from other errors at driver
> side.
>=20
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
>=20
> ---
>=20
> The special handling in this driver was added when fixing a problem
> where returning zero from fwnode_irq_get[_byname]() was treated as
> succes yielding zero being used as a valid IRQ by the driver.
> f4a31facfa80 ("pinctrl: wpcm450: Correct the fwnode_irq_get() return valu=
e check")
> The commit message does not mention if choosing not to abort the probe
> on device-tree mapping failure (as is done on other errors) was chosen
> because: a) Abort would have broken some existing setup. b) Because skipp=
ing
> an IRQ on failure is "the right thing to do", or c) because it sounded li=
ke
> a way to minimize risk of breaking something.
>=20
> If the reason is a) - then I'd appreciate receiving some more
> information and a suggestion how to proceed (if possible). If the reason
> is b), then it might be best to just skip the IRQ instead of aborting
> the probe for all errors on IRQ getting. Finally, in case of c), well,
> by acking this change you will now accept the risk :)
>=20
> The first patch of the series changes the fwnode_irq_get() so this depends
> on the first patch of the series and should not be applied alone.

Thanks for investigating this!

It's not a), because there are no existing setups that rely on broken
IRQs connected to this pinctrl/GPIO controller.

I suspect b) or c), but I'll let Andy give a more definite answer.

> ---
>  drivers/pinctrl/nuvoton/pinctrl-wpcm450.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c b/drivers/pinctrl/=
nuvoton/pinctrl-wpcm450.c
> index 2d1c1652cfd9..f9326210b5eb 100644
> --- a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
> +++ b/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
> @@ -1106,8 +1106,6 @@ static int wpcm450_gpio_register(struct platform_de=
vice *pdev,
>  			irq =3D fwnode_irq_get(child, i);
>  			if (irq < 0)
>  				break;
> -			if (!irq)
> -				continue;
> =20
>  			girq->parents[i] =3D irq;
>  			girq->num_parents++;

Anyway, this looks good to me.

Reviewed-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>

--WrLvMy0clVxWGHYm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEvHAHGBBjQPVy+qvDCDBEmo7zX9sFAmRjr+cACgkQCDBEmo7z
X9sWzA//bZZ5OxVZ8EtxzPSK/eibQZfgmPiYXqXgsEMjpRZwcPXskSEwCPtOtf6m
iRl8ElSCbpvjpPbtjnUWp8s4OcehmR6WvMwY9kSj2rlzojAi5Q3vypAPJKi1l/qn
X/XFvUt7H21kj2uxfvCF2MTpIimfc+52YDyE2f1JZgcczkSaRzL4fc1EtQMpW2BQ
/OekLcM7OV9iebAFdptvQiRJIMFPCTL0G7RQKoWrCvoB+TaKBR/FDRYyLIOtzbYe
r3KCfb1b9ocP4FERIOXPWaeaFmk5cX6fDw3+UOr9w7h1UzKzRYGE+f2eQ9s2kPzy
kP6Cy6wJ5u1MbnqBDiw1+zZhLTDcP4g2wwWVNMVZdwspVfs5zpdSOwzcYRAhRQeY
0uy9tJ1HxveapA9WLQCrpEi09c3M3T3rHM8Ico04tpsqSmELqgvFhNaaULcBqQij
mmQD8nMmJJD2bGVxHl23JtpFFjgK0kDM7TmAxfpbBJc3MSf8cWaOpcZYrsOPmYaI
fCXIwzCt3eLMkz3/biTv4ORaXEjxuEn5a2c83DLNCiDIOBcZdXkewdorw+PJdxES
xoM8/2zc7jondgdJv/OMRccXi/AFHybz0pt46gT049vHNvKvBVH1DawYqKIVQb/T
4O0q+GgQhYRTCb3iz8ZPVEJoGcYiqi4J/xUpx7UAMNY8fYCUsUU=
=yzDe
-----END PGP SIGNATURE-----

--WrLvMy0clVxWGHYm--

