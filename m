Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3D035D8A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfFENKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:10:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34007 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfFENKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:10:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id m29so12592392qtu.1
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 06:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SjKvcJWT1qJCrA2qzNlNAA6sWjwD+zejUCYiVMbFumQ=;
        b=nnxZV8sjkfa/CeMUMAEqRt75XKu8G5xT0ZXRi/HwQvL+4mPVa6BvegS/lNI1TkluMz
         r+oU7d61O2qncv76ET2XCQEdxPftr8b/WBq60uBOBE8QeaXte7sDJUjpzlQzBYbZIGzN
         I3ElCyNlAOR1upHoa5CboX/IT3EHznusAcuBJBamSZqjHu/ObcAeF8J9syYyanUULGHJ
         WhcEgLYRwk3TDeZYu6Pjj5KSdqdw9qD6wGSHW7aXS7Wn1i5M+G/08vDwobsi3UiDgaBj
         xIO3eCMriA0FdvUbYRNUP9tM+OmYJvBrrL7r6K84V9AXGJKOooiG0nXyX1+P25XF3ble
         rQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SjKvcJWT1qJCrA2qzNlNAA6sWjwD+zejUCYiVMbFumQ=;
        b=ePX9k6IVqbs3qfCTaJ0MhzHsFbmJ9vUHm47nmjJeOaifvrry8xAGFkAYWc5tCpeEyf
         PlhwY8e7AzdMNfdhEKlTUePDOxg37aCfPw/UZB5wNrlVtS/xlY+6W8tyMb4baz976GYS
         tvZFus18bdYTNrwQFpMALlhb3ocgP2Py0Tf9e97buLz/0+nM3s0UmLbV2rE+mFbALU92
         0lxRX61Qpm185BSHgjIQFGP9aU6DLwpebpQ2biNyCoODHnXpE5mZnKbe+Ie5uC5iwN7W
         z/Gnmb77+mDwBU7Iuv2NSLNw9D//8kQSfn5WgboPxBYD03BMJgv31hsEJakCPkM0olD9
         2v2g==
X-Gm-Message-State: APjAAAWfpwe9fa96IDfYuQr6Bq9iSar6d0GwX4ISNQrkdT8L7KZ4O5ze
        jUlHZM0odquzyCehd/BbHuubPYBa
X-Google-Smtp-Source: APXvYqzpXU4sY4/ehOVOwwFuGQIbT53ACRj6Op6agUKuOXlxHM2bUzSYo6keodGObOldQCI/46otSg==
X-Received: by 2002:ac8:3267:: with SMTP id y36mr33671173qta.293.1559740252210;
        Wed, 05 Jun 2019 06:10:52 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([2804:14c:482:3c8:56cb:1049:60d2:137b])
        by smtp.gmail.com with ESMTPSA id q36sm7447819qtc.12.2019.06.05.06.10.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 06:10:51 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 net-next] net: fec_ptp: Use dev_err() instead of pr_err()
Date:   Wed,  5 Jun 2019 10:10:35 -0300
Message-Id: <20190605131035.9267-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_err() is more appropriate for printing error messages inside
drivers, so switch to dev_err().

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Fugang Duan <fugang.duan@nxp.com>
---
Changes since v2:
- Made it a standalone patch
- Collected Andy's Ack

 drivers/net/ethernet/freescale/fec_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 7e892b1cbd3d..19e2365be7d8 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -617,7 +617,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	fep->ptp_clock = ptp_clock_register(&fep->ptp_caps, &pdev->dev);
 	if (IS_ERR(fep->ptp_clock)) {
 		fep->ptp_clock = NULL;
-		pr_err("ptp_clock_register failed\n");
+		dev_err(&pdev->dev, "ptp_clock_register failed\n");
 	}
 
 	schedule_delayed_work(&fep->time_keep, HZ);
-- 
2.17.1

