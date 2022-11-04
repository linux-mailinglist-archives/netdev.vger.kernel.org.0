Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169A3619319
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 10:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKDJFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 05:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKDJFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 05:05:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773371C90A;
        Fri,  4 Nov 2022 02:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11BD96210A;
        Fri,  4 Nov 2022 09:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEC8C433C1;
        Fri,  4 Nov 2022 09:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667552739;
        bh=ZSnfcbo7a554FxbRKiHzgm/4DxE8HZ48VBVyW0oWshY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UtnQYKfKCY36RTupDEI2hU7Bui6ycF38v079aWJrvbzHn8pStbIKuNS/Zu/NYBPBV
         XdvNghvD3CXYZvKlZCKBkQD2t822P//Ky9cLlvC5SWO1hg0+zaOmLol17zniGJ057z
         XeM4mRa8DDFOXSHJORHmOePFjBYBS6RvCEB+psaQXTABlOv43TEfj2EQlItjHHWE3T
         Aprmzp03KZui0SEj16c9UWWyepPwkUDt4KOAJx9RbfChR2+Y75IhWozY/gL6waRRSs
         BAoW+5QcG4X440PgdnTfmtDPy64qC4uOdY+ZawYwuV42+ZyH0NFUIuxS9bMgBA+DTz
         vHQ/eU+hjqYvg==
Date:   Fri, 4 Nov 2022 10:05:35 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org,
        Sam.Shih@mediatek.com
Subject: Re: [PATCH v3 net-next 1/8] arm64: dts: mediatek: mt7986: add
 support for RX Wireless Ethernet Dispatch
Message-ID: <Y2TV34YFl/uySbiP@lore-desk>
References: <cover.1667466887.git.lorenzo@kernel.org>
 <4bd5f6626174ac042c0e9b9f2ffff40c3c72b88a.1667466887.git.lorenzo@kernel.org>
 <3046551a-62d7-2990-afb6-75fe2e20d8cb@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="P7L9QEHRaBj8iPjh"
Content-Disposition: inline
In-Reply-To: <3046551a-62d7-2990-afb6-75fe2e20d8cb@collabora.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--P7L9QEHRaBj8iPjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Il 03/11/22 10:28, Lorenzo Bianconi ha scritto:
> > Similar to TX Wireless Ethernet Dispatch, introduce RX Wireless Ethernet
> > Dispatch to offload traffic received by the wlan interface to lan/wan
> > one.
> >=20
> > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Hello Lorenzo,

Hi Angelo,

> thanks for the patch! However, there's something to improve...
>=20
> > ---
> >   arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 75 +++++++++++++++++++++++
> >   1 file changed, 75 insertions(+)
> >=20
> > diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boo=
t/dts/mediatek/mt7986a.dtsi
> > index 72e0d9722e07..b0a593c6020e 100644
> > --- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> > +++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
>=20
> ..snip..
>=20
> > @@ -226,6 +252,12 @@ ethsys: syscon@15000000 {
> >   			 reg =3D <0 0x15000000 0 0x1000>;
> >   			 #clock-cells =3D <1>;
> >   			 #reset-cells =3D <1>;
> > +
> > +			ethsysrst: reset-controller {
>=20
> That's not right. It works, yes, but your ethsys rightfully declares #res=
et-cells,
> because it is supposed to also be a reset controller (even though I don't=
 see any
> reset controller registering action in clk-mt7986-eth.c).
>=20
> Please document the ethernet reset in the appropriate dt-bindings header =
and
> register the reset controller in clk-mt7986-eth.c.
>=20
> Finally, you won't need any "ti,syscon-reset" node, and resets will look =
like
>=20
> 	resets =3D <&ethsys MT7986_ETHSYS_SOMETHING_SWRST>;
>=20
> If you need any hint about how to do that, please check clk-mt8195-infra_=
ao.c.

reviewing the code I think we do not have any mt7986-eth reset line consume=
r at the
moment, since:
- mtk_eth_soc driver rely on syscon for resetting the chip writing directly=
 in the register
  in ethsys_reset()
- we do not rely on reset api in wed wo code.

I think we can just drop reset support in ethsys/wo-dlm nodes at the moment=
 (since it
is not used in this series) and convert the driver to reset api as soon as
we have proper support in clk-mt7986-eth.c (AFAIU sam will work on it).

Regards,
Lorenzo

>=20
> Regards,
> Angelo
>=20

--P7L9QEHRaBj8iPjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY2TV3wAKCRA6cBh0uS2t
rDvkAQDRi+dctkQ5LZ35L85BSvNNY1urFlysqWl8he4gt/A7lAD+PYMwbezhgc58
vi3XsNZV3Ai9yacwLFeEBnE3SbmpGQc=
=uq0/
-----END PGP SIGNATURE-----

--P7L9QEHRaBj8iPjh--
