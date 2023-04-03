Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC3C6D3D8A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 08:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjDCGsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDCGr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:47:58 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47816A275
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 23:47:54 -0700 (PDT)
X-QQ-mid: bizesmtp63t1680504420t6edhsxm
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 03 Apr 2023 14:46:51 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000B00A0000000
X-QQ-FEAT: CR3LFp2JE4nSc63oCUuY4CPWQDS69Vr0CpTX1PkhB/NgYKy8YYHcqXxBMZp74
        jBVUu+vpXnPfh/eVUsugxv9mdEXxPpzXyZoInD4xfKJoSFA+KrzPlMzHN0zhOwDNiJnjVcU
        aCtRD86SjMhMnjFPH05KyewqGkr9QFyEfJ+KIpcHC3z49NL2qOiWnzO0NQxvahdAOYITwub
        Wo+ChUICnov4ppjfo6xd9ZG3opEbWwQMGnsnJofG49+CUGA255AnBTwLIge3DXGmQfqtJS7
        QzLAfF9v9u5Gxu4oKlCoEaq6hpLpI4DBlfWKQjMdlrcqby5oGe70YDmqoY5eXPDK77oo5+d
        ZEeoxOue+PmwtuqrtlZVB9RNlErJHw2Ez8M6F5HY08+tTpjyzk=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 6167654242960929765
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 0/6] TXGBE PHYLINK support
Date:   Mon,  3 Apr 2023 14:45:22 +0800
Message-Id: <20230403064528.343866-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement I2C, SFP, GPIO and PHYLINK to setup TXGBE link and switch link
rate based on optical module information.

Jiawen Wu (6):
  net: txgbe: Add software nodes to support phylink
  net: txgbe: Implement I2C bus master driver
  net: txgbe: Add SFP module identify
  net: txgbe: Support GPIO to SFP socket
  net: txgbe: Implement phylink pcs
  net: txgbe: Support phylink MAC layer

 .../device_drivers/ethernet/wangxun/txgbe.rst |  47 +
 drivers/net/ethernet/wangxun/Kconfig          |   5 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   3 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  34 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  61 +-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 934 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |  10 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 156 +++
 11 files changed, 1223 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h

-- 
2.27.0

