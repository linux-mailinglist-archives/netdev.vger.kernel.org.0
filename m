Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7EF1EDA72
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 03:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgFDB3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 21:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgFDB3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 21:29:44 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14680C03E96D;
        Wed,  3 Jun 2020 18:29:44 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49cp9K3xn0z9sRN;
        Thu,  4 Jun 2020 11:29:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591234182;
        bh=2KHuzZQ+RXbR0wHAx6Mzf1ntNTqMB1evvaLV+unE6SM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jInMOd/bs3ql88HiEtcxMyYGci1n6EP7ak52X5WJuc344KUNT+yIXWESxV9YGuUBL
         aSOm5Pif+/q8OnkPV/A2iQxuob9cqpF+OoQBHfsWgLglWyM62xyzLyuSjva2HZ1b1n
         WeOFGacVn5TifZHHq2SD7135PwKju7o23dCdehUjUSLbr6GWOlvBTMurY8DkoNE8nz
         v7wKyM7Ub/p4LX1pMTtWdeFjDhczLwAQS/tbqA7jgpId1DddsGHu/PCWRq1pZkv5P/
         +t5xiSYCmnJj72VZxPUqPZEd52dcm42J/pNBJN9w/4EX3JkUU9IkjA9QtlZR8+Otr1
         lk1QLSm7TGnCg==
Date:   Thu, 4 Jun 2020 11:29:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Mike Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: linux-next: manual merge of the net-next tree with the clk tree
Message-ID: <20200604112940.560978f3@canb.auug.org.au>
In-Reply-To: <20200602120957.1351bda0@canb.auug.org.au>
References: <20200602120957.1351bda0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/G52KOylxla=mZaaf.Z88kBx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/G52KOylxla=mZaaf.Z88kBx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 2 Jun 2020 12:09:57 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt
>=20
> between commit:
>=20
>   7b9e111a5216 ("dt-bindings: clock: mediatek: document clk bindings for =
Mediatek MT6765 SoC")
>=20
> from the clk tree and commit:
>=20
>   9f9d1e63dc55 ("dt-bindings: convert the binding document for mediatek P=
ERICFG to yaml")
>=20
> from the net-next tree.
>=20
> I fixed it up (I deleted the file and added the following patch) and
> can carry the fix as necessary. This is now fixed as far as linux-next
> is concerned, but any non trivial conflicts should be mentioned to your
> upstream maintainer when your tree is submitted for merging.  You may
> also want to consider cooperating with the maintainer of the conflicting
> tree to minimise any particularly complex conflicts.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 2 Jun 2020 12:07:03 +1000
> Subject: [PATCH] dt-bindings: fix up for "dt-bindings: clock: mediatek:
>  document clk bindings for Mediatek MT6765 SoC"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  .../devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml       | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,peri=
cfg.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.=
yaml
> index 55209a2baedc..e271c4682ebc 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
> @@ -20,6 +20,7 @@ properties:
>          - enum:
>            - mediatek,mt2701-pericfg
>            - mediatek,mt2712-pericfg
> +          - mediatek,mt6765-pericfg
>            - mediatek,mt7622-pericfg
>            - mediatek,mt7629-pericfg
>            - mediatek,mt8135-pericfg
> --=20
> 2.26.2

This merge resolution patch is now needed when the clk tree merges with
Linus' tree

--=20
Cheers,
Stephen Rothwell

--Sig_/G52KOylxla=mZaaf.Z88kBx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7YToQACgkQAVBC80lX
0Gxv/Af+K9A0Q6zKBH6ugExa7GwKENxQJT/iToQ98ZH8PoinDOXsdp1Cqo1scS+l
RmUg1EHf1c5OgbB0w5YK722d9rXtI9CW83Si97cJIUoqjVJjT05i+F78c2x0i5dk
dmfsCxW2k36av9D4ecWJL8isD9qF0DLTs3cueEuzx/0dH1vvgNEOoXS7d3ESEDtm
3vHjWh0uYNIQG33VBJ5YBNGHfAj4Cgg0wat7eailhEuDLODnemCLQj4c6IxLV7rN
5taHLd7I8m8nVVda80GoHePv44CsQ5qC6zFHmGgp0uyyfsRWptyivmOkTxBYHX9T
UNdzwMD2rAFPAii7fNomWZ83ukawIg==
=iPus
-----END PGP SIGNATURE-----

--Sig_/G52KOylxla=mZaaf.Z88kBx--
