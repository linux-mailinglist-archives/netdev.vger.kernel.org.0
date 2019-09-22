Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF771BA20F
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 13:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfIVLmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 07:42:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39164 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbfIVLmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 07:42:19 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iC0Fs-0006Bg-Gj; Sun, 22 Sep 2019 11:42:16 +0000
From:   Colin King <colin.king@canonical.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] atm: he: clean up an indentation issue
Date:   Sun, 22 Sep 2019 13:42:16 +0200
Message-Id: <20190922114216.10158-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a statement that is indented one level too many, remove
the extraneous tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/atm/he.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 70b00ae4ec38..8af793f5e811 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1690,7 +1690,7 @@ he_service_rbrq(struct he_dev *he_dev, int group)
 
 		if (RBRQ_HBUF_ERR(he_dev->rbrq_head)) {
 			hprintk("HBUF_ERR!  (cid 0x%x)\n", cid);
-				atomic_inc(&vcc->stats->rx_drop);
+			atomic_inc(&vcc->stats->rx_drop);
 			goto return_host_buffers;
 		}
 
-- 
2.20.1

