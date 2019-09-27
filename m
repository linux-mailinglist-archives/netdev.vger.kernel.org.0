Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F50C0334
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfI0KPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:57586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727581AbfI0KPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 83A38AF92;
        Fri, 27 Sep 2019 10:15:31 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/17] staging: qlge: Remove useless memset
Date:   Fri, 27 Sep 2019 19:12:07 +0900
Message-Id: <20190927101210.23856-14-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This just repeats what the other memset a few lines above did.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/staging/qlge/qlge_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index ef33db118aa1..8da596922582 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2812,7 +2812,6 @@ static int qlge_init_bq(struct qlge_bq *bq)
 	buf_ptr = bq->base;
 	bq_desc = &bq->queue[0];
 	for (i = 0; i < QLGE_BQ_LEN; i++, buf_ptr++, bq_desc++) {
-		memset(bq_desc, 0, sizeof(*bq_desc));
 		bq_desc->index = i;
 		bq_desc->buf_ptr = buf_ptr;
 	}
-- 
2.23.0

