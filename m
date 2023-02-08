Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB9A68E61C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBHCex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBHCer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:34:47 -0500
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D68783C2
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 18:34:45 -0800 (PST)
X-QQ-mid: bizesmtp75t1675823680tbi4ymlr
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 08 Feb 2023 10:34:31 +0800 (CST)
X-QQ-SSF: 01400000000000H0Y000000A0000000
X-QQ-FEAT: UXDQX2OwVhlY5JvTKEjgnykxxBiXDMPBh9RN0NuRmaOyGVXYd1SiNj9Oc4QQQ
        LYcnAHAsgzdgGiQTZJqna4aeQyBudV4Uz3fkbI/MFR/dqpskUNDrtq9STb6tn7RL4IO7xic
        C/OYAW3tviQW+hY8eRzWD2UsqFcVwBzs9MZPy/LxCR1mCVAqExXgPDoyZOgScz/wQK/ZDv5
        emk9aAOGoVPysTBs2jePhfK7o079tiqL5Cc8+BDrsUUc9h+zHiYay7mCEzrcQKCFxqC5AvK
        J7rsoZyjOYv4qA1Hpmvyd0FbTxKRPkFbi1aH5RnyjlTCYT5haUY7D1tFb1trpHtl55b12rT
        Y0X4LIwuvkkVnjNKjvF0d6bqvuQvglHpLi3f/LiIDjNDUAmznRfjrjnhwCedw==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net v2] net: txgbe: Update support email address
Date:   Wed,  8 Feb 2023 10:30:35 +0800
Message-Id: <20230208023035.3371250-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

