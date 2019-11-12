Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CE1F9029
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfKLNF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:05:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49466 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfKLNF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:05:26 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iUVrH-0008UC-Kk; Tue, 12 Nov 2019 13:05:23 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Iwan R Timmer <irtimmer@gmail.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: dsa: mv88e6xxx: fix broken if statement because of a stray semicolon
Date:   Tue, 12 Nov 2019 13:05:23 +0000
Message-Id: <20191112130523.232461-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a stray semicolon in an if statement that will cause a dev_err
message to be printed unconditionally. Fix this by removing the stray
semicolon.

Addresses-Coverity: ("Stay semicolon")
Fixes: f0942e00a1ab ("net: dsa: mv88e6xxx: Add support for port mirroring")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e8bf6ac1e0f4..3bd988529178 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5317,7 +5317,7 @@ static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
 		if (chip->info->ops->set_egress_port(chip,
 						     direction,
 						     dsa_upstream_port(ds,
-								       port)));
+								       port)))
 			dev_err(ds->dev, "failed to set egress port\n");
 	}
 
-- 
2.20.1

