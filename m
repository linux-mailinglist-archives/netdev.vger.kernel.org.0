Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0F747BA4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfFQHuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:50:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:40340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727485AbfFQHuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 03:50:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EC3F3AFED;
        Mon, 17 Jun 2019 07:50:14 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 12/16] qlge: Remove useless memset
Date:   Mon, 17 Jun 2019 16:48:54 +0900
Message-Id: <20190617074858.32467-12-bpoirier@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This just repeats what the other memset a few lines above did.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index b1fabe60f589..b6e948caf2aa 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -2814,7 +2814,6 @@ static int qlge_init_bq(struct qlge_bq *bq)
 	buf_ptr = bq->base;
 	bq_desc = &bq->queue[0];
 	for (i = 0; i < QLGE_BQ_LEN; i++, buf_ptr++, bq_desc++) {
-		memset(bq_desc, 0, sizeof(*bq_desc));
 		bq_desc->index = i;
 		bq_desc->buf_ptr = buf_ptr;
 	}
-- 
2.21.0

