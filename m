Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D388522A4F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiEKDTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiEKDTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:21 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39006CA9B
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:19 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239146tqo3nfdz
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:18:47 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: F3yR32iATbilT+Qd7SIBrb6hoe0AjJ0C9eF5h2tPOjcRtEd0wtiCEQMvtL4PI
        zI4o/cNqjxZCGDlciFWdK2BRETpEyofkKkMafYADo8sKzb4LEL5Q8rElQlKvnXKOht8/oAH
        C5qSzwJ7l9Ocxa1dwxXb0D4XUGDDyM8WKCcXke0PC95pAfL6EaHnmdihf8YFGo7G0C7qG3f
        xwiV580DP8a6uiwEWQoRuyZIpGGFZ9UI9cJF476e2yJLRjpwwTsH0iBD97e6Z4S/+UptqzX
        0z+zyMwLiCD2uq9tlrBGUadXkc3MhfjQXAcRzzNi4/GEsMYqUvRC3TbVQzLCdONoo9nzRVD
        7VEYcmWWpm7F2dp0eQ=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 00/14] Wangxun 10 Gigabit Ethernet Driver
Date:   Wed, 11 May 2022 11:26:45 +0800
Message-Id: <20220511032659.641834-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign8
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch contains the support of linux base driver for wangxun 10
gigabit PCI express adapter which is named TXGBE.

This patch is meant to control the basic functionality of the PF driver,
and it would be incrementally enhanced with more features.

Jiawen Wu (14):
  net: txgbe: Add build support for txgbe ethernet driver
  net: txgbe: Add hardware initialization
  net: txgbe: Add operations to interact with firmware
  net: txgbe: Add PHY interface support
  net: txgbe: Add interrupt support
  net: txgbe: Support to receive and tranmit packets
  net: txgbe: Support flow control
  net: txgbe: Support flow director
  net: txgbe: Support PTP
  net: txgbe: Add ethtool support
  net: txgbe: Support PCIe recovery
  net: txgbe: Support power management
  net: txgbe: Support debug filesystem
  net: txgbe: Support sysfs file system

 .../device_drivers/ethernet/index.rst         |    1 +
 .../device_drivers/ethernet/wangxun/txgbe.rst |  238 +
 MAINTAINERS                                   |    7 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/wangxun/Kconfig          |   41 +
 drivers/net/ethernet/wangxun/Makefile         |    6 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   15 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  829 ++
 .../ethernet/wangxun/txgbe/txgbe_debugfs.c    |  582 ++
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    | 3188 ++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 5785 ++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  238 +
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    |  531 ++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 6748 +++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_pcierr.c |  236 +
 .../net/ethernet/wangxun/txgbe/txgbe_pcierr.h |    8 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    |  439 ++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |   65 +
 .../net/ethernet/wangxun/txgbe/txgbe_ptp.c    |  840 ++
 .../net/ethernet/wangxun/txgbe/txgbe_sysfs.c  |  203 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 2837 +++++++
 22 files changed, 22839 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
 create mode 100644 drivers/net/ethernet/wangxun/Kconfig
 create mode 100644 drivers/net/ethernet/wangxun/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_debugfs.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_ptp.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_sysfs.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h

-- 
2.27.0



