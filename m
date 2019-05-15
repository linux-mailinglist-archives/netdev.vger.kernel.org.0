Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36CE1F6D0
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 16:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfEOOql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 10:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbfEOOqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 10:46:40 -0400
Received: from localhost.localdomain (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BADFE20843;
        Wed, 15 May 2019 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557931600;
        bh=HQ3Mr0N/1o93gqrPRYtpkTpDg/FALryqw8+Ww5M7/0Y=;
        h=From:To:Cc:Subject:Date:From;
        b=ZbybCEV/HTGmf0TdfaqJqol3sY5M2u9RBLUpdaqtJ5rIPB17lixA73BlUPDjXNQAv
         CBpwOjWizcAriNmPp+KTEO60MJaD3U0m5KnQsp2vvIyd//tkCH5dR8eTB/1cOPyXwk
         TaNylCwUkPCIL+xB3xgTfS9Iv9zdhJVL4fMeyZe4=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     netdev@vger.kernel.org
Cc:     dinguyen@kernel.org, davem@davemloft.net, joabreu@synopsys.com,
        Wei Liang Lim <wei.liang.lim@intel.com>
Subject: [PATCH net-next] net: stmmac: socfpga: add RMII phy mode
Date:   Wed, 15 May 2019 09:46:31 -0500
Message-Id: <20190515144631.5490-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add option for enabling RMII phy mode.

Signed-off-by: Wei Liang Lim <wei.liang.lim@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index d466e33635b0..75a6471db76c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -251,6 +251,9 @@ static int socfpga_dwmac_set_phy_mode(struct socfpga_dwmac *dwmac)
 	case PHY_INTERFACE_MODE_SGMII:
 		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII;
 		break;
+	case PHY_INTERFACE_MODE_RMII:
+		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII;
+		break;
 	default:
 		dev_err(dwmac->dev, "bad phy mode %d\n", phymode);
 		return -EINVAL;
-- 
2.20.0

