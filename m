Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5184CA5E04
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 01:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfIBXOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 19:14:38 -0400
Received: from mx1.ucr.edu ([138.23.248.2]:5684 "EHLO mx1.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfIBXOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 19:14:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1567466279; x=1599002279;
  h=from:to:cc:subject:date:message-id;
  bh=wrJn6aBHz0Uw1eGhnnd+uYHpG8nT9vsMJN2vUur/bWQ=;
  b=OhnTr0ldt5Mv8QIOqfKoGO5jKzVcBnhz2phCnjp8HMy3Z4zhSBlPlWZP
   EdYsMgKQVGFjDTBARnjzO1+p3Zcad2mYHadNlnF8bnxE92fv/WzQFlQcb
   vEZTyFZO1KJo4TYmIOza7DNBfwApnSU2GF4L1symoGL47trASjQk/1JEn
   TjcyO48I5Hn3HOcQZetzNqa1uoOTmBSqSgD/ZzFZYdOQHzrR8iCXIdcX9
   tHV1HJFyz8kl6wRNrcIXtc24rqWC47WNjpsvWfosz8Q8RG2kFodhLA1pS
   8xHaERd8BlS1ilkFzBCGFHz5hAhSg9dCh13yw9eq0ANketdiJ9aYsHetA
   Q==;
IronPort-SDR: 91Demo70DShrkXVbUVWHMRod9XLbB0XHbZAAaQT9hfbpEDN1w0/HtArCyOppa6d2BO6nfiqw9F
 NMfG3CNOB2PQlnGX814Nuab2JGjdbWI4FmVuOfj77Obf2KxrGR1ATqL7yeFzZTtCINoxoJnR9H
 ulwrLIH/jk8ARFgV0JgobkrC3PW3Fjc1cN3UGsu9IE7LVdkZaY15DlD14iuF0NMhHUy/xXrs5U
 4CKznKCnQoc+2O6x3X40LSItoVUPd5B0GrKH50Qo3nVpteGdI94HOmgDhw+7oCgU4CVyH9VRrO
 G+0=
IronPort-PHdr: =?us-ascii?q?9a23=3AI61//hAIY9lmpQJWG2/7UyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSPvzpcbcNUDSrc9gkEXOFd2Cra4d0ayP7PmrADNIyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfK1+IA+roQjTq8UajpZuJ6QswR?=
 =?us-ascii?q?bVv3VEfPhby3l1LlyJhRb84cmw/J9n8ytOvv8q6tBNX6bncakmVLJUFDspPX?=
 =?us-ascii?q?w7683trhnDUBCA5mAAXWUMkxpHGBbK4RfnVZrsqCT6t+592C6HPc3qSL0/RD?=
 =?us-ascii?q?qv47t3RBLulSwKLCAy/n3JhcNsjaJbuBOhqAJ5w47Ie4GeKf5ycrrAcd8GWW?=
 =?us-ascii?q?ZNW8BcVylAAoOndIsPDuwBPelFpIfjvlUFsBW+BQiyC+Pr1zBDm3v60KMm3+?=
 =?us-ascii?q?gkFwzNwQ4uEM8UsHnMrNv7KrocX+62wqfP1jjPc+9a1C3h5IXSbhwtvfeBVq?=
 =?us-ascii?q?9wf8rLzkkvEhvIgVeRqY3kPzOVy+MNuHWc4utgVOOvi3QoqwBtrjSzyMohkZ?=
 =?us-ascii?q?TJiZ4Pylze6yp23Zs1KMS+RUVmYtCkCINduz+GO4ZyWM8vQGFltDwkxrEbuZ?=
 =?us-ascii?q?O3ZjYGxIg7yxLHdvCKcoyF7gj9WOufITp0nmxpdbOlixuw/kWtzPD3WNOu31?=
 =?us-ascii?q?ZQtCVFl8HBtnUK1xPO9MeKUuB9/kK92TaX0ADT9/1ELVg0laXFL54hxaY9lp?=
 =?us-ascii?q?8JvkTCGi/6gV32jKCLekk99Oik9fjrbqn8qp+TMI90jQ7+MqAwlcClHes4NQ?=
 =?us-ascii?q?0OU3Ca+eS6yrLj4VX0TKtWgvAyiKXUs5DXKd4FqqKkAwJZyJgv5wqjAzu+1d?=
 =?us-ascii?q?QXh3gHLFZLeBKdiIjpPknDIfD5DPe/mVuskStny+zIM7D6H5XCMmLDnK3/cr?=
 =?us-ascii?q?lg9k5Q0BAzwsxH55JIFrEBJ+r+Wknvu9zEExA2LRK0zv35CNVyyIweQ3iDAq?=
 =?us-ascii?q?yHP6PIt1+H+OYvL/OLZI8PtzauY9Y/4Pu7vH4rmUIaNf24z5seaSjgRdx7KF?=
 =?us-ascii?q?/fbHbx1IRSWVwWtxYzGbS5wGaJViReMjPtB68=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2E8AACqgmddgMjXVdFlHgEGBwaBUwk?=
 =?us-ascii?q?LAYNXTBCNHYZcAQEBBosfGHGFeYMJhSSBewEIAQEBDAEBLQIBAYQ/glsjNAk?=
 =?us-ascii?q?OAgMIAQEFAQEBAQEGBAEBAhABAQkNCQgnhUOCOimCYAsWFVJWPwEFATUiOYJ?=
 =?us-ascii?q?HAYF2FJ08gQM8jCMziGkBCAyBSQkBCIEiAYcdhFmBEIEHhGGEDYNWgkQEgS4?=
 =?us-ascii?q?BAQGUTpYFAQYCAYIMFIFyklMngjKBfokZOYpaAS2ldwIKBwYPIYEvghFNJYF?=
 =?us-ascii?q?sCoFEgnqOLR8zgQiMAYJUAQ?=
X-IPAS-Result: =?us-ascii?q?A2E8AACqgmddgMjXVdFlHgEGBwaBUwkLAYNXTBCNHYZcA?=
 =?us-ascii?q?QEBBosfGHGFeYMJhSSBewEIAQEBDAEBLQIBAYQ/glsjNAkOAgMIAQEFAQEBA?=
 =?us-ascii?q?QEGBAEBAhABAQkNCQgnhUOCOimCYAsWFVJWPwEFATUiOYJHAYF2FJ08gQM8j?=
 =?us-ascii?q?CMziGkBCAyBSQkBCIEiAYcdhFmBEIEHhGGEDYNWgkQEgS4BAQGUTpYFAQYCA?=
 =?us-ascii?q?YIMFIFyklMngjKBfokZOYpaAS2ldwIKBwYPIYEvghFNJYFsCoFEgnqOLR8zg?=
 =?us-ascii?q?QiMAYJUAQ?=
X-IronPort-AV: E=Sophos;i="5.64,443,1559545200"; 
   d="scan'208";a="5470476"
Received: from mail-pg1-f200.google.com ([209.85.215.200])
  by smtp1.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2019 16:17:58 -0700
Received: by mail-pg1-f200.google.com with SMTP id m19so9675849pgv.7
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 16:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qbPcGIvjek55/mukFc57PQHYy7743OrNG7Y4v0Ab2d0=;
        b=ZEqAToTCzX83vMgkLYF7QfBNXPOMLwGIaFa+xvKbP936+nHgmXNywaVTBlY4Pf/lwW
         X46VkEeoq1GrwziVvA1Or13QenHRUX4JBAdwi80Wt7aoNyb1bJlzqxqbsabCJHSxBrCT
         aSls4shoGEiKtGRpTV/yyv5P5kqH15Kwz78LQOZz428ca0YA85V3VuVj6FCJJNNCDNyQ
         jaOrCLiQjCKftofLvw8F6qASKCEMMvlMDkDB86aupNpLQVBQ64NX0IHkNS7ZIIWVmrXF
         s/z01P041DsMm5d+30zx/DZkLYXtRmXWfXycuRo+EPaQxxzCPfm0NRkw0/vfM3mOPTtz
         3fgw==
X-Gm-Message-State: APjAAAWDcNQnLOzTJETDL7w+rIfX8FSl4Lh7cG/qbEqwwWEPZSo1Ok5A
        B6ogL2SeIRyXALw9wnmUUM5awO75NUgzVpBlByxtsXqxMpxZc4JLcvJdMh1fz5qROIbKuiFFVVW
        HRuBvLKBeuwkvsucMsQ==
X-Received: by 2002:a17:902:9f97:: with SMTP id g23mr25566852plq.248.1567466076389;
        Mon, 02 Sep 2019 16:14:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyG1mxoH7h9PwFtEKTdqe361X81McE/StIlugJILQyx3cKKtm08UaQvwZnUk/+e7cNgptjUmQ==
X-Received: by 2002:a17:902:9f97:: with SMTP id g23mr25566835plq.248.1567466076169;
        Mon, 02 Sep 2019 16:14:36 -0700 (PDT)
Received: from Yizhuo.cs.ucr.edu (yizhuo.cs.ucr.edu. [169.235.26.74])
        by smtp.googlemail.com with ESMTPSA id 138sm18270374pfw.78.2019.09.02.16.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 16:14:35 -0700 (PDT)
From:   Yizhuo <yzhai003@ucr.edu>
Cc:     csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, Yizhuo <yzhai003@ucr.edu>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: hisilicon: Variable "reg_value" in function mdio_sc_cfg_reg_write() could be uninitialized
Date:   Mon,  2 Sep 2019 16:15:10 -0700
Message-Id: <20190902231510.21374-1-yzhai003@ucr.edu>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function mdio_sc_cfg_reg_write(), variable reg_value could be
uninitialized if regmap_read() fails. However, this variable is
used later in the if statement, which is potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 3e863a71c513..f5b64cb2d0f6 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -148,11 +148,17 @@ static int mdio_sc_cfg_reg_write(struct hns_mdio_device *mdio_dev,
 {
 	u32 time_cnt;
 	u32 reg_value;
+	int ret;
 
 	regmap_write(mdio_dev->subctrl_vbase, cfg_reg, set_val);
 
 	for (time_cnt = MDIO_TIMEOUT; time_cnt; time_cnt--) {
-		regmap_read(mdio_dev->subctrl_vbase, st_reg, &reg_value);
+		ret = regmap_read(mdio_dev->subctrl_vbase, st_reg, &reg_value);
+		if (ret) {
+			dev_err(mdio_dev->regmap->dev, "Fail to read from the register\n");
+			return ret;
+		}
+
 		reg_value &= st_msk;
 		if ((!!check_st) == (!!reg_value))
 			break;
-- 
2.17.1

