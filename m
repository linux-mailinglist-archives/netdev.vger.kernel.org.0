Return-Path: <netdev+bounces-1970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F01036FFCA1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 00:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2D5D1C21090
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A77317730;
	Thu, 11 May 2023 22:29:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B071A174F0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 22:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92B0C433EF;
	Thu, 11 May 2023 22:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683844166;
	bh=JTzpkxSr+WUr9mtwXRAATmDWd54k8NYw09DpF3q2F8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H7xHg04127AaUCeXJEtiVTjf+c2HWlvGS2BaNojXk9aqOgK9I4+rTaXlC3dBOg5Wx
	 yquhLWhV0pIh3nJ2gBQ02OwcpUueebcI9okxB7dxkaY1t55EzqHvlvC82CrtLBfR3m
	 Te45ZfCRrUb9mFZ2X9h3ZaeWE1mZy+R6LOjQcbDMAw3MeBF2cOLvoBW2+kR+I9cwPL
	 /nXqfT0JnCdd+wrwzi3jPnMx/KI15bZl/7lvZ5s0XzOmOuMFy/QmnuKczuDHnbnpSS
	 nFNMWQFdYEfsU1zWZM2KBKHJQrPS94n0iAVjExjGLNnF5CaEAGwbUQK+Y3Shrm0w2w
	 GK8LIZVQjPgfw==
Date: Thu, 11 May 2023 23:29:20 +0100
From: Conor Dooley <conor@kernel.org>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Pranavi Somisetty <pranavi.somisetty@amd.com>,
	nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com, linux@armlinux.org.uk,
	palmer@dabbelt.com, git@amd.com, michal.simek@amd.com,
	harini.katakam@amd.com, radhey.shyam.pandey@amd.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: cdns,macb: Add
 rx-watermark property
Message-ID: <20230511-unhidden-mummify-800fe847e25d@spud>
References: <20230511071214.18611-1-pranavi.somisetty@amd.com>
 <20230511071214.18611-2-pranavi.somisetty@amd.com>
 <20230511-canned-gray-005130594368@wendy>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cp1Gsw0Yd1cfGjfb"
Content-Disposition: inline
In-Reply-To: <20230511-canned-gray-005130594368@wendy>


--cp1Gsw0Yd1cfGjfb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 11, 2023 at 08:25:15AM +0100, Conor Dooley wrote:
> On Thu, May 11, 2023 at 01:12:13AM -0600, Pranavi Somisetty wrote:
> > watermark value is the minimum amount of packet data
> > required to activate the forwarding process. The watermark
> > implementation and maximum size is dependent on the device
> > where Cadence MACB/GEM is used.
> >=20
> > Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
>=20
> Please send dt-binding patches to the dt-binding maintainers and list.
> get_maintainer.pl should have told you to do so & without having done
> so, the bindings will not get tested :/

The automation we run for the linux-riscv did actually run against
this though, and even dtbs_check complains about this binding:

Documentation/devicetree/bindings/net/cdns,macb.yaml: properties:rx-waterma=
rk:maxItems: False schema does not allow 1
	hint: Scalar properties should not have array keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#

Please test your bindings :/

Cheers,
Conor.

--cp1Gsw0Yd1cfGjfb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZF1sQAAKCRB4tDGHoIJi
0mx8AQDvCXrHHAJUliEbLe3FqTXIyyuFRBHjHbmN16sg23MaCwEAwYNs6Dk9vDu4
ES17DcW0ax+qchBDdyxacGBtlx2oswU=
=lc3I
-----END PGP SIGNATURE-----

--cp1Gsw0Yd1cfGjfb--

