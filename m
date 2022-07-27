Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78036583419
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 22:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiG0UcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 16:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiG0UcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 16:32:05 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476E251A2E;
        Wed, 27 Jul 2022 13:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1658953873;
        bh=6cegGklwMN8G/EK3L6ajLxFxmA8JR/v85vtwkffWMww=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CwJ4xHtVxy9J5c/slCbc9JvCrWKYAsKvdZfBoF9xVxfJxj0VMlfB6xAXS7YxRmsUM
         PDumPMvlaNqzvx2q5jf4RkdrCeLG1OM+tnGB4oEqOF/tlMnAgq2sPf2ACTmsNBRywB
         blcMv8DJDxJWcg/sN4Lfg7hCBLeABDqjk9tqpvaY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.155.189] ([217.61.155.189]) by web-mail.gmx.net
 (3c-app-gmx-bs42.server.lan [172.19.170.94]) (via HTTP); Wed, 27 Jul 2022
 22:31:13 +0200
MIME-Version: 1.0
Message-ID: <trinity-96b64414-7b29-4886-b309-48fc9f108959-1658953872981@3c-app-gmx-bs42>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: Aw: [RFC PATCH net-next] dt-bindings: net: dsa: mediatek,mt7530:
 completely rework binding
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 27 Jul 2022 22:31:13 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20220726122406.31043-1-arinc.unal@arinc9.com>
References: <20220726122406.31043-1-arinc.unal@arinc9.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:2SCSIFa9qDIxiGlO6/J12e1r5kj8WpzZq8CaGp3EH1FDBTB/Zd42SDKO7cKqmHqOw4L9d
 tUQCJxaAASNxBfcLOB9WuFIH7h316jwbh7nsC3aMNtjgQb4AertNWPW8mMveK3gOWDh7l5oIeEmH
 p15ux5hOX+BSmAUo95QOtlvr/d0pmMjeZ4ZG7uTkJfDCrO+NNpdVvNFde23ax6hmXuyIERN0D1zD
 aIokREl3zb1PurqUsXvf0HJb8wM6/vFgPfhJGYie4gWZe8X63g/eeHjiGHRt++gqsF1xxnudgup3
 Ts=
X-UI-Out-Filterresults: notjunk:1;V03:K0:5q6bngrjAHQ=:h2eOVPO5MfSejV/TG/wNgV
 hGp99wen7FNY6GZ1t/so1OQBm8rIRbIDc9wDNrYt+yfw65+YQQ5tW2xQWP8sTVmo57DvpH//k
 d7jbo+5q0XNWqp6gG9YDL/WJgQ32f/Z9ufUNxXZQsOraoMfXc+IZvVtb3wawktWk6vYZknPwm
 opSrJ9dvygiWjp/evzApHuKNRdhdaxbo690MgJ9azVXCoKk9vDwRpPK6DMl9teJL7SwejaWOr
 9SQUuq5iB9eydFT9vFNK2kZpAtTEHZ5YI7YLOYlkunoyfUXOFftsL1L9BrnZXn9pS+8N8l5V3
 kUa+4hgzVB9zfijMYrAFzhQgJI8ANSbW70JBwTZOEyNm/YzXc9atNPYPouUybe15xEg+axL2+
 BSqRmpVC+1H0e9h4RRS04MMQKyljErAasx4CglvrO+p+Olgzqywq8TmOtAhtB9PRrltkyWH52
 8U6eolvfNl7QT8esur9ILdj5sZXOayoPUBnYXNroku6RmcLNWo78YGT1K/5YfGdrVohpDnp6x
 HFwjQe8QHaQdKoQDvGW/CMJc1KJ2TineNxzDH3yGuj9TNoaSe+KnJMqSemZHqL50/S63BYC18
 O0m722erANOhEy6/XiCeBlVUzL01HAEQiNuiFjaPbJclC/4I5XMQ+55lm62Osgko/DHO0wplT
 W6Mp9wRL3cHbgvw//8i22BMJaxIDBVGoNtxLstz1amdpQJPwK9vw05UzrPB900uOt2DXeDEl2
 fIDyg7Q4FWCq8EBtLZJu5UcncMOhOwkQG9TogufLtQpnxVcdRnUpO1xFhtkGsWHn6BPvhEndI
 NhgtWGX
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Gesendet: Dienstag, 26=2E Juli 2022 um 14:24 Uhr
> Von: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>

Hi,=20

> To Frank:
> Let me know if MII bindings for port 5 and 6 on MT7531 are okay=2E

I ack krzysztof, that the change is really huge and it is hard to understa=
nd what exactly is changed and why=2E So please split=2E I have converted=
=20
it to yaml, but not have changed the logic itself=2E I guess you know the =
switch better than me=2E

> Does your recent patch for MT7531 make it possible to set any port for C=
PU,
> including user ports? For now, I put a rule to restrict CPU ports to 5 a=
nd
> 6, as described on the description of dsa port reg property=2E

i only know that port 5 and 6 are possible, not about the other ports=2E A=
fair there was a check if port 5 or 6 (followed by available modes
like rgmii, trgmii or sgmii) and then allow cpu-port-mode else allow only =
user-port mode=2E Had not changed this, so currently only these 2
ports can be used as CPU=2E

> I suppose your patch does not bring support for using MT7530's port 5 as
> CPU port=2E We could try this on a BPI-R2=2E Device schematics show that
> MT7530's GMII pins are wired to GMAC1 of MT7623NI to work as RGMII=2E

my patches (and the version from Vladimir that was merged) only solves the=
 Problem that CPU-Port was fixed to 6 before=2E I tested Patches on r2=20
(mt7530) and r64 too (mt7531) that they do not break anything=2E But i hav=
e not disabled port 6 (maybe i had to do so for a port5-only mode), only
enabled port 5 too and run iperf3 over a vlan-aware bridge between wan-por=
t and port 5=2E

> Ar=C4=B1n=C3=A7

regards Frank
