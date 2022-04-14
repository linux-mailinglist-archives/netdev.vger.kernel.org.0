Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56C1501B11
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 20:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344566AbiDNS3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 14:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbiDNS3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 14:29:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEA5EBBA3;
        Thu, 14 Apr 2022 11:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 541E5B82B6E;
        Thu, 14 Apr 2022 18:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C03C385A1;
        Thu, 14 Apr 2022 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649960838;
        bh=cVyGgge77easV/e7GZ83K4vsC7qb1xeRuZBNlG8cMIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ax+a+rs3AfdCzK0LxSaafqzkjCWmVhb4CYt2Y6YCQuV5fxsbx/wveYCftmeFCY5s2
         4kxUtOQsL2e3QbH3amHfHVElze0SwdkcTDghnRo1Uk09XqVmFw/pYzPo+JLANPHMr1
         +f6QICn/VmMyXnaAYAUxMUeAEc2vVIZcCffInolZlHxSkEPmLI35TRy76xudcr5PlQ
         jmkQUBvDGc4PcFGKlpmcAxuAiCSBC7KJxD/9v0TjCmPEHoWA/0khl5kRqlyFpR9nwV
         5OQqBmZXFHc4vuyIJoDNIx3dztXfye8LipMYMtijIc48SOfmygpd5PyfeF+/gbKHm3
         MRD14/AyHrJDw==
Date:   Thu, 14 Apr 2022 20:27:14 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, lorenzo.bianconi@redhat.com,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, john@phrozen.org
Subject: Re: [PATCH net-next] dt-bindings: net: mediatek,net: convert to the
 json-schema
Message-ID: <YlhngsBYwjR0Eg6q@lore-desk>
References: <a01e3acda892ea0dd46edad024d91f213a9db27c.1649931322.git.lorenzo@kernel.org>
 <YlgpCN0hmCvGK6ey@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PsZ7KXMlNe/bEwMM"
Content-Disposition: inline
In-Reply-To: <YlgpCN0hmCvGK6ey@robh.at.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PsZ7KXMlNe/bEwMM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 14, 2022 at 12:19:28PM +0200, Lorenzo Bianconi wrote:
> > This patch converts the existing mediatek-net.txt binding file
> > in yaml format.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../devicetree/bindings/net/mediatek,net.yaml | 294 ++++++++++++++++++
> >  .../devicetree/bindings/net/mediatek-net.txt  | 108 -------
> >  2 files changed, 294 insertions(+), 108 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/mediatek,net.=
yaml
> >  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-net.=
txt
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/=
Documentation/devicetree/bindings/net/mediatek,net.yaml
> > new file mode 100644
> > index 000000000000..6c7696a5b8e7
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> > @@ -0,0 +1,294 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/mediatek,net.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: MediaTek Frame Engine Ethernet controller
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The frame engine ethernet controller can be found on MediaTek SoCs. =
These SoCs
> > +  have dual GMAC ports.
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - mediatek,mt2701-eth
> > +      - mediatek,mt7623-eth
> > +      - mediatek,mt7622-eth
> > +      - mediatek,mt7629-eth
> > +      - ralink,rt5350-eth
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    minItems: 3
> > +    maxItems: 3
> > +
> > +  power-domains:
> > +    maxItems: 1
> > +
> > +  resets:
> > +    maxItems: 1
>=20
> Is it 1 reset or...

Hi Rob,

looking at mt7623.dtsi, I guess we have 3 reset lines here:

	resets:
	  maxItems: 3

>=20
> > +
> > +  reset-names:
> > +    items:
> > +      - const: fe
> > +      - const: gmac
> > +      - const: ppe
>=20
> ... 3 resets?
>=20
> > +
> > +  mediatek,ethsys:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Phandle to the syscon node that handles the port setup.
> > +
> > +  cci-control-port: true
> > +
> > +  mediatek,hifsys:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Phandle to the mediatek hifsys controller used to provide variou=
s clocks
> > +      and reset to the system.
> > +
> > +  dma-coherent: true
> > +
> > +  mdio-bus:
> > +    $ref: mdio.yaml#
> > +    unevaluatedProperties: false
> > +
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
> > +
> > +allOf:
> > +  - $ref: "ethernet-controller.yaml#"
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - mediatek,mt2701-eth
> > +              - mediatek,mt7623-eth
> > +    then:
> > +      properties:
> > +        clocks:
> > +          minItems: 4
> > +          maxItems: 4
> > +
> > +        clock-names:
> > +          additionalItems: false
> > +          items:
> > +            - const: ethif
> > +            - const: esw
> > +            - const: gp1
> > +            - const: gp2
> > +
> > +        mediatek,pctl:
> > +          $ref: /schemas/types.yaml#/definitions/phandle
> > +          description:
> > +            Phandle to the syscon node that handles the ports slew rat=
e and
> > +            driver current.
> > +
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: mediatek,mt7622-eth
> > +    then:
> > +      properties:
> > +        clocks:
> > +          minItems: 11
> > +          maxItems: 11
> > +
> > +        clock-names:
> > +          additionalItems: false
> > +          items:
> > +            - const: ethif
> > +            - const: esw
> > +            - const: gp0
> > +            - const: gp1
> > +            - const: gp2
> > +            - const: sgmii_tx250m
> > +            - const: sgmii_rx250m
> > +            - const: sgmii_cdr_ref
> > +            - const: sgmii_cdr_fb
> > +            - const: sgmii_ck
> > +            - const: eth2pll
> > +
> > +        mediatek,sgmiisys:
> > +          $ref: /schemas/types.yaml#/definitions/phandle-array
> > +          maxItems: 1
> > +          description:
> > +            A list of phandle to the syscon node that handles the SGMI=
I setup which is required for
> > +            those SoCs equipped with SGMII.
> > +
> > +        mediatek,wed:
> > +          $ref: /schemas/types.yaml#/definitions/phandle-array
> > +          minItems: 2
> > +          maxItems: 2
> > +          description:
> > +            List of phandles to wireless ethernet dispatch nodes.
> > +
> > +        mediatek,pcie-mirror:
> > +          $ref: /schemas/types.yaml#/definitions/phandle
> > +          description:
> > +            Phandle to the mediatek pcie-mirror controller.
> +
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: mediatek,mt7629-eth
> > +    then:
> > +      properties:
> > +        clocks:
> > +          minItems: 17
> > +          maxItems: 17
> > +
> > +        clock-names:
> > +          additionalItems: false
> > +          items:
> > +            - const: ethif
> > +            - const: sgmiitop
> > +            - const: esw
> > +            - const: gp0
> > +            - const: gp1
> > +            - const: gp2
> > +            - const: fe
> > +            - const: sgmii_tx250m
> > +            - const: sgmii_rx250m
> > +            - const: sgmii_cdr_ref
> > +            - const: sgmii_cdr_fb
> > +            - const: sgmii2_tx250m
> > +            - const: sgmii2_rx250m
> > +            - const: sgmii2_cdr_ref
> > +            - const: sgmii2_cdr_fb
> > +            - const: sgmii_ck
> > +            - const: eth2pll
> > +
> > +        mediatek,infracfg:
> > +          $ref: /schemas/types.yaml#/definitions/phandle
> > +          description:
> > +            Phandle to the syscon node that handles the path from GMAC=
 to
> > +            PHY variants.
> > +
> > +        mediatek,sgmiisys:
> > +          $ref: /schemas/types.yaml#/definitions/phandle-array
> > +          maxItems: 2
> > +          description:
> > +            A list of phandle to the syscon node that handles the SGMI=
I setup which is required for
> > +            those SoCs equipped with SGMII.
> > +
> > +patternProperties:
> > +  "^mac@[0-1]$":
> > +    type: object
> > +    additionalProperties: false
> > +    allOf:
> > +      - $ref: ethernet-controller.yaml#
> > +    description:
> > +      Ethernet MAC node
> > +    properties:
> > +      compatible:
> > +        const: mediatek,eth-mac
> > +
> > +      reg:
> > +        maxItems: 1
> > +
> > +      phy-handle: true
> > +
> > +      phy-mode: true
> > +
> > +    required:
> > +      - reg
> > +      - compatible
> > +      - phy-handle
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - clock-names
> > +  - power-domains
> > +  - mediatek,ethsys
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    #include <dt-bindings/clock/mt7622-clk.h>
> > +    #include <dt-bindings/power/mt7622-power.h>
> > +
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      ethernet: ethernet@1b100000 {
> > +        compatible =3D "mediatek,mt7622-eth";
> > +        reg =3D <0 0x1b100000 0 0x20000>;
> > +        interrupts =3D <GIC_SPI 223 IRQ_TYPE_LEVEL_LOW>,
> > +                     <GIC_SPI 224 IRQ_TYPE_LEVEL_LOW>,
> > +                     <GIC_SPI 225 IRQ_TYPE_LEVEL_LOW>;
> > +        clocks =3D <&topckgen CLK_TOP_ETH_SEL>,
> > +                 <&ethsys CLK_ETH_ESW_EN>,
> > +                 <&ethsys CLK_ETH_GP0_EN>,
> > +                 <&ethsys CLK_ETH_GP1_EN>,
> > +                 <&ethsys CLK_ETH_GP2_EN>,
> > +                 <&sgmiisys CLK_SGMII_TX250M_EN>,
> > +                 <&sgmiisys CLK_SGMII_RX250M_EN>,
> > +                 <&sgmiisys CLK_SGMII_CDR_REF>,
> > +                 <&sgmiisys CLK_SGMII_CDR_FB>,
> > +                 <&topckgen CLK_TOP_SGMIIPLL>,
> > +                 <&apmixedsys CLK_APMIXED_ETH2PLL>;
> > +        clock-names =3D "ethif", "esw", "gp0", "gp1", "gp2",
> > +                      "sgmii_tx250m", "sgmii_rx250m",
> > +                      "sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii_ck",
> > +                      "eth2pll";
> > +        power-domains =3D <&scpsys MT7622_POWER_DOMAIN_ETHSYS>;
> > +        mediatek,ethsys =3D <&ethsys>;
> > +        mediatek,sgmiisys =3D <&sgmiisys>;
> > +        cci-control =3D <&cci_control2>;
>=20
> Doesn't match the schema. Did you test this? I didn't because it doesn't=
=20
> apply to rc1.

I guess the patch does not apply since there are some commits ([0], [1]) in
the net-next tree not available in Linus's tree yet. I posted this patch for
net-next tree to avoid conflicts, I should hightlight it, sorry for that.

ack, after commit [1] it should be:

             cci-control-port =3D <&cci_control2>;

I tested it running:

$make dt_binding_check DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings/=
net/mediatek,net.yaml

Regards,
Lorenzo

[0] 1dafd0d60703 ("dt-bindings: net: mediatek: add optional properties for =
the SoC ethernet core")
[1] 4263f77a5144 ("net: ethernet: mtk_eth_soc: use standard property for cc=
i-control-port")

>=20
> > +        mediatek,pcie-mirror =3D <&pcie_mirror>;
> > +        mediatek,hifsys =3D <&hifsys>;
> > +        dma-coherent;
> > +
> > +        #address-cells =3D <1>;
> > +        #size-cells =3D <0>;
> > +
> > +        mdio0: mdio-bus {
> > +          #address-cells =3D <1>;
> > +          #size-cells =3D <0>;
> > +
> > +          phy0: ethernet-phy@0 {
> > +            reg =3D <0>;
> > +          };
> > +
> > +          phy1: ethernet-phy@1 {
> > +            reg =3D <1>;
> > +          };
> > +        };
> > +
> > +        gmac0: mac@0 {
> > +          compatible =3D "mediatek,eth-mac";
> > +          phy-mode =3D "rgmii";
> > +          phy-handle =3D <&phy0>;
> > +          reg =3D <0>;
> > +        };
> > +
> > +        gmac1: mac@1 {
> > +          compatible =3D "mediatek,eth-mac";
> > +          phy-mode =3D "rgmii";
> > +          phy-handle =3D <&phy1>;
> > +          reg =3D <1>;
> > +        };
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/D=
ocumentation/devicetree/bindings/net/mediatek-net.txt
> > deleted file mode 100644
> > index f18d70189375..000000000000
> > --- a/Documentation/devicetree/bindings/net/mediatek-net.txt
> > +++ /dev/null
> > @@ -1,108 +0,0 @@
> > -MediaTek Frame Engine Ethernet controller
> > -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > -
> > -The frame engine ethernet controller can be found on MediaTek SoCs. Th=
ese SoCs
> > -have dual GMAC each represented by a child node..
> > -
> > -* Ethernet controller node
> > -
> > -Required properties:
> > -- compatible: Should be
> > -		"mediatek,mt2701-eth": for MT2701 SoC
> > -		"mediatek,mt7623-eth", "mediatek,mt2701-eth": for MT7623 SoC
> > -		"mediatek,mt7622-eth": for MT7622 SoC
> > -		"mediatek,mt7629-eth": for MT7629 SoC
> > -		"ralink,rt5350-eth": for Ralink Rt5350F and MT7628/88 SoC
> > -- reg: Address and length of the register set for the device
> > -- interrupts: Should contain the three frame engines interrupts in num=
eric
> > -	order. These are fe_int0, fe_int1 and fe_int2.
> > -- clocks: the clock used by the core
> > -- clock-names: the names of the clock listed in the clocks property. T=
hese are
> > -	"ethif", "esw", "gp2", "gp1" : For MT2701 and MT7623 SoC
> > -        "ethif", "esw", "gp0", "gp1", "gp2", "sgmii_tx250m", "sgmii_rx=
250m",
> > -	"sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii_ck", "eth2pll" : For MT7622 S=
oC
> > -	"ethif", "sgmiitop", "esw", "gp0", "gp1", "gp2", "fe", "sgmii_tx250m",
> > -	"sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii2_tx250m",
> > -	"sgmii2_rx250m", "sgmii2_cdr_ref", "sgmii2_cdr_fb", "sgmii_ck",
> > -	"eth2pll" : For MT7629 SoC.
> > -- power-domains: phandle to the power domain that the ethernet is part=
 of
> > -- resets: Should contain phandles to the ethsys reset signals
> > -- reset-names: Should contain the names of reset signal listed in the =
resets
> > -		property
> > -		These are "fe", "gmac" and "ppe"
> > -- mediatek,ethsys: phandle to the syscon node that handles the port se=
tup
> > -- mediatek,infracfg: phandle to the syscon node that handles the path =
=66rom
> > -	GMAC to PHY variants, which is required for MT7629 SoC.
> > -- mediatek,sgmiisys: a list of phandles to the syscon node that handle=
s the
> > -	SGMII setup which is required for those SoCs equipped with SGMII such
> > -	as MT7622 and MT7629 SoC. And MT7622 have only one set of SGMII shared
> > -	by GMAC1 and GMAC2; MT7629 have two independent sets of SGMII directed
> > -	to GMAC1 and GMAC2, respectively.
> > -- mediatek,pctl: phandle to the syscon node that handles the ports sle=
w rate
> > -	and driver current: only for MT2701 and MT7623 SoC
> > -
> > -Optional properties:
> > -- dma-coherent: present if dma operations are coherent
> > -- mediatek,cci-control: phandle to the cache coherent interconnect node
> > -- mediatek,hifsys: phandle to the mediatek hifsys controller used to p=
rovide
> > -	various clocks and reset to the system.
> > -- mediatek,wed: a list of phandles to wireless ethernet dispatch nodes=
 for
> > -	MT7622 SoC.
> > -- mediatek,pcie-mirror: phandle to the mediatek pcie-mirror controller=
 for
> > -	MT7622 SoC.
> > -
> > -* Ethernet MAC node
> > -
> > -Required properties:
> > -- compatible: Should be "mediatek,eth-mac"
> > -- reg: The number of the MAC
> > -- phy-handle: see ethernet.txt file in the same directory and
> > -	the phy-mode "trgmii" required being provided when reg
> > -	is equal to 0 and the MAC uses fixed-link to connect
> > -	with internal switch such as MT7530.
> > -
> > -Example:
> > -
> > -eth: ethernet@1b100000 {
> > -	compatible =3D "mediatek,mt7623-eth";
> > -	reg =3D <0 0x1b100000 0 0x20000>;
> > -	clocks =3D <&topckgen CLK_TOP_ETHIF_SEL>,
> > -		 <&ethsys CLK_ETHSYS_ESW>,
> > -		 <&ethsys CLK_ETHSYS_GP2>,
> > -		 <&ethsys CLK_ETHSYS_GP1>;
> > -	clock-names =3D "ethif", "esw", "gp2", "gp1";
> > -	interrupts =3D <GIC_SPI 200 IRQ_TYPE_LEVEL_LOW
> > -		      GIC_SPI 199 IRQ_TYPE_LEVEL_LOW
> > -		      GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>;
> > -	power-domains =3D <&scpsys MT2701_POWER_DOMAIN_ETH>;
> > -	resets =3D <&ethsys MT2701_ETHSYS_ETH_RST>;
> > -	reset-names =3D "eth";
> > -	mediatek,ethsys =3D <&ethsys>;
> > -	mediatek,pctl =3D <&syscfg_pctl_a>;
> > -	#address-cells =3D <1>;
> > -	#size-cells =3D <0>;
> > -
> > -	gmac1: mac@0 {
> > -		compatible =3D "mediatek,eth-mac";
> > -		reg =3D <0>;
> > -		phy-handle =3D <&phy0>;
> > -	};
> > -
> > -	gmac2: mac@1 {
> > -		compatible =3D "mediatek,eth-mac";
> > -		reg =3D <1>;
> > -		phy-handle =3D <&phy1>;
> > -	};
> > -
> > -	mdio-bus {
> > -		phy0: ethernet-phy@0 {
> > -			reg =3D <0>;
> > -			phy-mode =3D "rgmii";
> > -		};
> > -
> > -		phy1: ethernet-phy@1 {
> > -			reg =3D <1>;
> > -			phy-mode =3D "rgmii";
> > -		};
> > -	};
> > -};
> > --=20
> > 2.35.1
> >=20
> >=20

--PsZ7KXMlNe/bEwMM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlhngQAKCRA6cBh0uS2t
rOOAAP0WhhJA0N0dWjfjeMuTh99tmwwWqCS23ogYfCcM9yFjsQEAmW6c4pAsRU2+
1Oy53oR8Bljz2jMyKgt0ZVWeyvyE2gg=
=Dfl0
-----END PGP SIGNATURE-----

--PsZ7KXMlNe/bEwMM--
