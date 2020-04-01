Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA6A19AC75
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 15:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732643AbgDANPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 09:15:10 -0400
Received: from m12-12.163.com ([220.181.12.12]:52257 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732252AbgDANPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 09:15:10 -0400
X-Greylist: delayed 928 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2020 09:14:58 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=9hBqq
        BBOphcjeouaGjRhwwLQLfRQf0pDSeH4OIWyx0Y=; b=DhGOFGx2/6rdqwdkhz0UF
        uiZRLKTWjBIGYZO+mhoI45GHPuZHLbQImCvEGiNzAPTpab7UchG6kcLoxGfEyVEW
        Cd4bofY2NIdtRKOtTl6CzC8IFf77KNDJy6xIuze2es6yIuIy1m0az7CrG/ogkp5e
        zKog81D3uCITlz+pErsCe4=
Received: from localhost.localdomain (unknown [125.82.11.8])
        by smtp8 (Coremail) with SMTP id DMCowACHlRGyj4ReewqBBg--.25810S4;
        Wed, 01 Apr 2020 20:57:23 +0800 (CST)
From:   Hu Haowen <xianfengting221@163.com>
To:     saeedm@mellanox.com, leon@kernel.org, davem@davemloft.net
Cc:     guoren@kernel.org, xiubli@redhat.com, jeyu@kernel.org, cai@lca.pw,
        wqu@suse.com, stfrench@microsoft.com,
        yamada.masahiro@socionext.com, chris@chris-wilson.co.uk,
        xianfengting221@163.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: improve some comments
Date:   Wed,  1 Apr 2020 20:57:20 +0800
Message-Id: <20200401125720.20276-1-xianfengting221@163.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowACHlRGyj4ReewqBBg--.25810S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrur18uF4fXFyDGr4kuw4fuFg_yoWDCFX_Cr
        1avw13Xw4Uur90k3y3uw43JrWrKr909rs3AF42gay3X3yjkr4xJ34kG34xJF97WFWYqasx
        A3W7GF1xA3sYvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUfgA3UUUUU==
X-Originating-IP: [125.82.11.8]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/xtbB0RP4AFzH9IuNdQAAsm
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added a missing space character and replaced "its" with "it's".

Signed-off-by: Hu Haowen <xianfengting221@163.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index c9c9b479bda5..0a8adda073c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -684,7 +684,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 		get_block_timestamp(tracer, &tmp_trace_block[TRACES_PER_BLOCK - 1]);
 
 	while (block_timestamp > tracer->last_timestamp) {
-		/* Check block override if its not the first block */
+		/* Check block override if it's not the first block */
 		if (!tracer->last_timestamp) {
 			u64 *ts_event;
 			/* To avoid block override be the HW in case of buffer
-- 
2.20.1


