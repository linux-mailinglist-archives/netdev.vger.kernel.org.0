Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE79C987C8
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbfHUX11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:27:27 -0400
Received: from mail.nic.cz ([217.31.204.67]:38022 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730160AbfHUX10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:27:26 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id F2CE5140C6B;
        Thu, 22 Aug 2019 01:27:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566430045; bh=JXU/dSraBqsFPZi8foMtfHyQpookZ7GgkJ3jUfzFTrk=;
        h=From:To:Date;
        b=wen9IMUS9TUVnTQqFZW58CdSj26qsScoUNq3NDOTNAgm6Wck5EMMVjHA0+dfJJ3s5
         4J3/VF0M9ixBW5+/tCyjB+5czWEy1uIQTHHco8hT9ZZqDGnUFbU42ruMW7NXl/ZVCr
         OLbxOB2iG30vyQv7jz5K8veicrVx4CVIxnhULVAs=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 02/10] net: dsa: mv88e6xxx: remove extra newline
Date:   Thu, 22 Aug 2019 01:27:16 +0200
Message-Id: <20190821232724.1544-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821232724.1544-1-marek.behun@nic.cz>
References: <20190821232724.1544-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two newlines separating mv88e6390_hidden_wait and
mv88e6390_hidden_read. Remove one.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d0bf98c10b2b..176173d96512 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2347,7 +2347,6 @@ static int mv88e6390_hidden_wait(struct mv88e6xxx_chip *chip)
 				  PORT_RESERVED_1A, bit, 0);
 }
 
-
 static int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
 				  int reg, u16 *val)
 {
-- 
2.21.0

