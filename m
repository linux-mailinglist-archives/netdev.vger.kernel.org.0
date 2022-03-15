Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FDD4DA56D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352260AbiCOWag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345139AbiCOWa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:30:29 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3F83B036;
        Tue, 15 Mar 2022 15:29:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p9so482743wra.12;
        Tue, 15 Mar 2022 15:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2mP7it1/VwMA5etq+ao66GLxUXQ6KGLRAa8IlL6JtUU=;
        b=CuFGm/I1dRoambfUa96lRkaH7kV7vgcN9VEUSVwtWPkwpJRWU96AUhgWgzJb0Kebak
         PcQ8Xi0UeSVTammDQxivKuBDY6fp394GdgcFk+RAkIHvgFZ/xWpxuxsreW6cLySGNhmq
         XaR/GdbxY+vrbFvGqNNgWoVA96UIy9KdyVHh6jRLBNjp8go9jB4OALqLkkG446Yz6Flo
         oN0ichTEsqz8bxrMNtrE+6tGR0S8IsHke7Bpgh8kNaTmrdA7Um3jIqyoJ+CVtv65xCnV
         hoqpS71dInSf8bJ6wAJNm5eVeu2PWq9CzyU4D0wfZUxHP0c3l/3XC7D0oqZezwinipvL
         ikyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2mP7it1/VwMA5etq+ao66GLxUXQ6KGLRAa8IlL6JtUU=;
        b=ROIyQrzYQhdecelmJptv/xvV48zWQCZEz6j9CT5yOOBnJwLYLuJhTzKmcteFns3xml
         1wQnQzLRTr1bUW4Vf+cafYtXr63untWY/ow7+bwGhuIAOWHvP/o9TJo2RaYfU2eFfvy0
         qZNsblmRUL4TWMUk1ODPxuvVnz/yd5jcjS/skSnauJ31gqWeqf3hEqoFSiaumSN/LZb6
         CGbQyPcbSyWnQ9uSN7ymfVsun3L3YzJEmPRv3BAoQLomMwCNgJa70xpdqsIy54OEOYIc
         ULM+HfohgTGen7lpMZ+VPEvISqW1m139mx02Cdnmj6wO55KF1ZuXzu3r5EIWIAV0zf+F
         eIVw==
X-Gm-Message-State: AOAM531CQZuD+F4/aoenB+bfKb9ASoCaUlqtxW/Db6YTAsDE6On/nRx8
        bPrnrg1M6VNiYDmd/LJ1tsoEBcy65kyu3g==
X-Google-Smtp-Source: ABdhPJxs5/XVKI8M6uvLbmKJ6JqUOz2cIuVNKXlVOZcM3keHpp0j1e9aIE29YLBbfuwAjynFaSaRlg==
X-Received: by 2002:adf:ce03:0:b0:1f0:62b9:3c7a with SMTP id p3-20020adfce03000000b001f062b93c7amr21796516wrn.102.1647383355616;
        Tue, 15 Mar 2022 15:29:15 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id bg18-20020a05600c3c9200b0037c2ef07493sm109916wmb.3.2022.03.15.15.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:29:15 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: Fix spelling mistake "does't" -> "doesn't"
Date:   Tue, 15 Mar 2022 22:29:14 +0000
Message-Id: <20220315222914.2960786-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 089f4444b7e3..1f87a8a3fe32 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1225,7 +1225,7 @@ static int hclge_tm_pri_dwrr_cfg(struct hclge_dev *hdev)
 		ret = hclge_tm_ets_tc_dwrr_cfg(hdev);
 		if (ret == -EOPNOTSUPP) {
 			dev_warn(&hdev->pdev->dev,
-				 "fw %08x does't support ets tc weight cmd\n",
+				 "fw %08x doesn't support ets tc weight cmd\n",
 				 hdev->fw_version);
 			ret = 0;
 		}
-- 
2.35.1

