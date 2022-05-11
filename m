Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB59522DD6
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbiEKIDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243300AbiEKIDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:03:41 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15158D69B;
        Wed, 11 May 2022 01:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1652256165;
        bh=B8FTFbkEKSq9FU1nYtmjnKVxghiXhAC0tTT4mBqiWNo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=aJuH3WpsbGssY0jxWTz6NtSsyJj/F0xB3cw1/JLXp51ddDUIpUqmQD5Wdp4TqBz2q
         CyjAL6KdVYo2Ky8npof7tVC9Rz3ydTCsz0+V5soEV9cGcl3c5snAF9lfbdd+Oqk7jz
         o3Dv6CHPzzSk2VO22pirR0DPXkoP6QVPNaqeZdlQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.76.65] ([80.245.76.65]) by web-mail.gmx.net
 (3c-app-gmx-bap47.server.lan [172.19.172.117]) (via HTTP); Wed, 11 May 2022
 10:02:45 +0200
MIME-Version: 1.0
Message-ID: <trinity-68761fe5-fcca-456b-ba50-ead759f0fb54-1652256165646@3c-app-gmx-bap47>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Rob Herring <robh@kernel.org>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Aw: Re: [PATCH v3 1/6] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 11 May 2022 10:02:45 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <YnqymzCbabEjV7GQ@robh.at.kernel.org>
References: <20220507170440.64005-1-linux@fw-web.de>
 <20220507170440.64005-2-linux@fw-web.de>
 <YnqymzCbabEjV7GQ@robh.at.kernel.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:eV/uQqPXza9IH9Y6Gv0NJsaSRebtJEgsDYaeyvL96Y4T6fYpr0o3B2H8VkA557m4XfuMP
 EJm8YxcfAdgzGs60GWOyMLLyOLwpHUmbcx+QBI57BblTcXBCv083UmF50AdAZIM3kIVCwTi/9e6S
 RZ31tWDNSxRFhYErWSOsYivD8eVR/a8PeaGq7XD3uTo325JmaNm68SgIKTNEqUSN38nYYXYf2/KT
 mxvT4xypcXMmCQ4hX3DmI53H0fBjFxbp3EhsginVvb+AQXve2LPZbAm22l28+vdqt1gTW2Vyz3jw
 7s=
X-UI-Out-Filterresults: notjunk:1;V03:K0:IOaqh5ngyBI=:d3wI83YyXXlAM5qDVFD0Bx
 cMUtUb2TC50x2gRAAJG8+Zg6pLpPDiDW9a92hECLC/VqDTv6yKkWZBeDp/qwthXNsa9xm6kVR
 LkII6/vwvDGV3DD1wFHaWMKvAH18z0Ufgo41xshVPfGu2lmUbxzjT3RaBtSXyvKTopRWP3gsx
 sPnFcGXfaVmXoA0AN9//S+VV/PVQ90jQ+9dTtsPEkgTpiGVgCs6FIWGjcyQ7u3tVEaCkNSUyi
 6RjE/M2Bo17O3Jb282h/qPFdHf4GS4k2Rq+BaBq7teOgLe/Y8oVScC45CVtGe2j/0XkJ1dbNM
 LBk4Ts7/2cO8h6hX9BydCCEiX5lwqRNX1rDXTgVxqwdFdpbnnw/l2Pm6Kst1VA2ba4zjjKgJw
 ZbrTNSqpt2lqPQiymgBt/e5NLYYn4GaUcTofI0j7jaGTiz0UOUMGzZg0uQwWCQoPtuf0afZHR
 HvYfLGzpoYO3eEkT6DkOM2l4GOQdTADBRzPPl5ExffJfpBVk+rCMG1ZIwsLnBnwz/aOvUv+Hz
 kctcK4jKKYPSSY+6LgGRFcR/wL2v7ZPEClOrrQE4GJgK0mN8lN66cTCSCP6eVNLjQsd8EuwhD
 RrKqo97HwEmf5fMgTpUYoefC1aQi9DTIRS3RTk6o82BI9ay5kJO5zy428FX+UX8EVPmZzOC/+
 22GIwYHZnZnJrLv7AQAjNoYXx4ZxcMo207iAE1fbEPbcrm6gSuWWnUAdW0VmdjnmFYt4aZ6g5
 E668W/8r4WDOpD8roFZvuJ12jZJ9N8wm0OhM2CsyQ0j2006xHt3m5PC63Ej5TtMF0KO2MgWMp
 nupH2rG
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

thanks for review

> Gesendet: Dienstag, 10. Mai 2022 um 20:44 Uhr
> Von: "Rob Herring" <robh@kernel.org>
> On Sat, May 07, 2022 at 07:04:35PM +0200, Frank Wunderlich wrote:
> > From: Frank Wunderlich <frank-w@public-files.de>

> > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml

> > +properties:
> > +  compatible:
> > +    enum:
> > +      - mediatek,mt7530
> > +      - mediatek,mt7531
> > +      - mediatek,mt7621
> > +
>
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
>
> I don't see any child nodes with addresses, so these can be removed.

dropping this (and address-cells/size-cells from examples) causes errors l=
ike this (address-/size-cells set in mdio
node, so imho it should inherite):

Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.example.dts:34.2=
5-35: Warning (reg_format):
/example-0/mdio/switch@0/ports/port@0:reg: property has invalid length (4 =
bytes) (#address-cells =3D=3D 2, #size-cells =3D=3D 1)
Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.example.dtb: War=
ning (pci_device_reg): Failed prerequisite 'reg_format'

> > +  interrupt-controller:
> > +    type: boolean
>
> Already has a type. Just:
>
> interrupt-controller: true
>
> > +
> > +  interrupts:
> > +    maxItems: 1

> > +patternProperties:
> > +  "^(ethernet-)?ports$":
> > +    type: object
>
>        additionalProperties: false

imho this will block address-/size-cells from this level too. looks like i=
t is needed here too (for port-regs).

> > +
> > +    patternProperties:
> > +      "^(ethernet-)?port@[0-9]+$":
> > +        type: object
> > +        description: Ethernet switch ports
> > +
> > +        unevaluatedProperties: false
> > +
> > +        properties:
> > +          reg:
> > +            description:
> > +              Port address described must be 5 or 6 for CPU port and =
from 0
> > +              to 5 for user ports.
> > +
> > +        allOf:
> > +          - $ref: dsa-port.yaml#
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

> > +  - if:
> > +      required:
> > +        - interrupt-controller
> > +    then:
> > +      required:
> > +        - interrupts
>
> This can be expressed as:
>
> dependencies:
>   interrupt-controller: [ interrupts ]

ok, i will change this

> > +            ports {
>
> Use the preferred form: ethernet-ports

current implementation in all existing dts and examples from old binding a=
re "ports" only.
should they changed too?

> > +                #address-cells =3D <1>;
> > +                #size-cells =3D <0>;
> > +                port@0 {

regards Frank
