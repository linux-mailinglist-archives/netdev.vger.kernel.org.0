Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168376CB917
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjC1IL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjC1ILy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:11:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3B8B1;
        Tue, 28 Mar 2023 01:11:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2FEBB810DF;
        Tue, 28 Mar 2023 08:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391EDC433EF;
        Tue, 28 Mar 2023 08:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679991110;
        bh=5qqfCDIKX8O+ZuI35vNhL5dM7n99//NsdnXWD5dIeaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHP6CBLqsGcbSrkcGuQMHJxp5oZB52bgDlIOthWrYDhgcfl9fUhteX2Qnbsy795cF
         kfvjeIgr7L4vXX03pPK0V9Z6ercd9m4ytr0WRbJl5FmaHzlzScUm8TbdmAegiTiQQ2
         BS4ZxGGzZx4MZaTukbbVbFn1hshJl4rETLdcPLa94VjAYZu+HDJtGL8CsISqvrJWtx
         P0u0PMNCrnFaGI3qt+yyCe/shSdrpEM1dkILNG9rnRQTSG6thpXIMM5wuYWEao3jSs
         dJdw0LWguKCcQeKYU1uv+UkQM1yPskj975dmtYsjQxAKa6uFwIJVCiJA4tj0ZrYapq
         eRzTzuevLsmeg==
Date:   Tue, 28 Mar 2023 10:11:46 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 06/10] dt-bindings: soc: mediatek: move ilm in a
 dedicated dts node
Message-ID: <ZCKhQt/h7ITzMmZ8@lore-desk>
References: <cover.1679330630.git.lorenzo@kernel.org>
 <c9b65ef3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org>
 <20230321193254.GA1306908-robh@kernel.org>
 <ZBsnLLh5zu9DEQBb@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IDH3Hw5Z9TRESUbK"
Content-Disposition: inline
In-Reply-To: <ZBsnLLh5zu9DEQBb@lore-desk>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IDH3Hw5Z9TRESUbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > On Mon, Mar 20, 2023 at 05:58:00PM +0100, Lorenzo Bianconi wrote:
> > > Since the cpuboot memory region is not part of the RAM SoC, move ilm =
in
> > > a deidicated syscon node.
> > > This patch helps to keep backward-compatibility with older version of
> > > uboot codebase where we have a limit of 8 reserved-memory dts child
> > > nodes.
> >=20
> > Maybe, but breaks the ABI. It also looks like a step backwards. Fix you=
r=20
> > u-boot.
>=20
> Can you please give some more details about ABI breakage? mtk_wed driver =
is
> supposed to be backward compatible with respect to the older dts descript=
ion
> (please take a look to patch 5/10 and 8/10).
>=20
> >=20
> > >=20
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 14 +++---
> > >  .../soc/mediatek/mediatek,mt7986-wo-ilm.yaml  | 45 +++++++++++++++++=
++
> > >  2 files changed, 53 insertions(+), 6 deletions(-)
> > >  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/me=
diatek,mt7986-wo-ilm.yaml
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,=
mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,m=
t7622-wed.yaml
> > > index 7f6638d43854..5d2397ec5891 100644
> > > --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-=
wed.yaml
> > > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-=
wed.yaml
> > > @@ -32,14 +32,12 @@ properties:
> > >    memory-region:
> > >      items:
> > >        - description: firmware EMI region
> > > -      - description: firmware ILM region
> > >        - description: firmware DLM region
> > >        - description: firmware CPU DATA region
> > > =20
> > >    memory-region-names:
> > >      items:
> > >        - const: wo-emi
> > > -      - const: wo-ilm
> > >        - const: wo-dlm
> > >        - const: wo-data
> > > =20
> > > @@ -51,6 +49,10 @@ properties:
> > >      $ref: /schemas/types.yaml#/definitions/phandle
> > >      description: mediatek wed-wo cpuboot controller interface.
> > > =20
> > > +  mediatek,wo-ilm:
> > > +    $ref: /schemas/types.yaml#/definitions/phandle
> > > +    description: mediatek wed-wo ilm interface.
> > > +
> > >  allOf:
> > >    - if:
> > >        properties:
> > > @@ -63,6 +65,7 @@ allOf:
> > >          memory-region: false
> > >          mediatek,wo-ccif: false
> > >          mediatek,wo-cpuboot: false
> > > +        mediatek,wo-ilm: false
> > > =20
> > >  required:
> > >    - compatible
> > > @@ -97,11 +100,10 @@ examples:
> > >          reg =3D <0 0x15010000 0 0x1000>;
> > >          interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> > > =20
> > > -        memory-region =3D <&wo_emi>, <&wo_ilm>, <&wo_dlm>,
> > > -                        <&wo_data>;
> > > -        memory-region-names =3D "wo-emi", "wo-ilm", "wo-dlm",
> > > -                              "wo-data";
> > > +        memory-region =3D <&wo_emi>, <&wo_dlm>, &wo_data>;
> > > +        memory-region-names =3D "wo-emi", "wo-dlm", "wo-data";
> > >          mediatek,wo-ccif =3D <&wo_ccif0>;
> > >          mediatek,wo-cpuboot =3D <&wo_cpuboot>;
> > > +        mediatek,wo-ilm =3D <&wo_ilm>;
> > >        };
> > >      };
> > > diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,=
mt7986-wo-ilm.yaml b/Documentation/devicetree/bindings/soc/mediatek/mediate=
k,mt7986-wo-ilm.yaml
> > > new file mode 100644
> > > index 000000000000..2a3775cd941e
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-=
wo-ilm.yaml
> > > @@ -0,0 +1,45 @@
> > > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/soc/mediatek/mediatek,mt7986-wo-i=
lm.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: MediaTek Wireless Ethernet Dispatch (WED) WO ILM firmware int=
erface for MT7986
> >=20
> > Either this region is some memory or it's a device. Sounds like the=20
> > former and this is not a 'syscon'.
>=20
> ILM and DLM are mmio regions used to store Wireless Ethernet Dispatch fir=
mware
> sections.
> AFAIU reserved-memory nodes are supposed to be used just for RAM areas, c=
orrect?
> What do you think would be the best dts node type for ILM and DLM?
>=20
> Another possibility I was discussing with Felix is to move ILM and DLM de=
finitions
> in WED node reg section, something like:
>=20
> wed0: wed@15010000 {
> 	compatible =3D "mediatek,mt7986-wed";
> 	reg =3D <0 0x15010000 0 0x1000>,
> 	      <0 0x151e0000 0 0x8000>,
> 	      <0 0x151e8000 0 0x2000>;
> 	...
> };
>=20
> Doing so we need to get rid of syscon in WED compatible string, right? Is=
 it acceptable?
>=20
> Regards,
> Lorenzo

Hi Rob,

do you have any more input about this? Is it fine to just use syscon for
ILM/DLM dts nodes or do you prefer to rework WED node in order to have ILM/=
DLM
regs info into it?

Regards,
Lorenzo

>=20
> >=20
> > > +
> > > +maintainers:
> > > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > > +  - Felix Fietkau <nbd@nbd.name>
> > > +
> > > +description:
> > > +  The MediaTek wo-ilm (Information Lifecycle Management) provides a =
configuration
> > > +  interface for WiFi critical data used by WED WO firmware. WED WO c=
ontroller is
> > > +  used to perform offload rx packet processing (e.g. 802.11 aggregat=
ion packet
> > > +  reordering or rx header translation) on MT7986 soc.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    items:
> > > +      - enum:
> > > +          - mediatek,mt7986-wo-ilm
> > > +      - const: syscon
> > > +
> > > +  reg:
> > > +    maxItems: 1
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +
> > > +additionalProperties: false
> > > +
> > > +examples:
> > > +  - |
> > > +    soc {
> > > +      #address-cells =3D <2>;
> > > +      #size-cells =3D <2>;
> > > +
> > > +      syscon@151e0000 {
> > > +        compatible =3D "mediatek,mt7986-wo-ilm", "syscon";
> > > +        reg =3D <0 0x151e0000 0 0x8000>;
> > > +      };
> > > +    };
> > > --=20
> > > 2.39.2
> > >=20



--IDH3Hw5Z9TRESUbK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZCKhQgAKCRA6cBh0uS2t
rObvAQCMaKWLG9Ulru7OhhvAppG/1E64Z9HPyAU4m8wbcM2h0AD/Z6cket2SEJDs
X3uTiZUjMaHYXIWuDIMA5EJd4SldyAo=
=PRya
-----END PGP SIGNATURE-----

--IDH3Hw5Z9TRESUbK--
