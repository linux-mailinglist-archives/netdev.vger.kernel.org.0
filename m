Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC8609486
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 17:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiJWPsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 11:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiJWPsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 11:48:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF6178BD1;
        Sun, 23 Oct 2022 08:48:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBB6EB80DAE;
        Sun, 23 Oct 2022 15:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113EDC433C1;
        Sun, 23 Oct 2022 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666540097;
        bh=yJn8OavakVOxQGW6g4JiudjKcYIPmwarJ89dSQSXsHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIiNsa1TaTdjM0LttYcAqnmMZ1P5SOkERVC1zWfaiyooK9vk8lt2KqjgoQ6qWzAsl
         xo6rB+peXWozLO5mwWxMgmvB5sBYTDg+Y/Lnl5s9o5BaBM0Dz2zWYIlKqK/xWAeYCv
         JseeGk5eiT9K5XxyzJZUkR3EUcqC2Gdr+1l+e3cE0x+6qJIQTpkoQYJvystUT6yy+v
         1uTmXPjOYj9v+FaoPS0DgkSIfNj0OXHKIG9uvJthfj77Lz+dJId6E58IyAVci9GRgK
         wGymDbOXqfx7eT7Iy+fxVc+B5YCAHgu1SlN3xpe40NzAAOiOGzze4Lbb/2Ej2PgkAa
         gvZAaWiooqpaw==
Date:   Sun, 23 Oct 2022 17:48:13 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, daniel@makrotopia.org
Subject: Re: [PATCH net-next 2/6] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Message-ID: <Y1ViPY8QIOeejxNh@lore-desk>
References: <cover.1666368566.git.lorenzo@kernel.org>
 <7a454984f0001a71964114b71f353cb47af95ee6.1666368566.git.lorenzo@kernel.org>
 <20221021224140.GA574155-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1DSfyrdVsyuHoMuf"
Content-Disposition: inline
In-Reply-To: <20221021224140.GA574155-robh@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1DSfyrdVsyuHoMuf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Oct 21, 2022 at 06:18:32PM +0200, Lorenzo Bianconi wrote:
> > Document the binding for the RX Wireless Ethernet Dispatch core on the
> > MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> > forwarded to LAN/WAN one.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 126 ++++++++++++++++++
> >  .../arm/mediatek/mediatek,mt7986-wo-boot.yaml |  45 +++++++
> >  .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml |  49 +++++++
> >  .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  |  66 +++++++++
> >  4 files changed, 286 insertions(+)
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
> > index 84fb0a146b6e..623f11df5545 100644
> > --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-we=
d.yaml
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-we=
d.yaml
> > @@ -29,6 +29,59 @@ properties:
> >    interrupts:
> >      maxItems: 1
> > =20
> > +  mediatek,wocpu_emi:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    maxItems: 1
> > +    description:
> > +      Phandle to a node describing reserved memory used by mtk wed fir=
mware
> > +      (see bindings/reserved-memory/reserved-memory.txt)
>=20
> What does that file contain?
>=20
> There's a standard property to refer to reserved-memory nodes, use it.

ack, I will fix it in v2.

>=20
> > +
> > +  mediatek,wocpu_data:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    maxItems: 1
> > +    description:
> > +      Phandle to a node describing reserved memory used by mtk wed fir=
mware
> > +      (see bindings/reserved-memory/reserved-memory.txt)
> > +
> > +  mediatek,wocpu_ilm:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    maxItems: 1
> > +    description:
> > +      Phandle to a node describing memory used by mtk wed firmware
> > +
> > +  mediatek,ap2woccif:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    maxItems: 1
> > +    description:
> > +      Phandle to the mediatek wed-wo controller.
> > +
> > +  mediatek,wocpu_boot:
>=20
> s/_/-/

ack, I will fix it in v2.

>=20
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    maxItems: 1
> > +    description:
> > +      Phandle to the mediatek wed-wo boot interface.
> > +
> > +  mediatek,wocpu_dlm:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    maxItems: 1
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
> > +        mediatek,wocpu_data: true
> > +        mediatek,wocpu_boot: true
> > +        mediatek,wocpu_emi: true
> > +        mediatek,wocpu_ilm: true
> > +        mediatek,ap2woccif: true
> > +        mediatek,wocpu_dlm: true
> > +
> >  required:
> >    - compatible
> >    - reg
> > @@ -49,3 +102,76 @@ examples:
> >          interrupts =3D <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
> >        };
> >      };
> > +
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    #include <dt-bindings/reset/ti-syscon.h>
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +      reserved-memory {
> > +        #address-cells =3D <2>;
> > +        #size-cells =3D <2>;
> > +        wocpu0_emi: wocpu0_emi@4fd00000 {
> > +          reg =3D <0 0x4fd00000 0 0x40000>;
> > +          no-map;
> > +        };
> > +
> > +        wocpu_data: wocpu_data@4fd80000 {
> > +          reg =3D <0 0x4fd80000 0 0x240000>;
> > +          no-map;
> > +        };
> > +      };
> > +
> > +      ethsys: syscon@15000000 {
> > +        #address-cells =3D <1>;
> > +        #size-cells =3D <1>;
> > +        compatible =3D "mediatek,mt7986-ethsys", "syscon";
> > +        reg =3D <0 0x15000000 0 0x1000>;
> > +
> > +        #clock-cells =3D <1>;
> > +        #reset-cells =3D <1>;
> > +        ethsysrst: reset-controller {
> > +          compatible =3D "ti,syscon-reset";
> > +          #reset-cells =3D <1>;
> > +          ti,reset-bits =3D <0x34 4 0x34 4 0x34 4 (ASSERT_SET | DEASSE=
RT_CLEAR | STATUS_SET)>;
> > +        };
>=20
> You don't need to show providers in examples. Presumably we already have=
=20
> an example of them in their binding.

ack, I will fix it in v2.
>=20
> > +      };
> > +
> > +      wocpu0_ilm: wocpu0_ilm@151e0000 {
> > +        compatible =3D "mediatek,wocpu0_ilm";
> > +        reg =3D <0 0x151e0000 0 0x8000>;
> > +      };
> > +
> > +      cpu_boot: wocpu_boot@15194000 {
> > +        compatible =3D "mediatek,wocpu_boot", "syscon";
> > +        reg =3D <0 0x15194000 0 0x1000>;
> > +      };
> > +
> > +      ap2woccif0: ap2woccif@151a5000 {
> > +        compatible =3D "mediatek,ap2woccif", "syscon";
> > +        reg =3D <0 0x151a5000 0 0x1000>;
> > +        interrupts =3D <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
> > +      };
> > +
> > +      wocpu0_dlm: wocpu_dlm@151e8000 {
> > +        compatible =3D "mediatek,wocpu_dlm";
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
> > +        mediatek,wocpu_data =3D <&wocpu_data>;
> > +        mediatek,ap2woccif =3D <&ap2woccif0>;
> > +        mediatek,wocpu_ilm =3D <&wocpu0_ilm>;
> > +        mediatek,wocpu_dlm =3D <&wocpu0_dlm>;
> > +        mediatek,wocpu_emi =3D <&wocpu_emi>;
> > +        mediatek,wocpu_boot =3D <&cpu_boot>;
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-boot.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek=
,mt7986-wo-boot.yaml
> > new file mode 100644
> > index 000000000000..dc8fdb706960
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo=
-boot.yaml
> > @@ -0,0 +1,45 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-bo=
ot.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +
> > +title: MediaTek WED WO boot controller interface for MT7986
>=20
> What is 'WED'?

Wireless Ethernet Dispatch. I will fix it in v2.

>=20
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
> > +          - mediatek,wocpu_boot
>=20
> This needs to be SoC specific.
>=20
> And s/_/-/

ack, I will fix it in v2.

>=20
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
> > +      cpu_boot: wocpu_boot@15194000 {
> > +        compatible =3D "mediatek,wocpu_boot", "syscon";
> > +        reg =3D <0 0x15194000 0 0x1000>;
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-ccif.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek=
,mt7986-wo-ccif.yaml
> > new file mode 100644
> > index 000000000000..8fea86425983
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
> > +
> > +title: MediaTek WED WO Controller for MT7986
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The mediatek WO-ccif provides a configuration interface for WED WO
> > +  controller on MT7986 soc.
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - enum:
> > +          - mediatek,ap2woccif
>=20
> SoC specific.

ack, I will fix it in v2.

>=20
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
> > +      ap2woccif0: ap2woccif@151a5000 {
> > +        compatible =3D "mediatek,ap2woccif", "syscon";
> > +        reg =3D <0 0x151a5000 0 0x1000>;
> > +        interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-dlm.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,=
mt7986-wo-dlm.yaml
> > new file mode 100644
> > index 000000000000..529343c57e4b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo=
-dlm.yaml
> > @@ -0,0 +1,66 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-dl=
m.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +
> > +title: MediaTek WED WO hw rx ring interface for MT7986
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The mediatek WO-dlm provides a configuration interface for WED WO
> > +  rx ring on MT7986 soc.
> > +
> > +properties:
> > +  compatible:
> > +    const: mediatek,wocpu_dlm
>=20
> Soc specific
>=20
> s/_/-/

ack, I will fix it in v2.
>=20
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  resets:
> > +    maxItems: 1
> > +
> > +  reset-names:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - resets
> > +  - reset-names
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/reset/ti-syscon.h>
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      ethsys: syscon@15000000 {
> > +        #address-cells =3D <1>;
> > +        #size-cells =3D <1>;
> > +        compatible =3D "mediatek,mt7986-ethsys", "syscon";
> > +        reg =3D <0 0x15000000 0 0x1000>;
> > +
> > +        #clock-cells =3D <1>;
> > +        #reset-cells =3D <1>;
> > +        ethsysrst: reset-controller {
> > +          compatible =3D "ti,syscon-reset";
> > +          #reset-cells =3D <1>;
> > +          ti,reset-bits =3D <0x34 4 0x34 4 0x34 4 (ASSERT_SET | DEASSE=
RT_CLEAR | STATUS_SET)>;
> > +        };
> > +      };
>=20
> Again, don't need the provider here.

ack, I will fix it in v2.

Regards,
Lorenzo

>=20
> > +
> > +      wocpu0_dlm: wocpu_dlm@151e8000 {
> > +        compatible =3D "mediatek,wocpu_dlm";
> > +        reg =3D <0 0x151e8000 0 0x2000>;
> > +        resets =3D <&ethsysrst 0>;
> > +        reset-names =3D "wocpu_rst";
> > +      };
> > +    };
> > --=20
> > 2.37.3
> >=20
> >=20

--1DSfyrdVsyuHoMuf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY1ViPQAKCRA6cBh0uS2t
rD2HAQCFDDC5z7hFAZN/CdFsQfy/0G73kE8rU6n3vN3jnAGfuwEAx85XrRLYcaWu
iQGNLEZqtLc73hY+oXvaAHAZIAY+Yg4=
=oKL4
-----END PGP SIGNATURE-----

--1DSfyrdVsyuHoMuf--
