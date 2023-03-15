Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4CF6BABF3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjCOJTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjCOJT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:19:27 -0400
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95170136F9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:19:21 -0700 (PDT)
X-QQ-mid: bizesmtp63t1678871952t12lwias
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 15 Mar 2023 17:18:49 +0800 (CST)
X-QQ-SSF: 01400000000000N0P000000A0000000
X-QQ-FEAT: W+onFc5Tw4M0etWcp/WqPr1K2c10p3+dsQGV3QP1Zte1IVVBq4BI7bEqBLkcj
        2MA9gg7WMWQtwluQISmP3oPFV4pFYYnx25gpOllpbEmGDUJTOOiWFXVeSjcwtad9pf3A3mk
        gKI9i68FWw/gAeQlD84lDfYCsbn5fA0oUm9ifHgSCvF5Z8aJP/12gUtZr0e2bcYEhvMsAGU
        /ajYqc8j4BCdSM1Js4MsrQADCEvzGWB01xsQml/tq+rEuLwIlUXVjWxrihJ7WYGx2wFD3n0
        8REOpGrs/+3Ln+2OVFzgw21tibJgLltVYUE5dxBeh2RJhlfyOqOT9zsx7iUi6DIub5butnw
        c5RFnGN3w9nItM1XdRuxXB9XHqdZbmPCwR5l8JtkVOYPVQffofXp986ZlS0X4wQS8TiHimv
        63IN5S/aKZrTkh5Spffu5g==
X-QQ-GoodBg: 2
From:   mengyuanlou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, mengyuanlou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next] net: wangxun: Remove macro that is redefined
Date:   Wed, 15 Mar 2023 17:18:46 +0800
Message-Id: <20230315091846.17314-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove PCI_VENDOR_ID_WANGXUN which is redefined in
drivers/pci/quirks.

Signed-off-by: mengyuanlou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 2b9efd13c500..2bec5b1bc196 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -7,11 +7,6 @@
 #include <linux/bitfield.h>
 #include <linux/netdevice.h>
 
-/* Vendor ID */
-#ifndef PCI_VENDOR_ID_WANGXUN
-#define PCI_VENDOR_ID_WANGXUN                   0x8088
-#endif
-
 #define WX_NCSI_SUP                             0x8000
 #define WX_NCSI_MASK                            0x8000
 #define WX_WOL_SUP                              0x4000
-- 
2.40.0

