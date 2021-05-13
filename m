Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9187337FAC6
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 17:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhEMPfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 11:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhEMPfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 11:35:18 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952BBC061574;
        Thu, 13 May 2021 08:34:08 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id 4FF711F42C47
Received: by earth.universe (Postfix, from userid 1000)
        id D36D73C0C95; Thu, 13 May 2021 17:34:02 +0200 (CEST)
Date:   Thu, 13 May 2021 17:34:02 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Alex Elder <elder@kernel.org>,
        Shengjiu Wang <shengjiu.wang@nxp.com>,
        linux-clk@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: More removals of type references on common
 properties
Message-ID: <20210513153402.q3w42oayif2l7rf4@earth.universe>
References: <20210510204524.617390-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6zntmlcncahxaxdz"
Content-Disposition: inline
In-Reply-To: <20210510204524.617390-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6zntmlcncahxaxdz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 10, 2021 at 03:45:24PM -0500, Rob Herring wrote:
> Users of common properties shouldn't have a type definition as the
> common schemas already have one. A few new ones slipped in and
> *-names was missed in the last clean-up pass. Drop all the unnecessary
> type references in the tree.
>=20
> A meta-schema update to catch these is pending.
>=20
> Cc: Luca Ceresoli <luca@lucaceresoli.net>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Olivier Moysan <olivier.moysan@foss.st.com>
> Cc: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Georgi Djakov <djakov@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Orson Zhai <orsonzhai@gmail.com>
> Cc: Baolin Wang <baolin.wang7@gmail.com>
> Cc: Chunyan Zhang <zhang.lyra@gmail.com>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Fabrice Gasnier <fabrice.gasnier@st.com>
> Cc: Odelu Kukatla <okukatla@codeaurora.org>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Shengjiu Wang <shengjiu.wang@nxp.com>
> Cc: linux-clk@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> [...]
>  .../devicetree/bindings/power/supply/sc2731-charger.yaml        | 2 +-
> [...]

Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>

-- Sebastian

--6zntmlcncahxaxdz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmCdRuoACgkQ2O7X88g7
+pp2eRAAji89IV6U3huPwd3QFqIvXt4J/smg1VWppBF8MRaAl/GQyC0ulamRL7Nw
JjkjziYNiLcykycKuiWb89OfBsoCPVS5WKRNvI5ckZTu2egIE+lEr7mACjughIpk
xp0NvbW8iIO3WxjnYh8LkFwJm4GxphCqlUkl32HKbafHkW9UKVEh8Ex6eoqnUk63
RXluSTs0bDdfkeGzWaR4/2ZBJh+iHoaoVbPiqTr4lLCfIEpg+6tERKBeIHFL82fE
8bxpm8/YAiG3ymllKDDzQIMTt1NHbBs4WtUcUq4X2gIlRFrLnV8w0DXmVPwDynKW
tN9mYEhHqR1y8bc0dx5X++M9ZEWX67GbuGa1+Om1rdSnnM2uxEwQEjht7JjpLFg3
n4urCpUbQjh+uW/hkNZjQlWb43TuUmslUrutHts+vlwf2vD6srxH0uy9I/GwtVGg
7CtZBtofKACRiYO2Aud7iaMuWYd8wYFx6gfuw7WY9tUJ5vlwQacPeLqedRcYWLPj
N5y/tY01/DqTBHFJmjUqCsvR2R+W17P9zO0Q4sB+wYLtE82H7O5suUkZFpe79bn5
rVpnaz3YAWirzucHrMpOsPVP8gs5taBkdSTKClnSQLek1Z/WJKwPAq26gqZ/EPOw
EJBYc0TMSmzTJIoRSkXxJGAeSwiDp8wCTFJA6r/QyASeQkGfqrM=
=Tg1h
-----END PGP SIGNATURE-----

--6zntmlcncahxaxdz--
