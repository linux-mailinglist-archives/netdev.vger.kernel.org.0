Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE56760DEEB
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 12:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiJZKhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 06:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiJZKhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 06:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8039F770;
        Wed, 26 Oct 2022 03:37:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8DDD61DFD;
        Wed, 26 Oct 2022 10:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A446CC433C1;
        Wed, 26 Oct 2022 10:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666780631;
        bh=eeh9OL7avB789BlWKiLVjvOqC4FJ1+LRr4nfJouxTcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gBus4uZji7p1TJHpG5wdZcYHRC5ORBJJ/CMU+ejBnX3Fs0QE9A1T4KsIFyG19ETey
         O3QGiIYPPfbsTenGoPykmHOrFwAr5BCsMAXnZ2TMU42BJFXvNN6elv7NsSZMLztHi7
         lLOX9DVJqVESak2WHoUtDmvvMlT8/nUWekOLTivZJnY9ipN4rQzbzETO/iCG//m4nC
         fz5XQGcqdP4r4rd3O5PQG2IfKz+sV7b7cMmZZY08gZ+nPHlxFtHrGPbb33aKCBl9SL
         1DE8m8LrCRLaARn89X8QghX6MsT46iqXAKL0FjEbE3DWJqNV9sNi0aU1g69OC2nxhy
         dNenzSivYgddg==
Date:   Wed, 26 Oct 2022 12:37:07 +0200
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
Subject: Re: [PATCH v2 net-next 2/6] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Message-ID: <Y1kN07OIIjs8QWCA@lore-desk>
References: <cover.1666549145.git.lorenzo@kernel.org>
 <337ef332ca50e6a40f3fdceeb7262d91165c6323.1666549145.git.lorenzo@kernel.org>
 <20221025225248.GA3405306-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1Vy6MAMTFxwciPN0"
Content-Disposition: inline
In-Reply-To: <20221025225248.GA3405306-robh@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1Vy6MAMTFxwciPN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, Oct 23, 2022 at 08:28:06PM +0200, Lorenzo Bianconi wrote:
> > Document the binding for the RX Wireless Ethernet Dispatch core on the
> > MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> > forwarded to LAN/WAN one.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
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
> > +    maxItems: 3
>=20
> What is each entry? Need to define them.

Is something like the chunk below works for you?

  ....

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

  ....
>=20
> > +    description:
> > +      phandles to nodes describing reserved memory used by mt7986-wed =
firmware
> > +      (see bindings/reserved-memory/reserved-memory.txt)
>=20
> What does that document say?
>=20
> (You don't need generic descriptions/refs of common properties)

I used some other bindings as reference (e.g. ti,k3-dsp-rproc.yaml) and
I have not checked the document. I will drop it in v3.

>=20
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
>=20
> This does nothing. You need the opposite? Disallow these properties for=
=20
> 7622?

ack, I will fix in v3.

>=20
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
>=20
> Why a new example?=20

do you mean to drop mt7986-wed example or squash it with mt7622-wed one?
Something like:

wed0: wed@1020a000 {
    compatible =3D "mediatek,mt7622-wed","syscon";
    ....
};

wed1: wed@15011000 {
    compatible =3D "mediatek,mt7986-wed","syscon";
    ....
};

> > +      wed1: wed@1020a000 {


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
>=20
> Don't need to show /reserved-memory in examples.

ack, I will fix it in v3.

>=20
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
>=20
> Don't really need to show these either. You already have them in their=20
> own schemas and we don't need 2 examples.
>=20
> Didn't I already say this?

sorry, I missed it. I will fix it in v3.

Regards,
Lorenzo

>=20
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
> > +        compatible =3D "mediatek,mt7986-wo-ccif","syscon";
> > +        reg =3D <0 0x151a5000 0 0x1000>;
> > +        interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-dlm.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,=
mt7986-wo-dlm.yaml
> > new file mode 100644
> > index 000000000000..db9252598a42
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo=
-dlm.yaml
> > @@ -0,0 +1,50 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-dl=
m.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +
> > +title: MediaTek Wireless Ethernet Dispatch WO hw rx ring interface for=
 MT7986
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The mediatek wo-dlm provides a configuration interface for WED WO
> > +  rx ring on MT7986 soc.
> > +
> > +properties:
> > +  compatible:
> > +    const: mediatek,mt7986-wo-dlm
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
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      wo_dlm0: wo-dlm@151e8000 {
> > +        compatible =3D "mediatek,mt7986-wo-dlm";
> > +        reg =3D <0 0x151e8000 0 0x2000>;
> > +        resets =3D <&ethsysrst 0>;
> > +        reset-names =3D "wocpu_rst";
> > +      };
> > +    };
> > --=20
> > 2.37.3
> >=20
> >=20

--1Vy6MAMTFxwciPN0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY1kN0wAKCRA6cBh0uS2t
rHOOAP9yoEMwa24JeJmhLl9WI65X/sK8nljJhmp/sLJatFtccwEAzECmzi0HuRRR
E3kMT2yzhNbacLKjO0ojG6au05XR+QM=
=q7Tz
-----END PGP SIGNATURE-----

--1Vy6MAMTFxwciPN0--
