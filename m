Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF65B469220
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 10:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbhLFJRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 04:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240354AbhLFJPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 04:15:38 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5F6C0613F8;
        Mon,  6 Dec 2021 01:12:09 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u1so20872731wru.13;
        Mon, 06 Dec 2021 01:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FGtulihe7ZbaEpsl9OFIbutBqE5uxxN+RlUqevniGGc=;
        b=DbbFihlmvXc6TyE+X9Wrmn6Sr/drJkmcKW4d5y5EerCQmJdPZ2suF6Ex8CF5NX6OF3
         uPnYpcBIz+kEOwbJNqN6GWAULeJGkVhhMbRFwdOXMWlu6fk73A+/W6zCawhxLK6ZBjCC
         cNCqmRqI4/17gU7SMHeu3DvLVgeLVzjcO0IFeAiuTxdCrpjJ51C3PtNKPC6oMr/oFSVI
         lJbfn75nalX9pn/peJ4eiUJCYEDWoeqfXzyz+ziztnUzTzv+qZNpCh7S/brpHmAQHcM2
         EXK7WaPTQWHBGhbxC1e2EFeg9K2xQ4IsIFS4IXEvfZXTz5lLwbSLRcBGQtE4Zxsu9elQ
         5LIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FGtulihe7ZbaEpsl9OFIbutBqE5uxxN+RlUqevniGGc=;
        b=13z1yHj3EWUdJ1ixw8AHqHgbRVy/vCPILjsjqQ47Pc/gUANvRy4VqSUhIrodwqYm+H
         lXXDpzsLxgARjjvWgttbRvPezkbTuqRz6Y/Y8/bnEUJGoNexBqw2QcvzdWSI+dRo9v46
         h5j/WSpSnONiMub+ph9e6qPbswNpIWT2TzT9vdeebQRl6MOKWWJx/LpiPr9BlfEao0mc
         sB3lpd6QFLFeJFZuihRwU5imiCwVywvhBN1ZD1pOOQhB4OHpe7Wnf0/pFxs6cwzPyNac
         rfk653ObHlPL6lRbvGg/woSRT0Dcsl4+ko+XPZmLFAJB//rIiHoGl1XYUUX/jY0r6a3L
         khMg==
X-Gm-Message-State: AOAM532GEGvF+I+1wJ2uvVa4AMgcmV3TLQTXnvn2ANfB8kZf+OT3PoHl
        kSXg5aItFtDGqK3ypwxAykZ75N1r/oNXKbnj
X-Google-Smtp-Source: ABdhPJxFt/TJQBps8M+Vvod/JSl2PWMHsPrHLQtL5cNl1tVXXHphlF0EQ5Dz3rbTSGnnql423+gbcA==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr40977623wrr.152.1638781928492;
        Mon, 06 Dec 2021 01:12:08 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id p2sm12866223wmq.23.2021.12.06.01.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 01:12:07 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: hns3: Fix spelling mistake "faile" -> "failed"
Date:   Mon,  6 Dec 2021 09:12:07 +0000
Message-Id: <20211206091207.113648-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3edea321e31a..1d1c4514aac2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8070,7 +8070,7 @@ static int hclge_cfg_common_loopback_wait(struct hclge_dev *hdev)
 		dev_err(&hdev->pdev->dev, "wait loopback timeout\n");
 		return -EBUSY;
 	} else if (!(req->result & HCLGE_CMD_COMMON_LB_SUCCESS_B)) {
-		dev_err(&hdev->pdev->dev, "faile to do loopback test\n");
+		dev_err(&hdev->pdev->dev, "failed to do loopback test\n");
 		return -EIO;
 	}
 
-- 
2.33.1

