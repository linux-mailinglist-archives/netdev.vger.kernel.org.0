Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA01C3878CD
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 14:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349158AbhERMeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 08:34:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4731 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349176AbhERMeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 08:34:11 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkwKt3VGWzqV9t;
        Tue, 18 May 2021 20:29:22 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 20:32:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 18 May 2021 20:32:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/5] net: wan: remove redundant braces {}
Date:   Tue, 18 May 2021 20:29:52 +0800
Message-ID: <1621340994-20760-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621340994-20760-1-git-send-email-huangguangbin2@huawei.com>
References: <1621340994-20760-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Braces {} are not necessary for single statement blocks,
this patch removes redundant braces {}.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 7eac6a3e1cde..39f05fabbfa4 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1171,9 +1171,8 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
 	ut_info->uf_info.irq = irq_of_parse_and_map(np, 0);
 
 	uhdlc_priv = kzalloc(sizeof(*uhdlc_priv), GFP_KERNEL);
-	if (!uhdlc_priv) {
+	if (!uhdlc_priv)
 		return -ENOMEM;
-	}
 
 	dev_set_drvdata(&pdev->dev, uhdlc_priv);
 	uhdlc_priv->dev = &pdev->dev;
-- 
2.8.1

