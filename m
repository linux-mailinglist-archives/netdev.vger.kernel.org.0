Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CBF51D19C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386293AbiEFGuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 02:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbiEFGun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:50:43 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC966AD6;
        Thu,  5 May 2022 23:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651819574;
        bh=KV3jeJ6Fj2L1SkAtCxVFmXK3uPzJKbcEAuSL/tlV1ik=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=btduVey3BlQmUfg6YOX6cYnoSH8Hy0RgnumNFTiL6wRjeNRBbHmR1J3h2Ypn/fMpW
         o7PY4Ot033Vr7WMjbpBSiQUav8WHmhIeF4BsucbIONsMYVngZcql81vmEyBirEfA73
         wWbYktjABSWwJxKWD5btvKlkTx8CLtk8We4+o24w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.76.19] ([80.245.76.19]) by web-mail.gmx.net
 (3c-app-gmx-bs21.server.lan [172.19.170.73]) (via HTTP); Fri, 6 May 2022
 08:46:14 +0200
MIME-Version: 1.0
Message-ID: <trinity-12061c77-38b6-4b56-bccd-3b54cf9dc0e8-1651819574078@3c-app-gmx-bs21>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
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
        Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Aw: Re: [RFC v2] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 6 May 2022 08:46:14 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <6d45f060-85e6-f3ff-ef00-6c68a2ada7a1@linaro.org>
References: <20220505150008.126627-1-linux@fw-web.de>
 <6d45f060-85e6-f3ff-ef00-6c68a2ada7a1@linaro.org>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:pW8IoZwJ4+eQLrpLprljZZ5we1mc6UihlPLnjsSKx7vGExwwU2pHfQGX8J6s3tEJlPWgp
 xzi8qCsXaC7GLmi/LlF5WI1Q4cUBfPLJEOQoXCaDJ9hsw7G+0ngljQolboWBHMGEiMfnwqWvEnY8
 nA2NWPUDKve/h/R5JID7lGuaLHV2On3MIvuEY/dJW/EfdeUSiYPbGl29bWl7YS9A8R74IK2xZxvG
 IuW1gNMgu8/lUoQ76NufC7mjXPEd5F83+0mN92qaJ8C18iE3pSGLi0bOq3tUvDrMQAw6PZcA87lO
 V8=
X-UI-Out-Filterresults: notjunk:1;V03:K0:duEsPfkDG34=:v+3VUoiQK5x+VV/9IMAE+d
 QoGcOzaWfo0bBO1fQQuWXRlQ3+3eYXHQqItCZu4fSnSP+hD4tbiqQ/A1TKFtYEQh9Ibfpe+A3
 8w/JgMk91ovqOLyMl9OJVsYw63f4SCEbgm/JXze9slUtTk8u+qEF9/SSek7CQgWdH4KsI5mCs
 02UNluDo3Hs/64UbXmWuaqYoC3g4RV8rZK4qUJls7twPkziZuZ3AJzn0pMXoAch3NKg/TGP8I
 rbaCuUMoCrILrezlh2VbnPUSbk05SAlwIrOSSll7aOw0dTBslVheYwf9tUzxoVr96V0LO7xOB
 XpIlRGTsa9hyW1iFAXKoFBNgTMknthWG7sDGbUaLAZqPWeckTEUyFhXziS3xmA1+PdL5K43aq
 Z5Lpluo+CsUIFaVajdpx6H4967jcTTs8vq4NdWm44jH6Gu/60ZSiBAAZYEROh6c9UAljRT/Yz
 jMlcCQj4TgFHl5M0znw3TXhP31xah5K7o7+NyP4FfT/CG7XPuzicNuGyNCvahmoMUl8pvYNCX
 LG6xGjiaIrEQ8vwDYlXd1OvJMcn6XFrkWb5dww+FHOkdv3q5hKK99iO9jZkWsKOWt59eUqgk0
 /h1OVFP7LJmAXnicoz03lsJixSzf3Ayd9EXGD2ltQRQ8oWBXW8MEOnZMtCoNDgzlRPhbpKn6b
 OG0+cn95Sbip7syJM3bpRNaIRrlXAJu4miFiAn4XzFIslUdU/HielGiQ5bOl8pDYRYQd8RBj/
 bw0yLUP7vx+tH2Qa39vTr1pVrBnr1RKq4iEN8NecE0/4uWzMbWFQax5LdIWLqVeCIwNgTjeBu
 n3OFKmr
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Donnerstag, 05=2E Mai 2022 um 22:29 Uhr
> Von: "Krzysztof Kozlowski" <krzysztof=2Ekozlowski@linaro=2Eorg>
> An: "Frank Wunderlich" <linux@fw-web=2Ede>, linux-mediatek@lists=2Einfra=
dead=2Eorg
> Cc: "Frank Wunderlich" <frank-w@public-files=2Ede>, "Andrew Lunn" <andre=
w@lunn=2Ech>, "Vivien Didelot" <vivien=2Edidelot@gmail=2Ecom>, "Florian Fai=
nelli" <f=2Efainelli@gmail=2Ecom>, "Vladimir Oltean" <olteanv@gmail=2Ecom>,=
 "David S=2E Miller" <davem@davemloft=2Enet>, "Jakub Kicinski" <kuba@kernel=
=2Eorg>, "Paolo Abeni" <pabeni@redhat=2Ecom>, "Rob Herring" <robh+dt@kernel=
=2Eorg>, "Krzysztof Kozlowski" <krzysztof=2Ekozlowski+dt@linaro=2Eorg>, "Ma=
tthias Brugger" <matthias=2Ebgg@gmail=2Ecom>, "Sean Wang" <sean=2Ewang@medi=
atek=2Ecom>, "Landen Chao" <Landen=2EChao@mediatek=2Ecom>, "DENG Qingfang" =
<dqfext@gmail=2Ecom>, netdev@vger=2Ekernel=2Eorg, devicetree@vger=2Ekernel=
=2Eorg, linux-kernel@vger=2Ekernel=2Eorg, linux-arm-kernel@lists=2Einfradea=
d=2Eorg, "Greg Ungerer" <gerg@kernel=2Eorg>, "Ren=C3=A9 van Dorst" <opensou=
rce@vdorst=2Ecom>, "Mauro Carvalho Chehab" <mchehab+samsung@kernel=2Eorg>
> Betreff: Re: [RFC v2] dt-bindings: net: dsa: convert binding for mediate=
k switches
>
> On 05/05/2022 17:00, Frank Wunderlich wrote:
> > From: Frank Wunderlich <frank-w@public-files=2Ede>
> >=20
> > Convert txt binding to yaml binding for Mediatek switches=2E
> >=20
> > Signed-off-by: Frank Wunderlich <frank-w@public-files=2Ede>
>=20
> Thank you for your patch=2E There is something to discuss/improve=2E
>=20
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
> > +
> > +  core-supply:
> > +    description: |
>=20
> Drop | everywhere where it is not needed (so in all places, AFAICT)

is it necessary for multiline-descriptions or is indentation enough?
=20
> > +      Phandle to the regulator node necessary for the core power=2E
> > +
> > +  "#gpio-cells":
> > +    description: |
> > +      Must be 2 if gpio-controller is defined=2E
>=20
> Skip description, it's obvious from the GPIO controller schema=2E

ok

> > +    const: 2
> > +
> > +  gpio-controller:
> > +    type: boolean
> > +    description: |
> > +      if defined, MT7530's LED controller will run on GPIO mode=2E
> > +
> > +  "#interrupt-cells":
> > +    const: 1
> > +
> > +  interrupt-controller:
> > +    type: boolean
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  io-supply:
> > +    description: |
> > +      Phandle to the regulator node necessary for the I/O power=2E
> > +      See Documentation/devicetree/bindings/regulator/mt6323-regulato=
r=2Etxt
> > +      for details for the regulator setup on these boards=2E
> > +
> > +  mediatek,mcm:
> > +    type: boolean
> > +    description: |
> > +      if defined, indicates that either MT7530 is the part on multi-c=
hip
> > +      module belong to MT7623A has or the remotely standalone chip as=
 the
> > +      function MT7623N reference board provided for=2E
> > +
> > +  reset-gpios:
> > +    description: |
> > +      Should be a gpio specifier for a reset line=2E
>=20
> Skip description=2E
ok=20
> > +    maxItems: 1
> > +
> > +  reset-names:
> > +    description: |
> > +      Should be set to "mcm"=2E
>=20
> Skip description=2E
ok
> > +    const: mcm
> > +
> > +  resets:
> > +    description: |
> > +      Phandle pointing to the system reset controller with line index=
 for
> > +      the ethsys=2E
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +allOf:
> > +  - $ref: "dsa=2Eyaml#"
> > +  - if:
> > +      required:
> > +        - mediatek,mcm
> > +    then:
> > +      required:
> > +        - resets
> > +        - reset-names
> > +    else:
> > +      required:
> > +        - reset-gpios
> > +
> > +  - if:
> > +      required:
> > +        - interrupt-controller
> > +    then:
> > +      required:
> > +        - interrupts
> > +
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          items:
> > +            - const: mediatek,mt7530
> > +    then:
> > +      required:
> > +        - core-supply
> > +        - io-supply
> > +
> > +
> > +patternProperties:
>=20
> patternProperties go before allOf, just after regular properties=2E

after required, right?

> > +  "^(ethernet-)?ports$":
> > +    type: object
>=20
> Also on this level:
>     unevaluatedProperties: false

this is imho a bit redundant because in dsa=2Eyaml (which is included now =
after patternProperties)
it is already set on both levels=2E
Adding it here will fail in examples because of size/address-cells which a=
re already defined in dsa=2Eyaml=2E=2E=2E
so i need to define them here again=2E

> > +
> > +    patternProperties:
> > +      "^(ethernet-)?port@[0-9]+$":
> > +        type: object
> > +        description: Ethernet switch ports
> > +
> > +        properties:
> > +          reg:
> > +            description: |
> > +              Port address described must be 6 for CPU port and from =
0 to 5 for user ports=2E
>=20
> This looks like not wrapped @80 character=2E

i fix this

> > +
> > +        unevaluatedProperties: false
> > +
> > +        allOf:
> > +          - $ref: dsa-port=2Eyaml#
> > +          - if:
> > +              properties:
> > +                label:
> > +                  items:
> > +                    - const: cpu
> > +            then:
> > +              required:
> > +                - reg
> > +                - phy-mode
> > +
> > +unevaluatedProperties: false
>=20
> Best regards,
> Krzysztof

regards Frank
