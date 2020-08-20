Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3B124AF6B
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgHTGsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:48:19 -0400
Received: from mail.loongson.cn ([114.242.206.163]:40570 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbgHTGsS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 02:48:18 -0400
Received: from bogon.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxOMSbHD5fEWoLAA--.36S2;
        Thu, 20 Aug 2020 14:47:55 +0800 (CST)
From:   Kaige Li <likaige@loongson.cn>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: mscc: Fix a couple of spelling mistakes "spcified" -> "specified"
Date:   Thu, 20 Aug 2020 14:47:55 +0800
Message-Id: <1597906075-12787-1-git-send-email-likaige@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9DxOMSbHD5fEWoLAA--.36S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKw47uF18ur13tr4rtF17Awb_yoWDAwb_K3
        93Ar47W3WDKrs2yFnrJw45ZryrKa1qqFn2gFnrt3s8t3y3t3yfCFySvFn8J34Uuw4UuFZY
        q3ZrZr1SyasFvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2xYjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_GF1l42xK
        82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUy9XoDUUUU
X-CM-SenderInfo: 5olntxtjh6z05rqj20fqof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a couple of spelling mistakes in comment text. Fix these.

Signed-off-by: Kaige Li <likaige@loongson.cn>
---
 drivers/net/phy/mscc/mscc_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index a4fbf3a..6bc7406 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1738,13 +1738,13 @@ static int __phy_write_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb,
 	return 0;
 }
 
-/* Trigger a read to the spcified MCB */
+/* Trigger a read to the specified MCB */
 static int phy_update_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb)
 {
 	return __phy_write_mcb_s6g(phydev, reg, mcb, PHY_MCB_S6G_READ);
 }
 
-/* Trigger a write to the spcified MCB */
+/* Trigger a write to the specified MCB */
 static int phy_commit_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb)
 {
 	return __phy_write_mcb_s6g(phydev, reg, mcb, PHY_MCB_S6G_WRITE);
-- 
2.1.0

