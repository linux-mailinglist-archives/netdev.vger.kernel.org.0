Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9332C5221
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 11:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388114AbgKZKel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 05:34:41 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48492 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbgKZKek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 05:34:40 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201126103436epoutp0222bcc02d03be59856a892faab9a62ec3~LCFp9UUDR2916829168epoutp02N
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 10:34:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201126103436epoutp0222bcc02d03be59856a892faab9a62ec3~LCFp9UUDR2916829168epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606386876;
        bh=SLA+YxSxwuaVy5M4r5sM0kRP4lwMguF/Prn+O9V/IEI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=qt2D70inCTC4LDmk5lr1eTgqho36/gz9LtKosz7MHBS63vH/CMBYhMNSHGRNM6oaI
         uJy5x5Ud3dVv5OlIAHDy4LzZismHMzGR5ZLjHb8Ikqd6JdJu8sOKhqSgsxXw3g1/cr
         6aPkj512U36Tet8UnvK+LvssHssOp2B8wWwYkXp4=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20201126103436epcas5p180b833cd843d91f42f7321724051be5d~LCFpNe70L2350023500epcas5p1T;
        Thu, 26 Nov 2020 10:34:36 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2F.25.33964.BB48FBF5; Thu, 26 Nov 2020 19:34:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20201126045221epcas5p46f00cd452b8023262f5556e6f4567352~K9a1ZhjFi0428904289epcas5p4b;
        Thu, 26 Nov 2020 04:52:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201126045221epsmtrp29075bc18fcb1d5b52cbde980e22b689d~K9a1Ysv8o2791927919epsmtrp2J;
        Thu, 26 Nov 2020 04:52:21 +0000 (GMT)
X-AuditID: b6c32a4b-eb7ff700000184ac-76-5fbf84bb50d7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D5.A0.13470.5843FBF5; Thu, 26 Nov 2020 13:52:21 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201126045220epsmtip1a5102e03d1a816fa0344453580167107~K9azy9Xka1656716567epsmtip1C;
        Thu, 26 Nov 2020 04:52:20 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sriram.dash@samsung.com, dmurphy@ti.com, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pankaj.dubey@samsung.com, Pankaj Sharma <pankj.sharma@samsung.com>
Subject: [PATCH] can: m_can: add support for bosch mcan version 3.3.0
Date:   Thu, 26 Nov 2020 10:21:42 +0530
Message-Id: <1606366302-5520-1-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWy7bCmhu7ulv3xBh9vmVvMOd/CYtF9egur
        xYVtfawWq75PZba4vGsOm8X6RVNYLI4tELNYtPULu8XyrvvMFjfWs1ssvbeT1YHbY8vKm0we
        Hy/dZvTYtKqTzaP/r4FH35ZVjB7Hb2xn8vi8SS6APYrLJiU1J7MstUjfLoErY+n8t2wFJ9kr
        jv/bwdbAuJyti5GTQ0LAROLVp8vsXYxcHEICuxkl/myZzwLhfGKUOPd1KlTmG6NEy4r7rDAt
        OzbPg6rayyhx6fEsVginhUni94zvYFVsAnoSl95PBlsiIhAqsax3AlicWeAAo8SvnzldjBwc
        wgKuEo2nSkDCLAKqEucPPWIHsXkF3CVm/u2EWiYncfNcJzPIfAmBa+wS154cY4dIuEgcW3yd
        EcIWlnh1fAtUXEri87u9UM9lSyzc3c8CsktCoEKibYYwRNhe4sCVOWBhZgFNifW79CHCshJT
        T61jgriST6L39xMmiDivxI55MLaaxNSn76C2ykjcebQZapOHxJLDV8FsIYFYiW2Xl7JOYJSd
        hbBhASPjKkbJ1ILi3PTUYtMC47zUcr3ixNzi0rx0veT83E2M4GSh5b2D8dGDD3qHGJk4GA8x
        SnAwK4nwugvvjRfiTUmsrEotyo8vKs1JLT7EKM3BoiTOq/TjTJyQQHpiSWp2ampBahFMlomD
        U6qByTZn0xVO3wmL2CatzRX49e5LYPypSXl/5nLEpv3+cmN6rTnThJd2zVIsxrrft25luxzz
        hOXl9O03rPh+KpvUJciaZLKy3fvKLb7ksJug7p8288QDajr3Mz8/EH65o+F3VkyPgIKrit+O
        TVJTVnpfbtefkZIVsce/+fF97cKO7KonfdNyVljduchsE2x7e8NOj2uCItEXVmxJN24Qnidb
        6Cg9NWnn2vVV/6SuuU/5+86zwin4+A7m+OsSL1bNeMqe9c38zs0XTh+MMlM+M3Z1RTvM5As6
        J2JaqLi9ya/plEzp1C9r1oXelW+/8nnH2de9aScF906PXeH4+2PXdz6LeTL8E6K2vNxzWbt5
        wX+9g0osxRmJhlrMRcWJAC5/IWeFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsWy7bCSnG6ryf54g8OTTCzmnG9hseg+vYXV
        4sK2PlaLVd+nMltc3jWHzWL9oiksFscWiFks2vqF3WJ5131mixvr2S2W3tvJ6sDtsWXlTSaP
        j5duM3psWtXJ5tH/18Cjb8sqRo/jN7YzeXzeJBfAHsVlk5Kak1mWWqRvl8CVsXT+W7aCk+wV
        x//tYGtgXM7WxcjJISFgIrFj8zyWLkYuDiGB3YwSi6a9AEpwACVkJBZ/roaoEZZY+e85O0RN
        E5PEzpe7GEESbAJ6EpfeTwYbJCIQLrFzQhcTSBGzwClGiU93VzCBDBIWcJVoPFUCUsMioCpx
        /tAjdhCbV8BdYubfTlaIBXISN891Mk9g5FnAyLCKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10v
        OT93EyM49LQ0dzBuX/VB7xAjEwfjIUYJDmYlEV534b3xQrwpiZVVqUX58UWlOanFhxilOViU
        xHlvFC6MExJITyxJzU5NLUgtgskycXBKNTAt61wQasWxRKNZcTc3+xnrxx55+zdm39Dauyj/
        +oXZ7swWqQeaHTkd/2xeJeDxVL/u2HLNhhfOxlw9mSwe+Wl37my6dbQzeX7qma+ONYcrk09X
        +p17qR7qGntg755zn19YLlY50V/HuNSAyVXGKfmoB1+Y+Nq9V/Vrjwe/3cg4gVXe+zy3rOVE
        g6hdDRtXFeSt5vvN5GXPdtkl8NOOgwb9wW4b99kp+jnHKpxkbNa9qnNr2ySzLzm/uJxEWipN
        63/paf/z/bnwUV9Iwll1ibu8tQs7QtyU9u8/5t550umC5bo5es7ip1bHnX/GGajZ0+30ZK/Y
        t7g6h113bi/T/PqmUcltw3qNhD+hkvOMipVYijMSDbWYi4oTAffoYf+sAgAA
X-CMS-MailID: 20201126045221epcas5p46f00cd452b8023262f5556e6f4567352
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20201126045221epcas5p46f00cd452b8023262f5556e6f4567352
References: <CGME20201126045221epcas5p46f00cd452b8023262f5556e6f4567352@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for mcan bit timing and control mode according to bosch mcan IP
version 3.3.0
The mcan version read from the Core Release field of CREL register would be
33. Accordingly the properties are to be set for mcan v3.3.0

Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
---
Depends on:
https://marc.info/?l=linux-can&m=160624495218700&w=2

 drivers/net/can/m_can/m_can.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 86bbbfa..7652175 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1385,6 +1385,8 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 						&m_can_data_bittiming_const_31X;
 		break;
 	case 32:
+	case 33:
+		/* Support both MCAN version v3.2.x and v3.3.0 */
 		m_can_dev->can.bittiming_const = m_can_dev->bit_timing ?
 			m_can_dev->bit_timing : &m_can_bittiming_const_31X;
 
-- 
2.7.4

