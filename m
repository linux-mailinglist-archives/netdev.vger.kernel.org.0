Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4EA68B44A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 03:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBFC7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 21:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBFC7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 21:59:43 -0500
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3361A49C
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 18:59:39 -0800 (PST)
X-QQ-mid: bizesmtp74t1675652372tb9qvicz
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 06 Feb 2023 10:59:22 +0800 (CST)
X-QQ-SSF: 01400000000000H0Y000000A0000000
X-QQ-FEAT: NcRVQeBiQWzXnVj0lCKJUwN3Icfkl7qVWcNIidf+fPbEznTwvcuQevwBm667v
        bXrDNuTLjsQ7v/XKc55kXF2zjLM31yFcbmJsuBbxsAWO1GL1nIS5MjtzCykdwTtz7TFPu6K
        tuAEUCUp1zTggztXAbLUqT2znes0eJgG3+MmOHZ5w+GsP4xm+m5FQoozqiJqRdIGGMQ9APS
        vskbXKqtnsTvUhtjbgPZhFSKYy7+nrYOk4E7QO5rKjmDJAoTMxM7eSW/fN0/rCX/tUM/jNt
        U6LS7HsKtlXhWruDgGszzr0vzD13QlR5QIvUXN6PWVpoBqBkbszZVqSWXRmVIMyBY/mXhQ5
        5AnO3c4V/qkmJqAwZp9WWM9nxkwdpcQbYc+O35WSiU8CJtsAZLOrgQo9wdCbg==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net] net: txgbe: Update support email address
Date:   Mon,  6 Feb 2023 10:55:29 +0800
Message-Id: <20230206025529.3333674-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update new email address for Wangxun 10Gb NIC support team.

Fixes: 3ce7547e5b71 ("net: txgbe: Add build support for txgbe")

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../networking/device_drivers/ethernet/wangxun/txgbe.rst        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
index eaa87dbe8848..d052ef40fe36 100644
--- a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -16,5 +16,5 @@ Contents
 
 Support
 =======
-If you got any problem, contact Wangxun support team via support@trustnetic.com
+If you got any problem, contact Wangxun support team via nic-support@net-swift.com
 and Cc: netdev.
-- 
2.27.0


