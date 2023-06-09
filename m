Return-Path: <netdev+bounces-9424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C91BE728E31
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E680C1C20A6E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D8215B8;
	Fri,  9 Jun 2023 02:55:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD8BEA6
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:55:15 +0000 (UTC)
Received: from mail-177132.yeah.net (mail-177132.yeah.net [123.58.177.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CF6D30E6;
	Thu,  8 Jun 2023 19:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Date:From:Subject:Message-ID:MIME-Version:
	Content-Type; bh=sMCFcoMSm3KIUqoY/BwUkMWGJLEkhAztPDeMF/Kppj8=;
	b=U5zl5YDsa3EGNJuAm00B/L+4kq87sb9rbx7PZvzMiUCSM8mQXlq7mQN22UcC3L
	Bf06bWGPY7Z4JhfxB7QBQTardzpBi7p2i/JnfitaPT6qhFWdgir4I8o0sUqtzP7j
	VRMv82xxAp5j5ZCncPJptwbZZhBp95BuhSauPWciouSYQ=
Received: from john-VirtualBox (unknown [111.19.92.254])
	by smtp2 (Coremail) with SMTP id C1UQrADHz19tlIJkewakDQ--.14997S2;
	Fri, 09 Jun 2023 10:54:38 +0800 (CST)
Date: Fri, 9 Jun 2023 10:54:37 +0800
From: Baozhu Ni <nibaozhu@yeah.net>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Outreachy <outreachy@lists.linux.dev>
Subject: [PATCH] e1000e: Remove not useful `else' after a break or return
Message-ID: <20230609025437.GA5307@john-VirtualBox>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-CM-TRANSID:C1UQrADHz19tlIJkewakDQ--.14997S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxury3WFW7ur1xXry5KF1xXwb_yoWrAr1fpF
	Wjvas8ur1fJr47W3ZrJw4xZan8Zws7A345Gr4fu39Yva45Jr95CF13KrZ3Wry0vrZrXry3
	KF15ZrnxCF4qg3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jSUDJUUUUU=
X-Originating-IP: [111.19.92.254]
X-CM-SenderInfo: 5qlet0x2kxq5hhdkh0dhw/1tbiDw+JelnxboRyfwAAs8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

`else' is not generally useful after a break or return

Signed-off-by: Baozhu Ni <nibaozhu@yeah.net>
---
 .../net/ethernet/intel/e1000e/80003es2lan.c   |  5 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c   | 59 +++++++++----------
 2 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/80003es2lan.c b/drivers/net/ethernet/intel/e1000e/80003es2lan.c
index be9c695dde12..f063e2bd48fa 100644
--- a/drivers/net/ethernet/intel/e1000e/80003es2lan.c
+++ b/drivers/net/ethernet/intel/e1000e/80003es2lan.c
@@ -43,11 +43,10 @@ static s32 e1000_init_phy_params_80003es2lan(struct e1000_hw *hw)
 	if (hw->phy.media_type != e1000_media_type_copper) {
 		phy->type = e1000_phy_none;
 		return 0;
-	} else {
-		phy->ops.power_up = e1000_power_up_phy_copper;
-		phy->ops.power_down = e1000_power_down_phy_copper_80003es2lan;
 	}
 
+	phy->ops.power_up = e1000_power_up_phy_copper;
+	phy->ops.power_down = e1000_power_down_phy_copper_80003es2lan;
 	phy->addr = 1;
 	phy->autoneg_mask = AUTONEG_ADVERTISE_SPEED_DEFAULT;
 	phy->reset_delay_us = 100;
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 0c7fd10312c8..8ab4e45de5f2 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -3592,9 +3592,8 @@ static s32 e1000_read_flash_byte_ich8lan(struct e1000_hw *hw, u32 offset,
 	 */
 	if (hw->mac.type >= e1000_pch_spt)
 		return -E1000_ERR_NVM;
-	else
-		ret_val = e1000_read_flash_data_ich8lan(hw, offset, 1, &word);
 
+	ret_val = e1000_read_flash_data_ich8lan(hw, offset, 1, &word);
 	if (ret_val)
 		return ret_val;
 
@@ -3659,20 +3658,20 @@ static s32 e1000_read_flash_data_ich8lan(struct e1000_hw *hw, u32 offset,
 			else if (size == 2)
 				*data = (u16)(flash_data & 0x0000FFFF);
 			break;
-		} else {
-			/* If we've gotten here, then things are probably
-			 * completely hosed, but if the error condition is
-			 * detected, it won't hurt to give it another try...
-			 * ICH_FLASH_CYCLE_REPEAT_COUNT times.
-			 */
-			hsfsts.regval = er16flash(ICH_FLASH_HSFSTS);
-			if (hsfsts.hsf_status.flcerr) {
-				/* Repeat for some time before giving up. */
-				continue;
-			} else if (!hsfsts.hsf_status.flcdone) {
-				e_dbg("Timeout error - flash cycle did not complete.\n");
-				break;
-			}
+		}
+
+		/* If we've gotten here, then things are probably
+		 * completely hosed, but if the error condition is
+		 * detected, it won't hurt to give it another try...
+		 * ICH_FLASH_CYCLE_REPEAT_COUNT times.
+		 */
+		hsfsts.regval = er16flash(ICH_FLASH_HSFSTS);
+		if (hsfsts.hsf_status.flcerr) {
+			/* Repeat for some time before giving up. */
+			continue;
+		} else if (!hsfsts.hsf_status.flcdone) {
+			e_dbg("Timeout error - flash cycle did not complete.\n");
+			break;
 		}
 	} while (count++ < ICH_FLASH_CYCLE_REPEAT_COUNT);
 
@@ -3734,20 +3733,20 @@ static s32 e1000_read_flash_data32_ich8lan(struct e1000_hw *hw, u32 offset,
 		if (!ret_val) {
 			*data = er32flash(ICH_FLASH_FDATA0);
 			break;
-		} else {
-			/* If we've gotten here, then things are probably
-			 * completely hosed, but if the error condition is
-			 * detected, it won't hurt to give it another try...
-			 * ICH_FLASH_CYCLE_REPEAT_COUNT times.
-			 */
-			hsfsts.regval = er16flash(ICH_FLASH_HSFSTS);
-			if (hsfsts.hsf_status.flcerr) {
-				/* Repeat for some time before giving up. */
-				continue;
-			} else if (!hsfsts.hsf_status.flcdone) {
-				e_dbg("Timeout error - flash cycle did not complete.\n");
-				break;
-			}
+		}
+
+		/* If we've gotten here, then things are probably
+		 * completely hosed, but if the error condition is
+		 * detected, it won't hurt to give it another try...
+		 * ICH_FLASH_CYCLE_REPEAT_COUNT times.
+		 */
+		hsfsts.regval = er16flash(ICH_FLASH_HSFSTS);
+		if (hsfsts.hsf_status.flcerr) {
+			/* Repeat for some time before giving up. */
+			continue;
+		} else if (!hsfsts.hsf_status.flcdone) {
+			e_dbg("Timeout error - flash cycle did not complete.\n");
+			break;
 		}
 	} while (count++ < ICH_FLASH_CYCLE_REPEAT_COUNT);
 
-- 
2.25.1


