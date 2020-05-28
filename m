Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E857F1E6DF5
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436699AbgE1Vnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:43:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436581AbgE1Vnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 17:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RiwrjAJ5mMO4fiRcmlCksWbNuqHdyN91ft4mLYuekug=; b=d4nKBwGvLFRCY59TKPNBxFtakv
        3KgvkbS1r+cle2/YKW8Xq7mx5awoU64j52Q0hLpXY7oJHZTg2deBzTUTZQFGhfsymnmpPlQ4QJo//
        UQaw8KdH2B62gE6VVxUynzk6AbHjNASiz3TS65ywuJGFtvmvbX2xeRq6D3HdXkK+SzXs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeQJC-003a64-Vc; Thu, 28 May 2020 23:43:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH] net: ethtool: cabletest: Make ethnl_act_cable_test_tdr_cfg static
Date:   Thu, 28 May 2020 23:43:24 +0200
Message-Id: <20200528214324.853699-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kbuild test robot is reporting:
net/ethtool/cabletest.c:230:5: warning: no previous prototype for

Mark the function as static.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/cabletest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 9991688d7d1d..7b7a0456c15c 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -227,9 +227,9 @@ cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
 };
 
 /* CABLE_TEST_TDR_ACT */
-int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
-				 struct genl_info *info,
-				 struct phy_tdr_config *cfg)
+static int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
+					struct genl_info *info,
+					struct phy_tdr_config *cfg)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX + 1];
 	int ret;
-- 
2.27.0.rc0

