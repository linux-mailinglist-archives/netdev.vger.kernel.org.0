Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEDD40BD93
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhIOCSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:00 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:53779 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhIOCR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:17:59 -0400
Received: (qmail 33907 invoked by uid 89); 15 Sep 2021 02:16:39 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 15 Sep 2021 02:16:39 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 02/18] ptp: ocp: Parameterize the TOD information display.
Date:   Tue, 14 Sep 2021 19:16:20 -0700
Message-Id: <20210915021636.153754-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only display the TOD information if there is a corresponding
TOD resource.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index d37eac69150a..2a6cc762c60e 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -743,7 +743,8 @@ ptp_ocp_info(struct ptp_ocp *bp)
 		 ptp_ocp_clock_name_from_val(select >> 16),
 		 ptp_clock_index(bp->ptp));
 
-	ptp_ocp_tod_info(bp);
+	if (bp->tod)
+		ptp_ocp_tod_info(bp);
 }
 
 static struct device *
-- 
2.31.1

