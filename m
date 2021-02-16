Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDED31C5FE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 05:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBPEat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 23:30:49 -0500
Received: from m12-13.163.com ([220.181.12.13]:45418 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhBPEaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 23:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=P4nP/c1fhkFQm6XfiE
        8QHNB8CAUEG0CcCgj0cJgsjKg=; b=pNabb49iOxoV8PgRZKTPCkWK4kWFOOlmdi
        20Fyt2PSadfFw4KS7k5ZNnEPg/IVPlY6DUa/5y1mYvI65URJlvRJhnu+ITa3+soH
        Zmco/762U4RYM9WktE7cs2Zg9ODFgL1jZAE9IaAbY4KdZRXLj46hMu/TX/5jWLfg
        T7EUmZIvM=
Received: from localhost.localdomain (unknown [125.70.193.99])
        by smtp9 (Coremail) with SMTP id DcCowAC3LtLAPitgnqnIfQ--.20342S2;
        Tue, 16 Feb 2021 11:40:55 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     pizza@shaftnet.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Lin <chen.lin5@zte.com.cn>
Subject: [PATCH] cw1200: Remove unused function pointer typedef cw1200_wsm_handler
Date:   Tue, 16 Feb 2021 11:41:58 +0800
Message-Id: <1613446918-4532-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
X-CM-TRANSID: DcCowAC3LtLAPitgnqnIfQ--.20342S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JryftFW7Xr18GFykCr4UArb_yoW3JFc_Gw
        4SyFn7GryxA3WSka4DArZxurySv3s3ua18WanIqFW3Ga1DJrWjqrWFvFyUCr9rCFW8ZFZ7
        Jw1kGa17A3yvqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0fHUDUUUUU==
X-Originating-IP: [125.70.193.99]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbBdgc7nlUMQAxxSQAAs5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Lin <chen.lin5@zte.com.cn>

Remove the 'cw1200_wsm_handler' typedef as it is not used.

Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
---
 drivers/net/wireless/st/cw1200/bh.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/bh.c b/drivers/net/wireless/st/cw1200/bh.c
index c364a39..8bade5d 100644
--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -42,9 +42,6 @@ enum cw1200_bh_pm_state {
 	CW1200_BH_RESUME,
 };
 
-typedef int (*cw1200_wsm_handler)(struct cw1200_common *priv,
-	u8 *data, size_t size);
-
 static void cw1200_bh_work(struct work_struct *work)
 {
 	struct cw1200_common *priv =
-- 
1.7.9.5


