Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED6843021A
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 12:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244210AbhJPKj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 06:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244193AbhJPKjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 06:39:25 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC9FC061570;
        Sat, 16 Oct 2021 03:37:18 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HWfhr3gJFzQjVN;
        Sat, 16 Oct 2021 12:37:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH v2 3/5] mwifiex: Fix an incorrect comment
Date:   Sat, 16 Oct 2021 12:36:54 +0200
Message-Id: <20211016103656.16791-4-verdre@v0yd.nl>
In-Reply-To: <20211016103656.16791-1-verdre@v0yd.nl>
References: <20211016103656.16791-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98D7C26B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're sending DELBA requests here, not ADDBA requests.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index 6696bce56178..b0695432b26a 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -125,7 +125,7 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 					   tx_ba_tbl->ra);
 	} else { /*
 		  * In case of failure, recreate the deleted stream in case
-		  * we initiated the ADDBA
+		  * we initiated the DELBA
 		  */
 		if (!INITIATOR_BIT(del_ba_param_set))
 			return 0;
-- 
2.31.1

