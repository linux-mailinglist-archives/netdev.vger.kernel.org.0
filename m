Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC6451D9FA
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 16:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391553AbiEFOMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 10:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391048AbiEFOMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 10:12:44 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC525A2DF;
        Fri,  6 May 2022 07:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651846105;
        bh=WgytZKjmiBQFX7uZ/jjhSIBiJAj8t5XglcXcRrxeF8Q=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=ZxddAxjw4ulOs6jvFgCz850BHQBqwBs2xNTCt3dcLrC9w5PnoSTdnQJ1L03hIwWHQ
         pUuf0nkXavc93/GJW3DSgT40dOcGB7oJxiBTm166dhP0rV2y3rK5pH5s+SgoMwwikq
         6V4CzMHxAHwRU0E5MRb1s6R531VcUhcE1Z6CAaJ0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.245.76.19]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MAwbz-1ng3gO1qMD-00BMAI; Fri, 06
 May 2022 16:08:25 +0200
Date:   Fri, 06 May 2022 16:08:17 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <ac70ae6d-7e1a-d6b9-e33e-793035d5606e@linaro.org>
References: <20220505150008.126627-1-linux@fw-web.de> <6d45f060-85e6-f3ff-ef00-6c68a2ada7a1@linaro.org> <trinity-12061c77-38b6-4b56-bccd-3b54cf9dc0e8-1651819574078@3c-app-gmx-bs21> <ac70ae6d-7e1a-d6b9-e33e-793035d5606e@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Aw: Re: [RFC v2] dt-bindings: net: dsa: convert binding for mediatek switches
Reply-to: frank-w@public-files.de
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Frank Wunderlich <linux@fw-web.de>,
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
        =?ISO-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <04062F03-43DC-4B92-8C39-2F84ABDE2DE4@public-files.de>
X-Provags-ID: V03:K1:T2On2gkE0ziiZBeVVFwz7HVvt6s28DOg5a5fA6wmtL/dbrZEuhj
 Lc6jEaasYReZ2Th3WG9V3OdBFSGLkGFhxjMiEPCQvTEG1WRCcqaUTZMhy2NnvA9H34jRsa6
 qFVirmd8FSVISD+xDX0OLaoJ58TUm8CgS26ZNmsFg6t9dgkRTpmDwPuiDVIGqnRkLnIACT+
 I9AxXwRJo8n/w6uDoj2zg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wLNzKAt24Gs=:9cXTi89Mx1jhPI9X1MTGb5
 2FtlAU0g62zkWejjYg3duxYKExkF8b1BKvybOIwO5PCED+wMAkU0VUcld1JJ5W+o6RxK8rk3X
 IY4IBtl/Haee4H1h/n2d6ouprEK1lAaQfGirHOihtyfKcWfYc9Q9M7g3iLDdSTpPusWvJh3Ow
 0cLYOxQcU4YzBzw3+RPuRv9LjXXb/6UlezyNZGKjCpVbNirIV39c6I6uSm58e5lvYBGibs1X0
 rfgvE9Tux3JjJ9jtEOmCBD3lSkn5NsK167A6X3CpRUH9OEhKRTiQZpI4k/mvzCT31LStYNBcx
 vWK/hw+5lG9W8th0sWDjSN9/CR23hYaOQUnwlHw2eJpKd5dlyaZztl9EbLRBne2eUUsNV9Ncd
 2IyLcYQXm6crYBI3L5gnrTDB6T4qbDv3PbPbWSF33moVo5WuopCgF+05MXVpRF4wSI2yGZERd
 60JKjqOz4fVYbD3UQGpA0TYjUfeSweEuvBIjZhhgLeRSwFIrUqsDfReWlt4JyfFAyewgqYd8N
 SIUrgTwTeDc3rvPDPn6Bt5n7z/uW9m0gULvr/IPsjwy4kORCKDHKuQ8HX6u8Lif/q3iX5w2Uc
 Aprol01yvwJ4e00aYhh64WS5G4PfE1Kh/x5tFkvSqpyRoCGpPmzx5X4J8dJxfJw3Jsxtl3qwt
 d18BPoo1xDyLtYYZ8Fzk1GmuDQGJy5dpkGcbuUh1MzOsPFWA/UKNxwo/7O/TmUZwmQyrT5kFd
 c9HihY7GMsBKO8BQR9G5Y+LYzuryLVPuj/exy5QSz9pMUR0kgiBCTpfhgLAdrWJhwanRB1G2t
 swnQPpv5l1IvZOIG///twmFl91e5bACtQR1y1CDMc4Bo3Xcxu3g/zGqx6oXkuphm4ZEqKlXmA
 FuW4fvoxNXAm2oXj2BbM9zF0te5Wc/hBafKPJMTe+G4NQ0sEaskKFmIXo49cwABeSFgH43mz/
 zNch3CAozA0grXMaOGIHAYR8RCScF01TDR2WS1bWI1bno9hdxUSe2hL2PCUtxOdjbCHqCRt6o
 qpLPtz4IavtR/x0mifFRSP07o6/Y2BcDiRXQsDxULMKEg537m0x+ATBus+Nc+BAAE/OC5J9bz
 zYvdaugEn1ns7Y=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 6=2E Mai 2022 09:15:12 MESZ schrieb Krzysztof Kozlowski <krzysztof=2Ekoz=
lowski@linaro=2Eorg>:
>On 06/05/2022 08:46, Frank Wunderlich wrote:
>>>> +    const: 1
>>>> +
>>>> +  "#size-cells":
>>>> +    const: 0
>>>> +
>>>> +  core-supply:
>>>> +    description: |
>>>
>>> Drop | everywhere where it is not needed (so in all places, AFAICT)
>>=20
>> is it necessary for multiline-descriptions or is indentation enough?
>
>It's necessary only when YAML syntax characters appear in description
>or
>when you want specific formatting=2E
>
>https://elixir=2Ebootlin=2Ecom/linux/v5=2E18-rc5/source/Documentation/dev=
icetree/bindings/example-schema=2Eyaml#L97
>
>https://yaml-multiline=2Einfo/

Ok then i drop all except on examples

>>>> +
>>>> +patternProperties:
>>>
>>> patternProperties go before allOf, just after regular properties=2E
>>=20
>> after required, right?
>
>properties do not go after required, so neither patternProperties
>should=2E Something like: propertes -> patternProperties -> dependencies
>-> required -> allOf -> additionalProperties -> examples

Thx for explanation

So i end up like this:

https://github=2Ecom/frank-w/BPI-R2-4=2E14/blob/5=2E18-mt7531-mainline/Doc=
umentation/devicetree/bindings/net/dsa/mediatek%2Cmt7530=2Eyaml

Including followup (remove reset-gpios and add rgmii for mt7531)=2E

>>=20
>>>> +  "^(ethernet-)?ports$":
>>>> +    type: object
>>>
>>> Also on this level:
>>>     unevaluatedProperties: false
>>=20
>> this is imho a bit redundant because in dsa=2Eyaml (which is included
>now after patternProperties)
>> it is already set on both levels=2E
>
>dsa=2Eyaml does not set it on ethernet-ports=2E
>
>> Adding it here will fail in examples because of size/address-cells
>which are already defined in dsa=2Eyaml=2E=2E=2E
>> so i need to define them here again=2E
>
>You're right, it cannot be set here=2E

So i make no change here,right?

>Best regards,
>Krzysztof


regards Frank
