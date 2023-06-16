Return-Path: <netdev+bounces-11546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47989733863
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79C991C21013
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C871ACC6;
	Fri, 16 Jun 2023 18:52:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481DD101F6
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C0BC433C8;
	Fri, 16 Jun 2023 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686941575;
	bh=rXAOuleexf719oHBItUk2/1HRdDKOpd0Rj6yJJRrZ0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uQptDTGP6Gn5u0IixUqZ1YrSYll9/0BBhDNyEJvj0XDP207w7DKIu1lqUjRY3h37M
	 NDtqDTYCvbYbm+ZuqFr2gUpCgyBzb3yhHiHJMnxLmbF4xQ10dku4w4LdXprTP9Y9F/
	 JOaCvPMVReWRlrdXG7gjSn/28bkKw59m3f6SQrw28VqOnQ+Mv3H2+vgb4ht5O59MVt
	 ZdDiLCFfO38C+BkPtipARwzQEYSoEpDLkfHAhVUI3siXj06po2bpl3az9EUhaIaKro
	 1jtf8AqxNos4QbgIptygfz8k4dHPstRcWQh0IJ5K3oCky7TpkvYO79i2lNN0C+ezPt
	 KKSySXPPnc3hw==
Date: Fri, 16 Jun 2023 19:52:49 +0100
From: Conor Dooley <conor@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [RFT PATCH 2/2] MIPS: dts: loongson: drop incorrect dwmac
 fallback compatible
Message-ID: <20230616-afar-glove-a58d8ea5576e@spud>
References: <20230616103127.285608-1-krzysztof.kozlowski@linaro.org>
 <20230616103127.285608-2-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="v5Uzg8JAkxoXp3OM"
Content-Disposition: inline
In-Reply-To: <20230616103127.285608-2-krzysztof.kozlowski@linaro.org>


--v5Uzg8JAkxoXp3OM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 12:31:27PM +0200, Krzysztof Kozlowski wrote:
> Device binds to proper PCI ID (LOONGSON, 0x7a03), already listed in DTS,
> so checking for some other compatible does not make sense.  It cannot be
> bound to unsupported platform.
>=20
> Drop useless, incorrect (space in between) and undocumented compatible.
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--v5Uzg8JAkxoXp3OM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIyvgQAKCRB4tDGHoIJi
0kPBAP9ge4BqKvCvx5l997dp/dJGtEyDhTnNVPpcziB52eZb+wD/VzpfQUv9mSIf
qO6NQbomXWFOYzC4upKMWuIoMqQ0Egs=
=OY/b
-----END PGP SIGNATURE-----

--v5Uzg8JAkxoXp3OM--

