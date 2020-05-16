Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F1E1D5DD1
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 04:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgEPCJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 22:09:57 -0400
Received: from mail.kevlo.org ([220.134.220.36]:40680 "EHLO ns.kevlo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgEPCJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 22:09:57 -0400
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id 04G29UNG006055
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 16 May 2020 10:09:31 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id 04G29RKG006054;
        Sat, 16 May 2020 10:09:27 +0800 (CST)
        (envelope-from kevlo)
Date:   Sat, 16 May 2020 10:09:26 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] net: phy: broadcom: fix checkpatch complains about
 tabs
Message-ID: <20200516020926.GA6046@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes checkpatch happy for tabs

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 8cd8d188542a..cd271de9609b 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -356,7 +356,7 @@ static int bcm54811_config_init(struct phy_device *phydev)
 					BCM54612E_LED4_CLK125OUT_EN | reg);
 		if (err < 0)
 			return err;
-        }
+	}
 
 	return err;
 }
