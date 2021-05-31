Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A279395ACF
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhEaMqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:46:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6095 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhEaMqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 08:46:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ftw0L0P9SzYnW1;
        Mon, 31 May 2021 20:41:54 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 20:44:36 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 31 May
 2021 20:44:36 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <jdmason@kudzu.us>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: neterion: fix doc warnings in s2io.c
Date:   Mon, 31 May 2021 20:48:59 +0800
Message-ID: <20210531124859.3847016-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for may_sleep to fix the W=1 warnings:

  drivers/net/ethernet/neterion/s2io.c:1110: warning: Function parameter or member 'may_sleep' not described in 'init_tti'
  drivers/net/ethernet/neterion/s2io.c:3335: warning: Function parameter or member 'may_sleep' not described in 'wait_for_cmd_complete'
  drivers/net/ethernet/neterion/s2io.c:4881: warning: Function parameter or member 'may_sleep' not described in 's2io_set_multicast'

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/neterion/s2io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 27a65ab3d501..0b017d4f5c08 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -1101,6 +1101,8 @@ static int s2io_print_pci_mode(struct s2io_nic *nic)
  *  @nic: device private variable
  *  @link: link status (UP/DOWN) used to enable/disable continuous
  *  transmit interrupts
+ *  @may_sleep: parameter indicates if sleeping when waiting for
+ *  command complete
  *  Description: The function configures transmit traffic interrupts
  *  Return Value:  SUCCESS on success and
  *  '-1' on failure
@@ -3323,6 +3325,8 @@ static void s2io_updt_xpak_counter(struct net_device *dev)
  *  @addr: address
  *  @busy_bit: bit to check for busy
  *  @bit_state: state to check
+ *  @may_sleep: parameter indicates if sleeping when waiting for
+ *  command complete
  *  Description: Function that waits for a command to Write into RMAC
  *  ADDR DATA registers to be completed and returns either success or
  *  error depending on whether the command was complete or not.
@@ -4868,6 +4872,8 @@ static struct net_device_stats *s2io_get_stats(struct net_device *dev)
 /**
  *  s2io_set_multicast - entry point for multicast address enable/disable.
  *  @dev : pointer to the device structure
+ *  @may_sleep: parameter indicates if sleeping when waiting for command
+ *  complete
  *  Description:
  *  This function is a driver entry point which gets called by the kernel
  *  whenever multicast addresses must be enabled/disabled. This also gets
-- 
2.25.1

