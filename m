Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CE0525FC0
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351135AbiEMK0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiEMK0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:26:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7CE23157;
        Fri, 13 May 2022 03:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52CDFB82D74;
        Fri, 13 May 2022 10:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B97C34100;
        Fri, 13 May 2022 10:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652437567;
        bh=DEFM/ExGoGjPo7YWItOfWKTXxJvHjRhr22Z8ZUxBr9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UhRSw3oowHz1/rZVLRKQ4Eel4zp46N36DXc61//DDlgO3fL9mmlF8BJU/NZSUu59m
         cKLJGs3ECK2rzz7JWSkdMhqqI43mVn+2TRnG5yATciHkOZ7AM8av9l4dpdp0j0+6+h
         e0bnyhEEt61MNZNUt+vwrIV/V88LUpPTAItxaG2n6rD8eTB6v+Q3My5edVgXqbDixV
         4zB36pxb/DkVgxsxxh3oIgVUMVDNKxNYGTaCSwvFnXLM27CmDSUkor0dCHmu+Vrw3l
         OEWW4ggl+M1VakqBFA+z4jY4Gmbr3dvjBJK+uMrD8K/WKzUgQAOTFMX9OwBmjK3nYz
         EXK1l0fVk7bhA==
Date:   Fri, 13 May 2022 12:26:03 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 02/14] dt-bindings: net: mediatek,net: add
 mt7986-eth binding
Message-ID: <Yn4yO6kf3Y6Vpco3@lore-desk>
References: <cover.1651839494.git.lorenzo@kernel.org>
 <ce9e2975645e81758558201337f50c6693143fd8.1651839494.git.lorenzo@kernel.org>
 <YnqRiEvS8OV20NSY@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KaswaBvxQsQ7svxS"
Content-Disposition: inline
In-Reply-To: <YnqRiEvS8OV20NSY@robh.at.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KaswaBvxQsQ7svxS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, May 06, 2022 at 02:30:19PM +0200, Lorenzo Bianconi wrote:
> > Introduce dts bindings for mt7986 soc in mediatek,net.yaml.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../devicetree/bindings/net/mediatek,net.yaml | 133 +++++++++++++++++-
> >  1 file changed, 131 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/=
Documentation/devicetree/bindings/net/mediatek,net.yaml
> > index 43cc4024ef98..da1294083eeb 100644
> > --- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
> > +++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> > @@ -21,6 +21,7 @@ properties:
> >        - mediatek,mt7623-eth
> >        - mediatek,mt7622-eth
> >        - mediatek,mt7629-eth
> > +      - mediatek,mt7986-eth
> >        - ralink,rt5350-eth
> > =20
> >    reg:
> > @@ -28,7 +29,7 @@ properties:
> > =20
> >    interrupts:
> >      minItems: 3
> > -    maxItems: 3
> > +    maxItems: 4
>=20
> What's the new interrupt? This should describe what each entry is.
>=20
> If the mt7986-eth must have all 4 interrupts, then the if/then needs a=20
> 'minItems: 4'.

ack, I will fix it in v2.

>=20
> > =20
> >    power-domains:
> >      maxItems: 1
> > @@ -189,6 +190,43 @@ allOf:
> >            minItems: 2
> >            maxItems: 2
> > =20
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: mediatek,mt7986-eth
> > +    then:
> > +      properties:
> > +        clocks:
> > +          minItems: 15
> > +          maxItems: 15
> > +
> > +        clock-names:
> > +          items:
> > +            - const: fe
> > +            - const: gp2
> > +            - const: gp1
> > +            - const: wocpu1
> > +            - const: wocpu0
> > +            - const: sgmii_tx250m
> > +            - const: sgmii_rx250m
> > +            - const: sgmii_cdr_ref
> > +            - const: sgmii_cdr_fb
> > +            - const: sgmii2_tx250m
> > +            - const: sgmii2_rx250m
> > +            - const: sgmii2_cdr_ref
> > +            - const: sgmii2_cdr_fb
> > +            - const: netsys0
> > +            - const: netsys1
> > +
> > +        mediatek,sgmiisys:
> > +          minItems: 2
> > +          maxItems: 2
> > +
>=20
> > +        assigned-clocks: true
> > +
> > +        assigned-clock-parents: true
>=20
> These are automatically allowed on any node with 'clocks' (and now=20
> #clock-cells), so you can drop them.

ack, I will fix it in v2.

>=20
> > +
> >  patternProperties:
> >    "^mac@[0-1]$":
> >      type: object
> > @@ -219,7 +257,6 @@ required:
> >    - interrupts
> >    - clocks
> >    - clock-names
> > -  - power-domains
>=20
> Is that because this chip doesn't have power domains, or support for=20
> them hasn't been added? In the latter case, then you should keep this.=20

power domain are not supported in mt7986 since the soc is intendent mainly =
for
router soc where the device is connected to a power adapter and so the power
domain is always on.

Regards,
Lorenzo

>=20
> >    - mediatek,ethsys
> > =20
> >  unevaluatedProperties: false
> > @@ -295,3 +332,95 @@ examples:
> >          };
> >        };
> >      };
> > +
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    #include <dt-bindings/clock/mt7622-clk.h>
> > +
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      eth: ethernet@15100000 {
> > +        #define CLK_ETH_FE_EN            0
> > +        #define CLK_ETH_WOCPU1_EN        3
> > +        #define CLK_ETH_WOCPU0_EN        4
> > +        #define CLK_TOP_NETSYS_SEL      43
> > +        #define CLK_TOP_NETSYS_500M_SEL 44
> > +        #define CLK_TOP_NETSYS_2X_SEL   46
> > +        #define CLK_TOP_SGM_325M_SEL    47
> > +        #define CLK_APMIXED_NET2PLL      1
> > +        #define CLK_APMIXED_SGMPLL       3
> > +
> > +        compatible =3D "mediatek,mt7986-eth";
> > +        reg =3D <0 0x15100000 0 0x80000>;
> > +        interrupts =3D <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
> > +                     <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>,
> > +                     <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
> > +                     <GIC_SPI 199 IRQ_TYPE_LEVEL_HIGH>;
> > +        clocks =3D <&ethsys CLK_ETH_FE_EN>,
> > +                 <&ethsys CLK_ETH_GP2_EN>,
> > +                 <&ethsys CLK_ETH_GP1_EN>,
> > +                 <&ethsys CLK_ETH_WOCPU1_EN>,
> > +                 <&ethsys CLK_ETH_WOCPU0_EN>,
> > +                 <&sgmiisys0 CLK_SGMII_TX250M_EN>,
> > +                 <&sgmiisys0 CLK_SGMII_RX250M_EN>,
> > +                 <&sgmiisys0 CLK_SGMII_CDR_REF>,
> > +                 <&sgmiisys0 CLK_SGMII_CDR_FB>,
> > +                 <&sgmiisys1 CLK_SGMII_TX250M_EN>,
> > +                 <&sgmiisys1 CLK_SGMII_RX250M_EN>,
> > +                 <&sgmiisys1 CLK_SGMII_CDR_REF>,
> > +                 <&sgmiisys1 CLK_SGMII_CDR_FB>,
> > +                 <&topckgen CLK_TOP_NETSYS_SEL>,
> > +                 <&topckgen CLK_TOP_NETSYS_SEL>;
> > +        clock-names =3D "fe", "gp2", "gp1", "wocpu1", "wocpu0",
> > +                      "sgmii_tx250m", "sgmii_rx250m",
> > +                      "sgmii_cdr_ref", "sgmii_cdr_fb",
> > +                      "sgmii2_tx250m", "sgmii2_rx250m",
> > +                      "sgmii2_cdr_ref", "sgmii2_cdr_fb",
> > +                      "netsys0", "netsys1";
> > +        mediatek,ethsys =3D <&ethsys>;
> > +        mediatek,sgmiisys =3D <&sgmiisys0>, <&sgmiisys1>;
> > +        assigned-clocks =3D <&topckgen CLK_TOP_NETSYS_2X_SEL>,
> > +                          <&topckgen CLK_TOP_SGM_325M_SEL>;
> > +        assigned-clock-parents =3D <&apmixedsys CLK_APMIXED_NET2PLL>,
> > +                                 <&apmixedsys CLK_APMIXED_SGMPLL>;
> > +
> > +        #address-cells =3D <1>;
> > +        #size-cells =3D <0>;
> > +
> > +        mdio: mdio-bus {
> > +          #address-cells =3D <1>;
> > +          #size-cells =3D <0>;
> > +
> > +          phy5: ethernet-phy@0 {
> > +            compatible =3D "ethernet-phy-id67c9.de0a";
> > +            phy-mode =3D "2500base-x";
> > +            reset-gpios =3D <&pio 6 1>;
> > +            reset-deassert-us =3D <20000>;
> > +            reg =3D <5>;
> > +          };
> > +
> > +          phy6: ethernet-phy@1 {
> > +            compatible =3D "ethernet-phy-id67c9.de0a";
> > +            phy-mode =3D "2500base-x";
> > +            reg =3D <6>;
> > +          };
> > +        };
> > +
> > +        mac0: mac@0 {
> > +          compatible =3D "mediatek,eth-mac";
> > +          phy-mode =3D "2500base-x";
> > +          phy-handle =3D <&phy5>;
> > +          reg =3D <0>;
> > +        };
> > +
> > +        mac1: mac@1 {
> > +          compatible =3D "mediatek,eth-mac";
> > +          phy-mode =3D "2500base-x";
> > +          phy-handle =3D <&phy6>;
> > +          reg =3D <1>;
> > +        };
> > +      };
> > +    };
> > --=20
> > 2.35.1
> >=20
> >=20

--KaswaBvxQsQ7svxS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYn4yOwAKCRA6cBh0uS2t
rN1rAQDdB83zL+UIsyVTlMdO1rT/bqpljEXmI4hSFAGKgirP7gD+ImkqQLhgsN0X
bZxpsGiwB7mKAvtxO9l0PdM7hQSBrQ8=
=ZBxy
-----END PGP SIGNATURE-----

--KaswaBvxQsQ7svxS--
