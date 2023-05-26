Return-Path: <netdev+bounces-5810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31AC5712DBE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 21:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA8B628198D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7EE2911D;
	Fri, 26 May 2023 19:41:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C90B24E96
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 19:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A6FC433D2;
	Fri, 26 May 2023 19:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685130107;
	bh=A14wYRd6bd3k17uq6bZSud2jdXo9S6kL3opZr6tnAVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MB+hILdtM6md541XzDe7RBrwh40QGaXBDxZSD4EJTfzBv5grj2tywoPa7Ocfo0vHz
	 gTzc2aGc9ytleWo+UzhtXz4/vw70KQcT+ptYx/94dQ39T/NZZSuTpa718jCjfnMmkL
	 Iza5uhIxRfRMHG9AYjrT1JUH9KK/ONoZZcEeRUvcVxYAv4KrosHwDVr+dmcFsLSkRC
	 /jWe9cRHDrUvchYl61UcHTmqrEZtWeFVeoho7MhNrqmfWy6dJ8qJYAbsAfPlIHyJxl
	 c68BVcuU66iDC19URkpayCQ1w+ngllXCz88FUEmOFniMgN+1vUxLPwJteyl8tWZfSN
	 pzarNOl5zG9wQ==
Date: Fri, 26 May 2023 20:41:42 +0100
From: Conor Dooley <conor@kernel.org>
To: Samin Guo <samin.guo@starfivetech.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	netdev@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
	Frank <Frank.Sae@motor-comm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
Message-ID: <20230526-glutinous-pristine-fed571235b80@spud>
References: <20230526090502.29835-1-samin.guo@starfivetech.com>
 <20230526090502.29835-2-samin.guo@starfivetech.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LKgeoOkBxI+igG/k"
Content-Disposition: inline
In-Reply-To: <20230526090502.29835-2-samin.guo@starfivetech.com>


--LKgeoOkBxI+igG/k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 26, 2023 at 05:05:01PM +0800, Samin Guo wrote:
> The motorcomm phy (YT8531) supports the ability to adjust the drive
> strength of the rx_clk/rx_data, the value range of pad driver
> strength is 0 to 7.
>=20
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../devicetree/bindings/net/motorcomm,yt8xxx.yaml    | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml =
b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> index 157e3bbcaf6f..29a1997a1577 100644
> --- a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> @@ -52,6 +52,18 @@ properties:
>        for a timer.
>      type: boolean
> =20
> +  motorcomm,rx-clk-driver-strength:
> +    description: drive strength of rx_clk pad.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]

I think you should use minimum & maximum instead of these listed out
enums. You have also had this comment since v1 & were reminded of it on
v2 by Krzysztof: "What do the numbers mean? What are the units? mA?"

This information should go into the binding, not sit in a thread on a
mailing list that noone will look at when trying to write a DT :(

Thanks,
Conor.

> +    default: 3
> +
> +  motorcomm,rx-data-driver-strength:
> +    description: drive strength of rx_data/rx_ctl rgmii pad.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
> +    default: 3
> +
>    motorcomm,tx-clk-adj-enabled:
>      description: |
>        This configuration is mainly to adapt to VF2 with JH7110 SoC.
> --=20
> 2.17.1
>=20

--LKgeoOkBxI+igG/k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHELdgAKCRB4tDGHoIJi
0hbCAQDvuvTSWPRNxoXFvIBvoNjD4hQVJI4ztANnrP+SfIKHSQEA5AVSZPpJUEdS
a3v4ifW/rEkkCs/0+vamGkR5ULUIowQ=
=4puj
-----END PGP SIGNATURE-----

--LKgeoOkBxI+igG/k--

