Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445A616603A
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgBTO7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:57446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBTO7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:32 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B739206F4;
        Thu, 20 Feb 2020 14:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210771;
        bh=wDd04J+iEhOXCJYxcPWpK+K6rE650aIVNXcP80WLgxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzhNFM0x+WjN2zbsjrr8u+Q+L6EwF02K81uPiR0xtX69kiSZEk8zjN+fBGJRrRSjJ
         U/KKO9s7knHsd4V9YNt7klG6r0fK3i2RlEOCnJxg7FYXHDYo2NAv/1AQNi3Qyl1354
         rC7blZI7jGtHkAq3NKuITcUZJ6BC7GmwN1SvdwOk=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 10/16] net/althera: Delete hardcoded driver version
Date:   Thu, 20 Feb 2020 16:58:49 +0200
Message-Id: <20200220145855.255704-11-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Convert to use default version provided by ethtool.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/altera/altera_tse_ethtool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_ethtool.c b/drivers/net/ethernet/altera/altera_tse_ethtool.c
index 23823464f2e7..4299f1301149 100644
--- a/drivers/net/ethernet/altera/altera_tse_ethtool.c
+++ b/drivers/net/ethernet/altera/altera_tse_ethtool.c
@@ -67,7 +67,6 @@ static void tse_get_drvinfo(struct net_device *dev,
 	u32 rev = ioread32(&priv->mac_dev->megacore_revision);

 	strcpy(info->driver, "altera_tse");
-	strcpy(info->version, "v8.0");
 	snprintf(info->fw_version, ETHTOOL_FWVERS_LEN, "v%d.%d",
 		 rev & 0xFFFF, (rev & 0xFFFF0000) >> 16);
 	sprintf(info->bus_info, "platform");
--
2.24.1

