Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21EFF3328C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfFCOod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729141AbfFCOob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:44:31 -0400
Received: from localhost.localdomain (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E26E27B2C;
        Mon,  3 Jun 2019 14:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559573070;
        bh=/S220ijI8iqwA0sn9FCSF8aBRd+Bbs9nAhd8qyPwoBo=;
        h=From:To:Cc:Subject:Date:From;
        b=McOp3c6IwBhGbP+ngSF2wlq9ne+d4yLR4G4vSYdHpAPkZaNMdyz0WM177tB0pwZn0
         EHdQzZMuHyqDkxboFrKTSmYd6q31jyPf/J00CTSQy6a+mPZs2AVxH/J5AMkEw1xr94
         NV0XEpeKiuyV89ArcC7IlCdfzaSU8XeQUqD37xmw=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     netdev@vger.kernel.org
Cc:     dinguyen@kernel.org, davem@davemloft.net,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wei Liang Lim <wei.liang.lim@intel.com>
Subject: [PATCH RESEND net-next] net: stmmac: socfpga: add RMII phy mode
Date:   Mon,  3 Jun 2019 09:44:18 -0500
Message-Id: <20190603144418.3297-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add option for enabling RMII phy mode.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

