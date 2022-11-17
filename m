Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C27062D997
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbiKQLjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239700AbiKQLix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:38:53 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91644D5F3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:38:51 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCdG15glLzHvwD;
        Thu, 17 Nov 2022 19:38:17 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 19:38:48 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <krzysztof.kozlowski@linaro.org>, <pavel@denx.de>,
        <u.kleine-koenig@pengutronix.de>, <kuba@kernel.org>,
        <michael@walle.cc>, <cuissard@marvell.com>,
        <sameo@linux.intel.com>, <clement.perrochaud@nxp.com>,
        <r.baldyga@samsung.com>, <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 0/3] nfc: Fix potential memory leak of skb
Date:   Thu, 17 Nov 2022 19:37:11 +0800
Message-ID: <20221117113714.12776-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are still somewhere maybe leak the skb, fix the memleaks by adding
fail path.

Shang XiaoJing (3):
  nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
  nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
  nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()

 drivers/nfc/nfcmrvl/i2c.c  | 4 +++-
 drivers/nfc/nxp-nci/core.c | 8 ++++++--
 drivers/nfc/s3fwrn5/core.c | 1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.17.1

