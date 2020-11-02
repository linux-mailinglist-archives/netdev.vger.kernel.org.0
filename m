Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2932A2BB5
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgKBNlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKBNlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:41:52 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE07CC0617A6;
        Mon,  2 Nov 2020 05:41:52 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c20so11139915pfr.8;
        Mon, 02 Nov 2020 05:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O7ajfVJhA/2SrZ1qqXiraNpNRGFUerSLYYMnKjCNxEE=;
        b=Ha+siYDn0Yozgsc/1FY0xnDPTq4nF44CFktiLyT0Rzsak8O8Aukpvexcx+cWPv21ta
         xCec7BEaTZwhlEaIh3FDMcajCravZ99TxEDlpMf5dNrFKxk6NzY1hw7YfamtLOT9lOwt
         zf7PP+fNt2s9sX0BZ5d6t5gkQg6dFl5KLtuqqdBVPEK5K0GQRQtRvzAlHCpVVu1tAAfk
         NAAfMSVm4LEcT18KupgcNlw/KFe3p8NUey7/f9bbYAJj8u69b4rAPdXgm3++klH5QHZz
         rWu03cKJQFcn+OvWiyuA08E85JUOtVDKFD4hC9bEV92Vh+E0VXluytZFrjKUccQg8PWU
         PufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O7ajfVJhA/2SrZ1qqXiraNpNRGFUerSLYYMnKjCNxEE=;
        b=qbu3KwWmdgWzhUH9Xpws/2YwsL9j1otUn+08deJ67rKqZvYFeNsPpYldFsWyAmr+jJ
         gh1OP5RD4HW3i4F0Afn+deO/QPniJUtxf/fkUgT06HGPEijMLZ7X7mixOSIvPtC2UY6C
         MTTONlriDyykXwJIB/2NxqxF61D5YWEQq1XCx3VRG2XyGgwTl9bS1IirE26I31Tfq0v+
         T5pOkYXV3oRhxm2oUTafdrXR9KY8Fk9gkKGtRZvyaqntsp+KkcNPiDMCx55OZAtys1yY
         0xsp7aSoXqw0DA6TUD6ZBEhU2gViSA64+DY74e6nduu3JKJznHCmynf2vnUENIUZC4u4
         xQmg==
X-Gm-Message-State: AOAM53216EFOlqiujFv+YvSL35Cd5X9vKTe70LcoFPqnWaE8X+DmlLtU
        8obSXOM/Q8oT0sdq4cYfTQ==
X-Google-Smtp-Source: ABdhPJzfq1UM6eOhcpRFCa8jiJHoGmM/KTFV4jY2NDis/q5pg0iSnGBdJGIYE6gJvpzM1SVaopG/lA==
X-Received: by 2002:a63:1825:: with SMTP id y37mr13208841pgl.284.1604324512329;
        Mon, 02 Nov 2020 05:41:52 -0800 (PST)
Received: from localhost.localdomain ([8.210.180.83])
        by smtp.gmail.com with ESMTPSA id k9sm14233438pfi.188.2020.11.02.05.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 05:41:51 -0800 (PST)
From:   Pujin Shi <shipujin.t@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pujin Shi <shipujin.t@gmail.com>
Subject: [PATCH] net: ethernet: mscc: fix missing brace warning for old compilers
Date:   Mon,  2 Nov 2020 21:41:36 +0800
Message-Id: <20201102134136.2565-1-shipujin.t@gmail.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For older versions of gcc, the array = {0}; will cause warnings:

drivers/net/ethernet/mscc/ocelot_vcap.c: In function 'is1_entry_set':
drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: missing braces around initializer [-Wmissing-braces]
    struct ocelot_vcap_u16 etype = {0};
           ^
drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: (near initialization for 'etype.value') [-Wmissing-braces]

1 warnings generated

Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d8c778ee6f1b..b96eab4583e7 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -752,7 +752,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 					     dport);
 		} else {
 			/* IPv4 "other" frame */
-			struct ocelot_vcap_u16 etype = {0};
+			struct ocelot_vcap_u16 etype = {};
 
 			/* Overloaded field */
 			etype.value[0] = proto.value[0];
-- 
2.18.1

