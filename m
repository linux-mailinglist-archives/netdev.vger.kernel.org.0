Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6784AC810
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiBGR7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345877AbiBGRxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:53:23 -0500
X-Greylist: delayed 448 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 09:53:16 PST
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616CDC0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:53:16 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id DBC6D9C0267;
        Mon,  7 Feb 2022 12:46:33 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id WPRRpxgss9DT; Mon,  7 Feb 2022 12:46:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 94A2B9C0268;
        Mon,  7 Feb 2022 12:46:33 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yLQZX1EZnHYi; Mon,  7 Feb 2022 12:46:33 -0500 (EST)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-1441-98.w90-27.abo.wanadoo.fr [90.27.160.98])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id CD24E9C0267;
        Mon,  7 Feb 2022 12:46:32 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v2 2/2] net: phy: micrel: add Microchip KSZ 9477 to the device table
Date:   Mon,  7 Feb 2022 18:45:36 +0100
Message-Id: <20220207174532.362781-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY_ID_KSZ9477 was supported but not added to the device table passed to
MODULE_DEVICE_TABLE.

Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index fc5c33194bdc..3112965a1fd4 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1938,6 +1938,7 @@ static struct mdio_device_id __maybe_unused micrel_=
tbl[] =3D {
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ9477, MICREL_PHY_ID_MASK },
 	{ }
 };

--
2.25.1
