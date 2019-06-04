Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F0133D61
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfFDDFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:05:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41680 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfFDDFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 23:05:00 -0400
Received: by mail-qt1-f196.google.com with SMTP id s57so4949535qte.8
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 20:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jm0ezgDi17FofWuaGtInQ4J/LscXDqySqau89wh+ot4=;
        b=MmlMRBgRGhN3qBGrmQdhs3FwLXiNcDB8b2jxctoqx8QgHws3aD/I0tyriXPrho0d30
         1AI9D/Jl2UeOqxpVtJACbWAt2CGLRqcEB6QARGbsrxSTkC2xy+xdFJ0sEZQ4tkeij7xj
         EQe/sfQyKTfpyE1kUPkEeTf2mi8owX8YimEfCtVj1mCcyORdTM2GolsaT5lgmgZQF+JO
         2zVTWOBk09EBcJJq5XLDnskh0gHkT4V5H5Z3YPPRr8pegFvZRpkYzj9Jw7hd2bTgu7L3
         lxHCqPRO001Ot7tq20+8tR6BYDejiSQ5Bk0zFtH7InHVu0jEBkMAY0vzy1pJk6OIOqo+
         tJEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jm0ezgDi17FofWuaGtInQ4J/LscXDqySqau89wh+ot4=;
        b=HaSkp6CPXQ5Gg4HrELfRB4EImYR24uZ/uvS4nqJjeMTtkhF3Sjw9A425BkogI2EXMU
         dUwqRlUSQ4SubUQZD2XMwrRsxVUBrt45iGfPJsNvk5PNqWDynV1QQKHjGge9NA5a/Fvp
         YAnWTWfsWAvCSntzhoyRgAl6ItOHyo3U5KdNCqWZCRGnvjmzev/W7MwVSNmcEULah/KC
         eZV05Q6lu+gqEFC6OFqwIc8bxY3QFaUogtWVKVm6Gh4anA0EqFZN3GWHcgSMon3nBbMk
         mElLb26rc5Ht/ZbzM08T2mzYbeC8f1+yn6qssjKbJ0FOWg+vAlTy7sRHPreiby8CWAA/
         XYwg==
X-Gm-Message-State: APjAAAXYuD+wRbT+EnDUsscnUCkFHeSZWLRLnZm8paDW5LMwUQWKLxDZ
        cF4qtczRDvz3Es9hxFQywU8=
X-Google-Smtp-Source: APXvYqxfor5u1EMS/u9uPOhUBuOXNjJyuZgxl9UA/oyG6q6Cf0eI8vslj2VAaavkPWUIUGSYBhTueg==
X-Received: by 2002:a0c:ee29:: with SMTP id l9mr816539qvs.43.1559617499747;
        Mon, 03 Jun 2019 20:04:59 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([2804:14c:482:3c8:56cb:1049:60d2:137b])
        by smtp.gmail.com with ESMTPSA id z12sm1135915qkf.20.2019.06.03.20.04.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 20:04:58 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next v2 1/2] net: fec_main: Use netdev_err() instead of pr_err()
Date:   Tue,  4 Jun 2019 00:04:44 -0300
Message-Id: <20190604030445.21994-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_err() is more appropriate for printing error messages inside
network drivers, so switch to netdev_err().

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Split the changes from fec_main and fec_ptp in two different patches

 drivers/net/ethernet/freescale/fec_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 848defa33d3a..4ec9733a88d5 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2452,24 +2452,24 @@ fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 		return -EOPNOTSUPP;
 
 	if (ec->rx_max_coalesced_frames > 255) {
-		pr_err("Rx coalesced frames exceed hardware limitation\n");
+		netdev_err(ndev, "Rx coalesced frames exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	if (ec->tx_max_coalesced_frames > 255) {
-		pr_err("Tx coalesced frame exceed hardware limitation\n");
+		netdev_err(ndev, "Tx coalesced frame exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	cycle = fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
 	if (cycle > 0xFFFF) {
-		pr_err("Rx coalesced usec exceed hardware limitation\n");
+		netdev_err(ndev, "Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	cycle = fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
 	if (cycle > 0xFFFF) {
-		pr_err("Rx coalesced usec exceed hardware limitation\n");
+		netdev_err(ndev, "Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-- 
2.17.1

