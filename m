Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46AA0166036
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgBTO7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBTO7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:18 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3865A206F4;
        Thu, 20 Feb 2020 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210757;
        bh=PqykvPQQ/udBG704OUeCLp9f/aB1NAyE9uTf+TCbpz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knS+/c7KtbIAQIWu4n1FFXj3eFssOOd8H1HTksKg7rNZ1jW7AkD1D0+uyKZgBNYgG
         uGHaAzyADtTCCpE7DqeKyG3heAqw0lcL5ga+tjeunFbROVnDIm8FGG6woZ4jBOvWYz
         SLsA4g5bMJAYfQc8j3HOe4TiwwvYVO+Gy0Uce9O8=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 06/16] net/agere: Delete unneeded driver version
Date:   Thu, 20 Feb 2020 16:58:45 +0200
Message-Id: <20200220145855.255704-7-leon@kernel.org>
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

There is no need in driver version for in-tree kernel code.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/agere/et131x.c | 1 -
 drivers/net/ethernet/agere/et131x.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index cb6a761d5c11..1b19385ad8a9 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2958,7 +2958,6 @@ static void et131x_get_drvinfo(struct net_device *netdev,
 	struct et131x_adapter *adapter = netdev_priv(netdev);

 	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(adapter->pdev),
 		sizeof(info->bus_info));
 }
diff --git a/drivers/net/ethernet/agere/et131x.h b/drivers/net/ethernet/agere/et131x.h
index be9a11c02526..d0e922584d8a 100644
--- a/drivers/net/ethernet/agere/et131x.h
+++ b/drivers/net/ethernet/agere/et131x.h
@@ -46,7 +46,6 @@
  */

 #define DRIVER_NAME "et131x"
-#define DRIVER_VERSION "v2.0"

 /* EEPROM registers */

--
2.24.1

