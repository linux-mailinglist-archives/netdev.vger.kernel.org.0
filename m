Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71CE5187D8
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbiECPJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbiECPJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:09:10 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F79C2A265;
        Tue,  3 May 2022 08:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651590197;
        bh=OcpafLIt0jbneUh+lh/+Hat5tB4rpXqh9esglhCE1PA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=J+keRjufRwAUUf2PcbgLNwiW6Tczw23s5ydI8twe+7t3Mv59Ff6aSzKs9u07oxywi
         Wk6ZesMMLwLbGHLKaxKQcEO3xbbnQOkAAWWAqyLeoKc4BgJa2uyq4unTIvuXPVb/gp
         783cO9vUh9S4925R1yr4Im5fSD4PSBBq1AyF9Tkw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.79.168] ([80.245.79.168]) by web-mail.gmx.net
 (3c-app-gmx-bap25.server.lan [172.19.172.95]) (via HTTP); Tue, 3 May 2022
 17:03:17 +0200
MIME-Version: 1.0
Message-ID: <trinity-213ab6b1-ccff-4429-b76c-623c529f6f73-1651590197578@3c-app-gmx-bap25>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Frank Wunderlich <linux@fw-web.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Aw: Re:  Re: [RFC v1] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 3 May 2022 17:03:17 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <10770ff5-c9b1-7364-4276-05fa0c393d3b@linaro.org>
References: <20220502153238.85090-1-linux@fw-web.de>
 <d29637f8-87ff-b5f0-9604-89b51a2ba7c1@linaro.org>
 <trinity-cda3b94f-8556-4b83-bc34-d2c215f93bcd-1651587032669@3c-app-gmx-bap25>
 <10770ff5-c9b1-7364-4276-05fa0c393d3b@linaro.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:412/kqjZIklGXFr8Vb2bmPU4hB0IuTBE1tkzXvY79SrJpQxz416SoaFKK9pphNaVQjsGu
 +NYzxSyHxPy7LiC3qq3uB3vzyIBI/nY/NfEzZyMlGIwwT90CqICKvGnqSx2s6zIXRIiOJ8QI2/e1
 0AVFBKhNZu99fXfWQjowWBjl5KXHacNsn4d+6nRmUVcNxmQVnhQDg/5UXTyyTknC7Z8NEcXChH58
 z+P1lQU2p3e+hftjX6Fgx1aFIdzbOG8cw/GnDmhl74bqbMwBQIzuxngEO2+m7vQk8+u+o8ZBDfrs
 fY=
X-UI-Out-Filterresults: notjunk:1;V03:K0:G5iULIMJIC8=:XNcQJK0m65jKrYRh25eIDF
 vOw5QoWubiN+Zt1sI06nKCoJpcZhNCUK481x7/qfN/hGPMMlVdQaT86tx9UfubYPZie4vGvtv
 wnZ5Mms/fLO6JJniRxh2Pu7jpf9eGUNf95XWtaRTX7X4PonWaQO8iHAv01/PtNRpeRO29Dh0L
 vIZ44nsJemkhKfLEjqtKnV4us0ziwZT5QPrXsND3oxu4CFCDG3yphLmvc1RiwaAlDU+oo8tSA
 BJMiZ7q1m84x1JwU50qkDWneljoJNkVWFFLCxalfYvRByUaIU5pEfUUKLgn1XGNic+Gc9Ee+l
 1Oxa0Nbn6kJtpCAuo92BVrUFJbdOQr++ObLshQMJjmWwvXCMyWwiInfaouS0/eknxAtskf0y8
 25Bn1anR2lzhSHYyNgyIlSP3meNQGALOoUzI3rs0ytYL+wfsKZefI2uHFuHh0I8D31X+ba2TH
 TADCSQMPc/yOoD+I6Ph2LgtQTbMvzWl3GChFNAAglSzimsUjrnFjljKsEx/kj2IjJH3whV8Xs
 RxSqenpWcSt49bOg6VOYhNWfYmTYGzhTDDFJjgCrPBGrTa8JCEHpnjN6Tyj5RIR4jga/pDbp8
 p8h5dBGmbNZ3xZ3VL02DCQ4e4ayNke/7dBgMeS1fQ+T/w/Fz3ZMNQanfLH5xd5XOiosneuxBC
 BPtn6fm4McxhXhaFmvfLxzZvuB71tW8n507yRlYeqDHUOhMOFstIl0a3X8HQAx24v4FJJ0qMM
 oRM99ONN3VmdVN3VrQmNlF9yL+eBwKeTHHOfw0sDOBC9h3MoMxv5XNfjhJu4N9G0EOXTyP0c2
 /+xbhxqNS5NfALhHs01R7/gvKbOl3G5A7u4HAy1oLEDUYsCwVPt7ZmImJatya7TizhSbZ9UuV
 lzs4ytH07TRehx8rDqiw==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Gesendet: Dienstag, 03. Mai 2022 um 16:40 Uhr
> Von: "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
> Betreff: Re: Aw: Re: [RFC v1] dt-bindings: net: dsa: convert binding for=
 mediatek switches
>
> On 03/05/2022 16:10, Frank Wunderlich wrote:
> > Hi,
> >
> > thank you for first review.
> >
> >> Gesendet: Dienstag, 03. Mai 2022 um 14:05 Uhr
> >> Von: "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
> >> Betreff: Re: [RFC v1] dt-bindings: net: dsa: convert binding for medi=
atek switches
> >>
> >> On 02/05/2022 17:32, Frank Wunderlich wrote:
> >>> From: Frank Wunderlich <frank-w@public-files.de>
> >>>
> >>> Convert txt binding to yaml binding for Mediatek switches.
> >>>
> >>> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> >>> ---
> >>>  .../devicetree/bindings/net/dsa/mediatek.yaml | 435 +++++++++++++++=
+++
> >>>  .../devicetree/bindings/net/dsa/mt7530.txt    | 327 -------------
> >>>  2 files changed, 435 insertions(+), 327 deletions(-)
> >>>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mediat=
ek.yaml
> >>>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530=
.txt
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek.yaml=
 b/Documentation/devicetree/bindings/net/dsa/mediatek.yaml
> >>> new file mode 100644
> >>> index 000000000000..c1724809d34e
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek.yaml
> >>
> >> Specific name please, so previous (with vendor prefix) was better:
> >> mediatek,mt7530.yaml
> >
> > ok, named it mediatek only because mt7530 is only one possible chip an=
d driver handles 3 different "variants".
> >
> >>> @@ -0,0 +1,435 @@
> >>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >>
> >> You should CC previous contributors and get their acks on this. You
> >> copied here a lot of description.
> >
> > added 3 Persons that made commits to txt before to let them know about=
 this change
> >
> > and yes, i tried to define at least the phy-mode requirement as yaml-d=
epency, but failed because i cannot match
> > compatible in subnode.
>
> I don't remember such syntax.
>
> (...)

have not posted this version as it was failing in dtbs_check, this was how=
 i tried:

https://github.com/frank-w/BPI-R2-4.14/blob/8f2033eb6fcae273580263c3f0b31f=
0d48821740/Documentation/devicetree/bindings/net/dsa/mediatek.yaml#L177


> >>> if defined, indicates that either MT7530 is the part
> >>> +      on multi-chip module belong to MT7623A has or the remotely st=
andalone
> >>> +      chip as the function MT7623N reference board provided for.
> >>> +
> >>> +  reset-gpios:
> >>> +    description: |
> >>> +      Should be a gpio specifier for a reset line.
> >>> +    maxItems: 1
> >>> +
> >>> +  reset-names:
> >>> +    description: |
> >>> +      Should be set to "mcm".
> >>> +    const: mcm
> >>> +
> >>> +  resets:
> >>> +    description: |
> >>> +      Phandle pointing to the system reset controller with
> >>> +      line index for the ethsys.
> >>> +    maxItems: 1
> >>> +
> >>> +required:
> >>> +  - compatible
> >>> +  - reg
> >>
> >> What about address/size cells?
> >
> > you're right even if they are const to a value they need to be set
> >
> >>> +
> >>> +allOf:
> >>> +  - $ref: "dsa.yaml#"
> >>> +  - if:
> >>> +      required:
> >>> +        - mediatek,mcm
> >>
> >> Original bindings had this reversed.
> >
> > i know, but i think it is better readable and i will drop the else-par=
t later.
> > Driver supports optional reset ("mediatek,mcm" unset and without reset=
-gpios)
> > as this is needed if there is a shared reset-line for gmac and switch =
like on R2 Pro.
> >
> > i left this as separate commit to be posted later to have a nearly 1:1=
 conversion here.
>
> Ah, I missed that actually your syntax is better. No need to
> reverse/negate and the changes do not have to be strict 1:1.

yes, but a conversion implies same meaning, so changing things later ;)

> >>> +    then:
> >>> +      required:
> >>> +        - resets
> >>> +        - reset-names
> >>> +    else:
> >>> +      required:
> >>> +        - reset-gpios
> >>> +
> >>> +  - if:
> >>> +      required:
> >>> +        - interrupt-controller
> >>> +    then:
> >>> +      required:
> >>> +        - "#interrupt-cells"
> >>
> >> This should come from dt schema already...
> >
> > so i should drop (complete block for interrupt controller)?
>
> The interrupts you need. What I mean, you can skip requirement of cells.

ok, i drop only the #interrupt-cells

> >>> +        - interrupts
> >>> +
> >>> +  - if:
> >>> +      properties:
> >>> +        compatible:
> >>> +          items:
> >>> +            - const: mediatek,mt7530
> >>> +    then:
> >>> +      required:
> >>> +        - core-supply
> >>> +        - io-supply
> >>> +
> >>> +
> >>> +patternProperties:
> >>> +  "^ports$":
> >>
> >> It''s not a pattern, so put it under properties, like regular propert=
y.
> >
> > can i then make the subnodes match? so the full block will move above =
required between "mediatek,mcm" and "reset-gpios"
>
> Yes, subnodes stay with patternProperties.
>
> >
> >   ports:
> >     type: object
> >
> >     patternProperties:
> >       "^port@[0-9]+$":
> >         type: object
> >         description: Ethernet switch ports
> >
> >         properties:
> >           reg:
> >             description: |
> >               Port address described must be 5 or 6 for CPU port and f=
rom 0 to 5 for user ports.
> >
> >         unevaluatedProperties: false
> >
> >         allOf:
> >           - $ref: dsa-port.yaml#
> >           - if:
> > ....
> >
> > basicly this "ports"-property should be required too, right?
>
> Previous binding did not enforce it, I think, but it is reasonable to
> require ports.

basicly it is required in dsa.yaml, so it will be redundant here

https://elixir.bootlin.com/linux/v5.18-rc5/source/Documentation/devicetree=
/bindings/net/dsa/dsa.yaml#L55

this defines it as pattern "^(ethernet-)?ports$" and should be processed b=
y dsa-core. so maybe changing it to same pattern instead of moving up as n=
ormal property?

> >>> +    type: object
> >>> +
> >>> +    patternProperties:
> >>> +      "^port@[0-9]+$":
> >>> +        type: object
> >>> +        description: Ethernet switch ports
> >>> +
> >>> +        $ref: dsa-port.yaml#
> >>
> >> This should go to allOf below.
> >
> > see above
> >
> >>> +
> >>> +        properties:
> >>> +          reg:
> >>> +            description: |
> >>> +              Port address described must be 6 for CPU port and fro=
m 0 to 5 for user ports.
> >>> +
> >>> +        unevaluatedProperties: false
> >>> +
> >>> +        allOf:
> >>> +          - if:
> >>> +              properties:
> >>> +                label:
> >>> +                  items:
> >>> +                    - const: cpu
> >>> +            then:
> >>> +              required:
> >>> +                - reg
> >>> +                - phy-mode
> >>> +
> >>> +unevaluatedProperties: false
> >>> +
> >>> +examples:
> >>> +  - |
> >>> +    mdio0 {
> >>
> >> Just mdio
> >
> > ok
> >
> >>> +        #address-cells =3D <1>;
> >>> +        #size-cells =3D <0>;
> >>> +        switch@0 {
> >>> +            compatible =3D "mediatek,mt7530";
> >>> +            #address-cells =3D <1>;
> >>> +            #size-cells =3D <0>;
> >>> +            reg =3D <0>;
> >>> +
> >>> +            core-supply =3D <&mt6323_vpa_reg>;
> >>> +            io-supply =3D <&mt6323_vemc3v3_reg>;
> >>> +            reset-gpios =3D <&pio 33 0>;
> >>
> >> Use GPIO flag define/constant.
> >
> > this example seems to be taken from bpi-r2 (i had taken it from the tx=
t). In dts for this board there are no
> > constants too.
> >
> > i guess
> > include/dt-bindings/gpio/gpio.h:14:#define GPIO_ACTIVE_HIGH 0
> >
> > for 33 there seem no constant..all other references to pio node are wi=
th numbers too and there seem no binding
> > header defining the gpio pins (only functions in include/dt-bindings/p=
inctrl/mt7623-pinfunc.h)
>
> ok, then my comment

you mean adding a comment to the example that GPIO-flags/constants should =
be used instead of magic numbers?

> Best regards,
> Krzysztof

this is how it looks like without the port-property-change:
https://github.com/frank-w/BPI-R2-4.14/blob/5.18-mt7531-mainline/Documenta=
tion/devicetree/bindings/net/dsa/mediatek,mt7530.yaml

regards Frank

