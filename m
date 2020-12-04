Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5542CF4FF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgLDTqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:46:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49070 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgLDTqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 14:46:33 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1klH1Z-0007wE-Al; Fri, 04 Dec 2020 19:45:49 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: fix spelling mistake "wil" -> "will" in Kconfig
Date:   Fri,  4 Dec 2020 19:45:49 +0000
Message-Id: <20201204194549.1153063-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in the Kconfig help text. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4ee41924cdf1..260f9f46668b 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -287,7 +287,7 @@ config GTP
 	  3GPP TS 29.060 standards.
 
 	  To compile this drivers as a module, choose M here: the module
-	  wil be called gtp.
+	  will be called gtp.
 
 config MACSEC
 	tristate "IEEE 802.1AE MAC-level encryption (MACsec)"
-- 
2.29.2

