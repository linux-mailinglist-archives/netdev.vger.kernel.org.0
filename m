Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD48CC41C0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfJAUX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 16:23:59 -0400
Received: from mx6.ucr.edu ([138.23.62.71]:34082 "EHLO mx6.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfJAUX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 16:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1569961440; x=1601497440;
  h=from:to:cc:subject:date:message-id;
  bh=6Std4kNv6rcCi3H8DqYign72h7owKlGXXMq3UQl1GHY=;
  b=T6tqX33rCkkIFRGL/sD3JHPXOJB47fFP51qzN+alalpqhqx2PxQpJXKF
   Um8gvZ/+aaC3eARVTWstnciwncM2ccKCzgi7T95CDKDAnZdU6+tYZSKan
   tUHR48Nusce83p74l3QdI6WffyrTmTiwen5sBhcr9mZPXnBhDN/4QitlC
   NStobkj5aprorFjekMuKftVtvBAMY6bRsLwLx8+oNzyXaB6wQ3ujbpAxJ
   lpPGbZlo/eduTbR4VCU+IuVMvrTGT/eMXoa+xUVUlZAnvagr4PvfwGGc1
   6+IvdcoKthgjFDZqxEcxgux5fiQ7Sv9JwZTtdmk9rUbQSUrtBsNrcS9yK
   A==;
IronPort-SDR: 2jOi9YDEYYXv0vbCJ3hM3VvS7+VbYVWE4GhyHSBv7T8tqME2QAeL/70aTnzMt2Ldq78T5xBxvU
 bbyBItL2Lhqmt4174ZwRflWUlDCbF0hO8PfSs+gIhROxPGSWXKrIS5ny3e6qoHtSBKrReD3Prh
 S8ExIzx8QYN6qFMrDv/iAy4fuTypHdRVoAT9Pue7qRNzUn9cqpj/w6+wnTM0saPyURxbSqXq52
 ZciLGvmKIgaP74PwlTefj1o1xT8mlRFUedgN4zymw3nYa6YgodT3nuQsGc2Ft1yEHOpVhN5h9a
 Ozw=
IronPort-PHdr: =?us-ascii?q?9a23=3An5BBmRNhbHJcWFot4AAl6mtUPXoX/o7sNwtQ0K?=
 =?us-ascii?q?IMzox0LfT5rarrMEGX3/hxlliBBdydt6sfzbaK+Pm8ByQp2tWoiDg6aptCVh?=
 =?us-ascii?q?sI2409vjcLJ4q7M3D9N+PgdCcgHc5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFR?=
 =?us-ascii?q?rhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTagb75+Nhq7oAreusULjoZvK7s6xw?=
 =?us-ascii?q?fUrHdPZ+lY335jK0iJnxb76Mew/Zpj/DpVtvk86cNOUrj0crohQ7BAAzsoL2?=
 =?us-ascii?q?465MvwtRneVgSP/WcTUn8XkhVTHQfI6gzxU4rrvSv7sup93zSaPdHzQLspVz?=
 =?us-ascii?q?mu87tnRRn1gyocKTU37H/YhdBxjKJDoRKuuRp/w5LPYIqIMPZyZ77Rcc8GSW?=
 =?us-ascii?q?ZEWMtRUi1BApinb4sOCeoBMvtToZfkqVAToxu+BBejBOfyxTRVgnP707E23+?=
 =?us-ascii?q?EnHArb3gIvAsgOvWzUotvrKakcX+O7wq7TwDnfc/9bwyvx5ZLUfhw9p/yHQL?=
 =?us-ascii?q?J+cdDWyUkqDw7KjFSQqI3lPzOI0eQGrm+W7uphVOKvkWEnqh19riShy8o3l4?=
 =?us-ascii?q?nGmpgVxkra+ipk3YY4PNu1Q1N4b968CJZcqT2WOo9sTs4hQ2xkojg2xqAJtJ?=
 =?us-ascii?q?KhYiQG1IgrywbCZ/GGd4WE+AzvWeiRLDtimn5oeaizihS9/EWm1+byTNO70E?=
 =?us-ascii?q?xQoSpAitTMs3cN2AHN5cWfUft9+1uh2S6I1wDO9uFIOUA0mrTfK54m2rMwk4?=
 =?us-ascii?q?AcsUXHHiPvgEX2iLKaelwq+uS29+jrfq/qppCbN49zhQH+NrohltajDuQ/Nw?=
 =?us-ascii?q?gCR2mb+eKi273/5UD1XqlGg/ksnqTasJ3WP9oXqrO2DgNPzIov9wqzAy+j0N?=
 =?us-ascii?q?sCnHkHKFxFeAiAj4jsI1zPIPH5DfeljFStjDtn2/7LM6b8AprRNHjPiqnucq?=
 =?us-ascii?q?tg60JE0go80chf545ICrEGOP/zXFH+tMDFARAnLQy52PjnCNpj2YMEQ26PAb?=
 =?us-ascii?q?GWMLnUsVCW4uIjOe6MZJUauGW1BeIi4qvfjG05hFhVKbi73ZIWMCjjNultOQ?=
 =?us-ascii?q?OUbWe60YRJKnsDogdrFL+is1aFSzMGIinqUg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HIAgD4tJNdh8jWVdFmHgEGEoFcC4N?=
 =?us-ascii?q?eTBCNH4ZMBosmGHGFeoMLhSeBewEIAQEBDAEBLQIBAYRAgjIjNAkOAgMJAQE?=
 =?us-ascii?q?FAQEBAQEFBAEBAhABAQEIDQkIKYVAgjopgzULFhVSgRUBBQE1IjmCRwGBdhQ?=
 =?us-ascii?q?Fo0aBAzyMJTOIYgEJDYFICQEIgSKHNYRZgRCBB4N1bIQNg1iCRASBNwEBAZU?=
 =?us-ascii?q?flksBBgKCEBSBeJMNJ4Q6iT2LQQEtpx8CCgcGDyOBL4ISTSWBbAqBRFAQFIF?=
 =?us-ascii?q?pHo4uITOBCI4fglQB?=
X-IPAS-Result: =?us-ascii?q?A2HIAgD4tJNdh8jWVdFmHgEGEoFcC4NeTBCNH4ZMBosmG?=
 =?us-ascii?q?HGFeoMLhSeBewEIAQEBDAEBLQIBAYRAgjIjNAkOAgMJAQEFAQEBAQEFBAEBA?=
 =?us-ascii?q?hABAQEIDQkIKYVAgjopgzULFhVSgRUBBQE1IjmCRwGBdhQFo0aBAzyMJTOIY?=
 =?us-ascii?q?gEJDYFICQEIgSKHNYRZgRCBB4N1bIQNg1iCRASBNwEBAZUflksBBgKCEBSBe?=
 =?us-ascii?q?JMNJ4Q6iT2LQQEtpx8CCgcGDyOBL4ISTSWBbAqBRFAQFIFpHo4uITOBCI4fg?=
 =?us-ascii?q?lQB?=
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="79524378"
Received: from mail-pl1-f200.google.com ([209.85.214.200])
  by smtpmx6.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Oct 2019 13:23:59 -0700
Received: by mail-pl1-f200.google.com with SMTP id d1so7944263plj.9
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 13:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=q599bl3zDqjBXqyRyPM4QuCbcNSe6pusjy0ki6fkKJs=;
        b=m4FPkHap1Ges9DdQEhbMzcfwMoPUwqgF+mAF6GAjcnVFfaabwtlo2Ug0cXXkkPfTIL
         taLgVRjhubIA6P0MoJddg2Ty2J8rpiYXEyM2D4jme8VB5VDkEjdo5qEaFrNRgyK16prC
         FgQ/QlVODmV85MvrPnAoqrAeNunOmajXM9BmtPkxzjsdf/IErF0j9+wzX7t/k5EpG9wl
         yeR+u1kQ17nTWqAsPMg20nyMn/xdImlfBnIi8P/Uf1IVnqtSqGZBT9117ogXskLPkr9K
         QIZfjpFS0XdrTdgfjclre2iozng3RY62GyWEnjH37aRAWxdsZ8lIsRCkH7whDO8EjmZE
         SUMA==
X-Gm-Message-State: APjAAAUOz/K1zNZDNkESYKJB6b8rOlcObXN2F/lc45Kt+8Ly5m7Xcqpg
        vj5BKkuSUL1737wdWK1Po+Yea782qb0rRS3Ej1LgmtkBt9kMOB6HxiQHCPHUW498Y+wfdMR2l5a
        Q7WaWU11zEj6bbjCKwA==
X-Received: by 2002:a62:4e0f:: with SMTP id c15mr182637pfb.42.1569961437720;
        Tue, 01 Oct 2019 13:23:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzHo3trZ/iZ+zj7Hc4tRao5vzbmDEDx6LB2tg/EDz+Vg7EKgDtl7xl6KNPl7o4NL6RoTM55oA==
X-Received: by 2002:a62:4e0f:: with SMTP id c15mr182595pfb.42.1569961437238;
        Tue, 01 Oct 2019 13:23:57 -0700 (PDT)
Received: from Yizhuo.cs.ucr.edu (yizhuo.cs.ucr.edu. [169.235.26.74])
        by smtp.googlemail.com with ESMTPSA id 202sm18779898pfu.161.2019.10.01.13.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 13:23:56 -0700 (PDT)
From:   Yizhuo <yzhai003@ucr.edu>
Cc:     csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, Yizhuo <yzhai003@ucr.edu>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()
Date:   Tue,  1 Oct 2019 13:24:39 -0700
Message-Id: <20191001202439.15766-1-yzhai003@ucr.edu>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function mdio_sc_cfg_reg_write(), variable "reg_value" could be
uninitialized if regmap_read() fails. However, "reg_value" is used
to decide the control flow later in the if statement, which is
potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 3e863a71c513..7df5d7d211d4 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -148,11 +148,15 @@ static int mdio_sc_cfg_reg_write(struct hns_mdio_device *mdio_dev,
 {
 	u32 time_cnt;
 	u32 reg_value;
+	int ret;
 
 	regmap_write(mdio_dev->subctrl_vbase, cfg_reg, set_val);
 
 	for (time_cnt = MDIO_TIMEOUT; time_cnt; time_cnt--) {
-		regmap_read(mdio_dev->subctrl_vbase, st_reg, &reg_value);
+		ret = regmap_read(mdio_dev->subctrl_vbase, st_reg, &reg_value);
+		if (ret)
+			return ret;
+
 		reg_value &= st_msk;
 		if ((!!check_st) == (!!reg_value))
 			break;
-- 
2.17.1

