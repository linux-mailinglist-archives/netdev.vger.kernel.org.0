Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8868E255179
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgH0XAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbgH0XAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:00:41 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FBCC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:40 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 2so3411736pjx.5
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VSnTEpLbazNJA89BLom2epQs6svpK8WKWU4oz2vSyfo=;
        b=2HglPIZ0bDFCE0ynp8OqwqPheSQISUeThnRHcH9x8L+fS66dg8SRS5d1PRasEreLV2
         0jNi+X1wpl8sefTc+F+S9kkk0ZnmMpAFCZX9QlVPwjKYdWAwE5hlpwBIztnGI2zWqIAj
         nNdjMC4ikSV+J0sMas/p6XTBKzGTyg5SJwDLi5UlNjLf9O9otNRhmCRK2xbN0tmT7+GR
         1RoeKz980FJVhuMC4OBBnhy2spAm1s72Ies6JuvzjWynktd/EgoUqECXH5Y91Fl5SUsF
         BnxmiCFRaOFumVtZEJOl9Z1b7BWPOFCC1uGL6ZGiTDfHKRMaeOunLwxVBDFk0x4phu6e
         p+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VSnTEpLbazNJA89BLom2epQs6svpK8WKWU4oz2vSyfo=;
        b=Lcf/Z4ESWNaT90HYhe7RKly4T+b4UWQmWoD+HJOnJ9R+2vTqllOSiZH9FdC2V/xD5v
         a7xOioDr1KYtIkDQA9RzPcCGcD3fZMB2hrCbMaz8yHaVJ0XAQ8o8f7HZIO0qcxw+DMxi
         ttMrSNDWmpUnDJQoGO63Y9RUCLwc0xSTsPXaHHYddlAx25j982cQlzLAOfvuvZT03/Go
         O3YmH8laVAcU/v0nTe9KrYhwCuFUaStzA7PV1vnJ10XF2xFvH98sGQxY5g/pS13k+m0C
         l8b8cvLnV9/AYyDb+ABgBglHANrZR18e/DwF82VVo1AzumnKMjkOPd20OT1CSuC3pLpM
         1QiQ==
X-Gm-Message-State: AOAM533Jc7sQ8xbddnPKWWkf48DDDLV/iylYLZ3FgNi6UIi9khMLiIzU
        WegaEPcR1l3WhWGtkg/I13zHOVhTFLW2bQ==
X-Google-Smtp-Source: ABdhPJxxdEUc+ue06oox/LizKa+T4kmCoWcxVo3y/IQvPiFlnFfjrYq8TprufCVhGDV1gpHdk4wqCA==
X-Received: by 2002:a17:90a:a102:: with SMTP id s2mr909711pjp.55.1598569239758;
        Thu, 27 Aug 2020 16:00:39 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n22sm3137534pjq.25.2020.08.27.16.00.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:00:39 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 02/12] ionic: fix up a couple of debug strings
Date:   Thu, 27 Aug 2020 16:00:20 -0700
Message-Id: <20200827230030.43343-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827230030.43343-1-snelson@pensando.io>
References: <20200827230030.43343-1-snelson@pensando.io>
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

