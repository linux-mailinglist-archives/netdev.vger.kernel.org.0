Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A795148A124
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 21:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241718AbiAJUw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 15:52:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45728 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241028AbiAJUw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 15:52:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4174BB8107D
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 20:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84FCC36AE3;
        Mon, 10 Jan 2022 20:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641847974;
        bh=AP0oW9vYPEKlqZenYw6yVAfiAf/4xewHva0zxrHrFWo=;
        h=From:To:Cc:Subject:Date:From;
        b=TJ0TYnqI+WbrkoPqqNq+uPbyndkAhOtcgzz1RTV59UjiYsKbzfMByo7HpFDTypMK4
         WJj0KqcVsQGISF29QpZam3IN0cte3soBm+4NeV9O8yZqxHMHL7shzEH4PZ2jeR1QwN
         3mTorYnr0c2ZQvA1Jyk6Ot961GZv4gQJT95FWjbhuRq90nGbZShHEuVmflmlMJJbTJ
         MWtfper7vi0Q7pHeGBN+ijB+VWvrseb3fXhJsG7lxuXTKUK0mYaNqk5cUBaiVlAzjS
         fuxvnlkRBxyYMGMXUod1au+rxEAfLzgcJppMDFFzhx2Vqez1t01ZpiK97HR7bwwcNg
         +FARzPVE+7c+Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next] Revert "net: vertexcom: default to disabled on kbuild"
Date:   Mon, 10 Jan 2022 12:52:46 -0800
Message-Id: <20220110205246.66298-1-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This reverts commit 6bf950a8ff72920340dfdec93c18bd3f5f35de6a.

To align with other vendors, NET_VENDOR configs are supposed to be ON by
default, while their drivers should default to OFF.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/vertexcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/vertexcom/Kconfig b/drivers/net/ethernet/vertexcom/Kconfig
index 6e2cf062ddba..4184a635fe01 100644
--- a/drivers/net/ethernet/vertexcom/Kconfig
+++ b/drivers/net/ethernet/vertexcom/Kconfig
@@ -5,7 +5,7 @@
 
 config NET_VENDOR_VERTEXCOM
 	bool "Vertexcom devices"
-	default n
+	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
-- 
2.34.1

