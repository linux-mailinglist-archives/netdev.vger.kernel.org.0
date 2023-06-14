Return-Path: <netdev+bounces-10804-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BA217305D6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02DF51C20CB4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD702EC2B;
	Wed, 14 Jun 2023 17:17:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF057F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF752C433C0;
	Wed, 14 Jun 2023 17:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686763041;
	bh=Zbb5hoog/Puebf5TpE0Zp/30wehyw5cRswSRzy0cnzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UMAgsPU2w/Os3tuheNEwgrsYVzF0KDntSZDWhpoaIkJvdKEfreq7VkqNhB8klzELL
	 fUAty8wopY432ZG3xnDQwR7kAhMYJsfUVZbz6lJgv9AvcgtJHikfplJzltZor4P6xC
	 sf9n4FaIJe2SC0T1DOdDP8keigWyFsz/v8tTzBAMvl1F6Ov8f/dsL5uLHBYA372lx4
	 6qNiKj+BfbeMyjCqnGNszlZArKH6r8oowoDEwXW4rYoc+Z7eWW/2X3t5ef5aIAocrd
	 16AEQflZJgU7RONo4Nwi0bfbNxLNIM9R14ZipnssKpOCBoSTTLDiZCz1t01HhPZM78
	 CfGBJpzkgUBmQ==
Date: Wed, 14 Jun 2023 18:17:15 +0100
From: Conor Dooley <conor@kernel.org>
To: Leonard =?iso-8859-1?Q?G=F6hrs?= <l.goehrs@pengutronix.de>
Cc: Rob Herring <robh@kernel.org>,
	Alexandre TORGUE <alexandre.torgue@foss.st.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Woojung Huh <woojung.huh@microchip.com>,
	UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Marek Vasut <marex@denx.de>, kernel@pengutronix.de,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/8] dt-bindings: net: dsa: microchip: add interrupts
 property for ksz switches
Message-ID: <20230614-pessimism-celibate-bcd0a624b1c4@spud>
References: <20230614123222.4167460-1-l.goehrs@pengutronix.de>
 <20230614123222.4167460-6-l.goehrs@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Pdz20o4oV1AIZJKV"
Content-Disposition: inline
In-Reply-To: <20230614123222.4167460-6-l.goehrs@pengutronix.de>


--Pdz20o4oV1AIZJKV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 02:32:19PM +0200, Leonard G=F6hrs wrote:
> The ksz switch driver allows specifying an interrupt line to prevent
> having to periodically poll the switch for link ups/downs and other
> asynchronous events.
>=20
> Signed-off-by: Leonard G=F6hrs <l.goehrs@pengutronix.de>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--Pdz20o4oV1AIZJKV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIn2GwAKCRB4tDGHoIJi
0nSKAQCaRAF7G/E8L+4Tdad/M48ZtCCFwHTCF2KLVFSi85SwCAD/eEV8HMRTM4ez
KGL/OAwHa27KLQ06AeWPKj1QNwQMCAc=
=DQ6b
-----END PGP SIGNATURE-----

--Pdz20o4oV1AIZJKV--

