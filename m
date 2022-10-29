Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57797612583
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 23:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJ2VNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 17:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJ2VN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 17:13:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B403DBFC;
        Sat, 29 Oct 2022 14:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AA06B80D29;
        Sat, 29 Oct 2022 21:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BE4C43153;
        Sat, 29 Oct 2022 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667078004;
        bh=LAb5KIWfqD5Ieoc6po1xcm3UCB0pZOliEZth1GO/who=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oU6rH4YD0vY8LLHeqsOFuV7TqPm/g5bk4xjniNHM2wmO1sFD2wg7Pm7nk5XQupWFb
         KeczfVaXIrQLcuGHLIXLuVULgRU7HcJ2PzAOE7EZ3l1kWeBM1H3nfmSoEU7xWVyi3r
         TK+58Xbp7CMUDUwM+0FXErs5hGX0qKRDHtptKDY3UrPXTpBl9TxQZjBVdGZXA3hWsK
         tyuX6GyqpMVlfLICQT8tfff43nclXWvgst4PmzUvt8mT9VUrgXh5lTOFmmzPbH/793
         wvjo3zH3uuHazSQPVRX9288KD2Q+hppPaHWinqK2OqFv8KBPLRJl4JSQM6t8THWEyG
         VGb2UcBZ2HKLQ==
Date:   Sat, 29 Oct 2022 23:13:20 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: Re: [PATCH v2 net-next 1/6] arm64: dts: mediatek: mt7986: add
 support for RX Wireless Ethernet Dispatch
Message-ID: <Y12XcHCVotO9dmk7@lore-desk>
References: <cover.1666549145.git.lorenzo@kernel.org>
 <41d67d36481f3099f953a462a80e99a4fcd477dd.1666549145.git.lorenzo@kernel.org>
 <4f9f6fcf-b6f2-7729-5950-7bc472d0c863@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DzLXIAU9zMmZf85z"
Content-Disposition: inline
In-Reply-To: <4f9f6fcf-b6f2-7729-5950-7bc472d0c863@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DzLXIAU9zMmZf85z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 23/10/2022 14:28, Lorenzo Bianconi wrote:
> > Similar to TX Wireless Ethernet Dispatch, introduce RX Wireless Ethernet
> > Dispatch to offload traffic received by the wlan interface to lan/wan
> > one.
>=20
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC.  It might happen, that command when run on an older
> kernel, gives you outdated entries.  Therefore please be sure you base
> your patches on recent Linux kernel.

Hi Krzysztof,

Ack, sorry. I will do it in v3.

>=20
> >=20
> > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 73 +++++++++++++++++++++++
> >  1 file changed, 73 insertions(+)
> >=20
> > diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boo=
t/dts/mediatek/mt7986a.dtsi
> > index 72e0d9722e07..e3b05280dcb6 100644
> > --- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> > +++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> > @@ -8,6 +8,7 @@
> >  #include <dt-bindings/interrupt-controller/arm-gic.h>
> >  #include <dt-bindings/clock/mt7986-clk.h>
> >  #include <dt-bindings/reset/mt7986-resets.h>
> > +#include <dt-bindings/reset/ti-syscon.h>
> > =20
> >  / {
> >  	interrupt-parent =3D <&gic>;
> > @@ -76,6 +77,31 @@ wmcpu_emi: wmcpu-reserved@4fc00000 {
> >  			no-map;
> >  			reg =3D <0 0x4fc00000 0 0x00100000>;
> >  		};
> > +
> > +		wo_emi0: wo-emi0@4fd00000 {
> > +			reg =3D <0 0x4fd00000 0 0x40000>;
> > +			no-map;
> > +		};
> > +
> > +		wo_emi1: wo-emi1@4fd40000 {
> > +			reg =3D <0 0x4fd40000 0 0x40000>;
> > +			no-map;
> > +		};
> > +
> > +		wo_ilm0: wo-ilm0@151e0000 {
> > +			reg =3D <0 0x151e0000 0 0x8000>;
> > +			no-map;
> > +		};
> > +
> > +		wo_ilm1: wo-ilm1@151f0000 {
> > +			reg =3D <0 0x151f0000 0 0x8000>;
> > +			no-map;
> > +		};
> > +
> > +		wo_data: wo-data@4fd80000 {
> > +			reg =3D <0 0x4fd80000 0 0x240000>;
> > +			no-map;
> > +		};
> >  	};
> > =20
> >  	timer {
> > @@ -226,6 +252,12 @@ ethsys: syscon@15000000 {
> >  			 reg =3D <0 0x15000000 0 0x1000>;
> >  			 #clock-cells =3D <1>;
> >  			 #reset-cells =3D <1>;
> > +
> > +			ethsysrst: reset-controller {
> > +				compatible =3D "ti,syscon-reset";
> > +				#reset-cells =3D <1>;
> > +				ti,reset-bits =3D <0x34 4 0x34 4 0x34 4 (ASSERT_SET | DEASSERT_CLE=
AR | STATUS_SET)>;
> > +			};
> >  		};
> > =20
> >  		wed_pcie: wed-pcie@10003000 {
> > @@ -240,6 +272,10 @@ wed0: wed@15010000 {
> >  			reg =3D <0 0x15010000 0 0x1000>;
> >  			interrupt-parent =3D <&gic>;
> >  			interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> > +			memory-region =3D <&wo_emi0>, <&wo_ilm0>, <&wo_data>;
> > +			mediatek,wo-ccif =3D <&wo_ccif0>;
> > +			mediatek,wo-dlm =3D <&wo_dlm0>;
> > +			mediatek,wo-boot =3D <&wo_boot>;
> >  		};
> > =20
> >  		wed1: wed@15011000 {
> > @@ -248,6 +284,43 @@ wed1: wed@15011000 {
> >  			reg =3D <0 0x15011000 0 0x1000>;
> >  			interrupt-parent =3D <&gic>;
> >  			interrupts =3D <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
> > +			memory-region =3D <&wo_emi1>, <&wo_ilm1>, <&wo_data>;
> > +			mediatek,wo-ccif =3D <&wo_ccif1>;
> > +			mediatek,wo-dlm =3D <&wo_dlm1>;
> > +			mediatek,wo-boot =3D <&wo_boot>;
> > +		};
> > +
> > +		wo_ccif0: wo-ccif1@151a5000 {
>=20
> Node names should be generic.
> https://devicetree-specification.readthedocs.io/en/latest/chapter2-device=
tree-basics.html#generic-names-recommendation
>=20
> "1" suffix is for sure not generic. Neither wo-ccif is... unless there
> is some article on Wikipedia about it? Or maybe generic name is not
> possible to get, which happens...

I think we can use "syscon" for wo_ccif and wo_boot. I can't find a better
name for wo_dlm since afaik it is a hw ring used for packet processing.
What do you think?

Regards,
Lorenzo

>=20
> > +			compatible =3D "mediatek,mt7986-wo-ccif","syscon";
> > +			reg =3D <0 0x151a5000 0 0x1000>;
> > +			interrupt-parent =3D <&gic>;
> > +			interrupts =3D <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
> > +		};
> > +
> > +		wo_ccif1: wo-ccif1@151ad000 {
> > +			compatible =3D "mediatek,mt7986-wo-ccif","syscon";
> > +			reg =3D <0 0x151ad000 0 0x1000>;
> > +			interrupt-parent =3D <&gic>;
> > +			interrupts =3D <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
> > +		};
> > +
> > +		wo_dlm0: wo-dlm@151e8000 {
> > +			compatible =3D "mediatek,mt7986-wo-dlm";
> > +			reg =3D <0 0x151e8000 0 0x2000>;
> > +			resets =3D <&ethsysrst 0>;
> > +			reset-names =3D "wocpu_rst";
> > +		};
> > +
> > +		wo_dlm1: wo-dlm@0x151f8000 {
> > +			compatible =3D "mediatek,mt7986-wo-dlm";
> > +			reg =3D <0 0x151f8000 0 0x2000>;
> > +			resets =3D <&ethsysrst 0>;
> > +			reset-names =3D "wocpu_rst";
> > +		};
> > +
> > +		wo_boot: wo-boot@15194000 {
> > +			compatible =3D "mediatek,mt7986-wo-boot","syscon";
>=20
> Missing space.
>=20
> > +			reg =3D <0 0x15194000 0 0x1000>;
> >  		};
> > =20
> >  		eth: ethernet@15100000 {
>=20
> Best regards,
> Krzysztof
>=20

--DzLXIAU9zMmZf85z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY12XcAAKCRA6cBh0uS2t
rBS/AP0VysqOcNwJcht83GFMNwtIkB9Kx6juESfTqOiREumIOgEAgW72UiJqGtzM
WJDTAGm6l8TMGnF5ku6bkRJprQ7IwAU=
=NbWc
-----END PGP SIGNATURE-----

--DzLXIAU9zMmZf85z--
