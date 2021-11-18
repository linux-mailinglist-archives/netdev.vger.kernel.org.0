Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1FB455DF8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhKROa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:30:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhKROa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:30:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ECA161B95;
        Thu, 18 Nov 2021 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637245648;
        bh=tAYoPgFnNhAvwyavdw0eBZsQCuGuTZJXZCyExNSeQAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDLgbBBx3+5EdO3TSwTs6FUvVBP7zG17fd3XwK3XgB3YKmTmiqfxjNn0Zp3aK8eO2
         YBJ5ITYJSHRg74L9frRov7pW8UO6+jH/zHqhO8UWT56edQyr/+w3bmA1oeVwoy22c6
         tDlt8dXJAkmkNDCKV3bTBfClYGhbw1Hic9qSC9WiYrItJMcCAcuzdArEbveg7P6ZDr
         VdDHjyjODVIOsVdW/PxgBFUs3Migqg+UgNAQT1t6uf9wew3Etq2GJtxMM4A90sPY01
         GQ5oJ8mlREXcSIbguPkEXAoCMBCxDAvvvzHxYA/V4Ts7CE1X0tpCff34q7/isIW4wq
         iT2A6dLvNTvOA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, stas.yakovlev@gmail.com
Subject: [PATCH net-next 4/4] ipw2200: constify address in ipw_send_adapter_address
Date:   Thu, 18 Nov 2021 06:27:20 -0800
Message-Id: <20211118142720.3176980-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118142720.3176980-1-kuba@kernel.org>
References: <20211118142720.3176980-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add const to the address param of ipw_send_adapter_address()
all the functions down the chain have already been changed.

Not sure how I lost this in the rebase.

Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: stas.yakovlev@gmail.com
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 23037bfc9e4c..5727c7c00a28 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -2303,7 +2303,7 @@ static int ipw_send_ssid(struct ipw_priv *priv, u8 * ssid, int len)
 				ssid);
 }
 
-static int ipw_send_adapter_address(struct ipw_priv *priv, u8 * mac)
+static int ipw_send_adapter_address(struct ipw_priv *priv, const u8 * mac)
 {
 	if (!priv || !mac) {
 		IPW_ERROR("Invalid args\n");
-- 
2.31.1

