Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00971174DC8
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgCAOpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgCAOph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:37 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC97222C4;
        Sun,  1 Mar 2020 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073937;
        bh=HDDbUQvXN1MCn4DqBIi9Nyeu2TiCTjJBY1Qm/e7ICdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8uNVGWeZv5a/21/erMV7nBGEPNmj1WjFr5o3ktOIx/FXCGmeWceeP1Z7N7RXBNn+
         F+7+T7EmzVHG0YqYUJ/BD6KFEm6JbICaOPQFcHy4ov7uW+w0wOnqn7jju0O6bMWhW+
         83oXCgEZpio37CtqJFJqcjz1X6efxAhy2eBMYj50=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH net-next 12/23] net/cortina: Delete driver version from ethtool output
Date:   Sun,  1 Mar 2020 16:44:45 +0200
Message-Id: <20200301144457.119795-13-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Use default ethtool version instead of static variant.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/cortina/gemini.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index f30fa8e6ef80..dc2a4adab793 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -44,7 +44,6 @@
 #include "gemini.h"
 
 #define DRV_NAME		"gmac-gemini"
-#define DRV_VERSION		"1.0"
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
 static int debug = -1;
@@ -2204,7 +2203,6 @@ static void gmac_get_drvinfo(struct net_device *netdev,
 			     struct ethtool_drvinfo *info)
 {
 	strcpy(info->driver,  DRV_NAME);
-	strcpy(info->version, DRV_VERSION);
 	strcpy(info->bus_info, netdev->dev_id ? "1" : "0");
 }
 
-- 
2.24.1

