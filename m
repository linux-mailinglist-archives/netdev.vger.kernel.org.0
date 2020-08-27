Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F44C254C91
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgH0SHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgH0SHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:07:50 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE82C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:50 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ds1so3044052pjb.1
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VSnTEpLbazNJA89BLom2epQs6svpK8WKWU4oz2vSyfo=;
        b=R4nlKBLXOL0flJe9x4uR61CsTAqBFZoRE3+wntSmYXUYH/U2iWSZSpF0PYMoLZCC8E
         KZlINV3qs0s0KkWtB8jYUbud7bphUyODVrkdUM+U78JQ47hM4i/IL8EunHqYjy+ktvLs
         0cekBDIPiI0mPpMLJYS4bPB255I8kOA8rmfQOh97zb0w1yNWpUZPdQhfxwLArpyzESXg
         zoSpXnwtTlEYT00GjR22Tq7yVJ0cCltKm8ERC+XDTz4Z6wUUDZPO94csa88Xy+yHVzSv
         P6EFdOoIDtMEcI00/AYA61e928YRYGfQQvJLqcsJfi1X0Qjq22UHzH4TLVmN76kXAOY4
         ReYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VSnTEpLbazNJA89BLom2epQs6svpK8WKWU4oz2vSyfo=;
        b=espThNW+XXPso4Ed5kyi5hqxxkyzJ8TdRWIkwaPI1eDIqtyTDkaUCKhnFljiJQI5db
         7hQbzgy8EdQpOZs03ySLhUeAT5rZEVYDn7SKMgiS/fOYc1qtj/eOmu0U58CXtIYinL3s
         yNJH/jQG6HXx+ilZ4p2VwV4CsYbTzXsekQyXxHeLHuR3BioD94lGTIJyMFON7kAPuoGM
         pBNE78jg1OCJXZiuq05BBd7zYPo+/pE+8B3yRfM8PWdMDCBXvVPYl8DvYKqyjHyl3XO2
         Y1FxFueOu8P1Rlh7uQjEq/VoYtAMCdu7ru359rAXeCw/vgr9owB1y8J33dJAsdyey+0l
         hFew==
X-Gm-Message-State: AOAM5332Hlpx6IOM/SOwf3YzIYkSPmcSe0CBt61UtNTx8/83CyEcmMyj
        pZpGVxCf56pcp51vShzQCPfFCnMRqXnlRw==
X-Google-Smtp-Source: ABdhPJzpy/Ttez0th8+GLv/IzlSeSUCuC9RV0vOt/qB/lD5rLe53jfcmnZVu0pgHVcOSOSexhMKHvQ==
X-Received: by 2002:a17:90a:6fc6:: with SMTP id e64mr101238pjk.34.1598551669830;
        Thu, 27 Aug 2020 11:07:49 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.07.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:07:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 02/12] ionic: fix up a couple of debug strings
Date:   Thu, 27 Aug 2020 11:07:25 -0700
Message-Id: <20200827180735.38166-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827180735.38166-1-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the queue name displayed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 235215c28f29..e95e3fa8840a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -433,14 +433,14 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		err = ionic_intr_alloc(lif, &new->intr);
 		if (err) {
 			netdev_warn(lif->netdev, "no intr for %s: %d\n",
-				    name, err);
+				    new->q.name, err);
 			goto err_out;
 		}
 
 		err = ionic_bus_get_irq(lif->ionic, new->intr.index);
 		if (err < 0) {
 			netdev_warn(lif->netdev, "no vector for %s: %d\n",
-				    name, err);
+				    new->q.name, err);
 			goto err_out_free_intr;
 		}
 		new->intr.vector = err;
@@ -449,7 +449,8 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 
 		err = ionic_request_irq(lif, new);
 		if (err) {
-			netdev_warn(lif->netdev, "irq request failed %d\n", err);
+			netdev_warn(lif->netdev, "irq request failed for %s: %d\n",
+				    new->q.name, err);
 			goto err_out_free_intr;
 		}
 
-- 
2.17.1

