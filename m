Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D190238ACEC
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241546AbhETLvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:51:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4700 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240908AbhETLs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 07:48:56 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fm7FV6ZTxz16PnN;
        Thu, 20 May 2021 19:44:46 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 19:47:33 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 19:47:33 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH 00/12] net/Bluetooth: correct the use of print format
Date:   Thu, 20 May 2021 19:44:21 +0800
Message-ID: <1621511073-47766-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Documentation/core-api/printk-formats.rst,
Use the correct print format. 
1. Printing an unsigned int value should use %u instead of %d.
2. Printing an unsigned long value should use %lu instead of %ld.
Otherwise printk() might end up displaying negative numbers.

Kai Ye (12):
  net/Bluetooth/bnep - use the correct print format
  net/Bluetooth/cmtp - use the correct print format
  net/Bluetooth/hidp - use the correct print format
  net/Bluetooth/rfcomm - use the correct print format
  net/Bluetooth/6lowpan - use the correct print format
  net/Bluetooth/a2mp - use the correct print format
  net/Bluetooth/amp - use the correct print format
  net/Bluetooth/hci - use the correct print format
  net/Bluetooth/mgmt - use the correct print format
  net/Bluetooth/msft - use the correct print format
  net/Bluetooth/sco - use the correct print format
  net/Bluetooth/smp - use the correct print format

 net/bluetooth/6lowpan.c     | 16 ++++++------
 net/bluetooth/a2mp.c        | 24 +++++++++---------
 net/bluetooth/amp.c         |  6 ++---
 net/bluetooth/bnep/core.c   |  6 ++---
 net/bluetooth/cmtp/capi.c   | 20 +++++++--------
 net/bluetooth/hci_conn.c    |  8 +++---
 net/bluetooth/hci_core.c    | 48 +++++++++++++++++------------------
 net/bluetooth/hci_event.c   | 24 +++++++++---------
 net/bluetooth/hci_request.c |  8 +++---
 net/bluetooth/hci_sock.c    |  6 ++---
 net/bluetooth/hci_sysfs.c   |  2 +-
 net/bluetooth/hidp/core.c   |  6 ++---
 net/bluetooth/mgmt.c        | 16 ++++++------
 net/bluetooth/mgmt_config.c |  4 +--
 net/bluetooth/msft.c        |  2 +-
 net/bluetooth/rfcomm/core.c | 62 ++++++++++++++++++++++-----------------------
 net/bluetooth/rfcomm/sock.c |  8 +++---
 net/bluetooth/rfcomm/tty.c  | 10 ++++----
 net/bluetooth/sco.c         |  8 +++---
 net/bluetooth/smp.c         |  6 ++---
 20 files changed, 145 insertions(+), 145 deletions(-)

-- 
2.8.1

