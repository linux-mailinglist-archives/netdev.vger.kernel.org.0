Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43F433E9CD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 07:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCQGeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 02:34:15 -0400
Received: from m12-11.163.com ([220.181.12.11]:55874 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhCQGeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 02:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=8Y3HR
        MDBaV95f2J1fKzScv+yjUogarkNBO6uLyNIbM0=; b=ExQmo9CIqHMlqsCjg9ZyI
        RxPadlPtSLmHClojmPjZABzAj8/XxRodsjaNqrIcETqXCeUDxkkwD1WhsfyhsArv
        3vFcrH+FlRqgCpMiEhE9JbVEpGB7UkRtuUgnrggh7tfNyDob4thEmBEkyJDXW5I7
        bPk60DP+2yO5y2k+kw45Hs=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp7 (Coremail) with SMTP id C8CowADHz0fGolFgBC7NSg--.5880S2;
        Wed, 17 Mar 2021 14:33:45 +0800 (CST)
From:   zuoqilin1@163.com
To:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] mwifiex: Remove unneeded variable: "ret"
Date:   Wed, 17 Mar 2021 14:33:53 +0800
Message-Id: <20210317063353.1055-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowADHz0fGolFgBC7NSg--.5880S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw1rGF43KryDKrWDWFy5twb_yoWDXwb_K3
        4I9w4fKrZrJ3s7Kr4UCFsrX3sakr4rXFn7ua12qFWfGaykta98C3WkCrs7JrZakwsIqr9r
        uwn8GFyxJa18WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU05l1DUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/xtbBRQ1YiVPAKjBU8QACs3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

Remove unneeded variable: "ret"

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index c2a685f..0b877f3 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1211,7 +1211,6 @@ enum cipher_suite {
 int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				    struct mwifiex_bssdescriptor *bss_entry)
 {
-	int ret = 0;
 	u8 element_id;
 	struct ieee_types_fh_param_set *fh_param_set;
 	struct ieee_types_ds_param_set *ds_param_set;
@@ -1464,7 +1463,7 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		bytes_left -= total_ie_len;
 
 	}	/* while (bytes_left > 2) */
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.9.1

