Return-Path: <netdev+bounces-12071-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00114735E2B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA7401C209E6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A0414A8E;
	Mon, 19 Jun 2023 20:06:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1779714A88
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AE7C433C0;
	Mon, 19 Jun 2023 20:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687205174;
	bh=CTxCMk1gTTUHDIrUKyoalHysRRGv6bTbdPSH/3zbi5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TIQTVfeYtBre7rWe8mp0bQlH/s+0b6z1oAmHfdXAyHNEmr7q3Nn69xHczgv/dtMZi
	 tuCdsCB0LyQYhSRCMZB5KumypM+b/RkXwiaSmxAuc60kddU+09MBFuC9luPtVc/jos
	 JcIW2Sb6ZHrqprYBq7nhZQlD2tQkR+EskgAto9tnZA0mtvZpiq52NkwjznRRmhlS7l
	 Ym7UxQfUpiaNNIZycmSGkqetlAGyCYUFiAh1XKlq6uJ5gDlOpj3Ji8QhCyZp21PzER
	 /3rP9Mjh5bWePyXn/d/HivSH31jJ8m9AnFWDed6vrvI90tnnUXYS+dZ4CosP/HLv5f
	 WexPSroD6RIsw==
Date: Mon, 19 Jun 2023 21:06:09 +0100
From: Conor Dooley <conor@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, Marek Vasut <marex@denx.de>,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: net: micrel,ks8851: allow SPI
 device properties
Message-ID: <20230619-aware-robin-789ada1c6db4@spud>
References: <20230619170134.65395-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Nal+MxCjpXktrc4o"
Content-Disposition: inline
In-Reply-To: <20230619170134.65395-1-krzysztof.kozlowski@linaro.org>


--Nal+MxCjpXktrc4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 19, 2023 at 07:01:34PM +0200, Krzysztof Kozlowski wrote:
> The Micrel KS8851 can be attached to SPI or parallel bus and the
> difference is expressed in compatibles.  Allow common SPI properties
> when this is a SPI variant and narrow the parallel memory bus properties
> to the second case.
>=20
> This fixes dtbs_check warning:
>=20
>   qcom-msm8960-cdp.dtb: ethernet@0: Unevaluated properties are not allowe=
d ('spi-max-frequency' was unexpected)
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Cheers,
Conor.

--Nal+MxCjpXktrc4o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZJC1MQAKCRB4tDGHoIJi
0rWMAQCcFMIt8ItKOlPO3UX2ZtobWQGO+xcS/uHckB0dDYyWIwEA/cUiCww3Nisg
NpZFU/CH5HUAVJOzke4wq4gzE/zngwA=
=0/YM
-----END PGP SIGNATURE-----

--Nal+MxCjpXktrc4o--

