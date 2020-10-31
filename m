Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DB22A123F
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgJaA6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:58:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgJaA6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:58:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYfEF-004Rqk-02; Sat, 31 Oct 2020 01:58:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/2] drivers: net: davicom Add COMPILE_TEST support
Date:   Sat, 31 Oct 2020 01:58:33 +0100
Message-Id: <20201031005833.1060316-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031005833.1060316-1-andrew@lunn.ch>
References: <20201031005833.1060316-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the build testing of this davicom driver by enabling it when
COMPILE_TEST is selected.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/davicom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/Kconfig b/drivers/net/ethernet/davicom/Kconfig
index 76247103e566..7af86b6d4150 100644
--- a/drivers/net/ethernet/davicom/Kconfig
+++ b/drivers/net/ethernet/davicom/Kconfig
@@ -5,7 +5,7 @@
 
 config DM9000
 	tristate "DM9000 support"
-	depends on ARM || MIPS || COLDFIRE || NIOS2
+	depends on ARM || MIPS || COLDFIRE || NIOS2 || COMPILE_TEST
 	select CRC32
 	select MII
 	help
-- 
2.28.0

