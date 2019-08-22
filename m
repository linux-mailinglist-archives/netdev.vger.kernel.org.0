Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7A99246
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 13:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbfHVLhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 07:37:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32779 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbfHVLhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 07:37:36 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i0lPF-0002y3-3i; Thu, 22 Aug 2019 11:37:29 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtw88: remove redundant assignment to pointer debugfs_topdir
Date:   Thu, 22 Aug 2019 12:37:28 +0100
Message-Id: <20190822113728.25494-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer debugfs_topdir is initialized to a value that is never read
and it is re-assigned later. The initialization is redundant and can
be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 383b04c16703..5d235968d475 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -672,7 +672,7 @@ static struct rtw_debugfs_priv rtw_debug_priv_rsvd_page = {
 
 void rtw_debugfs_init(struct rtw_dev *rtwdev)
 {
-	struct dentry *debugfs_topdir = rtwdev->debugfs;
+	struct dentry *debugfs_topdir;
 
 	debugfs_topdir = debugfs_create_dir("rtw88",
 					    rtwdev->hw->wiphy->debugfsdir);
-- 
2.20.1

