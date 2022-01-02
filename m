Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F16482CE6
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 23:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiABWMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 17:12:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54402 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiABWMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 17:12:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 410E6B80E41
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 22:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992F1C36AE7;
        Sun,  2 Jan 2022 22:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641161527;
        bh=Bbdtuofop6LKMixAFGtpewpnqAz4GAReT0Hm/8dTdqI=;
        h=From:To:Cc:Subject:Date:From;
        b=kw2MrbYSL6CipdJp1E+dJPMAuAWEcnF81e1pTlWA3w+ruaCf5wlotPXyx/+W3ibJ1
         XvXYCqDYm9ho7ZziNnlWMf9jXAwKDaXF9wK575MFsnM6fj2pftPcZJqNCJOj13lEyh
         dqu3SWQ/c2QRIzLXx+XH38ey0p835KBaSk/R26wXtl6oKMuPUhfUCtegA6T1J1sjRb
         R/pgInVw7CBvksiBE0kz3yeYhnvTqgfwOs72v8cYrmfVjZAMa8cB0QDW1AD52aAU06
         vkqo6ho0kSkO8yuVxHDeOsy17vSdUjFvyLpmFNGQpD/9P+QeeyFjNkZigaAFhZxvmP
         GrBTFRpS6pVXw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH net-next] net: vertexcom: default to disabled on kbuild
Date:   Sun,  2 Jan 2022 14:11:26 -0800
Message-Id: <20220102221126.354332-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Sorry for being rude but new vendors/drivers are supposed to be disabled
by default, otherwise we will have to manually keep track of all vendors
we are not interested in building.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
CC: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/vertexcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/vertexcom/Kconfig b/drivers/net/ethernet/vertexcom/Kconfig
index 4184a635fe01..6e2cf062ddba 100644
--- a/drivers/net/ethernet/vertexcom/Kconfig
+++ b/drivers/net/ethernet/vertexcom/Kconfig
@@ -5,7 +5,7 @@
 
 config NET_VENDOR_VERTEXCOM
 	bool "Vertexcom devices"
-	default y
+	default n
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
-- 
2.33.1

