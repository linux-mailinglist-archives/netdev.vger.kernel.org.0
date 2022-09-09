Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8195B41A0
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 23:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiIIVrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 17:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIIVra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 17:47:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3028053B;
        Fri,  9 Sep 2022 14:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D915FB82659;
        Fri,  9 Sep 2022 21:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04275C433D7;
        Fri,  9 Sep 2022 21:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662760046;
        bh=Ax/uvAY03/zgpeUKLhwstiXZ3hgfRZwfa9av35aAHXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OwoSfo3Bd9xYfIGwgcbVQjmaS1OKWhafPVU2M5E3uQ3xVQnIxtPJSRfMy5XpdEsuB
         YbuN3yYoFTM9yEEHtcY+gRDAPEN//SxS4FIOh0MBzinNjwPwwSgKih9xdJxRNeECHU
         wNeY1+eyKj8axBJi8t9g8ewh/rBfEga7G4OYFnW7aDAjnQOFzqLOrmk2zbeE7woStX
         fHYoPmUCtIZloQhFL3zay3IzE879R+qTC1LGkxr00/m4g2Kuyt29Q1evNWrDBU/bsZ
         7mvrTZddtXkcbpevydhkCPRCQH1Rx+7GjE0PxvMfPM5wMSVq2BZKnfVXAG+h85pBgG
         k7IU9aU1+X8FA==
Date:   Fri, 9 Sep 2022 23:47:22 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH net-next 08/12] net: ethernet: mtk_eth_soc: add foe info
 in mtk_soc_data structure
Message-ID: <Yxu0aoBcCirDkm9j@lore-desk>
References: <cover.1662661555.git.lorenzo@kernel.org>
 <0d0bfa99e313c0b00bf75f943f58b6fe552ed004.1662661555.git.lorenzo@kernel.org>
 <YxuL45OghfKVGTrM@makrotopia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o/fDb3p0UsNpkYZx"
Content-Disposition: inline
In-Reply-To: <YxuL45OghfKVGTrM@makrotopia.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o/fDb3p0UsNpkYZx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Sep 08, 2022 at 09:33:42PM +0200, Lorenzo Bianconi wrote:
> > Introduce foe struct in mtk_soc_data as a container for foe table chip
> > related definitions.
> > This is a preliminary patch to enable mt7986 wed support.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  70 +++++++-
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  27 ++-
> >  drivers/net/ethernet/mediatek/mtk_ppe.c       | 161 ++++++++++--------
> >  drivers/net/ethernet/mediatek/mtk_ppe.h       |  29 ++--
> >  .../net/ethernet/mediatek/mtk_ppe_offload.c   |  34 ++--
> >  5 files changed, 208 insertions(+), 113 deletions(-)
> >=20
> > [...]
> > diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethe=
rnet/mediatek/mtk_ppe.h
> > index 6d4c91acd1a5..a364f45edf38 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_ppe.h
> > +++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
> > @@ -61,6 +61,8 @@ enum {
> >  #define MTK_FOE_VLAN2_WINFO_WCID	GENMASK(13, 6)
> >  #define MTK_FOE_VLAN2_WINFO_RING	GENMASK(15, 14)
> > =20
> > +#define MTK_FIELD_PREP(mask, val)	(((typeof(mask))(val) << __bf_shf(ma=
sk)) & (mask))
> > +#define MTK_FIELD_GET(mask, val)	((typeof(mask))(((val) & (mask)) >> _=
_bf_shf(mask)))
>=20
> This seems to trigger a compiler bug on ARMv7 (e.g. MT7623) builds:
>=20
>   LD      .tmp_vmlinux.kallsyms1
> arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o=
: in function `mtk_flow_entry_match':
> /usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-m=
ediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:406: u=
ndefined reference to `__ffsdi2'
> arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o=
: in function `__mtk_foe_entry_commit':
> /usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-m=
ediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:533: u=
ndefined reference to `__ffsdi2'
> arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o=
: in function `mtk_foe_entry_l2':
> /usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-m=
ediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:134: u=
ndefined reference to `__ffsdi2'
> arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o=
: in function `mtk_foe_entry_commit_subflow':
> /usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-m=
ediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:611: u=
ndefined reference to `__ffsdi2'
> arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o=
: in function `mtk_foe_entry_ib2':
> /usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-m=
ediatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:148: u=
ndefined reference to `__ffsdi2'
> arm-openwrt-linux-muslgnueabi-ld: drivers/net/ethernet/mediatek/mtk_ppe.o=
:/usr/src/lede/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-me=
diatek_mt7623/linux-5.15.67/drivers/net/ethernet/mediatek/mtk_ppe.c:169: mo=
re undefined references to `__ffsdi2' follow

Hi Daniel,

ack, I will fix it in v2.

Regards,
Lorenzo

>=20
>=20
> >  enum {
> >  	MTK_FOE_STATE_INVALID,
> >  	MTK_FOE_STATE_UNBIND,

--o/fDb3p0UsNpkYZx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYxu0agAKCRA6cBh0uS2t
rIASAQC4DrW2Z2WRfMzAKwO9ZVvP2jDgt/p3kM30a/xV699wywEA9xq3pzx4TYa7
H2xGS3bd8wdUqwiGkljU0zhYoWxG5Qg=
=WiH2
-----END PGP SIGNATURE-----

--o/fDb3p0UsNpkYZx--
