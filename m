Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4CE337C6C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCKSWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhCKSWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:22:11 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD61C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 10:22:11 -0800 (PST)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lKPVc-0008Vo-R8; Thu, 11 Mar 2021 18:54:04 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 4/6] net: dsa: hellcreek: Use boolean value
Date:   Thu, 11 Mar 2021 18:53:42 +0100
Message-Id: <20210311175344.3084-5-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311175344.3084-1-kurt@kmk-computers.de>
References: <20210311175344.3084-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615486931;396d5fba;
X-HE-SMSGID: 1lKPVc-0008Vo-R8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hellcreek_select_vlan() takes a boolean instead of an integer.
So, use false accordingly.

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 910c992a84b0..d21f614f1c23 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -437,7 +437,7 @@ static void hellcreek_unapply_vlan(struct hellcreek *hellcreek, int port,
 
 	mutex_lock(&hellcreek->reg_lock);
 
-	hellcreek_select_vlan(hellcreek, vid, 0);
+	hellcreek_select_vlan(hellcreek, vid, false);
 
 	/* Setup port vlan membership */
 	hellcreek_select_vlan_params(hellcreek, port, &shift, &mask);
-- 
2.30.2

