Return-Path: <netdev+bounces-11750-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC0D7343A6
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 22:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 673D1281451
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 20:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31A181F;
	Sat, 17 Jun 2023 20:38:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721DF7F4
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 20:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C30C433C0;
	Sat, 17 Jun 2023 20:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687034302;
	bh=/CHwpk9CBRFmj1qYfEWsG2JdH/bSAqaXeZPeerJdLOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ebt4yl7MR9pZwZCVuNh1wMiPjTlGYP6hkiDNUSQLteLPVD5x17gQ+FflSSpgJzgn1
	 yYgUNq0KU6O179Qb6GrWe1aPbuI4yBKBP7WmhkU8jY618VYxdV0vZwaiVJMbR63Iiq
	 +PBPISWdQ9NMXbZEDPkuGimMtk+aLYv+kfkmR4wAXKlKtATkmYcKrJc7dz7bgqATPH
	 5ou6RLA68W9zH9SyucniKOVoxMYGHdo02H1s61pNy76dqqqHSXCMBQDbP3lkzh7+7A
	 CkySlUNNcsPuoZR2cP9pTlFMILEVaPkxuIdrSIE1GFlun9ESFmXwlSqm3h1olsDYL/
	 4POqhexA3kEAw==
Date: Sat, 17 Jun 2023 21:38:15 +0100
From: Conor Dooley <conor@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Balakrishna Godavarthi <bgodavar@codeaurora.org>,
	Rocky Liao <rjliao@codeaurora.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: net: bluetooth: qualcomm: document
 VDD_CH1
Message-ID: <20230617-utmost-outboard-d0fbda0588af@spud>
References: <20230617165716.279857-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gBVqaVQp7SyCcKqF"
Content-Disposition: inline
In-Reply-To: <20230617165716.279857-1-krzysztof.kozlowski@linaro.org>


--gBVqaVQp7SyCcKqF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 17, 2023 at 06:57:16PM +0200, Krzysztof Kozlowski wrote:
> WCN3990 comes with two chains - CH0 and CH1 - where each takes VDD
> regulator.  It seems VDD_CH1 is optional (Linux driver does not care
> about it), so document it to fix dtbs_check warnings like:
>=20
>   sdm850-lenovo-yoga-c630.dtb: bluetooth: 'vddch1-supply' does not match =
any of the regexes: 'pinctrl-[0-9]+'
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--gBVqaVQp7SyCcKqF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZI4ZtwAKCRB4tDGHoIJi
0nOmAP9Iu+69skBmd4x6Z/VRLzT2M963rDxIErRC3I8Hndv75QEAhOIW+4qs7m7I
UA9aps2KgWb69bcn7axi+MB02oDPlww=
=QFLZ
-----END PGP SIGNATURE-----

--gBVqaVQp7SyCcKqF--

