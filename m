Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38A63017A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfE3SHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:07:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42252 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfE3SGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4dndL24LWcAh0B46AvE4n/1VGXV5h2xmIR/lcaAAIgM=; b=Vf8+2qms3ig2Dqe+ZC2/VLo6Df
        WDbIzSH2JQDtbMl9ZLgJqaYzRdKs4cKkdSmPa0P9DbXak1v08U3IINmAxVDR8SHRShdKapO+MtHop
        rLSV620b07AKLM4i1QC2HQIUsmGkvtEEKycYZUEzrJ9kF44PkURAfAyuFJclwuKGaBTI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWPRX-0000Ol-Is; Thu, 30 May 2019 20:06:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     linville@redhat.com
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 1/2] ethtool: sync ethtool-copy.h with linux-next from 30/05/2019
Date:   Thu, 30 May 2019 20:06:15 +0200
Message-Id: <20190530180616.1418-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530180616.1418-1-andrew@lunn.ch>
References: <20190530180616.1418-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync ethtool-copy.h with linux-next from 22/05/2019. This provides
access to the new link modes for 100BaseT1 and 1000BaseT1.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 ethtool-copy.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/ethtool-copy.h b/ethtool-copy.h
index 92ab10d65fc9..ad16e8f9c290 100644
--- a/ethtool-copy.h
+++ b/ethtool-copy.h
@@ -1481,6 +1481,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT = 64,
 	ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT	 = 65,
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
+	ETHTOOL_LINK_MODE_100baseT1_Full_BIT             = 67,
+	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT            = 68,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
@@ -1597,7 +1599,7 @@ enum ethtool_link_mode_bit_indices {
 
 static __inline__ int ethtool_validate_speed(__u32 speed)
 {
-	return speed <= INT_MAX || speed == SPEED_UNKNOWN;
+	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
 }
 
 /* Duplex, half or full. */
@@ -1710,6 +1712,9 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
 #define ETH_MODULE_SFF_8436		0x4
 #define ETH_MODULE_SFF_8436_LEN		256
 
+#define ETH_MODULE_SFF_8636_MAX_LEN	640
+#define ETH_MODULE_SFF_8436_MAX_LEN	640
+
 /* Reset flags */
 /* The reset() operation must clear the flags for the components which
  * were actually reset.  On successful return, the flags indicate the
-- 
2.20.1

