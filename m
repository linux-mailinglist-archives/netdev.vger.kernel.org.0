Return-Path: <netdev+bounces-3769-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85DE7708AB3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 23:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28075280ED9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 21:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061B62099B;
	Thu, 18 May 2023 21:43:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDCF134C8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 21:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893EFC433D2;
	Thu, 18 May 2023 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684446224;
	bh=K5xEeU1mCoS/OcrSjPJzbDiJWn0dLzXGU8F7Uq+vaiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z8O9DHsXQ7ixpbmHAwzzZ2YY7NsU7T0laR+7Rw60X1rR66jZYjs1n8mzpc2a+bCof
	 Iihi1/FYLdZtmgRAB0K61CWx3p6JR1+Y5FoNhgaOYNCK7ZyGwB3tqOr3L15SJceHzv
	 NPGwAEsfg5hpGoLenhLr0qeLmm9X5ChldfLVDlU71tOPBa4G1C6ypJ4g6LAMRZODOG
	 PTeMzAm1hd2R1wcQcZbRinNjibK6Sb9XNPSPeVRy35cEOfgIvfwHTH0NP55sqQhs19
	 rzTnLdgCn+BO8ZcLXFM2dnanLgDfoZsDWJdfyBVcaecUsW7u4r2b+tyQdCW84/LNKG
	 f98g0Tw2Sl4KA==
Date: Thu, 18 May 2023 22:43:39 +0100
From: Conor Dooley <conor@kernel.org>
To: alexis.lothore@bootlin.com
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com, paul.arola@telus.com,
	scott.roberts@telus.com
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: marvell: add
 MV88E6361 switch to compatibility list
Message-ID: <20230518-sporting-tweezers-14cee98a4832@spud>
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
 <20230517203430.448705-2-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="l0BAS8I4h0k//Wt/"
Content-Disposition: inline
In-Reply-To: <20230517203430.448705-2-alexis.lothore@bootlin.com>


--l0BAS8I4h0k//Wt/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 17, 2023 at 10:34:29PM +0200, alexis.lothore@bootlin.com wrote:
> From: Alexis Lothor=E9 <alexis.lothore@bootlin.com>
>=20
> Marvell MV88E6361 is an 8-port switch derived from the
> 88E6393X/88E9193X/88E6191X switches family. Since its functional behavior
> is very close to switches from this family, it can benefit from existing
> drivers for this family, so add it to the list of compatible switches
>=20
> Signed-off-by: Alexis Lothor=E9 <alexis.lothore@bootlin.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--l0BAS8I4h0k//Wt/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGacCgAKCRB4tDGHoIJi
0pNtAP9Z3CouQuLHG/+Yypu0zs/7meyJHceLCh6LCSAsRqLvNwEA2T8Kag0bW8kh
8+SyrKFgL5BuNOiHglfhLmXHtOciagM=
=IO47
-----END PGP SIGNATURE-----

--l0BAS8I4h0k//Wt/--

