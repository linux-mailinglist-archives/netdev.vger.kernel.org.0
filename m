Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC492D15BE
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgLGQNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:13:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40042 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLGQNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:13:16 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kmJ7n-0002cW-Da; Mon, 07 Dec 2020 16:12:31 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sched: fix spelling mistake in Kconfig "trys" -> "tries"
Date:   Mon,  7 Dec 2020 16:12:31 +0000
Message-Id: <20201207161231.173234-1-colin.king@canonical.com>
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
 net/nfc/Kconfig   | 2 +-
 net/sched/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 9b27599870e3..96b91674dd37 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# NFC sybsystem configuration
+# NFC subsystem configuration
 #
 
 menuconfig NFC
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..8a4542387bbd 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -281,7 +281,7 @@ config NET_SCH_CHOKE
 	help
 	  Say Y here if you want to use the CHOKe packet scheduler (CHOose
 	  and Keep for responsive flows, CHOose and Kill for unresponsive
-	  flows). This is a variation of RED which trys to penalize flows
+	  flows). This is a variation of RED which tries to penalize flows
 	  that monopolize the queue.
 
 	  To compile this code as a module, choose M here: the
-- 
2.29.2

