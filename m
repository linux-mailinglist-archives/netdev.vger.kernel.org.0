Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F9B61258A
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 23:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJ2VRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 17:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJ2VRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 17:17:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C17E41994;
        Sat, 29 Oct 2022 14:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF217B80939;
        Sat, 29 Oct 2022 21:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17A6C433D6;
        Sat, 29 Oct 2022 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667078270;
        bh=WpqkAJ0d5uQC7Xu0S15OIsrNLmh5iCCzkIIAyjwyDPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qpno7iG7QSILXyZAOHwKHOdc8/aRzjOhSp23V3rS0RlTtk1UsX0u2T3AHIDkcNrQd
         WE6gaTRhBbs5qPC82l3xt4ST4THeoOHRJtNIM5byq5kIquuJbLPh7EsKq5JWCQx1rU
         3G4u306sN8/mtCWoWKsBVSK/GD2ShwtDEImnjCdKuluZURTK0RojHTIQ99W7Xidadk
         2rf/ToHiiFLWyX35HQ8Q3Bu9vmc8hoEknLmYpaoC8dE0fHbp1x5wdIt3RvVY50NRbL
         pIJG6dRRwzVRMAx8gI59IROOiyvcQh6B6xZnu91x4F7MjB8IHKEiYTNAuK6+p6osrR
         n3Ig8xbuI8NXg==
Date:   Sat, 29 Oct 2022 23:17:46 +0200
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
Subject: Re: [PATCH v2 net-next 2/6] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Message-ID: <Y12Yen8fK9+LAGkv@lore-desk>
References: <cover.1666549145.git.lorenzo@kernel.org>
 <337ef332ca50e6a40f3fdceeb7262d91165c6323.1666549145.git.lorenzo@kernel.org>
 <8d067556-a6ee-ac6c-3ff1-d3906d9e9899@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iq3giSCjfGb5Olpa"
Content-Disposition: inline
In-Reply-To: <8d067556-a6ee-ac6c-3ff1-d3906d9e9899@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iq3giSCjfGb5Olpa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 23/10/2022 14:28, Lorenzo Bianconi wrote:
> > Document the binding for the RX Wireless Ethernet Dispatch core on the
> > MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> > forwarded to LAN/WAN one.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC.  It might happen, that command when run on an older
> kernel, gives you outdated entries.  Therefore please be sure you base
> your patches on recent Linux kernel.
>=20
> > ---
> >  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 91 +++++++++++++++++++
> >  .../arm/mediatek/mediatek,mt7986-wo-boot.yaml | 46 ++++++++++
> >  .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml | 49 ++++++++++
> >  .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  | 50 ++++++++++
> >  4 files changed, 236 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/medi=
atek,mt7986-wo-boot.yaml
> >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/medi=
atek,mt7986-wo-ccif.yaml
> >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/medi=
atek,mt7986-wo-dlm.yaml
> >=20
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7=
622-wed.yaml
> > index 84fb0a146b6e..8e2905004790 100644
> > --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-we=
d.yaml
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-we=
d.yaml
> > @@ -29,6 +29,41 @@ properties:
> >    interrupts:
> >      maxItems: 1
> > =20
> > +  memory-region:
> > +    minItems: 3
>=20
> No need for minItems.

can we specify memory-region and memory-region-names properties like the co=
de
below?

 memory-region:
    items:
      - description:
          Phandle for the node (wo-emi) used to run firmware EMI region
      - description:
          Phandle for the node (wo-ilm) used to run firmware ILM region
      - description:
          Phandle for the node (wo-data) used to run firmware CPU DATA regi=
on

  memory-region-names:
    items:
      - const: wo-emi
      - const: wo-ilm
      - const: wo-data

Regards,
Lorenzo

>=20
> > +    maxItems: 3
> > +    description:
> > +      phandles to nodes describing reserved memory used by mt7986-wed =
firmware
> > +      (see bindings/reserved-memory/reserved-memory.txt)
> > +
> > +  mediatek,wo-ccif:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Phandle to the mediatek wed-wo controller.
> > +
> > +  mediatek,wo-boot:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Phandle to the mediatek wed-wo boot interface.
> > +
> > +  mediatek,wo-dlm:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Phandle to the mediatek wed-wo rx hw ring.
> > +
> > +allOf:
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: mediatek,mt7986-wed
> > +    then:
> > +      properties:
> > +        mediatek,wo-boot: true
> > +        mediatek,wo-ccif: true
> > +        mediatek,wo-dlm: true
> > +        memory-region: true
> > +
> >  required:
> >    - compatible
> >    - reg
> > @@ -49,3 +84,59 @@ examples:
> >          interrupts =3D <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
> >        };
> >      };
> > +
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +      reserved-memory {
> > +        #address-cells =3D <2>;
> > +        #size-cells =3D <2>;
> > +
> > +        wo_emi: wo-emi@4fd00000 {
> > +          reg =3D <0 0x4fd00000 0 0x40000>;
> > +          no-map;
> > +        };
> > +
> > +        wo_data: wo-data@4fd80000 {
> > +          reg =3D <0 0x4fd80000 0 0x240000>;
> > +          no-map;
> > +        };
> > +
> > +        wo_ilm: wo-ilm@151e0000 {
> > +          reg =3D <0 0x151e0000 0 0x8000>;
> > +          no-map;
> > +        };
> > +      };
> > +
> > +      wo_boot: wo-boot@15194000 {
> > +        compatible =3D "mediatek,mt7986-wo-boot","syscon";
> > +        reg =3D <0 0x15194000 0 0x1000>;
> > +      };
> > +
> > +      wo_ccif0: wo-ccif@151a5000 {
> > +        compatible =3D "mediatek,mt7986-wo-ccif","syscon";
> > +        reg =3D <0 0x151a5000 0 0x1000>;
> > +        interrupts =3D <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
> > +      };
> > +
> > +      wo_dlm0: wo-dlm@151e8000 {
> > +        compatible =3D "mediatek,mt7986-wo-dlm";
> > +        reg =3D <0 0x151e8000 0 0x2000>;
> > +        resets =3D <&ethsysrst 0>;
> > +        reset-names =3D "wocpu_rst";
> > +      };
> > +
> > +      wed1: wed@1020a000 {
> > +        compatible =3D "mediatek,mt7986-wed","syscon";
> > +        reg =3D <0 0x15010000 0 0x1000>;
> > +        interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> > +
> > +        memory-region =3D <&wo_emi>, <&wo_data>, <&wo_ilm>;
> > +        mediatek,wo-ccif =3D <&wo_ccif0>;
> > +        mediatek,wo-boot =3D <&wo_boot>;
> > +        mediatek,wo-dlm =3D <&wo_dlm0>;
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-boot.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek=
,mt7986-wo-boot.yaml
> > new file mode 100644
> > index 000000000000..ce9c971e6604
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo=
-boot.yaml
> > @@ -0,0 +1,46 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-bo=
ot.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +
> > +title:
> > +  MediaTek Wireless Ethernet Dispatch WO boot controller interface for=
 MT7986
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The mediatek wo-boot provides a configuration interface for WED WO
> > +  boot controller on MT7986 soc.
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - enum:
> > +          - mediatek,mt7986-wo-boot
> > +      - const: syscon
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +      wo_boot: wo-boot@15194000 {
> > +        compatible =3D "mediatek,mt7986-wo-boot","syscon";
> > +        reg =3D <0 0x15194000 0 0x1000>;
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-ccif.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek=
,mt7986-wo-ccif.yaml
> > new file mode 100644
> > index 000000000000..48cb27bcc4cd
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo=
-ccif.yaml
> > @@ -0,0 +1,49 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-cc=
if.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>=20
> No improvements...
>=20
> > +
> > +title: MediaTek Wireless Ethernet Dispatch WO Controller for MT7986
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The mediatek wo-ccif provides a configuration interface for WED WO
> > +  controller on MT7986 soc.
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - enum:
> > +          - mediatek,mt7986-wo-ccif
> > +      - const: syscon
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +      wo_ccif0: wo-ccif@151a5000 {
>=20
> This is still not entirely generic... What is wo-ccif?
>=20
>=20
> > +        compatible =3D "mediatek,mt7986-wo-ccif","syscon";
>=20
> Missing space.
>=20
> All comments might apply to other places.
>=20
>=20
> Best regards,
> Krzysztof
>=20

--iq3giSCjfGb5Olpa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY12YegAKCRA6cBh0uS2t
rKk2AQDV8Ee7HG6+KpSxLB4oZb5TJKfQb8Usnle09b6WhuXQTQEAz3Khrl6soBsX
25m3hgFlA+RWc0YMM8zN3Nh3tu3YHw0=
=as+y
-----END PGP SIGNATURE-----

--iq3giSCjfGb5Olpa--
