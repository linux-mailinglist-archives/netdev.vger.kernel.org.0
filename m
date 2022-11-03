Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96A46186C4
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiKCR7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiKCR7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:59:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E252182;
        Thu,  3 Nov 2022 10:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F379DB80AD6;
        Thu,  3 Nov 2022 17:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDC6C433D7;
        Thu,  3 Nov 2022 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667498335;
        bh=OiLLXwuhYw1xR0y6XYeVWsRPOf+qoYlgQ48YRm3kRw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vwh6fNXTuOZuXbRtnvFrrAl5/F0Sgy9R2V83zPZJte2gccL1XU2gcsyGpKCHi6SRl
         AcLmY4JQEz4hqk3dBC67gfI+Y+ettsrsSMft/Hv9Rd4mAMryZp0fuHN/Ot+kcl2ZY+
         QYC1gT10hWgQ/8VUMXS4xHMh2SIU25UOcmIhbiUdMUo6hEg0VFYmCg3zbPyczwsypk
         bbdu6RAz/jjnJViuKOUGbXRZbMu3AMgM8HijVv+wPKeoB1eR7OfqidMQpzSaucvWDE
         GX3+HZxdyWHahcuhpwHT4D5gP52fs+C1CjTe31jmqHpMtDT4vfXSNE+JE7NjPgjsmr
         zOmmrsJ+saHCQ==
Date:   Thu, 3 Nov 2022 18:58:52 +0100
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
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
Subject: Re: [PATCH v3 net-next 1/8] arm64: dts: mediatek: mt7986: add
 support for RX Wireless Ethernet Dispatch
Message-ID: <Y2QBXKupcBVtw8Gv@lore-desk>
References: <cover.1667466887.git.lorenzo@kernel.org>
 <4bd5f6626174ac042c0e9b9f2ffff40c3c72b88a.1667466887.git.lorenzo@kernel.org>
 <3046551a-62d7-2990-afb6-75fe2e20d8cb@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ScmsxxUnOprYMSb4"
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


--ScmsxxUnOprYMSb4
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

Hi Angelo,

Thx for the review. This is not strictly related to the wed rx support adde=
d in this
series, anyway I will look into it in the next revision.

Regards,
Lorenzo

>=20
> Regards,
> Angelo
>=20

--ScmsxxUnOprYMSb4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY2QBXAAKCRA6cBh0uS2t
rN9HAP9nSmSjLG2CT2ALVzxmgBBX3AdNnT3xbfu0hBZc3g6+YwD/Tn6ca6LO2cQ+
BX9fN/p6r+bm+4UoAh72x/A4Nvgiqwk=
=QrcJ
-----END PGP SIGNATURE-----

--ScmsxxUnOprYMSb4--
