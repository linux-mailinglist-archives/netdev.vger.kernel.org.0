Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D937D30D363
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 07:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhBCG3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 01:29:00 -0500
Received: from m12-14.163.com ([220.181.12.14]:58960 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhBCG2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 01:28:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=3PjaSyTPIF/0eA0o6d
        2SeGzWaUYGs51QsvtN6khf1pE=; b=TWPFLVzzzFAqhbfZT/mDeERBmfj4sxWmdC
        bVYHMwQnbl53pB2vFtnMwoQJN3AZvSEFl/6kzlIa06ys8Nn4YV1r0yvscJO05Iwv
        UIamMfyXSx2tsWbHcfReVDxxeifdU/vohWwdomjt/UhE1HGHuYF1o7W7B6AJ9ZxP
        bWfbnvCkI=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.55.230])
        by smtp10 (Coremail) with SMTP id DsCowADH3ko6QhpgbEunjA--.285S2;
        Wed, 03 Feb 2021 14:27:07 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] rsi: remove redundant assignment
Date:   Wed,  3 Feb 2021 14:27:17 +0800
Message-Id: <20210203062717.1228-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowADH3ko6QhpgbEunjA--.285S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWxWF1kZw1xWw1fKF4UJwb_yoW3Krb_ur
        10qF4fWrWkG3W8Kryj9FW3Zr9Iya4UW3WrGw4qq3yfGryUtrZxAw15Crn3J3yDG34jvr9x
        Gws7uryIva43ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUe-yCJUUUUU==
X-Originating-IP: [119.137.55.230]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiRRsusVl91EvVBwAAso
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

INVALID_QUEUE has been used as a return value,it is not necessary to
assign it to q_num,so just return INVALID_QUEUE.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 2d49c5b..a48e616 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -193,8 +193,7 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 		if (recontend_queue)
 			goto get_queue_num;
 
-		q_num = INVALID_QUEUE;
-		return q_num;
+		return INVALID_QUEUE;
 	}
 
 	common->selected_qnum = q_num;
-- 
1.9.1


