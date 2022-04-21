Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152F9509B50
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 10:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiDUI6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 04:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiDUI6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 04:58:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112751AF2C;
        Thu, 21 Apr 2022 01:55:49 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m14so5675067wrb.6;
        Thu, 21 Apr 2022 01:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rx6YW0z7TNgwrZzCOM/LadQs2IROT5w7euvFjQgv97I=;
        b=KF2vkyN/kcWb3uC+3v/wWOoqsfdtj2UwSVyPlTbFTNKEMy6eNSh3WI6DKjEac6mKA0
         eEE8dgZGBRacJwS9FyI8He8jccbvTR4qE3SfEzC+aN3FFphgG0TwKMcwB9lG50K/Pktd
         E4sXnZ/laH6RvPi7kFR+vqz+PdnLuOvtgjfCSW5YNmwDzfRY2qOm5hhHs4jhI1zsQzrw
         lsH+f15LfyCR1YAEdKKamN5rLaOe5H75Xn8NuHuYKv923XxcNklBgNqO8oFyR1VUPiwr
         i+gxqvXyh+jb7ttNvF4IahsukBwcsXUuzZh6xUweqravQosdFu/rcgeBazlpbywI/C/H
         m0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rx6YW0z7TNgwrZzCOM/LadQs2IROT5w7euvFjQgv97I=;
        b=EDCjv1fnVn6NW6MwW0jkyOYAXL2JUtMyIs4UdeO8YkANYkCZOYNatxPIQmhGuv/Cb/
         6DVaF3DgqulcWE5mX5FEF2N+500RHeK7mEQ1mVTpd+Qt1qp8kO+fgX/XGwuaOpGfBcgh
         KAKGR+M4w+cXlXEbOicApajlw0KwMf8vI98BsaFI6ognymyKmmxOI8BjfxDUQEITOd6K
         6xSN8b95iR2upxHpg0LfXdJaf+8qk8A9J6u0a4OnNoZUUNBOql8+Y/YCdQlJ5ujjp4Zj
         vbmTD8WLaV5RWkxXq6cqxBDTOw+OZhteOzf4UApsfynFtbhehvIJ/TZbgXNEfKmzPgK4
         HFUg==
X-Gm-Message-State: AOAM531uUP3GyxUC/J65wlUE8Ow3GWrmXPHf9VNzBNozEeX4SRlUK6zY
        LhWIhaAzmaKvYeYeUA/D850=
X-Google-Smtp-Source: ABdhPJxWKzmGEVET2B/IQtcjzG1GiBxqmi9/CRN/U34lV/Xj2CT045mFHvG8LKRvHXGM3gcTi8SiiA==
X-Received: by 2002:a5d:52c9:0:b0:207:99d3:7b4d with SMTP id r9-20020a5d52c9000000b0020799d37b4dmr19770425wrv.77.1650531347604;
        Thu, 21 Apr 2022 01:55:47 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id m4-20020a7bcb84000000b00389efb7a5b4sm1539091wmi.17.2022.04.21.01.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 01:55:47 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: hns3: Fix spelling mistake "actvie" -> "active"
Date:   Thu, 21 Apr 2022 09:55:46 +0100
Message-Id: <20220421085546.321792-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
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

There is a spelling mistake in a netdev_info message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index bb001f597857..1db8a86f046d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1915,7 +1915,7 @@ static int hns3_set_tunable(struct net_device *netdev,
 			return ret;
 		}
 
-		netdev_info(netdev, "the actvie tx spare buf size is %u, due to page order\n",
+		netdev_info(netdev, "the active tx spare buf size is %u, due to page order\n",
 			    priv->ring->tx_spare->len);
 
 		break;
-- 
2.35.1

