Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F9619CF63
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 06:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgDCElb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 00:41:31 -0400
Received: from m12-17.163.com ([220.181.12.17]:54183 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgDCElb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 00:41:31 -0400
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2020 00:41:27 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Wbeh/
        XXcF9p0H3UV40lvWAHy5eGKJ2dZMK1faGpA0Mk=; b=lZKfrtq4VPhBnTsUSbGIX
        iQy/EXDnhCeyIreOXuLN7PUTXqpqhYuWq69bgVyYEZ1QboneYk1an9JVxTCB89rV
        WoE+jpFOnr7Mw+mHf8w/IMQxdK1zpHfPW9SRwi6yJnlem8O3LeeQZlVV9wOrafOG
        rj96huHOzeyV6v68Hx2p0o=
Received: from localhost.localdomain (unknown [125.82.11.124])
        by smtp13 (Coremail) with SMTP id EcCowACXzbI+uoZevzrGCg--.22384S4;
        Fri, 03 Apr 2020 12:23:28 +0800 (CST)
From:   Hu Haowen <xianfengting221@163.com>
To:     saeedm@mellanox.com, leon@kernel.org, davem@davemloft.net
Cc:     moshe@mellanox.com, lsahlber@redhat.com, kw@linux.com,
        wqu@suse.com, xiubli@redhat.com, xianfengting221@163.com,
        chris@chris-wilson.co.uk, stfrench@microsoft.com,
        airlied@redhat.com, yamada.masahiro@socionext.com, cai@lca.pw,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [v2] net/mlx5: add the missing space character
Date:   Fri,  3 Apr 2020 12:23:12 +0800
Message-Id: <20200403042312.9036-1-xianfengting221@163.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowACXzbI+uoZevzrGCg--.22384S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7GryfGr4fCr1UZrWUWw17ZFb_yoW8Jr45pF
        s8JFZrurs7tw45Xa18ZFW8Z3s5GwsYkay09F4fC393Xrn5tr48Crn3tryYkr10kr13J3sx
        tF9rArW7Awn8W37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jU73kUUUUU=
X-Originating-IP: [125.82.11.124]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/1tbiMgD6AFWBoITXkAAAs-
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 91b56d8462a9 ("net/mlx5: improve some comments") did not add
that missing space character and this commit is used to fix it up.

Fixes: 91b56d8462a9 ("net/mlx5: improve some comments")
Signed-off-by: Hu Haowen <xianfengting221@163.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index c9c9b479bda5..31bddb48e5c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -676,7 +676,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 	block_count = tracer->buff.size / TRACER_BLOCK_SIZE_BYTE;
 	start_offset = tracer->buff.consumer_index * TRACER_BLOCK_SIZE_BYTE;
 
-	/* Copy the block to local buffer to avoid HW override while being processed*/
+	/* Copy the block to local buffer to avoid HW override while being processed */
 	memcpy(tmp_trace_block, tracer->buff.log_buf + start_offset,
 	       TRACER_BLOCK_SIZE_BYTE);
 
-- 
2.20.1


