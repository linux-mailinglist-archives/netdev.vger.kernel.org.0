Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A013401B6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 10:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCRJQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 05:16:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:50548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhCRJQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 05:16:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F0AC2AC1E;
        Thu, 18 Mar 2021 09:16:12 +0000 (UTC)
Message-ID: <13fafc4dbbb8b4e9c68c71aabcff08751123b0b2.camel@suse.de>
Subject: Re: [PATCH] dt-bindings: Drop type references on common properties
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@kernel.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Alex Elder <elder@kernel.org>, Suman Anna <s-anna@ti.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Date:   Thu, 18 Mar 2021 10:16:10 +0100
In-Reply-To: <20210316194858.3527845-1-robh@kernel.org>
References: <20210316194858.3527845-1-robh@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-09POy/eeqAoG7Dif8JG1"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-09POy/eeqAoG7Dif8JG1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-03-16 at 13:48 -0600, Rob Herring wrote:
> Users of common properties shouldn't have a type definition as the
> common schemas already have one. Drop all the unnecessary type
> references in the tree.
>=20
> A meta-schema update to catch these is pending.
>=20
> Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Cheng-Yi Chiang <cychiang@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stefan Wahren <wahrenst@gmx.net>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Odelu Kukatla <okukatla@codeaurora.org>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Suman Anna <s-anna@ti.com>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-remoteproc@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> =C2=A0.../bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml       | 5 +-=
---

				^
				|

Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

Regards,
Nicolas


--=-09POy/eeqAoG7Dif8JG1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAmBTGloACgkQlfZmHno8
x/7QBgf/X2Of8KHkQ7koHtulAqLWqHAwLmJ4UDf2ZhAm+Zpb3naXS4ZTQoQtZBv1
7M+tRcB2B9eLSvYEYeWk9b3ainWXmwZA6NoAdda2c+KtEhEBlD1o2ZwHJ6Tt2RRW
QbunvwfPBhoO3zNadU6v3x6sm5rw+lt/H1nSl8VnuujI1xI2+g0gjZPoeDbhQpVm
FJLknBJjqlla9y1V90oh+tQ3b4R5HaHrxNEjEG/8OYFEL7GFFk282vTcrHhbGayu
GN4wW0M04rFTlJ/GdO36Vr7zUUfU+/YqbbkglcoUh2UE2LButL3/31k/x6NetOws
Ac1+8c7ZkXpssyBFvebQ4A/csN88Dw==
=87aF
-----END PGP SIGNATURE-----

--=-09POy/eeqAoG7Dif8JG1--

