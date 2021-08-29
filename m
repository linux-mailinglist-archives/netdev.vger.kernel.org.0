Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3ED3FAD41
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbhH2Qwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 12:52:44 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:51518
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhH2Qwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 12:52:43 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id A40EF3F232;
        Sun, 29 Aug 2021 16:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630255910;
        bh=grqiVd1tHlP+USP8A2T1/Sgex7wgmkoi/169ON1QGFo=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=DFIObwuVGBDJaynj2jjtTKqsbRui4u0iozrVIURyd/OrrdaYujBj3D5zD/fOUHEaH
         GGlBe1MqHriShWafIgsno4tkZf4YXoZFLWi4KlIM45KxvYa5OQuGWJJU/PINIFg1ND
         9RcVn0LW/SHrP4hfbwFy43XC563Rg7dbNp73qzmQGV0z1ugzMvmDob9MO6Bc5oOvQI
         kSpECAP+LvKWuwnJtIFubVvFdDATJM3v3+H+F3WQCQTV9+66LZfRKIUYSljlG7qDNJ
         3Bazue+b3XSOAdeppp0eEARe0mo2+o6FtwRWX7Ko9frHv4GT1O8ElVJ9VXI/9RcvHT
         XYz0MhKjnJWzw==
From:   Colin King <colin.king@canonical.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] igc: remove redundant continue statement
Date:   Sun, 29 Aug 2021 17:51:50 +0100
Message-Id: <20210829165150.531678-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The continue statement at the end of a for-loop has no effect,
remove it.

Addresses-Coverity: ("Continue has no effect")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 0f021909b430..b615a980f563 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -860,7 +860,6 @@ static int igc_phc_get_syncdevicetime(ktime_t *device,
 			 * so write the previous error status to clear it.
 			 */
 			wr32(IGC_PTM_STAT, stat);
-			continue;
 		}
 	} while (--count);
 
-- 
2.32.0

