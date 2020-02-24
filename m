Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C345F16AD9F
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgBXRf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:35:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57537 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgBXRf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:35:57 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1j6He5-0004zd-GE; Mon, 24 Feb 2020 17:35:53 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: qrtr: fix spelling mistake "serivce" -> "service"
Date:   Mon, 24 Feb 2020 17:35:53 +0000
Message-Id: <20200224173553.386446-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pr_err message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/qrtr/ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 67a4e59cdf4d..7bfde01f4e8a 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -150,7 +150,7 @@ static int service_announce_del(struct sockaddr_qrtr *dest,
 
 	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 	if (ret < 0)
-		pr_err("failed to announce del serivce\n");
+		pr_err("failed to announce del service\n");
 
 	return ret;
 }
-- 
2.25.0

