Return-Path: <netdev+bounces-4765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3F8C70E284
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F3E31C20A48
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC04206A4;
	Tue, 23 May 2023 16:58:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469DF4C91
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698BBC433D2;
	Tue, 23 May 2023 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684861114;
	bh=Y5FZGJOVD6fWSyOkSrV9mHh+QEcVsnYTwwIwtV+YJIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kvsP8s1MjKTuRt9j6veIKTkaS75MerI1Jjz5VIozlpG+QzliQq01SpTU2H5A4PiJD
	 KINeqqXwrENNizksF/jVOQScMYbxWiwoq5QwE8RIrzuA+b+tneITfBDBuHKlDJ+GX8
	 GpmtNTEjSA9rmvUfGqjTEIgdgcxI5aSLhts4gvs+rYUmydJo1Ir5dUoo9TK/TF+rBP
	 4RSGOO1sZaJ8aafENCvrrYiP/EQEeilHfxJHkq5KbO9Pkk3mbv9rgT8WBCbu1BZBz3
	 9OMpEZjrzUu/94i3KZMrbqVKtYfCxHEHaxCXc4OW+3LL09Z6Yt2NXgqVeN+eLTPkc/
	 e/lReVponM9bA==
Date: Tue, 23 May 2023 17:58:28 +0100
From: Conor Dooley <conor@kernel.org>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Schuyler Patton <spatton@ti.com>, Tero Kristo <kristo@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v7 1/2] dt-bindings: net: can: Remove interrupt
 properties for MCAN
Message-ID: <20230523-sliding-brethren-17ce71cdb8bd@spud>
References: <20230523023749.4526-1-jm@ti.com>
 <20230523023749.4526-2-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PXixhndM8VNwGChl"
Content-Disposition: inline
In-Reply-To: <20230523023749.4526-2-jm@ti.com>


--PXixhndM8VNwGChl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 22, 2023 at 09:37:48PM -0500, Judith Mendez wrote:
> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
> routed to A53 Linux, instead they will use software interrupt by
> timer polling.
>=20
> To enable timer polling method, interrupts should be
> optional so remove interrupts property from required section and
> add an example for MCAN node with timer polling enabled.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--PXixhndM8VNwGChl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGzwswAKCRB4tDGHoIJi
0tXCAP9ltNbM9GBm65IeJW558coKXOtltJqAmSNzBzMM+Fm7cgD/eWve/kUtYKU8
tRZCBLPf2SA/ay8T2++x+f3Rt4QDkwM=
=al3C
-----END PGP SIGNATURE-----

--PXixhndM8VNwGChl--

