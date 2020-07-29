Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AE6231AF9
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgG2IPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:15:51 -0400
Received: from mout.gmx.net ([212.227.17.20]:34621 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgG2IPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 04:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1596010525;
        bh=SEqiVovF7XeGtohoS2GMeFwDMUmZ9pW/KT58etbzx3I=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=XCZiliPRjvI4fnxBMHTK8ktxBj8sm8c/suvC2q8k3NejMEYSicFhklCixPYr8jL/q
         p1s0lmomB8VJWQ3JsjfhEHquqim7j0pwfdIs7m46HB5x6m66dlD40RnA59WugB/3i0
         yUz3c1y3zCJnzX1w5V7FO4NHoO2sDc7T7nuYWa4U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([185.75.74.240]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1M9Fnj-1k6SfS2l1j-006QTq; Wed, 29 Jul 2020 10:15:25 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Landen Chao <landen.chao@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4] net: ethernet: mtk_eth_soc: fix MTU warnings
Date:   Wed, 29 Jul 2020 10:15:17 +0200
Message-Id: <20200729081517.4026-1-frank-w@public-files.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SIqtPyJoGFptjlcPcxyQb71WF05R8NP7BOYsxZfVn4TevUka2hv
 16bkgQRk2SbtWS26redKg5T9xwqZyS6LYPZc4nlqNtdOfjc06O3Jrl08QXrr6YDL/rstb1f
 l0xWrYmKz/JACy8a9r7NVqZ4c8VThH2ylroN+QjDMqc0cPtmCd+236ZK1kPKzt1RGF4+1GM
 8VtrTh/CFp4NgsEdY2c9Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3EloKpSUWt8=:iY6EPOZWtHi/ZM6E34hZlR
 2xSfHxvGFSXGxamCo079Z4sANGXK3lUhCJ+AQLOA9MkvmzRmwvhwHYa7aQwcfH0e9CIEipuBg
 GEngknl+qZuHctfDasmRn3F2KTtOywyAwgqVpmHaqQfpl5hH5ScWJSuxH/cLBr8Ek9Oa7q1Dr
 +zf0UEgCupZML5LpvsCnOoOS5GSFr6DtYMprSc+h3M2lT3OS+72eOCUmao/yDIUQGjabX38VJ
 NLuOCcsgyrjfRQHaRWxp6vOx1DKzclBdHJWpY7XZiEGE+c9Fpv0MiuLikJGvI2TQkQ/pgKwTW
 6DsrbaD2vLZ4r/Bs7W5mJos+RF4gR1F3tEgzP60BLcw5NNO8wFuEg/MCjmgOoZSC9znRa4Td7
 hmGscGs/I/zKN8rz5vrjX5gr8oPuusM7Q4NMgafAHuKYjTwu6XhW9wmIM5158VqhhCV8hfpBJ
 tpFhnqmxS1iwilu+3w6Z2VIQzH2Q/7imS5JXTkEQLngvCpl9LKNYC5kFWYuGfBr5bRjB627Ll
 ICSqqxd3qGMKuehRy9DSFFdZjI8oc1xeMc5fY9f96LVZw1vtTfdtgppss78XeH+8wOJatIhBY
 EyhaWfZPkul6GRtgs6sSmQvRmUNyb6bCF7itUbEXGKV7H6NZ2UhBW5JJIeuKqeHNk9QjAHPV3
 zJPE6xvXUJa3W2HGC0FEuxte//wjUamhgd2gRS92xZn84VuZikNhhROrNKL7f88usifF1aOZQ
 mjpxid9UwrvBoiODjCQ0iS222hls0dpLDKsTJnPUpJrX84Qgg+pWYZ7KYRyyhQOGfjkzyt9SW
 mr0nubXYx1GCyzDcmz/XvpVoMwNqgl26092wYHvAYFXXD5ROUMeL31JX06S3XrEM7jhrmdwuB
 H6E+PBlxWLeu7UWwsvhbLz8sOKJbB2G5VwJhoN6sltjIJPCN/LkRaLQOndWiWMNR629HM6TlS
 AU+MtZYQvBOD03K5ggKTDgJl7HDa5jaldAJV4oa5mkW2W0Yy/GfPcLhdHLNloMQvQ+7fDrNGy
 2PseCo4ehl+PUHN9WgUxctTxE5LDbbn75IfpasO2/Hz7jQ3T9dY9rolYKNKvZGhqSfPPzEQSp
 bUer4W27aVniiQtPAXaJmXN+BrgcHsTAnhHcaaXXHfXvMYy1OKLDW32vU6UnX7bYWbGrv0guT
 uKiqi35C9tqTAJypDlFi3T86ksHJAnRFK2rH/CUWZkvaYr1HmyeLb7NvO8aukyh6iXXVcK7UY
 wMicRZde5dkHaP+DpmOHh5gjVFF86/SJeFQ6cqA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Landen Chao <landen.chao@mediatek.com>

in recent kernel versions there are warnings about incorrect MTU size
like these:

eth0: mtu greater than device maximum
mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA o=
verhead

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set the=
 MTU")
Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
Signed-off-by: Landen Chao <landen.chao@mediatek.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
=2D--
v3->v4
  - fix commit-message (hyphernations,capitalisation) as suggested by Russ=
ell
  - add Signed-off-by Landen
  - dropped wrong signed-off from rene (because previous v1/2 was from him=
)
=2D--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/eth=
ernet/mediatek/mtk_eth_soc.c
index 85735d32ecb0..a1c45b39a230 100644
=2D-- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2891,6 +2891,8 @@ static int mtk_add_mac(struct mtk_eth *eth, struct d=
evice_node *np)
 	eth->netdev[id]->irq =3D eth->irq[0];
 	eth->netdev[id]->dev.of_node =3D np;

+	eth->netdev[id]->max_mtu =3D MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;
+
 	return 0;

 free_netdev:
=2D-
2.25.1

