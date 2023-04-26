Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5136EF974
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjDZRcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjDZRcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:32:08 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5CABE;
        Wed, 26 Apr 2023 10:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1682530289; i=frank-w@public-files.de;
        bh=GwRobiqv1qHp5RU7uxMCBJnYrMPL3FpHdLHoiVSsaRw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Ynmr3saC4iT4xsA2cYSZ05NnIP8XzKG1V0psslk61w24hDwQbkwfcyIvK7GDr4HRm
         qKnq8HRq+0K0f7auvo5BfThrJfwswJMly83JGZKiGds3/fddIoSAthHgxHonhiqCkr
         afQsGyGy4PlXj4DAZRWhsDSMzY7+4g77G22J/Q7DjQpdRkeKccVhx9dDXlRs+LoOzK
         eDU+5AtMTO4BbLnhUYaCY+RoGnseTa/Y8g6fTZrO6ZZTGDxNAGuwcPYE/uk9VTyY5C
         uHzbI3EsezbKxgI9BI8F5ULgFcaJ6p9SHGtyW0IK2s23Io2dQZDZSoMJO879Q1VIsB
         H6P8A0wFTkoPQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.146.19] ([217.61.146.19]) by web-mail.gmx.net
 (3c-app-gmx-bs05.server.lan [172.19.170.54]) (via HTTP); Wed, 26 Apr 2023
 19:31:29 +0200
MIME-Version: 1.0
Message-ID: <trinity-bb65fd35-fe52-45d2-975c-230e504cc93f-1682530288982@3c-app-gmx-bs05>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Aw: Re: [net v2] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 26 Apr 2023 19:31:29 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <61ea49b7-8a04-214d-ef02-3ef6181619e9@arinc9.com>
References: <20230426172153.8352-1-linux@fw-web.de>
 <61ea49b7-8a04-214d-ef02-3ef6181619e9@arinc9.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:sfKj/0EyPG6sxAAmaIVKAX88w+UGhKLUJ8ltiFTLiTzen4a0Ujz1BDaHcYGDwLlsOr0+g
 DhKQL0QqklHHQHJumYXj9f4OrvWwWOvttMODD8UUNTbxwnnoVTUB6XBSfQAFrDbfl2ySNqhMwqXc
 iuDSz4V1SoQ7FRc6+NzPgJz5D5gQWyWVcg/kHTnBRX5ntKT3gT3561lhcQNU5b9XYcgYZRd6ANBj
 Ds1hfb6sCWcMiMWf/kaJ+dRT7s2Lc5IDnp0fzQyQ2Lw0C+gCDz2XCiB7mc2S9R11b8wbmbCetKSR
 pQ=
UI-OutboundReport: notjunk:1;M01:P0:XZz2sY72ML8=;a16m+i1PJgczSaVFW4Bi1WoZCKJ
 bU4Sw6mk+Nslc93fETkWifNuUOKGQ9HxuNA5SpHMig8TsNPkDADeeGEXsVAhuLTRvyHyXwlQm
 k60cNN1Wt5uTNXrJp0wWgblXvahHEEalQA64QKy1eAwpDNTzRhm4N01bFVedyho9fZs/PU+bK
 KflWe02buao1pJrN7oxlaQaku4EvYcCs/+7vv7HTp0/JDMui4173iwUWicwDGVDcNKH+CHkmJ
 VUcUAHVrrWvYMPLYBsEI30RFImCGeNMKjNTfDZ1Di7BlWY2zoZEkdg791z23iqXKhQKBYjprC
 btOCn1dqw+h9U4+1CCIrxWzC6j9SXhJqsZehh36fyu3rkq8yXSP2iU2hAsBN7UqmtLgEnQUQS
 AEsNmBEYCAA5ExvSWANB2UMa4VLs6Hm+pKZCM99HWtFNOu1vcOc421D8FGAKCftT3NO5w6zqD
 i4dYz60FFn8N2cXS1FbRkF9xgH4u1tmtP9BfVZ0ZNat0K/BNO7mq5j3HTTbJsQUIpt4Gk/6CA
 smWTTMG526A0/d26WGfpDbB1ook2ouBq8eOuoXTJYRTEsYeljaymRhuYmD/mFg0PEqeHryPkM
 7CJR4QvfhSavt2QYiTidHutBDHrW/3QPyAUuRnPREHUvQnd0f1POsrD/WSqfqQar2dPjQ4PNb
 BJjTRMUyCp92giVZeDTWm7YITaWNt3QDI6DTgnUhthcRNQTTu+flToTMtZyhW7fxFGEzGDyk1
 a5BxqFKBqEu3qnRmQTZ6cgFJviLUZ8GdB73IEI2VQe6j8c2V+rhNpTjr7qhFw7EX/nE+dwnkq
 XnA5mwqNbm0853lmblTRY7jw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Gesendet: Mittwoch, 26=2E April 2023 um 19:25 Uhr
> Von: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>
> On 26/04/2023 20:21, Frank Wunderlich wrote:
> > From: Felix Fietkau <nbd@nbd=2Ename>
> >=20
> > Through testing I found out that hardware vlan rx offload support seem=
s to
> > have some hardware issues=2E At least when using multiple MACs and whe=
n
> > receiving tagged packets on the secondary MAC, the hardware can someti=
mes
> > start to emit wrong tags on the first MAC as well=2E
> >=20
> > In order to avoid such issues, drop the feature configuration and use
> > the offload feature only for DSA hardware untagging on MT7621/MT7622
> > devices where this feature works properly=2E
> >=20
> > Fixes: 08666cbb7dd5 ("net: ethernet: mtk_eth_soc: add support for conf=
iguring vlan rx offload")
> > Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>
> > Signed-off-by: Felix Fietkau <nbd@nbd=2Ename>
> > Signed-off-by: Frank Wunderlich <frank-w@public-files=2Ede>
> > Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc=2Eunal@arinc9=2Ecom>
>=20
> I'm confused by this=2E What is HW-vlan-untagging, and which SoCs do you=
=20
> think this patch would break this feature? How can I utilise this=20
> feature on Linux so I can confirm whether it works or not?

the feature itself breaks vlan on mac of bpi-r3

1 mac is connected to switch and uses dsa tags, the other mac is directly =
accessible and vlan-tag
there is stripped by this feature=2E

with this patch i can use vlans on the "standalone" mac again (see tagged =
packets incoming)=2E

regards Frank
