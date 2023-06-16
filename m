Return-Path: <netdev+bounces-11545-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0F373385D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B911A2816B0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062091ACC2;
	Fri, 16 Jun 2023 18:52:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7FB171DE
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ACCC433C8;
	Fri, 16 Jun 2023 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686941544;
	bh=SnILc4tHzLQ9qrWedm4qlSPGM6MMXgUtHYq78NQdHfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iUqw7j+HeuoziYt9RbZCtqc64v+4G8v1edN3GQo4dVrs8cP0pYDBRLyr3g3RMkjL2
	 oPprPOtTyghZTTdiSDa7G2/c3Dc/vDfBXIIr5C7a3Cap2ycoLvw/rpuwKN0vq1yjQr
	 4B5WRMfgCFIsAo6ll4rl6MEz/eO4YMqlIcVETg58DdNwK0jvm4P++lNzCliGEOKeEf
	 QMhuaPfMlWzxplJPj2Pj3O1JIfiIXMMEHMA+PZR2mpRWL+QuboRLHFkzDxBNNnDVOX
	 l80E37UZxLBzpUsiZI6MOaQ+i+7FE8qrrRTe4XqojVDupcp2SR2Ud20w+8bYyELRGD
	 KR8K0rWKiE0pg==
Date: Fri, 16 Jun 2023 19:52:18 +0100
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
Subject: Re: [RFT PATCH 1/2] stmmac: dwmac-loongson: drop useless check for
 compatible fallback
Message-ID: <20230616-activity-shed-be3c13e5ac71@spud>
References: <20230616103127.285608-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IZVYiw4TzhyBwr89"
Content-Disposition: inline
In-Reply-To: <20230616103127.285608-1-krzysztof.kozlowski@linaro.org>


--IZVYiw4TzhyBwr89
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 12:31:26PM +0200, Krzysztof Kozlowski wrote:
> Device binds to proper PCI ID (LOONGSON, 0x7a03), already listed in DTS,
> so checking for some other compatible does not make sense.  It cannot be
> bound to unsupported platform.
>=20
> Drop useless, incorrect (space in between) and undocumented compatible.
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Might be worth noting that dropping it is required to allow the
new loongarch dts stuff to be functional with a sane set of compatibles.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--IZVYiw4TzhyBwr89
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIyvYQAKCRB4tDGHoIJi
0g+bAPwIqFpdSVFR1J6wtacOyxZPUWWrlEBqpTPyxDWe+xdBWwEA2ZuQq95BtjsK
MOqgX/xyqqlAFwqAfioKQf/5rfup/gI=
=hq3B
-----END PGP SIGNATURE-----

--IZVYiw4TzhyBwr89--

