Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4F97D3B6
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfHADdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:33:49 -0400
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:12582 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfHADdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:33:49 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2019 23:33:49 EDT
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id x713Tdhi022265
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 1 Aug 2019 11:29:39 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id x713TcKi022264;
        Thu, 1 Aug 2019 11:29:38 +0800 (CST)
        (envelope-from kevlo)
Date:   Thu, 1 Aug 2019 11:29:38 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] r8152: fix typo in register name
Message-ID: <20190801032938.GA22256@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is likely that PAL_BDC_CR should be PLA_BDC_CR.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 39e0768d734d..0cc03a9ff545 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -50,7 +50,7 @@
 #define PLA_TEREDO_WAKE_BASE	0xc0c4
 #define PLA_MAR			0xcd00
 #define PLA_BACKUP		0xd000
-#define PAL_BDC_CR		0xd1a0
+#define PLA_BDC_CR		0xd1a0
 #define PLA_TEREDO_TIMER	0xd2cc
 #define PLA_REALWOW_TIMER	0xd2e8
 #define PLA_SUSPEND_FLAG	0xd38a
@@ -274,7 +274,7 @@
 #define TEREDO_RS_EVENT_MASK	0x00fe
 #define OOB_TEREDO_EN		0x0001
 
-/* PAL_BDC_CR */
+/* PLA_BDC_CR */
 #define ALDPS_PROXY_MODE	0x0001
 
 /* PLA_EFUSE_CMD */
@@ -3191,9 +3191,9 @@ static void r8152b_enter_oob(struct r8152 *tp)
 
 	rtl_rx_vlan_en(tp, true);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PAL_BDC_CR);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BDC_CR);
 	ocp_data |= ALDPS_PROXY_MODE;
-	ocp_write_word(tp, MCU_TYPE_PLA, PAL_BDC_CR, ocp_data);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BDC_CR, ocp_data);
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
@@ -3577,9 +3577,9 @@ static void r8153_enter_oob(struct r8152 *tp)
 
 	rtl_rx_vlan_en(tp, true);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PAL_BDC_CR);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BDC_CR);
 	ocp_data |= ALDPS_PROXY_MODE;
-	ocp_write_word(tp, MCU_TYPE_PLA, PAL_BDC_CR, ocp_data);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BDC_CR, ocp_data);
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
