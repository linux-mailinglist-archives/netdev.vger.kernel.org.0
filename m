Return-Path: <netdev+bounces-7525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB117208D2
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B798E1C2122B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D051C755;
	Fri,  2 Jun 2023 18:08:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB4D332F8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A36C433D2;
	Fri,  2 Jun 2023 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685729336;
	bh=10iJGgwrpA9wdDRNXV0ARDrh9AmyLZFipDpULgg9qvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TbkYTGEHSwUxDiRZrOzThXAUnd02tQTpo3hNE+sT+IAHpOR1gC5aOc5bExaaJBCmv
	 pS9BGwwnGB7/aRDcuyV95i6cG7xx/SlC5bc38jSVLdNTGYkekldw0SHAFF1K19kvwd
	 B/pjFX5sERUtP245CtZ0sSY95ecQXZRua4Zi+3nv+4QVG41TgkqB0bCFrto+SHM1nY
	 6mJrBQsjfRLsf8iyw5NQTSPK0S32dtugMfBn7rTF8RRqi3myNB4zxFf8fy3gfgaVoS
	 IHD3aG3nlfd+E/NkbzRHAlGsdGXyj/gt5HHmtRZChaGgvvCgH1i6nPZPaqlmjcV3tj
	 TzKt2DZgCbKow==
Date: Fri, 2 Jun 2023 19:08:50 +0100
From: Conor Dooley <conor@kernel.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arend Van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	bcm-kernel-feedback-list@broadcom.com,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH 1/3] dt-bindings: net: wireless: brcm,bcm4329-fmac: add
 BCM4366 binding
Message-ID: <20230602-wisplike-pretzel-5b6f8cf1a624@spud>
References: <20230602135925.14143-1-zajec5@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zqhB05ulchZ039cx"
Content-Disposition: inline
In-Reply-To: <20230602135925.14143-1-zajec5@gmail.com>


--zqhB05ulchZ039cx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 02, 2023 at 03:59:23PM +0200, Rafa=C5=82 Mi=C5=82ecki wrote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>=20
> It's an 802.11ac chipset that can be found hardwired in a lot of
> Northstar based routers.
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--zqhB05ulchZ039cx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHowMgAKCRB4tDGHoIJi
0pcQAQDeOMCRF1CoMkrPzchm1bsil3YUTdzfwtNe5c2+9CDkRAD9FgnA6rMUUjZu
Em/vsEbEem8RmhNFyEtI/M88IkYvxgs=
=xVIl
-----END PGP SIGNATURE-----

--zqhB05ulchZ039cx--

