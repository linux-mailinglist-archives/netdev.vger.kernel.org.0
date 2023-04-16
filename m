Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939F26E37A4
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjDPLKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 07:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDPLKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 07:10:17 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF2126A3;
        Sun, 16 Apr 2023 04:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1681643386; i=frank-w@public-files.de;
        bh=ymxhQ9TX2WQdTJ+ydPfC8GgwxHoF1StrwXLPfQQbXrc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IFWzxJ56LXpFRMyFSPNTvIA5v9oJ0terq/FW1KKzCKls9n9hD44LkqrzQc7kfEtHT
         Js1Yld/8V7iktVyv0o8nWLnRDJZpzetxONeMV3S10DU6a34x8YLEcpkeMzHD9yuxW3
         IEOPbWlw42EkiYDmCWx7kK4a8ORW/w7UaVBS7AhZkkPXDGwam9k00+wZhids2lxFNY
         wlSFbQ3ZtwVyIUz7TwX4mJFW1/eoO/BZt5cUUdclu9uCCEvpVYIBo6Ap/LxzlNCXuE
         eOJtQgzRSKKvRbmNHbqJXBhMjffqC/HYunRhYvtREk9UbyslTwUrT+EYjBZf2kOpcO
         KSSKBRYBQCGJg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.152.230] ([217.61.152.230]) by web-mail.gmx.net
 (3c-app-gmx-bap64.server.lan [172.19.172.134]) (via HTTP); Sun, 16 Apr 2023
 13:09:46 +0200
MIME-Version: 1.0
Message-ID: <trinity-753f5441-ab68-43df-9640-b9b0db7f8491-1681643386248@3c-app-gmx-bap64>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Cc:     Frank Wunderlich <linux@fw-web.de>, Felix Fietkau <nbd@nbd.name>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Daniel Golle <daniel@makrotopia.org>,
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
        linux-mediatek@lists.infradead.org
Subject: Aw: Re: [RFC/RFT v1] net: ethernet: mtk_eth_soc: drop generic vlan
 rx offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 16 Apr 2023 13:09:46 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <2ad08330-59a0-d3b2-214e-13d93dbe35a1@arinc9.com>
References: <20230416091038.54479-1-linux@fw-web.de>
 <c657f6a2-74fa-2cc1-92cf-18f25464b1e1@arinc9.com>
 <161044DF-0663-42D4-94B8-03741C91B1A4@public-files.de>
 <2ad08330-59a0-d3b2-214e-13d93dbe35a1@arinc9.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:SUiR8hF+FewDGgljpxCW1y4S4fpM7gECbaE3CkqBMqIdBAyTY7LETYV1hoM742uPFLHIr
 YVkhQKp/qAoom3V3ymdrd0oZ0evtIxGs5zB4lMfeXU05+OVgeHWh58OTb6NUxBve93bA7DU4+Fjs
 sTUdhsSTWAC+FU6CukKrqjTmKyQ3bvThF5vuyjRI8TjEgMV4F99+sxyABA4PxjthyKO9Oow++Alg
 LUZIG2pB79ewfbE1KUAtlHqJSVa4lbce5EQO7sYvUma8YScoPXi2ew1ntiKiMQM44+lU7Fohy5IM
 1Y=
UI-OutboundReport: notjunk:1;M01:P0:C+O3HvvEQuY=;EO/g9Mg78RLMbfAH98AuOMYVGWF
 BwyDHPC1IuOZneV8Xvdsq97XR6Esw6D5GCGIOeB3oWnXcxMjUJnC9ELwNoN5tPgoB4kKtm298
 sCkMSA3TnIipuJFN1QT69ADzc54ii1oNpoAy+TXk3HCbAS6z1QQ9pBq2C+NJPBC0d7apjGvfx
 KkGh39fEjAI8gw+0fWdGyp9G7RZ9p7OinQzB5aAKqwJEXyTy5lfGyDc1qqWD6/S4YOKvrkSty
 QhHQij9Y2G26+RubsTXICBBVcP7IPUnj2FeFOjhJeeAXrSsesAszCADcq5R+4KUPwsRjKiZzf
 amcM1ag0vWEi/uG6289PhhfQQHocHSLzVIJND9VS9qUn+3E7KP3JbrbIOf5+vXytJnOTKtxUi
 jj9PayiBEThiDVPjII29eSrId3dRgXcQ6ebEmJcB/YO4XyD0i3dntbcRUasswX8NaWgIvTCl8
 qY4C/IKwuFHnAQvLHIwPgoqMwJpck3oIuXW0l+bE3TaTqbTrW0A6Z7QaMS2ZV7p2T1c0PTnV/
 k38IyMRbugvgSaZT1BQ3le0OU3mEceInu01Cm+nw97LmYpTt8QYh7GVHHpEBcW8tXjk0hzx2P
 kwutZgr/iby2n4hywzbeU7pNjpqKQkZfiNz8rfoATjpKujoNZn7yFxqQzmzyigAerEgs+Pc2O
 TipzsYSibSgYyFg462ej3vTU3tpiDR+EIie9pAeb32ZZcU7zAeN2UwobnYaUyLoGU4/540pAP
 USFvAtnhQ/MiVYVzZ6r91A/LZ2gPnmg13Ta49XEWk0OMybh72qjy83/SBxCsun5zIYBaT/vuw
 Ov3cUKT9k8V/jpP17TLOwNJw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 16=2E April 2023 um 12:55 Uhr
> Von: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>
> On 16=2E04=2E2023 13:15, Frank Wunderlich wrote:
> > Am 16=2E April 2023 11:52:31 MESZ schrieb "Ar=C4=B1n=C3=A7 =C3=9CNAL" =
<arinc=2Eunal@arinc9=2Ecom>:
> >> On 16=2E04=2E2023 12:10, Frank Wunderlich wrote:
> >>> From: Felix Fietkau <nbd@nbd=2Ename>
> >>>
> >>> Through testing I found out that hardware vlan rx offload support se=
ems to
> >>> have some hardware issues=2E At least when using multiple MACs and w=
hen receiving
> >>> tagged packets on the secondary MAC, the hardware can sometimes star=
t to emit
> >>> wrong tags on the first MAC as well=2E
> >>>
> >>> In order to avoid such issues, drop the feature configuration and us=
e the
> >>> offload feature only for DSA hardware untagging on MT7621/MT7622 dev=
ices which
> >>> only use one MAC=2E
> >>
> >> MT7621 devices most certainly use both MACs=2E
> >>
> >>>
> >>> Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>
> >>> Signed-off-by: Felix Fietkau <nbd@nbd=2Ename>
> >>> Signed-off-by: Frank Wunderlich <frank-w@public-files=2Ede>
> >>> ---
> >>> used felix Patch as base and ported up to 6=2E3-rc6 which seems to g=
et lost
> >>> and the original bug is not handled again=2E
> >>>
> >>> it reverts changes from vladimirs patch
> >>>
> >>> 1a3245fe0cf8 net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for =
switch port 0
> >>
> >> Do I understand correctly that this is considered being reverted beca=
use the feature it fixes is being removed?
> >=20
> > As far as i understood, vladimirs patch fixes one
> > cornercase of hw rx offload where felix original
> > patch was fixing more=2E=2Esent it as rft to you to test
> > if your bug (which vladimir fixed) is not coming in
> > again=2E If it does we can try to merge both
> > attempts=2E But current state has broken vlan on
> > bpi-r3 non-dsa gmac1 (sfp-wan)=2E
>=20
> I tested this patch on MT7621AT and MT7623NI SoCs on the current=20
> linux-next=2E Port 0 keeps working fine=2E

looks good so far ;)

> So when you use VLANs on non-DSA gmac1, network connectivity is broken?

the vlan does not work=2E=2E=2Eit looks it is untagged on rx path=2E i see=
 tagged frames on the other
end, send tagged back and these are not received tagged on the mac=2E=2E=
=2Ethis behaviour has brought
me to felix patch i had rebased here=2E the non-vlan traffic is not affect=
ed=2E

> I've got an MT7621AT device which gmac1 is connected to an external phy=
=20
> (sfp-wan, the same case as yours)=2E I'll test VLANs there=2E See if MT7=
621=20
> is affected by this as well since the patch log here states this feature=
=20
> is kept enabled for MT7621 because only gmac0 is used which is false=2E

good idea :)

> Ar=C4=B1n=C3=A7

