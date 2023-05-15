Return-Path: <netdev+bounces-2733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2421B7038BA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28AF01C20C1F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D058FC13;
	Mon, 15 May 2023 17:34:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2861FC12
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 17:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106D6C433A1;
	Mon, 15 May 2023 17:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684172065;
	bh=ZhczMg7BcIRbvgQ6nKtaj0yIcga6i1Gg3pQFmQuOxFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oMgl1ycJpxn4uldR6cZJiQnZU/65OoKiShjWRSze6hCT1SKoSBxwY/ZoBha1x6NGt
	 Ad6s0x7YZRfz4C56Xx28lWAT7EnM6H2qqxJDKcoZHLFhhYH4eKFNj3+2sSWKnNBkOK
	 UYJcZozK/Ief3CdBIumcZ9Z4WEkXrKPWELR+b3z0PiVd2Nejk8Fh5jTXRIkaWDMaxP
	 k7ZlBnnRizzrtNEplHB00LQAozY2DUCc/DYbB3l99XrsfGB5lttzSUD348xz7zY4Ol
	 XG4zV74rk77vtyd/kcaIF2zlfODLGLMfzf2qbp3L1AO9r2VyrsjnEtvAVtKahdX0g5
	 pzc+rtW3H7LKg==
Date: Mon, 15 May 2023 18:34:16 +0100
From: Conor Dooley <conor@kernel.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Alexander Couzens <lynxis@fe80.eu>,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Bo Jiao <bo.jiao@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	MeiChia Chiu <MeiChia.Chiu@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wang Yufen <wangyufen@huawei.com>, Lorenz Brun <lorenz@brun.one>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 1/2] dt-bindings: net: wireless: mt76: add bindings
 for MT7981
Message-ID: <20230515-kilt-reanalyze-a38e556756e4@spud>
References: <cover.1684155848.git.daniel@makrotopia.org>
 <0f04fcc9f81cd15a8ee2a9194cf95f2b924ef299.1684155848.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4YT4Z+CDln4kywVw"
Content-Disposition: inline
In-Reply-To: <0f04fcc9f81cd15a8ee2a9194cf95f2b924ef299.1684155848.git.daniel@makrotopia.org>


--4YT4Z+CDln4kywVw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 15, 2023 at 03:25:59PM +0200, Daniel Golle wrote:
> Add mediatek,mt7981-wmac compatible string entry.

The driver patch gets a nice:
| Add support for the MediaTek MT7981 SoC which is similar to the MT7986
| but with a newer IP cores and only 2x ARM Cortex-A53 instead of 4x.
| Unlike MT7986 the MT7981 can only connect a single wireless frontend,
| usually MT7976 is used for DBDC.

That actually explains that there is something different between this
and the other listed compatibles. It'd be nice to have that in the
bindings patch too...

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

>=20
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../devicetree/bindings/net/wireless/mediatek,mt76.yaml          | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76=
=2Eyaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> index 67b63f119f64..9081731611ef 100644
> --- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> @@ -28,6 +28,7 @@ properties:
>        - mediatek,mt76
>        - mediatek,mt7628-wmac
>        - mediatek,mt7622-wmac
> +      - mediatek,mt7981-wmac
>        - mediatek,mt7986-wmac
> =20
>    reg:
> --=20
> 2.40.1
>=20

--4YT4Z+CDln4kywVw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGJtGAAKCRB4tDGHoIJi
0m8EAQDXmdphlAVTvvvqQJrTwZ4enaM2W2GFPoOhXz0fS8Vx0gD/bBbExt7v1pm3
pMR0d6NEE1L+GwbYb5+Li25BBZasnAs=
=e6RM
-----END PGP SIGNATURE-----

--4YT4Z+CDln4kywVw--

