Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6096F5B6DC7
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiIMMz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiIMMzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:55:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9861B80;
        Tue, 13 Sep 2022 05:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46B3C61463;
        Tue, 13 Sep 2022 12:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E3EC433D6;
        Tue, 13 Sep 2022 12:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663073722;
        bh=nVK1PpFpr3HrxHyxFHxXGkoi91E0D9INc8k4vrxLlO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sQoTQw9b5uv42Gc79PBJk8gsxELlxcrDQhMhi8d3x3Y2H9xEos2A972w/zKyL1j/Q
         y+/N5nIH7j3YYttsfXFwQL0GqSrEsQqgI1TBZIcIvwMM4fTpp/7nV8T31BKiOeHnq8
         zT7WK4MG3gv74eeXFHhXSxDJkApJ5MJUIpox63pT4JL+LYxJpMcuI2gh17Blly0Xbq
         GhrcN4ahEMfOCEEmF+PYYPrCfkw1mlryD7UDb4bFlCfh/99isAXsEJjs6dM6Nr26g0
         PeLZjr8LXFSDl64K6lGbDQsHVflDJ4fUwvLSY04ZLge11E1g02kiEq46Q19SQPLuNI
         q6bO4q8xV2/Mw==
Date:   Tue, 13 Sep 2022 14:55:18 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 01/12] arm64: dts: mediatek: mt7986: add support
 for Wireless Ethernet Dispatch
Message-ID: <YyB9tvD6+gQUe2tk@lore-desk>
References: <cover.1662661555.git.lorenzo@kernel.org>
 <e034b4b71437bce747b128382f1504d5cdc6974b.1662661555.git.lorenzo@kernel.org>
 <20220913120950.GA3397630-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZB171Q3MrJkpLRzK"
Content-Disposition: inline
In-Reply-To: <20220913120950.GA3397630-robh@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZB171Q3MrJkpLRzK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sep 13, Rob Herring wrote:
> On Thu, Sep 08, 2022 at 09:33:35PM +0200, Lorenzo Bianconi wrote:
> > Introduce wed0 and wed1 nodes in order to enable offloading forwarding
> > between ethernet and wireless devices on the mt7986 chipset.
> >=20
> > Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
> > Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >=20
> > diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boo=
t/dts/mediatek/mt7986a.dtsi
> > index e3a407d03551..419d056b8369 100644
> > --- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> > +++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> > @@ -222,6 +222,25 @@ ethsys: syscon@15000000 {
> >  			 #reset-cells =3D <1>;
> >  		};
> > =20
> > +		wed_pcie: wed_pcie@10003000 {
> > +			compatible =3D "mediatek,wed";
>=20
> This is undocumented. It needs a binding.

ack I will fix it in v2.

>=20
> > +			reg =3D <0 0x10003000 0 0x10>;
> > +		};
> > +
> > +		wed0: wed@15010000 {
> > +			compatible =3D "mediatek,wed", "syscon";
>=20
> Some are syscon's and some are not?

ack I will fix it in v2.

Regards,
Lorenzo
>=20
> > +			reg =3D <0 0x15010000 0 0x1000>;
> > +			interrupt-parent =3D <&gic>;
> > +			interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> > +		};
> > +
> > +		wed1: wed@15011000 {
> > +			compatible =3D "mediatek,wed", "syscon";
> > +			reg =3D <0 0x15011000 0 0x1000>;
> > +			interrupt-parent =3D <&gic>;
> > +			interrupts =3D <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
> > +		};
> > +
> >  		eth: ethernet@15100000 {
> >  			compatible =3D "mediatek,mt7986-eth";
> >  			reg =3D <0 0x15100000 0 0x80000>;
> > @@ -256,6 +275,7 @@ eth: ethernet@15100000 {
> >  						 <&apmixedsys CLK_APMIXED_SGMPLL>;
> >  			mediatek,ethsys =3D <&ethsys>;
> >  			mediatek,sgmiisys =3D <&sgmiisys0>, <&sgmiisys1>;
> > +			mediatek,wed =3D <&wed0>, <&wed1>;
> >  			#reset-cells =3D <1>;
> >  			#address-cells =3D <1>;
> >  			#size-cells =3D <0>;
> > --=20
> > 2.37.3
> >=20
> >=20

--ZB171Q3MrJkpLRzK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYyB9tgAKCRA6cBh0uS2t
rEI/AP9/wgj2OBuhzFXTwuox6VAFFP2XrEoPs+UIwXt69PmD+gD/WvunCMCbUQC7
V+zgy5wDDPTsNR0A6Wd+b8I6LYtAQg4=
=Wi3g
-----END PGP SIGNATURE-----

--ZB171Q3MrJkpLRzK--
