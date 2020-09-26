Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCCA27963F
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 04:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgIZCi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 22:38:29 -0400
Received: from m17618.mail.qiye.163.com ([59.111.176.18]:1671 "EHLO
        m17618.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgIZCi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 22:38:29 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id 373614E0007;
        Sat, 26 Sep 2020 10:38:26 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wang Qing <wangqing@vivo.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: ti: fix a typo in comments
Date:   Sat, 26 Sep 2020 10:37:18 +0800
Message-Id: <1601087891-11281-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZH0lOGRpNT04ZGENDVkpNS0pLQ0xCS01OTUpVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N006Tyo*ST8fNAE1PgFRMkwj
        PVZPFDpVSlVKTUtKS0NMQktMS0lLVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFJSElMNwY+
X-HM-Tid: 0a74c846a29c9376kuws373614e0007
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the comment typo: "compliment" -> "complement".

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/wireless/ti/wl1251/reg.h | 2 +-
 drivers/net/wireless/ti/wl12xx/reg.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/reg.h b/drivers/net/wireless/ti/wl1251/reg.h
index e03f832..890176c
--- a/drivers/net/wireless/ti/wl1251/reg.h
+++ b/drivers/net/wireless/ti/wl1251/reg.h
@@ -217,7 +217,7 @@ enum wl12xx_acx_int_reg {
  Halt eCPU   - 32bit RW
  ------------------------------------------
  0 HALT_ECPU Halt Embedded CPU - This bit is the
- compliment of bit 1 (MDATA2) in the SOR_CFG register.
+ complement of bit 1 (MDATA2) in the SOR_CFG register.
  During a hardware reset, this bit holds
  the inverse of MDATA2.
  When downloading firmware from the host,
diff --git a/drivers/net/wireless/ti/wl12xx/reg.h b/drivers/net/wireless/ti/wl12xx/reg.h
index 247f558..8ff0188
--- a/drivers/net/wireless/ti/wl12xx/reg.h
+++ b/drivers/net/wireless/ti/wl12xx/reg.h
@@ -139,7 +139,7 @@
  Halt eCPU   - 32bit RW
  ------------------------------------------
  0 HALT_ECPU Halt Embedded CPU - This bit is the
- compliment of bit 1 (MDATA2) in the SOR_CFG register.
+ complement of bit 1 (MDATA2) in the SOR_CFG register.
  During a hardware reset, this bit holds
  the inverse of MDATA2.
  When downloading firmware from the host,
-- 
2.7.4

