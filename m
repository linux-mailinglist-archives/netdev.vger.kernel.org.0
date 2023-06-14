Return-Path: <netdev+bounces-10803-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F00A77305D1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F8E0281423
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203062EC27;
	Wed, 14 Jun 2023 17:16:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EB47F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539F2C433C8;
	Wed, 14 Jun 2023 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686763014;
	bh=NHe088c1o+Jq210BxHdiVxxRFtRSMBshsrQJ+SPLxbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bWtgCU+6ufuU6Xdic33eWjkskELBMGTngTkrUEGc2GDt6cLDaNKiK2DCjtdr8rjuz
	 qkQ6ZI5OCnHqXWXmefvVWT++3kK5iYtLBPRMtGU2vgWztYuteLXv1C2zGDFYm28QUL
	 mKzhiSG4Jr0ve0wpMHL6KU+jSWgUWdJrkWnwpl86SV8lPoBDV7ay4pAzanQuaGXv54
	 LrF/JUgxDKJhYUJyYlpWEmLL6PnpykkHdHuLGXxiObMmO3bL55CeqvwXjYLsMOgVhD
	 QiiOvZFwOLKzoofqXFj/0a8TrXCSQNFnmqGCjZKC0gy3sYAzNrTFvr6Vjl1rJQc+a3
	 /an1uiIrjBY8g==
Date: Wed, 14 Jun 2023 18:16:49 +0100
From: Conor Dooley <conor@kernel.org>
To: Leonard =?iso-8859-1?Q?G=F6hrs?= <l.goehrs@pengutronix.de>
Cc: Rob Herring <robh@kernel.org>,
	Alexandre TORGUE <alexandre.torgue@foss.st.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	kernel@pengutronix.de, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-can@vger.kernel.org,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] dt-bindings: can: m_can: change from additional-
 to unevaluatedProperties
Message-ID: <20230614-chomp-surfer-6866386bfa9b@spud>
References: <20230614123222.4167460-1-l.goehrs@pengutronix.de>
 <20230614123222.4167460-5-l.goehrs@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NyTjScBlhm/mrubF"
Content-Disposition: inline
In-Reply-To: <20230614123222.4167460-5-l.goehrs@pengutronix.de>


--NyTjScBlhm/mrubF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 02:32:18PM +0200, Leonard G=F6hrs wrote:
> This allows the usage of properties like termination-gpios and
> termination-ohms, which are specified in can-controller.yaml
> but were previously not usable due to additionalProperties: false.
>=20
> Signed-off-by: Leonard G=F6hrs <l.goehrs@pengutronix.de>
> Suggested-by: Rob Herring <robh@kernel.org>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--NyTjScBlhm/mrubF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIn2AAAKCRB4tDGHoIJi
0oSnAP9t/ky4bUHtrdCYyGTGf+rlOh9PaoIb1M2yCjvlHffP4QEA8GHfeb9pYWCG
B95yVv/Jd4LlGTcac4lxeVqws9djzgw=
=OjL8
-----END PGP SIGNATURE-----

--NyTjScBlhm/mrubF--

