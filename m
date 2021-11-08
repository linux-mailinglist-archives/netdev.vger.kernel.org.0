Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21244449D03
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbhKHUVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238662AbhKHUVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 15:21:05 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786A7C061570;
        Mon,  8 Nov 2021 12:18:20 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id w29so17453459wra.12;
        Mon, 08 Nov 2021 12:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j0tzCILtYLjnkVMw5fV9YV7kZoveDNXNdYAPtQjDjAQ=;
        b=K+HM8JZN9aItz4KVC/AvPZGGZ0Diii0j3X7ZYP+c5n1YFhusHiijkCF9jYJCc2sviB
         OzQebppaGlOLbg4TnRF3lxekMTZ5MnZgB9Eq5VDQPnDYEH6RkopaphLkWz1tUgupdnct
         uCI+twI+d1gRdqkQiG0movCBd32XnG4hIz1zVNKdaDxuAIG4SBRHwsBJtK/0j3DijQc+
         Yf6SHEQklwIup5h4Phxg3XHmJQBnk56Ox1VSPSLjym1mLGRLg1b5tSdO9vL5Dc6q1AmY
         ER4D18GIh+ThoUKCaZmf6NHUqMmpMZ5pJJN0fcdYqKX5bJZIEAJyiSEWGTQNu5qiBBrv
         Xw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j0tzCILtYLjnkVMw5fV9YV7kZoveDNXNdYAPtQjDjAQ=;
        b=LGDkfD29Vg5QwGf/zt6c+0kNIExQ2fo5oVcEKFvYutueFd1v9iytI0y93HTyKYnP6s
         oJdDDLzsWpfRzdC0IP3wtazRAHMYcp1wWTSbUFno7Yd4lSP9ZJ+AD7vNHrnx2qcENwVk
         TXDz2G+byFqnpEa/lBxYEwXGx/xWMBF3sMC86PgHokeFDXTk2oMKT0XmywTEiqOqmYwd
         YcyNGMSjuNfAjqn7Ww3RF1IJBYcZ6qYKx053vqrg+yzZ2tGISJlWXL44Lu/OyWloyhuA
         JEpH8tSE4IrJRMWUSQEKwz6cORdRK3iSjRGfkTCdVaP561iGlxBnB3zG5w1KFK2caJU4
         7NrA==
X-Gm-Message-State: AOAM532846ALRXJprnBKWhYWtdhzKwx658uPIWwz7eCfmRj5NftPrOe/
        njRNDOqe/2eLng==
X-Google-Smtp-Source: ABdhPJzcTnCe0YEDx8RwNlWOrSJDmOYk/x4KD1BDzyGoVvop6ej0ZZTM+odIqcfL3wSOnq6RfnaXFw==
X-Received: by 2002:adf:e991:: with SMTP id h17mr2262962wrm.40.1636402699089;
        Mon, 08 Nov 2021 12:18:19 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id c15sm17359871wrs.19.2021.11.08.12.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 12:18:18 -0800 (PST)
From:   Colin Ian King <colin.i.king@googlemail.com>
X-Google-Original-From: Colin Ian King <colin.i.king@gmail.com>
To:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: mana: Fix spelling mistake "calledd" -> "called"
Date:   Mon,  8 Nov 2021 20:18:17 +0000
Message-Id: <20211108201817.43121-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_info message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index c96ac81212f7..636dfef24a6c 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1424,7 +1424,7 @@ static void mana_gd_shutdown(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 
-	dev_info(&pdev->dev, "Shutdown was calledd\n");
+	dev_info(&pdev->dev, "Shutdown was called\n");
 
 	mana_remove(&gc->mana, true);
 
-- 
2.32.0

