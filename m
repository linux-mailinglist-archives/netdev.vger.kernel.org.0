Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4826B6727
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 15:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjCLO1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 10:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCLO1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 10:27:08 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5104ECF3;
        Sun, 12 Mar 2023 07:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678631183; i=frank-w@public-files.de;
        bh=8gKmDff4fx4P4y7WV2067v+MtnzHHo6PoNVb2ypzQEc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bz5/DNvoIUvR6IGhiyPE5jf27AC799hRswTuQ1aX1LaEJna929zlhnh56cHb/wuu9
         uwxmiI3r5YWe1Spyk5GaLeJLp2AXeRmGVee7YICvXlJIYD72dOe5CsxjvClnvXRnt+
         iQn2ir5fPbWQ9uHCDUurisFv0zOn0Io5q1Xlp+VrGdhaR3ioqHvc1JBRQzFCEs7a/K
         22W0zrVN0X+6+WLPP6auapLT/Yv5fjg9hf4ibwagjMHjJY96WxtM6eS8AhLkSe6fWh
         tQTfG7oCz1bCryl+pon/whdu9SY6FEZygNbyiaR643TTMh5Lh1kLHOr7pnYhWy+5iq
         2jcLoFm5yKJaQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.155.253] ([217.61.155.253]) by web-mail.gmx.net
 (3c-app-gmx-bap51.server.lan [172.19.172.121]) (via HTTP); Sun, 12 Mar 2023
 15:26:23 +0100
MIME-Version: 1.0
Message-ID: <trinity-27a405f3-fece-4500-82ef-4082af428a7a-1678631183133@3c-app-gmx-bap51>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Aw: Re: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc:
 fix 1000Base-X and 2500Base-X modes
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 12 Mar 2023 15:26:23 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
References: <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk> <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk> <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:8Dr+JbZAG9ReX8C7mk7Vo758aZ6vkIpxnCQlU/ppmzdxB2U5/9GlsHVagRkJvrGo9uIgc
 9kl4wlKNJpMQKnmQaEtUkHWqAceUpdRm+N0KFLg/L1d5pm7cpM+kFeufcr3Wn43GTR6trmyxY2VX
 7ZUwB8/Z/9xqErQbbFfJDUTMg15NQ7FwVrYMLLzqA5HubC++Eamx4f1Fnxeln0kXORT6lHCzquKk
 paMHjUYsZbxeTFeodfKTXw2IGYQAjwXGXvKMZJ+wnIZ9Yvk8NmOfH3JlQpCqt/e2B9pf/Xs0+8k/
 QQ=
UI-OutboundReport: notjunk:1;M01:P0:a1KgfutJ3bA=;+wMz+CmGCfod2DAgCSEq7Q8DBpJ
 jAR0XkWMzx9WEzb959bifW4ZCFZ8mP0ktv0wY6q8PiKxIrVMTXgkhuHrtiZFiUeMrMVnjcqhe
 +05OZs/8ZxrckwscPZqYpBWPgM6wLDd624Z8K8eD2JoHP5RWavscb6m4ke0wVPsXfA5ZH8dju
 KkQVR4zeGJbnbKRbbdpWx7NC8/fytZ95CSGkRAKz0AQU3LwRI7Alwy35FJGxm639DzvkN1hxX
 Qq2OeR3gcp9BwLVcY/SCMCIsznnKu4hw5ACWQ/obVHSESiZGkNCkEbW4DnOvF1jt9fZ4EDd0z
 AN1/0OKMOGpqIyxXBfcjofUn7COi96P7uFprUg/uK8vFDNnuTkeXdDvhdfWWT3cmdeL9uIFPW
 wBmCMAYzke6Nyybwye5Jf9265wVS2N+B0SgNZt5tiF4HiQ2JybySjXBReNCTaW1zg971znHHf
 I8BgG/QhzuMKvwFTs+RYuJwAk0mTy41VFzfMuyZljbM44V/RsoHtH8keUbPm3O1llsigEQCFp
 Jp5cv3mA7q0DZ6zCTUj9IQuWnGc4Sx7302wY144wpT30Wcg+AK5DihZ+Q9Z2wu7nw4tn1yi6Q
 MQEUA6nrNYjLGfvanWsyoRjOLC8dpl8Lrs8soj0905NgQKfTbfSBHIo78Pw/+IXoXDMYWgwHX
 UgF8nX8rDb4g5u5QRwlRgTN8tBVCEb4vl0BIP1WyautDSWneM9hjTRh6oreN4LzyhT603qals
 FfGLNGhjFJ3lSKKohz7I87zaP9w2OMcdHbOlBT4jsxlX31v1JzGzpAHUW55cQQdSzQzVBp6Y6
 FcXy5ihg4kQplw7SpPz+C2Fg==
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

and i can confirm that disabling autoneg on userspace brings up link on th=
e 2.5g rj45 sfp

root@bpi-r3:~# ip link set eth1 up
[   73.433869] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/=
2500base-x link mode
root@bpi-r3:~# ip link show eth1
3: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state=
 DOWN mode DEFAULT group default qlen 1000
    link/ether 92:2f:d3:16:6f:94 brd ff:ff:ff:ff:ff:ff
root@bpi-r3:~# ethtool -s eth1 autoneg off
root@bpi-r3:~# [  147.190136] mtk_soc_eth 15100000.ethernet eth1: Link is =
Up - 2.5Gbps/Full - flow control off
[  147.198600] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
root@bpi-r3:~#

wonder which flags this changes compared to the original state...these i h=
ave to set in code when the sfp is recognized.

setting these flags in the phylink_parse_mode (or skipping set AN-flags) s=
eem to break it completely

regards Frank
