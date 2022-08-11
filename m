Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB38958FBAE
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbiHKLzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiHKLzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:55:17 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8301C25EB0;
        Thu, 11 Aug 2022 04:55:15 -0700 (PDT)
X-QQ-mid: bizesmtp86t1660218899tmr6761p
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 19:54:57 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000020
X-QQ-FEAT: zT6n3Y95oi1oJXzBywfqcWcYSgxJH1UxfzTdQWO0XH7ftAAMCGYnUyYsF8N0C
        S0dU1+TpmNK/l/TdWrBXfeUfW9ln6mbtJ4bEjKoecc4Tu50d/7KawQAodi0dg0/vGjTog3u
        OHT4NJn5/6beVgxACAzfBR6/BXZUe4m9fqwgR+Q8epzl+j2xL1AkIWfX4XbLp2+f11tpiDL
        4BQheEU1AJ/f+xss4kwxSRcoVnGxo4pn000yjZ7ZqQ05bbzD6Qp7qZgiUamol10zWLqyyfs
        7OfdEmOxl1u0ROMqpyULZT6fQmgICx5OHbuwJxq1A29+8wu7YmHYuOTgNEesjbMGcCGAs0i
        3SALs+hmK6fo+NcXgWLTKuVVRq7b7k6PLBaCabch9G5s+7aplZaq5aTEFjBg1UNt5c5o5cS
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net/fddi: Fix comment typo
Date:   Thu, 11 Aug 2022 19:54:49 +0800
Message-Id: <20220811115449.1817-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/fddi/skfp/h/hwmtm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/h/hwmtm.h b/drivers/net/fddi/skfp/h/hwmtm.h
index 76c4a709d73d..e97db826cdd4 100644
--- a/drivers/net/fddi/skfp/h/hwmtm.h
+++ b/drivers/net/fddi/skfp/h/hwmtm.h
@@ -348,7 +348,7 @@ do {									\
  *		This macro is invoked by the OS-specific before it left the
  *		function mac_drv_rx_complete. This macro calls mac_drv_fill_rxd
  *		if the number of used RxDs is equal or lower than the
- *		the given low water mark.
+ *		given low water mark.
  *
  * para	low_water	low water mark of used RxD's
  *
-- 
2.36.1

