Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE93AC50D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhFRHha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:37:30 -0400
Received: from m12-11.163.com ([220.181.12.11]:46660 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhFRHh3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 03:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=z8AqF
        vUURWTQHEJseWjpAIzD2HX/C7Nsa/lkQ0LkCYw=; b=cnI8p8bvOe/BFQXQuFODy
        pAJ2mDnPdj6PYsIQRUpeRYahQcpWbujD6qaF8f16ePwMbW2YGImoNK6YIx0jpIS1
        B9iB0/tQwjcg1ppjNjd6FFWRAd90pj9kgkrbCFJD/TEMFRrNsJf9gI6oj5ZIDghl
        grob+Ps6Ors0Sceqc1GeJM=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp7 (Coremail) with SMTP id C8CowACXnmakTMxg+Vuuig--.31126S2;
        Fri, 18 Jun 2021 15:35:03 +0800 (CST)
From:   dingsenjie@163.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] ethernet: marvell/octeontx2: Simplify the return expression of npc_is_same
Date:   Fri, 18 Jun 2021 15:34:31 +0800
Message-Id: <20210618073431.103924-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowACXnmakTMxg+Vuuig--.31126S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw4UXrWUCrWUGw1ftF4UXFb_yoWkWwb_Cr
        ySvFsay3WDKryktr4UtrZav34IyaykXrWvqrs0qrZIyF9rG3yUA3sxCFWxJFWkWr4Fq3Zr
        Crn3C347tw4UJjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnahF7UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiZRqyyF8ZPK6ebQABsj
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

Simplify the return expression in the rvu_npc_fs.c

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 14832b6..1995df4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -116,11 +116,8 @@ static bool npc_is_field_present(struct rvu *rvu, enum key_fields type, u8 intf)
 static bool npc_is_same(struct npc_key_field *input,
 			struct npc_key_field *field)
 {
-	int ret;
-
-	ret = memcmp(&input->layer_mdata, &field->layer_mdata,
-		     sizeof(struct npc_layer_mdata));
-	return ret == 0;
+	return memcmp(&input->layer_mdata, &field->layer_mdata,
+		     sizeof(struct npc_layer_mdata)) == 0;
 }
 
 static void npc_set_layer_mdata(struct npc_mcam *mcam, enum key_fields type,
-- 
1.9.1

