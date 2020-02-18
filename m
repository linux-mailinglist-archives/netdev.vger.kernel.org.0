Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF30C1629C4
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgBRPra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:47:30 -0500
Received: from mout.gmx.net ([212.227.15.19]:46263 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgBRPr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 10:47:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1582040838;
        bh=MBOJrFcaXa3Z19n1i45xJXpCvEYvi0ktVJoJ0KCJdaM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=lEAw20A9pa4AMyV2mOHYTAYIhJPNpYHngS5bg8kwJcoVo+iuzPocNOYbDtuBiVWPe
         ukVY//hBaxNGUw16uGyN9eH1BgJqS7q1OOnNbXVYmA/9Li7vyyTb4y93CZfJx64cPB
         BKg0V2/7Nb7bycl5dWxxazxRijxtVcdNtnIY5eRM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([5.146.194.223]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M5QF5-1j3Fbv3L3F-001RAv; Tue, 18
 Feb 2020 16:47:18 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: broadcom: Fix a typo ("firsly")
Date:   Tue, 18 Feb 2020 16:47:01 +0100
Message-Id: <20200218154701.1639-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:c0xLfCruKpO49xdxAJWcPwUZ8C0bEuPdja+hSV//rJgFLlGQLlh
 8pHOZUB6UVZ3NDRosEVruEci3mivxKm3kJzTNlbIE9k0GkyMqwOogA7pBas4fzElBwu44Tz
 4bENV1Y/kyWD/OWxiZ3wiXAQs+fMAx8/vGwHi6ylP9Ryrrq0AseLtlvPu68ZclCo36cnLj2
 3l3QeqP+LupeCUhY42R6Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8fOIy8TzPYM=:w3XmnmVGYvahaYGzCVqNwe
 KLu1WaDDWsLkJqiHw38ffAdHLR3+6mDtbz3UD2EzkCdLt+LMfio1cKeAdqS13UeVyEtHX7RtA
 qcVOas4Zsjmq09DQnEfQbNDsXoymm8Z7OuQNTPuDWmbrmsMXA1UB3qh1VCxtKkwer+ALaNDFR
 f7dNZ/lHk3VxRH0oyoHBne25oCs8V2eG/a7TS5Ngt3MvWPbA+TzGui1bjBsK8vupxbGHz/lU+
 TiGN9ZGBYJwVcVVI1T6C1rRlQ6nSnDdig+2vCX4IIYWiSNkgGqgn+EK2c/BuzAay87vU0x3cK
 WRRQeJkq7ar66FHcEuR5E/hoeXV9noQh0QxOK3xLwDP+oIxv12YJK5vahXZ6T0aayi/A0Ht+z
 7HiiIXmSrwZVsmXBNDScy+jHSMsFLAIuZQrg7DtF+3Ks8AqSUBU47OmyH1vaA4QEGX3ibj8qQ
 nbmhYSYwbjPTw80OjkoCwlL0Lt9Ef8bI6JStwgseYWrahPN1iBeb2J8aQ1f+yzs0N4ZFn4rKb
 Abn9sZtNYbY80noibkupgH9SefbQd45K2isMocsFbHGxd59Pyc7mBWwxRYIIjaOcmiEPu5Dzw
 /2nIp+Per/YJ3Q32sNOQ1P+6XhbXaBGI88V9+unG7C+HkyjIyj4MmD+21iULNA8xX96BuLEsy
 lSJhuqWHMQ6t7gWV0f9Z3m6GhThiBy1ogKHhdKPXtQht1o09PRz1zeM/UwiLx/v+BsHJScsN0
 jfpQb9guFZ3Z0hUjqq6tPyHQu3Okv3MeCi8PB8/BLqYMV6x/fHs/JiVGhCEwwA21J/7xo0Cqb
 83Ib1x90fNyPLqbqIeXKUM1dBmvyv8+EvfWam/E77qywFbAxLZStqn8N9CZYaQSlOhfegR9hY
 8bVdR/S5pE8rdhcOEuOBTEBMxFzNvBBfdFmZyRtDaih2wiuhIA7x60C+OmJ/JlHuzdAL5CLgu
 HovwOxMAugBVaTDqh43winFahe7o4UvSoeuRcKTKtqpoHKUFKRvXLu6LARuzG/Dwg7aQhgrie
 yfxgVQgibi5mkDhGQU8VoHXO69TbWiLkMRjGSQemKM0SZVBt3vlq/eHB/55yX3d+UybPsTRAr
 R6myshlmqp5kBi3qY4Uj3D7ezvIJRGTn3xjjqiorgapIih6NdKNdHY8fe7wSFzlPWyxkX6BOE
 KIRYv3WkEwwp/iL2XYF4ikS8XDhx4ow7K8ZULjHfSl5fm1nVpFFgC9hkXk9Yg+IPOs8XXQ/KQ
 ljxVPU7JGkDdVfKOl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 drivers/net/phy/broadcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 7d68b28bb893..a62229a8b1a4 100644
=2D-- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -410,7 +410,7 @@ static int bcm5481_config_aneg(struct phy_device *phyd=
ev)
 	struct device_node *np =3D phydev->mdio.dev.of_node;
 	int ret;

-	/* Aneg firsly. */
+	/* Aneg firstly. */
 	ret =3D genphy_config_aneg(phydev);

 	/* Then we can set up the delay. */
@@ -463,7 +463,7 @@ static int bcm54616s_config_aneg(struct phy_device *ph=
ydev)
 {
 	int ret;

-	/* Aneg firsly. */
+	/* Aneg firstly. */
 	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX)
 		ret =3D genphy_c37_config_aneg(phydev);
 	else
=2D-
2.20.1

