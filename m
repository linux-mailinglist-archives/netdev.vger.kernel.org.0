Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB9930553F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhA0IGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:06:45 -0500
Received: from m12-11.163.com ([220.181.12.11]:43019 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234542AbhA0IE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 03:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=bRLQS
        kBMT/+SWY6fxZqhz3rJJ5Q63NN9OXjHW1J+11c=; b=dy5h6f6HveyWXqLPJAV+D
        MIsLxrYsrXmI6pmIuFDCfsChGbGeAV5tXz2XSoGzbF5aC/EXIuGL+/I9MajBGFBv
        jUuhxMPsvjC7gXOVzIJTNVTFsMrlvvBQgcQx/F5B+8bO9mXep9tXedSragvwUW8r
        U92di9Jd0aksckMcb9jL2c=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp7 (Coremail) with SMTP id C8CowACnoJi3zxBgBowgKw--.53584S2;
        Wed, 27 Jan 2021 10:28:09 +0800 (CST)
From:   dingsenjie@163.com
To:     aelior@marvell.com, GR-everest-linux-l2@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] linux/qed: fix spelling typo in qed_chain.h
Date:   Wed, 27 Jan 2021 10:28:01 +0800
Message-Id: <20210127022801.8028-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowACnoJi3zxBgBowgKw--.53584S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw4xWrWkGFW5AFWDZw48tFb_yoW3Wwc_Wa
        4xJ3yxurWDAFsFqw18tFn2vFyvq34fZFykuF1vkr12qFy5Xa1kJw1xKF9FqF47Wa13ur9F
        vFy8WayfKry29jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5IYLPUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiHhknyFSIshqz8wAAsc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

allocted -> allocated

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 include/linux/qed/qed_chain.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 4d58dc8..e339b48 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -470,7 +470,7 @@ static inline void *qed_chain_consume(struct qed_chain *p_chain)
 /**
  * @brief qed_chain_reset - Resets the chain to its start state
  *
- * @param p_chain pointer to a previously allocted chain
+ * @param p_chain pointer to a previously allocated chain
  */
 static inline void qed_chain_reset(struct qed_chain *p_chain)
 {
-- 
1.9.1

