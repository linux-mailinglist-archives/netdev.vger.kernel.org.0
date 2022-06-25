Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1489655A772
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiFYGPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 02:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiFYGPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 02:15:16 -0400
Received: from smtpbg.qq.com (smtpbg136.qq.com [106.55.201.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CD223BDE;
        Fri, 24 Jun 2022 23:15:08 -0700 (PDT)
X-QQ-mid: bizesmtp67t1656137557ta5j49cz
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 25 Jun 2022 14:12:33 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: 5YkfsBQ8D0+vbSD9zBIbuoYWBuaBF83kmkiAHr32HjlVrGdqFT46BmopDE9ua
        uLjJj+B6jDDcQkxHW7bgV1WXSW2mWKBVoWbtfmzLUEHF+oTnr1hSib1J0xC1jLEhB1nOuYX
        Va7y154Y5pbwxF0sY8iG7apOz4Ohms4htUKLH41WkCvoHJBYbkWvGwVsHtzC1693dAhkFiW
        OOFaActADNPmw7OlySmTSB3sDl42LPbyY80F5YVOJuUGvHpccs6iE5gd4pl0gdubmYf0vZi
        kwY47Ed9vGpzdIn/DcvCsdlkKnDcdShG5mWoY5OOJBlanRyktjlfC38OE=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] sfc: fix repeated words in comments
Date:   Sat, 25 Jun 2022 14:12:23 +0800
Message-Id: <20220625061223.50510-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'set'.
Delete the redundant word 'a'.
Delete the redundant word 'in'.
Found the same error as before.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/sfc/mcdi_pcol.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_pcol.h b/drivers/net/ethernet/sfc/mcdi_pcol.h
index ff617b1b38d3..7984f6f84a3c 100644
--- a/drivers/net/ethernet/sfc/mcdi_pcol.h
+++ b/drivers/net/ethernet/sfc/mcdi_pcol.h
@@ -274,7 +274,7 @@
  * MC_CMD_WORKAROUND_BUG26807.
  * May also returned for other operations such as sub-variant switching. */
 #define MC_CMD_ERR_FILTERS_PRESENT 0x1014
-/* The clock whose frequency you've attempted to set set
+/* The clock whose frequency you've attempted to set
  * doesn't exist on this NIC */
 #define MC_CMD_ERR_NO_CLOCK 0x1015
 /* Returned by MC_CMD_TESTASSERT if the action that should
@@ -7782,7 +7782,7 @@
  * large number (253) it is not anticipated that this will be needed in the
  * near future, so can currently be ignored.
  *
- * On Riverhead this command is implemented as a a wrapper for `list` in the
+ * On Riverhead this command is implemented as a wrapper for `list` in the
  * sensor_query SPHINX service.
  */
 #define MC_CMD_DYNAMIC_SENSORS_LIST 0x66
@@ -7827,7 +7827,7 @@
  * update is in progress, and effectively means the set of usable sensors is
  * the intersection between the sets of sensors known to the driver and the MC.
  *
- * On Riverhead this command is implemented as a a wrapper for
+ * On Riverhead this command is implemented as a wrapper for
  * `get_descriptions` in the sensor_query SPHINX service.
  */
 #define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS 0x67
@@ -7876,7 +7876,7 @@
  * update is in progress, and effectively means the set of usable sensors is
  * the intersection between the sets of sensors known to the driver and the MC.
  *
- * On Riverhead this command is implemented as a a wrapper for `get_readings`
+ * On Riverhead this command is implemented as a wrapper for `get_readings`
  * in the sensor_query SPHINX service.
  */
 #define MC_CMD_DYNAMIC_SENSORS_GET_READINGS 0x68
@@ -19322,7 +19322,7 @@
  * TLV_PORT_MODE_*). A superset of MC_CMD_GET_PORT_MODES_OUT/MODES that
  * contains all modes implemented in firmware for a particular board. Modes
  * listed in MODES are considered production modes and should be exposed in
- * userland tools. Modes listed in in ENGINEERING_MODES, but not in MODES
+ * userland tools. Modes listed in ENGINEERING_MODES, but not in MODES
  * should be considered hidden (not to be exposed in userland tools) and for
  * engineering use only. There are no other semantic differences and any mode
  * listed in either MODES or ENGINEERING_MODES can be set on the board.
-- 
2.36.1

