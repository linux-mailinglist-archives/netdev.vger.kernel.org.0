Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48C3620E1A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiKHLFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiKHLFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:05:06 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C2C47309;
        Tue,  8 Nov 2022 03:05:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id i5-20020a1c3b05000000b003cfa97c05cdso814930wma.4;
        Tue, 08 Nov 2022 03:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=djx0y+EGNKlQ+Rmpfi08YMzznsTRBlDgFYnuDiHncdM=;
        b=DdtabEAB8YkZDsbfpew8LBwerFB+hd2huHnSXPsuk6cozl8de643oj/QWLaxdPMpkX
         dXSwHqmauJL8cE1UkHGzBfgJ8av89XtjIapV/j7glCVvzeze4xe30DnrDY3VITsXHQXY
         3Uphz58+OBu7ycz0t8zX6hnN892i5fd6uLa8p368BjW9gkdjLA64y5T0RyW0Q+UPa4Le
         5JU4MoJ6oVODY1K51UP7LWiVQFHuzzRz4ql2fH8qFvu+l1WPkeCLvnLegUYEE0QY/mFR
         GR7y/Qi8OHn3XtA8gurPJKAEHYxSmcRA96HbtnhnEZcfJhUBGjBv3SpeMgj9/UufwJHm
         KThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=djx0y+EGNKlQ+Rmpfi08YMzznsTRBlDgFYnuDiHncdM=;
        b=hXKOUEhgHbrLEmitnd12V6R4uFSUyLSBXfh9+XAN/Bc8RGDeu+jzsxyfDNE/ik7/s8
         bk9zPe0Kr+87/ubIxeZegQcqlaGrHIR2txTw9KVEEFvSdbxGawpWMYfCK2rVtK8ijrWK
         SKcwLzxU6feWKe44nUaAivfd5Gi+ZlOqVzggsxw9gOJHe5bFVlGod3Eh/b4zugrD6rPd
         k0ktoE6j3OdORbkVLCmfPrK608vinEJG4WQ+ZWJ+PEOc2sDGH/s38ygRzB4S68kUJ6iS
         I5j6j8gso6vWrbl/tjRfKX+Zlk/0IVe7nxUOUM0YB+6/dkIuHdDLDILxh4zZCc4fpDT8
         67Ng==
X-Gm-Message-State: ACrzQf3BzL1m8QPxYCOrRozpEQp+TMIe5k9HXNN4NXClJp9HyN002D4T
        ePx5F2aLFLhhtR+fc6wjHkE=
X-Google-Smtp-Source: AMsMyM6U/UcqQkaoQFwHy2HIStWRuHsxgcc6OxtK6VEE+wtFf2pLteWT7+gUwjcDfp6wYVbJv7eJtQ==
X-Received: by 2002:a7b:cb81:0:b0:3c0:f8fc:ea23 with SMTP id m1-20020a7bcb81000000b003c0f8fcea23mr47203938wmi.31.1667905503881;
        Tue, 08 Nov 2022 03:05:03 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id bx14-20020a5d5b0e000000b0022cd0c8c696sm9933379wrb.103.2022.11.08.03.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 03:05:03 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] hinic: Fix spelling mistake "fliter" -> "filter"
Date:   Tue,  8 Nov 2022 11:05:02 +0000
Message-Id: <20221108110502.114328-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a function name and a dev_err message containing a
spelling mistake. Fix them.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_port.c | 4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_port.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 977c41473ab7..db82fe4736a6 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1093,7 +1093,7 @@ static int set_features(struct hinic_dev *nic_dev,
 	}
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		ret = hinic_set_vlan_fliter(nic_dev,
+		ret = hinic_set_vlan_filter(nic_dev,
 					    !!(features &
 					       NETIF_F_HW_VLAN_CTAG_FILTER));
 		if (ret) {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 9406237c461e..0ab72069e377 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -447,7 +447,7 @@ int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en)
 	return 0;
 }
 
-int hinic_set_vlan_fliter(struct hinic_dev *nic_dev, u32 en)
+int hinic_set_vlan_filter(struct hinic_dev *nic_dev, u32 en)
 {
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
@@ -472,7 +472,7 @@ int hinic_set_vlan_fliter(struct hinic_dev *nic_dev, u32 en)
 		err = HINIC_MGMT_CMD_UNSUPPORTED;
 	} else if (err || !out_size || vlan_filter.status) {
 		dev_err(&pdev->dev,
-			"Failed to set vlan fliter, err: %d, status: 0x%x, out size: 0x%x\n",
+			"Failed to set vlan filter, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, vlan_filter.status, out_size);
 		err = -EINVAL;
 	}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index c8694ac7c702..1b2e45c704d5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -841,7 +841,7 @@ int hinic_get_vport_stats(struct hinic_dev *nic_dev,
 
 int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en);
 
-int hinic_set_vlan_fliter(struct hinic_dev *nic_dev, u32 en);
+int hinic_set_vlan_filter(struct hinic_dev *nic_dev, u32 en);
 
 int hinic_get_mgmt_version(struct hinic_dev *nic_dev, u8 *mgmt_ver);
 
-- 
2.38.1

