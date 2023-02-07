Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DEC68D63E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjBGMNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjBGMNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:13:08 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C207AEFA2;
        Tue,  7 Feb 2023 04:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1675771928;
        bh=SZ69qIin1bOhcHFHX74qsjeogSVMDRGBQzd0Cfhbs2E=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=aThNGe0oN9xWnJyHr7GmeaUAcFgS91VHwl3T4h6Bh5LX2gFUMzsOaliBZPtELWzWu
         3JmiYNBBbPDGOzd4cWpTbu8JgX+2ayddP/XXDnBMSdtpA1yCGZUkPJ/DaMuMl4pYUi
         jf4Cyb2kLI9QRiblEb++hArVvoFRE84yuHXO6ljvBpi/SBYOqfQpJ0Tg9GFoZW9S2c
         NoVnWie2tTsuF3ZpmYlW75PN6K68svmpp22rqULWLrmcgZs8EFmZWA31u5HiRcDXOw
         MFJli+T+9k6wXLONIsxHZJ/wuNc7MERLHVO/HZCZelDVKlwkJa6EyrrCPxcXtWBxPO
         wnU6MF+Wj46nQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.159.155] ([217.61.159.155]) by web-mail.gmx.net
 (3c-app-gmx-bap02.server.lan [172.19.172.72]) (via HTTP); Tue, 7 Feb 2023
 13:12:08 +0100
MIME-Version: 1.0
Message-ID: <trinity-808b2619-4325-4d03-b2f5-1a7bc27d42ea-1675771928390@3c-app-gmx-bap02>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH] dt-bindings: mt76: add active-low property to led
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 7 Feb 2023 13:12:08 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <fe3673d9-b921-c445-0f5f-a6bc824e8582@linaro.org>
References: <20230207102501.11418-1-linux@fw-web.de>
 <fe3673d9-b921-c445-0f5f-a6bc824e8582@linaro.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:+4vKtr2ePMdUPyHJjXQx8kjAst9kx6vKtoEZ0xKiTT993WQMGKiXQ7eai7/oGn6SLz9nI
 ExIu7cc+kU3n1HPesxF6zHZqoD5uSYv30WVUhVvbh4whPGhV1ClwgCBYqTPR72g31ap06OVSWIuS
 kUhgkM/shASAqUFcQMHCf1yopvlNodRCkHi1GjXiTfn2XD2HV+1w6HQ4fSmXYeRaajB/sv3vXklv
 3fRlFtg0JVx4PchdKiX+uLoeEA5pW9+LCRNBGAys0H0frB9UAALUBht9ZxjXFjmLLb45w8iazMo2
 S8=
UI-OutboundReport: notjunk:1;M01:P0:MvbBDhuOXcc=;48R3pzi9pbTRbbvz53aZgp+LQH9
 JOc/6fcqxIWF0aacjcgq8+IJ3jRjhxIhdwMJnFr5Y1pr5pUZdjZF0h9ti8ekdXI2fFBVTrkfW
 mn3s/vPiBScFlXx5NiahBjaoqTVuwJcnY1BZ/ICTCv14lpPkOcQrru29OFvaO5RQhWevVhgmc
 lCc1+g3erJ87M7oCsS4KeX6VImQhNVzzY4IEeexbbBgilKn+v6OZD8Bz6RSPa7Kxg/e950lZ5
 H3WFPHzE3hmhVK7DyBQfpHce3NoM5xoqn5N5sNb0uXeNGr1ZfARJli3idt2NTVrjvVS5Q9yem
 6QeHUf4hDD20a+WIfjkLP05zkztHPsF3twaH4Yvs8Qk5fT9FxGjdeaZWW7EhuEfIGBYDLRK0A
 2S8f3L3NwhLd1pdPANh1VdF6+8YdYos+mxk2kQdx5e52JuhsqJkF9oOrPLRp6K//z3e6OpSuk
 a1Ah/srrTOOfg+NWTZDAddu+8nJqP0FN955ZdGB44eg8Mdx7fKPsATkb0hFpxfb0GP+VPsU1R
 eQVLd9LB1hIn7ApvSNTcekZuiYBosX6krL7xejrcr7jLH9ZbNYwDeoFSyZ3ifPRCFT2QVQyKo
 vX2OhyE7j3sm1eYajY4dvPexarxpENtj8vWh/8kK6xtlu/2L5CULkazncboYqY9A5txcoepYf
 pRuN5Bro41Gc6vRSjePZb4+ItkcreGKv3FY0RzCtD8hBvFAUGExarBMZDPcMtGAGch4AXSGxN
 IJrmehVPbNbg42Jcu/na4jMWveY8HHJpr9s3018sdPYkBfxmP69+A58CmpVlptFrvBqhkl3ZU
 EshiDhaI48OoE50v+9COOxsg==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Dienstag, 07. Februar 2023 um 11:40 Uhr
> Von: "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
> On 07/02/2023 11:25, Frank Wunderlich wrote:
> > From: Frank Wunderlich <frank-w@public-files.de>
> >
> > LEDs can be in low-active mode, so add dt property for it.
> >
> > Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> > ---
> >  .../devicetree/bindings/net/wireless/mediatek,mt76.yaml      | 5 ++++=
+
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,m=
t76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.ya=
ml
> > index f0c78f994491..212508672979 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yam=
l
> > +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yam=
l
> > @@ -112,6 +112,11 @@ properties:
> >      $ref: /schemas/leds/common.yaml#
> >      additionalProperties: false
> >      properties:
> > +      led-active-low:
> > +        description:
> > +          LED is enabled with ground signal.
>
> What does it mean? You set voltage of regulator to 0? Or you set GPIO as
> 0? If the latter, it's not the property of LED...

basicly it is a gpio-led mapped into the mt76 driver, but not passing gpio=
 itself in this property (like gpio-led does).
This gpio is set to 0 signal (gnd) to let the led go on ;) so imho it is a=
 led-property, but below the wifi-node as
the trigger comes from mt76 hardware, not an external (soc) gpio controlle=
r.

mt76 driver supports it already like i post change here:

https://patchwork.kernel.org/project/linux-mediatek/patch/20230205174833.1=
07050-1-linux@fw-web.de/

only needed the binding for it.

> Best regards,
> Krzysztof
>
>
