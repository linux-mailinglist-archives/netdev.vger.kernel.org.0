Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8212E671525
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjARHib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjARHiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:38:04 -0500
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52BC1A498
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 22:58:36 -0800 (PST)
X-QQ-mid: bizesmtp80t1674025109tzur9m9y
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 18 Jan 2023 14:58:19 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: QityeSR92A0a1DvJOxjXWsUJYLdgq8LmJOuyOUDlcO+cMLP89XQrWe82Kb0ye
        azdQptlNoeyJaUWVZe44cF68ed27NZyD6Js/qzOcMeMDd1T7Mu39Jfe35omc6qEsi1cYCPv
        QhEADxYFiNCzoQEnF+cKvwkL5Clfk4/ZCvB1gpugdfs9mOmREf/IqqPfxMqc/TSwzyMzmmc
        wb1sh8syKr/uNeeAUrdEoKjqYg5Idz0De178EsPcE78WFwts74n17IScbgMXifypdYBaYdY
        gVnNevR48Z6PmbPcIjYk6lMdsY5UpTXrp7DtJNDZAi3x/hdu7vciEVrUV49A9ITRNxKvvEY
        VJF9Oy4VAgfv/RY65qawzlSyBwjMttphAPBIjQiz+28mlGhqMDBZdMGMcNhah0qDpAh5WYz
        dBEE8ATrZB8=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 00/10] Wangxun interrupt and RxTx support
Date:   Wed, 18 Jan 2023 14:54:54 +0800
Message-Id: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
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

Configure interrupt, setup RxTx ring, support to receive and transmit
packets.

Jiawen Wu (7):
  net: txgbe: Add interrupt support
  net: libwx: Configure Rx and Tx unit on hardware
  net: libwx: Allocate Rx and Tx resources
  net: txgbe: Setup Rx and Tx ring
  net: libwx: Support to receive packets in NAPI
  net: libwx: Add transmit path to process packets
  net: txgbe: Support Rx and Tx process path

Mengyuan Lou (3):
  net: libwx: Add irq flow functions
  net: ngbe: Add irqs request flow
  net: ngbe: Support Rx and Tx process path

 drivers/net/ethernet/wangxun/Kconfig          |    1 +
 drivers/net/ethernet/wangxun/libwx/Makefile   |    2 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |  675 +++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |    5 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 1993 +++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h   |   32 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  315 +++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  249 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   18 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  271 ++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   21 +
 11 files changed, 3564 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.h

-- 
2.27.0

