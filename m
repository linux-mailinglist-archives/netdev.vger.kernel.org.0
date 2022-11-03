Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C7461877D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiKCSaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiKCSar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:30:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020DF9FD3;
        Thu,  3 Nov 2022 11:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 659B2B8299B;
        Thu,  3 Nov 2022 18:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C03C43470;
        Thu,  3 Nov 2022 18:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667500190;
        bh=8NP93N6yjeh5BdXa1HZVMaOo/12CqJQIQJ1ATx2oaqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=icjWYXZ1vsXVjHuH1AbsSNQtnpwFyQcAWIttcLJ2qf1mUH3F04/GH47DSo9Zofa51
         DkL2Mi8Ux9he/2xVpxoUY2o6eR77YaYyfEDEzWQdeMg48dXckSDIuXYxyXCL+ba1L6
         uwFRoqH/Gw+ZnetL1OcndpH7XkmnMJiVrh5FmjzQgJJU/3BPI9eS9u6c59SWa/NHFl
         SY3xePxwkwKGtG5VjBn/8BierLrA5Ji2iLhNgw8M5/jqeDezBlsGQ3N22kYkOiOuT1
         qqroipr2eX2ioGI3CJZSDDPJU4yXCcm3Do2dn0Qp2caBorpMoam3erXURPPrj30W1R
         h19weCJDmorKA==
Date:   Thu, 3 Nov 2022 19:29:46 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh+dt@kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org
Subject: Re: [PATCH v3 net-next 2/8] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Message-ID: <Y2QImkLcWIcwiTjW@lore-desk>
References: <cover.1667466887.git.lorenzo@kernel.org>
 <2d92c3e282c6a788e54370604f966fc7a5b479bf.1667466887.git.lorenzo@kernel.org>
 <6d1bd86e-29f0-a3b2-700b-978d64990d56@linaro.org>
 <Y2P/jq34IjyM2iXu@lore-desk>
 <aa7e325f-2986-005a-3d0a-579ac46491f6@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yb/LjqbCAVIpV8Hn"
Content-Disposition: inline
In-Reply-To: <aa7e325f-2986-005a-3d0a-579ac46491f6@linaro.org>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yb/LjqbCAVIpV8Hn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 03/11/2022 13:51, Lorenzo Bianconi wrote:
> >>> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,=
mt7986-wo-boot.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediat=
ek,mt7986-wo-boot.yaml
> >>> new file mode 100644
> >>> index 000000000000..6c3c514c48ef
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-=
wo-boot.yaml

Regarding "mediatek,mt7986-wed" compatible string it has been added to
mt7986a.dtsi in the commit below:

commit 00b9903996b3e1e287c748928606d738944e45de
Author: Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue Sep 20 12:11:13 2022 +0200

arm64: dts: mediatek: mt7986: add support for Wireless Ethernet Dispatch

> >>
> >> arm is only for top-level stuff. Choose appropriate subsystem, soc as
> >> last resort.
> >=20
> > these chips are used only for networking so is net folder fine?
>=20
> So this is some MMIO and no actual device? Then rather soc.

ack, I will move them there

>=20
> >=20
> >>
> >>> @@ -0,0 +1,47 @@
> >>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> >>> +%YAML 1.2
> >>> +---
> >>> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-b=
oot.yaml#
> >>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >>> +
> >>> +title:
> >>> +  MediaTek Wireless Ethernet Dispatch WO boot controller interface f=
or MT7986
> >>> +
> >>> +maintainers:
> >>> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> >>> +  - Felix Fietkau <nbd@nbd.name>
> >>> +
> >>> +description:
> >>> +  The mediatek wo-boot provides a configuration interface for WED WO
> >>> +  boot controller on MT7986 soc.
> >>
> >> And what is "WED WO boot controller?
> >=20
> > WED WO is a chip used for networking packet processing offloaded to the=
 Soc
> > (e.g. packet reordering). WED WO boot is the memory used to store start=
 address
> > of wo firmware. Anyway I will let Sujuan comment on this.
>=20
> A bit more should be in description.

I will let Sujuan adding more details (since I do not have them :))

>=20
> >=20
> >>
> >>> +
> >>> +properties:
> >>> +  compatible:
> >>> +    items:
> >>> +      - enum:
> >>> +          - mediatek,mt7986-wo-boot
> >>> +      - const: syscon
> >>> +
> >>> +  reg:
> >>> +    maxItems: 1
> >>> +
> >>> +  interrupts:
> >>> +    maxItems: 1
> >>> +
> >>> +required:
> >>> +  - compatible
> >>> +  - reg
> >>> +
> >>> +additionalProperties: false
> >>> +
> >>> +examples:
> >>> +  - |
> >>> +    soc {
> >>> +      #address-cells =3D <2>;
> >>> +      #size-cells =3D <2>;
> >>> +
> >>> +      wo_boot: syscon@15194000 {
> >>> +        compatible =3D "mediatek,mt7986-wo-boot", "syscon";
> >>> +        reg =3D <0 0x15194000 0 0x1000>;
> >>> +      };
> >>> +    };
> >>> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,=
mt7986-wo-ccif.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediat=
ek,mt7986-wo-ccif.yaml
> >>> new file mode 100644
> >>> index 000000000000..6357a206587a
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-=
wo-ccif.yaml
> >>> @@ -0,0 +1,50 @@
> >>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> >>> +%YAML 1.2
> >>> +---
> >>> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-c=
cif.yaml#
> >>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >>> +
> >>> +title: MediaTek Wireless Ethernet Dispatch WO controller interface f=
or MT7986
> >>> +
> >>> +maintainers:
> >>> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> >>> +  - Felix Fietkau <nbd@nbd.name>
> >>> +
> >>> +description:
> >>> +  The mediatek wo-ccif provides a configuration interface for WED WO
> >>> +  controller on MT7986 soc.
> >>
> >> All previous comments apply.
> >>
> >>> +
> >>> +properties:
> >>> +  compatible:
> >>> +    items:
> >>> +      - enum:
> >>> +          - mediatek,mt7986-wo-ccif
> >>> +      - const: syscon
> >>> +
> >>> +  reg:
> >>> +    maxItems: 1
> >>> +
> >>> +  interrupts:
> >>> +    maxItems: 1
> >>> +
> >>> +required:
> >>> +  - compatible
> >>> +  - reg
> >>> +  - interrupts
> >>> +
> >>> +additionalProperties: false
> >>> +
> >>> +examples:
> >>> +  - |
> >>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> >>> +    #include <dt-bindings/interrupt-controller/irq.h>
> >>> +    soc {
> >>> +      #address-cells =3D <2>;
> >>> +      #size-cells =3D <2>;
> >>> +
> >>> +      wo_ccif0: syscon@151a5000 {
> >>> +        compatible =3D "mediatek,mt7986-wo-ccif", "syscon";
> >>> +        reg =3D <0 0x151a5000 0 0x1000>;
> >>> +        interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> >>> +      };
> >>> +    };
> >>> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,=
mt7986-wo-dlm.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediate=
k,mt7986-wo-dlm.yaml
> >>> new file mode 100644
> >>> index 000000000000..a499956d9e07
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-=
wo-dlm.yaml
> >>> @@ -0,0 +1,50 @@
> >>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> >>> +%YAML 1.2
> >>> +---
> >>> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-d=
lm.yaml#
> >>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >>> +
> >>> +title: MediaTek Wireless Ethernet Dispatch WO hw rx ring interface f=
or MT7986
> >>> +
> >>> +maintainers:
> >>> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> >>> +  - Felix Fietkau <nbd@nbd.name>
> >>> +
> >>> +description:
> >>> +  The mediatek wo-dlm provides a configuration interface for WED WO
> >>> +  rx ring on MT7986 soc.
> >>> +
> >>> +properties:
> >>> +  compatible:
> >>> +    const: mediatek,mt7986-wo-dlm
> >>> +
> >>> +  reg:
> >>> +    maxItems: 1
> >>> +
> >>> +  resets:
> >>> +    maxItems: 1
> >>> +
> >>> +  reset-names:
> >>> +    maxItems: 1
> >>> +
> >>> +required:
> >>> +  - compatible
> >>> +  - reg
> >>> +  - resets
> >>> +  - reset-names
> >>> +
> >>> +additionalProperties: false
> >>> +
> >>> +examples:
> >>> +  - |
> >>> +    soc {
> >>> +      #address-cells =3D <2>;
> >>> +      #size-cells =3D <2>;
> >>> +
> >>> +      wo_dlm0: wo-dlm@151e8000 {
> >>
> >> Node names should be generic.
> >> https://devicetree-specification.readthedocs.io/en/latest/chapter2-dev=
icetree-basics.html#generic-names-recommendation
> >=20
> > DLM is a chip used to store the data rx ring of wo firmware. I do not h=
ave a
> > better node name (naming is always hard). Can you please suggest a bett=
er name?
>=20
> The problem is that you added three new devices which seem to be for the
> same device - WED. It looks like some hacky way of avoid proper hardware
> description - let's model everything as MMIO and syscons...

is it fine to use syscon as node name even if we do not declare it in compa=
tible
string for dlm?

Regards,
Lorenzo

>=20
> For such model - register addresses exposed as separate devices - I do
> not have appropriate name, but the real problem is not in the name. It's
> in the hardware description.
>=20
>=20
> Best regards,
> Krzysztof
>=20

--yb/LjqbCAVIpV8Hn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY2QImgAKCRA6cBh0uS2t
rPdEAQCOdMw1tyeiIQYXHc4we36BEm56cUSJi7SnCgku5X5ctwD9EejZmSVVQLMA
Nwuh3+a02q6DTVYTdBHmFUtRVR798gA=
=ALvQ
-----END PGP SIGNATURE-----

--yb/LjqbCAVIpV8Hn--
