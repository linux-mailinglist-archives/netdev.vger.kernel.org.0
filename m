Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2E325351C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgHZQmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgHZQmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AB9C061756
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kx11so1112000pjb.5
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VSnTEpLbazNJA89BLom2epQs6svpK8WKWU4oz2vSyfo=;
        b=41TQ7w3PErs9xFKwdx5aEnO2CjYTJ0LtGUykB/roIgAwQ2yjGisy/OUobca4tUew7k
         GBBrnR+ZqBHRhvVLnoFcFEt0wiarYq+A8kFrzh5KkI8KMpUUaiAce4518bTuZtPtuoE5
         Ix6ez2J986bbBNkLjGKev7q3ui4MjD2KAgTcs6ZjfFyE9H1viKBM5tep0XgwrqEd0bTA
         LJu6uL9qPGazqR7B+LN7AC69Pnb29MHBskK0eOKxpBt4rcDN5dmct5Ey5j0jkYEXIKFf
         QanJjd3Q8/1AUwamr2QSC+savsZk+eHEx6TFGHcyToZyslePj42+TgKLs0N7B1JMwypY
         +yYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VSnTEpLbazNJA89BLom2epQs6svpK8WKWU4oz2vSyfo=;
        b=uXEe2WD93D76fjfybBFCNYA2If1W6kfMuOku7IRTR0nx1d6cCOiapX0PpRmi4pImZz
         yDg128Sm/dBnXn8ADKi73bo4IYjJ1uFGBDYP8nc2qrnQ5zjs0UpNs3C9/0t7g1ed+nXT
         ehDvQElTNqD+h4+qy10q3L+KS5rl4hg2emPxP1pXSQ4NJK8z0efaiyVJWzFUKr3nuFsC
         xe5Fjn7gsucYJeUck3sG+Vl5bQjMzmC24mLyn/bNe/KyNXn/3AIWsx4LdgZna5R3hFRu
         lQR28RrYVcGcNgcQKwdX1x7/24vAcSJfQrOTyEY79SUycrTWrYRd7KNz4ZC0h+1lInCe
         BlEw==
X-Gm-Message-State: AOAM533qIBxvqaFDLbQ7VqWNh4hERxJ5na5iz9iTyCVRbjVZJEGANN7u
        fz92TFD7/jXr2dsW6LPx1cVaVoT679Yywg==
X-Google-Smtp-Source: ABdhPJzvvyBSDTAo0ZtJ/o73T4d8xe1yect9TA+7QXEwge6KFb6bO5lzPrK9Qp+mT+tIXoMgqXbsBg==
X-Received: by 2002:a17:90a:e986:: with SMTP id v6mr110312pjy.167.1598460144004;
        Wed, 26 Aug 2020 09:42:24 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:23 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 02/12] ionic: fix up a couple of debug strings
Date:   Wed, 26 Aug 2020 09:42:04 -0700
Message-Id: <20200826164214.31792-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
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

