Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689CA1F7DF1
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 22:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgFLUHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 16:07:03 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:60554 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLUHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 16:07:02 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 49kBZs739yz9vfXc
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 20:07:01 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KJS9seHrTp2W for <netdev@vger.kernel.org>;
        Fri, 12 Jun 2020 15:07:01 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 49kBZs5SL0z9vfXY
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 15:07:01 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p6.oit.umn.edu 49kBZs5SL0z9vfXY
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 49kBZs5SL0z9vfXY
Received: by mail-io1-f71.google.com with SMTP id h65so6840151ioa.7
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TEHhynpdM5DMn747yDxQHAnOD63fP4aU5muENxpDExw=;
        b=NNff1R45Wt7qhp9gZnQWqRRJM7xIw8QuDw6QH+au+QeUWCpUdR3TMbC/KLXgNbQluY
         l2h7S8zvLys0BdKsAaUC8RQpW+Se0yRnyiXkkCwy0ujtqgylzwhGT0gUY72jhFbbvT7e
         q9J2wudVLZvys41s0Fbj8BalOTLQ7xG5xU5ohUYLxGhwmFkzvaIRe+7256kR97osmIva
         uWSaKtH2SVTS8QDw3k4LTE6RuCi1v9GY0PR6PVTVnBay2R28q8jcp568vEEybHByqkR4
         iUSKAQX7OEI9MFw6iZsHaYbLOeYDexnwUs7ZhJ2hvxD+jR3Ruba0+OyijrLz8TZKTVud
         KElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TEHhynpdM5DMn747yDxQHAnOD63fP4aU5muENxpDExw=;
        b=HGbtDfhsVy7wtKeYm0F0voQNy8NBnezjKxxw0X3U91xeaAAiGsW+YdX3AJd4/YCHog
         0mrrYVE+PmCusPqhzynednoFDMPv40lcZeB62iy3bRIaQSKL4g7Xfx+8WDy7dHpRBChw
         3qiplWlw7T6/owBgjv/u0IQubDZXci9sqC4kPN2rC0+JzFR9oOW44uzVL0HykG6lmCoh
         hilrlJXLCd6YNV6rZdyXiTLFkaWl+Mn39Y8dNbzCplofH6bq0vhLl9x6tuvakbB7QLVA
         jye0KIywCljUQ1fVorJ6CX86RRnmXNR66O2OoZuDrNamwHMvtKiw57z6d2TZFJN+YLFz
         bZVQ==
X-Gm-Message-State: AOAM531AZ6/TG8CjIzH6NGpStOnvmCKJAKLV5FtP5Z3jb1wRt7zISIma
        Z1/HtsOGd91xEmrPmb7rR1ZjJons1OPMiYWIUwBV9cr/oAo8MVEScI+fEyIAQY2QXrm4ktXsIur
        RA858t0ZZ1j5xeYA7Uuf+
X-Received: by 2002:a92:8488:: with SMTP id y8mr14815048ilk.262.1591992421414;
        Fri, 12 Jun 2020 13:07:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyEETRnG9c5znkFcuVG3mipCUc4zEHS2GMklQoD0zcw7+4vuJEA2jNGyCrCmH/WR/w3DcPzA==
X-Received: by 2002:a92:8488:: with SMTP id y8mr14815037ilk.262.1591992421246;
        Fri, 12 Jun 2020 13:07:01 -0700 (PDT)
Received: from piston-t1.hsd1.mn.comcast.net ([2601:445:4380:5b90:79cf:2597:a8f1:4c97])
        by smtp.googlemail.com with ESMTPSA id n21sm3584221ioj.43.2020.06.12.13.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 13:07:00 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, wu000273@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: Fix potential memory leak caused in error handling
Date:   Fri, 12 Jun 2020 15:06:54 -0500
Message-Id: <20200612200656.56019-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ethoc_probe, a failure of mdiobus_register() does not release
the memory allocated by mdiobus_alloc. The patch fixes this issue.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/ethernet/ethoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index a817ca661c1f..2f6bab9f1d71 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1207,7 +1207,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	ret = mdiobus_register(priv->mdio);
 	if (ret) {
 		dev_err(&netdev->dev, "failed to register MDIO bus\n");
-		goto free2;
+		goto free_mdio;
 	}
 
 	ret = ethoc_mdio_probe(netdev);
@@ -1239,6 +1239,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	netif_napi_del(&priv->napi);
 error:
 	mdiobus_unregister(priv->mdio);
+free_mdio:
 	mdiobus_free(priv->mdio);
 free2:
 	clk_disable_unprepare(priv->clk);
-- 
2.25.1

