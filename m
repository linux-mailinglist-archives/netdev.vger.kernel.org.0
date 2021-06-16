Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318EA3A93B9
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhFPH2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:28:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10089 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhFPH2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:28:12 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4c9822DpzZfYM;
        Wed, 16 Jun 2021 15:23:08 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:03 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:02 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: iosm: remove the repeated declaration and comment
Date:   Wed, 16 Jun 2021 15:25:40 +0800
Message-ID: <1623828340-2019-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function 'ipc_mmio_get_cp_version' is declared twice, so remove the
repeated declaration and wrong comments.

Cc: M Chetan Kumar <m.chetan.kumar@intel.com>
Cc: Intel Corporation <linuxwwan@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mmio.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.h b/drivers/net/wwan/iosm/iosm_ipc_mmio.h
index bcf77aea06e7..45e6923da78f 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mmio.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.h
@@ -121,16 +121,6 @@ void ipc_mmio_set_contex_info_addr(struct iosm_mmio *ipc_mmio,
 				   phys_addr_t addr);
 
 /**
- * ipc_mmio_get_cp_version - Write context info and AP memory range addresses.
- *			     This needs to be called when CP is in
- *			     IPC_MEM_DEVICE_IPC_INIT state
- * @ipc_mmio:	Pointer to mmio instance
- *
- * Returns: cp version else failure value on error
- */
-int ipc_mmio_get_cp_version(struct iosm_mmio *ipc_mmio);
-
-/**
  * ipc_mmio_get_cp_version - Get the CP IPC version
  * @ipc_mmio:	Pointer to mmio instance
  *
-- 
2.7.4

