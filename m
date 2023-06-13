Return-Path: <netdev+bounces-10523-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B8D72ED6C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 733F01C20404
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C49427217;
	Tue, 13 Jun 2023 20:57:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F16174FA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 20:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C154C433C0;
	Tue, 13 Jun 2023 20:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686689867;
	bh=16rG3Y0vOlpHVgnmwY42ppaSUcT2KRuT590yu9eCc0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EQUWBXsi0EP8QFDoW1PhOPTaNCzUaa2ygBgSHBdDJakb+67u6JKik08mC/OIv4IkZ
	 fM/D2m710nuqtuEOeGtfpDDUT2E11TRRGLqeO/VaEmnXnq8kpr0FLePxmFcF+tcD7N
	 ZSqj8Ke0Om6QowL4BxL/qmLt1SPlRymOoCvkLBO425Yn7g70EqAoDRGmfzfqNKPfZN
	 uwv3P/7H+q2GyuoGt8jhrP0TRp1qks825yCdM8PDD7fn4FN2ljl+nwyBLhJamx00KY
	 pEz7y4aP8iGZsQ/iaVsiiQbYHlVn4tfUXSDAUb+8c6qxv9EJF0A6ttxoNYDVuu5Qja
	 q/Z+8pz1DQXhg==
Date: Tue, 13 Jun 2023 21:57:42 +0100
From: Conor Dooley <conor@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Amitkumar Karwar <amitkumar.karwar@nxp.com>,
	Neeraj Kale <neeraj.sanjaykale@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: bluetooth: nxp: Add missing type for
 "fw-init-baudrate"
Message-ID: <20230613-underfed-divinity-6b0736a99845@spud>
References: <20230613200929.2822137-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gTLLYxVJbP1O93MX"
Content-Disposition: inline
In-Reply-To: <20230613200929.2822137-1-robh@kernel.org>


--gTLLYxVJbP1O93MX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 13, 2023 at 02:09:29PM -0600, Rob Herring wrote:
> "fw-init-baudrate" is missing a type, add it. While we're here, define the
> default value with a schema rather than freeform text.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--gTLLYxVJbP1O93MX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIjYRgAKCRB4tDGHoIJi
0irFAQCaXswTCJpW35F1LAkKLWwzD5HgwW1DCUp81fSoIGrZogEA6eyHcuhFLmsy
j5XMZ+mgGcqayNc3lJcyVY47JCgfPgI=
=RTuu
-----END PGP SIGNATURE-----

--gTLLYxVJbP1O93MX--

