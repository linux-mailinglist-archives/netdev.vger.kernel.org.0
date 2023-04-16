Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831BD6E3708
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 12:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjDPKQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 06:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPKQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 06:16:00 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6969F;
        Sun, 16 Apr 2023 03:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1681640123; i=frank-w@public-files.de;
        bh=esbXS3erM+9bN7FXQfqK4Y+DzXw+7shdEXSjgm5kthU=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=NsN2QSE0pIFy4P8nIh6vsVWtIWTV5qVXWhRn1GPb/SET9aCwAQoPAHKzJfNV50p2l
         VxA3MUqo/FcyiVhHe87oTxR2i9HdepmrNltsesJEHx0avtM+kxIx1jYdZc2ylHm2Ob
         56odbYXBzhn7lsPXvGasftTKwwR9OLZzwzo0oYkhbxyN3lM+L3qrrlpmg+ed3UPpW1
         ULbIqVr9+WTxXs5FtvMy2+q/dRMw3OjtLntMpI1kgPFSBZBcoaTvQn+zrDm+/tM6Zw
         aiW1JDTAlv37VKJFbGUKZubkzkyIb//FzOal1ypbti8KpHHrRrQmN7E55IhRKbutVs
         r+Qtk36hO6sYQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([217.61.152.230]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N8GQy-1qRQq32tsG-014G8M; Sun, 16
 Apr 2023 12:15:23 +0200
Date:   Sun, 16 Apr 2023 12:15:20 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <linux@fw-web.de>,
        Felix Fietkau <nbd@nbd.name>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Daniel Golle <daniel@makrotopia.org>
CC:     John Crispin <john@phrozen.org>,
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
Subject: =?US-ASCII?Q?Re=3A_=5BRFC/RFT_v1=5D_net=3A_et?= =?US-ASCII?Q?hernet=3A_mtk=5Feth=5Fsoc=3A_dro?= =?US-ASCII?Q?p_generic_vlan_rx_offload=2C_only_use_DSA_untagging?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <c657f6a2-74fa-2cc1-92cf-18f25464b1e1@arinc9.com>
References: <20230416091038.54479-1-linux@fw-web.de> <c657f6a2-74fa-2cc1-92cf-18f25464b1e1@arinc9.com>
Message-ID: <161044DF-0663-42D4-94B8-03741C91B1A4@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HAemf09H/mcZT5enwWu1poSJfbWxNQaAH2fZSTGAKXFufW508mO
 zFq7NFgz1YrrMnS4Gk47U7NYO+3EzF4/Le4t0Rs7/4mJRDFXIamqvYoeIAmfsPcQkdbO0Oy
 r6+IGqNB8++NGK7c/5fL8JpOTFlkCtSsS3LPwDnAdfuJvYOEeVRqo5UBnMCNgSayJU3uX5S
 /OnOsSvexov/YZ2P1woXQ==
UI-OutboundReport: notjunk:1;M01:P0:Lrheoc8owC8=;S6MoK7apUwBCxS/IzsJSLjidBVb
 QffW8VJxCxEawwnznEY3BFMr0KkCSg1YO607+l/H19IDnPCbdCL4HujvH6qwW/ZB9v5dkNGKy
 EwP0oy5U0dciEkZM+4gMmbm8ideA28IDlIMFYMokr7/iiKhpFzQpvrFwcK69DTZtFuIkWPiuC
 jlhQuA/+ANKLcCI6WoJ28h+2x7EBdu2Pv8Hu6JvAWzfOhqHrjnLN8KMPHzOS0TCshY8AtLk/p
 pkb+rF8Kywojnj7XOey/tsDLTpgdyMHsLQGnvSXoQZaZCvRXa+GUhEUCpVyLB7UW0oiwv+Z5D
 vp1ARyeC1qwyLwGyuWXzq6tJj2maU/KxIneA6HUj75Hc5aYG6X66iNsE7HmQt575bgCKFlZMn
 /sLQeNUn9yfes/olhDJTMxT22V5+guVTV1MKOKpacyBRJIJHY26BGJznoN/spkpriBylIYrmf
 o7K9L9J+SuIKTGN1fdiSj6hr3ZwIPexaKAEeXSJeg6v2dFBMx/Ei0fL2g5DRnExCKGq4Secly
 CpNyeZGTGLC0zLoFmiFaGny1AOOQCWjl3Q3JkUdKDefr2j9ruW6F7E8g5Faihf9co2hVRt0QL
 SgkXH7cWOBVPqs0Xqzw2rz45x4tHjIjG7cYQyB5rI8brVzqjlSXxPDSZOs2rLlRBk2tSJkGgf
 BX80uIJH+Ed2meH80wJZgYr10XRuh6mpvjxG362wDsUBWIVQ4pc2E9n6dknD6Qfl6yaZW4Qr0
 vLg6ZMCb2ZTHMgUP4iKZxB7nMN6jkPEFbK5Hls/nx32AbL44EZ7PV/fQXgE7loy2rXB48W2yk
 3YL1N2jckwDqaeT6DwIw2XlnjJSTqlZfcjb4V3zxTpdp3wg3sYDTIphQPosX40bclNnyvtygw
 G4xpc1onzeqB49KHkJa6tzWinWzYWH4WNFISeM0v9KhjI5zcHE6hgJuc1hUBT34gCgH8+6H38
 fG+Bmw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 16=2E April 2023 11:52:31 MESZ schrieb "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arin=
c=2Eunal@arinc9=2Ecom>:
>On 16=2E04=2E2023 12:10, Frank Wunderlich wrote:
>> From: Felix Fietkau <nbd@nbd=2Ename>
>>=20
>> Through testing I found out that hardware vlan rx offload support seems=
 to
>> have some hardware issues=2E At least when using multiple MACs and when=
 receiving
>> tagged packets on the secondary MAC, the hardware can sometimes start t=
o emit
>> wrong tags on the first MAC as well=2E
>>=20
>> In order to avoid such issues, drop the feature configuration and use t=
he
>> offload feature only for DSA hardware untagging on MT7621/MT7622 device=
s which
>> only use one MAC=2E
>
>MT7621 devices most certainly use both MACs=2E
>
>>=20
>> Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>
>> Signed-off-by: Felix Fietkau <nbd@nbd=2Ename>
>> Signed-off-by: Frank Wunderlich <frank-w@public-files=2Ede>
>> ---
>> used felix Patch as base and ported up to 6=2E3-rc6 which seems to get =
lost
>> and the original bug is not handled again=2E
>>=20
>> it reverts changes from vladimirs patch
>>=20
>> 1a3245fe0cf8 net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for swi=
tch port 0
>
>Do I understand correctly that this is considered being reverted because =
the feature it fixes is being removed?

As far as i understood, vladimirs patch fixes one
cornercase of hw rx offload where felix original
patch was fixing more=2E=2Esent it as rft to you to test
if your bug (which vladimir fixed) is not coming in
again=2E If it does we can try to merge both
attempts=2E But current state has broken vlan on
bpi-r3 non-dsa gmac1 (sfp-wan)=2E

>Ar=C4=B1n=C3=A7


regards Frank
