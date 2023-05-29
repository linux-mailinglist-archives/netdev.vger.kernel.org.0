Return-Path: <netdev+bounces-6161-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E46714F66
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12E051C20ABD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A4B8C12;
	Mon, 29 May 2023 18:36:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227FC7C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCECC433D2;
	Mon, 29 May 2023 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685385368;
	bh=lkTfNrYOzCpI6SoJNVwaVPp2FKlAnmBT7ORl+lXnr8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PtFPe3kDIykYxjwzabBZHJtnv4O8hLCMDBeWrQClthr/SU4D1WMpa7v6pkwJ/a70E
	 nH4QeRLPkjUnu7qq5LXJh/sFyvz8nqwGSTqnBvlxByRTK6TyrJczkIBqJTNC3U7iuw
	 ujFSGtyg7bYwhwKAz/tU5jA86PcqCvRc4lsQs+4hfZCfBhdexJfzlsx0S49jVLaOcA
	 lOMO0xXJY9KKjb+2Q5Faa5kxxpkAqMidCaQOMxit47KIOz0dTqzDkmsop89Jf1mMDv
	 8BoGWF6zJUQvcUorlTYmxHs17s/syiEM7Xzo23vBnVIYCUAT9ioIxhfx4fqaUr1KZ3
	 xSNYp7O7WxZkw==
Date: Mon, 29 May 2023 19:36:03 +0100
From: Conor Dooley <conor@kernel.org>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	geert+renesas@glider.be, magnus.damm@gmail.com,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: r8a779f0-ether-switch:
 Add ACLK
Message-ID: <20230529-cassette-carnivore-4109a31ccd11@spud>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8OwMbtV6y5wx6lrz"
Content-Disposition: inline
In-Reply-To: <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>


--8OwMbtV6y5wx6lrz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Mon, May 29, 2023 at 05:08:36PM +0900, Yoshihiro Shimoda wrote:
> Add ACLK of GWCA which needs to calculate registers' values for
> rate limiter feature.
>=20
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  .../bindings/net/renesas,r8a779f0-ether-switch.yaml    | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether=
-switch.yaml b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether=
-switch.yaml
> index e933a1e48d67..cbe05fdcadaf 100644
> --- a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch=
=2Eyaml
> +++ b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch=
=2Eyaml
> @@ -75,7 +75,12 @@ properties:
>        - const: rmac2_phy
> =20
>    clocks:
> -    maxItems: 1
> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - const: fck
> +      - const: aclk

Since having both clocks is now required, please add some detail in the
commit message about why that is the case. Reading it sounds like this
is an optional new feature & not something that is required.

Thanks,
Conor.

> =20
>    resets:
>      maxItems: 1
> @@ -221,7 +226,8 @@ examples:
>                            "rmac2_mdio",
>                            "rmac0_phy", "rmac1_phy",
>                            "rmac2_phy";
> -        clocks =3D <&cpg CPG_MOD 1505>;
> +        clocks =3D <&cpg CPG_MOD 1505>, <&cpg CPG_CORE R8A779F0_CLK_S0D2=
_HSC>;
> +        clock-names =3D "fck", "aclk";
>          power-domains =3D <&sysc R8A779F0_PD_ALWAYS_ON>;
>          resets =3D <&cpg 1505>;
> =20
> --=20
> 2.25.1
>=20

--8OwMbtV6y5wx6lrz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHTwkwAKCRB4tDGHoIJi
0ioFAP99inWrlxukmjHpvT9VUVemMgcZA3zU47zhjrwDpVsQDwEAwLykfanYED3H
ymxwPcszUZKtk/BEKJfD1oEUiQLfpgg=
=le1N
-----END PGP SIGNATURE-----

--8OwMbtV6y5wx6lrz--

