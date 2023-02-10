Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1502691F10
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 13:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjBJM1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 07:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBJM1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 07:27:06 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB26020077;
        Fri, 10 Feb 2023 04:27:04 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B9FD6C0005;
        Fri, 10 Feb 2023 12:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676032023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onC4uvSvom/UzAuHfG54ufV5S11DPr9PwQEDZQSvD/8=;
        b=D17I3QpQS2PBGfHhv5YdbROETUA+7fAsoT6dg4Br3BNDYs78m2tMntxVZ4/F4ORHBm3MsM
        PIxxe/dJ5MIrm7A7GSeYLl86oQ1yY8FGQNrFQwYK/8psH5xalF7vexhDY3Ng4kw5Ytg/m7
        HHEFHly7quw+bfnMAu9Mt9duRki+Zl3+gbq7slWurMCNlLQIWNOgcGP1uV13SmIf4YY+ks
        WDZtzKrqM1zSksFoZFCSRkukqAPo0gNjir4+3putED9OScnNes0Qh2HFOHI4yocR6HATB6
        udOEiLkIiwedm2twRteLedmCkJerZ3qruz6KSSwKAgrhAeWvN3vWwMFVtYLYtg==
Date:   Fri, 10 Feb 2023 13:29:21 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v3 4/6] dt-bindings: net: renesas,rzn1-gmac:
 Document RZ/N1 GMAC support
Message-ID: <20230210132921.2d6ab6a0@fixe.home>
In-Reply-To: <f894aa27-0f14-5bc9-2eae-114fae7ef3b0@linaro.org>
References: <20230209151632.275883-1-clement.leger@bootlin.com>
        <20230209151632.275883-5-clement.leger@bootlin.com>
        <f894aa27-0f14-5bc9-2eae-114fae7ef3b0@linaro.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 10 Feb 2023 13:01:01 +0100,
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> a =C3=A9crit :

> On 09/02/2023 16:16, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add "renesas,rzn1-gmac" binding documentation which is compatible with
> > "snps,dwmac" compatible driver but uses a custom PCS to communicate
> > with the phy.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> >  .../bindings/net/renesas,rzn1-gmac.yaml       | 67 +++++++++++++++++++
> >  1 file changed, 67 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-=
gmac.yaml
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.ya=
ml b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> > new file mode 100644
> > index 000000000000..029ce758a29c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> > @@ -0,0 +1,67 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/renesas,rzn1-gmac.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Renesas GMAC
> > +
> > +maintainers:
> > +  - Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > +
> > +select:
> > +  properties:
> > +    compatible:
> > +      contains:
> > +        enum:
> > +          - renesas,r9a06g032-gmac
> > +          - renesas,rzn1-gmac
> > +  required:
> > +    - compatible
> > +
> > +allOf:
> > +  - $ref: snps,dwmac.yaml#
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - enum:
> > +          - renesas,r9a06g032-gmac
> > +      - const: renesas,rzn1-gmac
> > +      - const: snps,dwmac =20
>=20
> Thanks, looks good now.
>=20
> > +
> > +  pcs-handle:
> > +    description:
> > +      phandle pointing to a PCS sub-node compatible with
> > +      renesas,rzn1-miic.yaml#
> > +    $ref: /schemas/types.yaml#/definitions/phandle =20
>=20
> you do not need ref here - it is coming from ethernet-controller.yaml
> via snps,dwmac.yaml. You actually could drop entire property, but it can
> also stay for the description.

Ok thanks for the tip. I will drop it since there will be a v4.

>=20
> > +
> > +required:
> > +  - compatible
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +    ethernet@44000000 {
> > +      compatible =3D "renesas,r9a06g032-gmac", "renesas,rzn1-gmac", "s=
nps,dwmac";
> > +      reg =3D <0x44000000 0x2000>;
> > +      interrupt-parent =3D <&gic>;
> > +      interrupts =3D <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
> > +             <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>, =20
>=20
> Please align with previous <
>=20
>=20
> Best regards,
> Krzysztof
>=20



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
