Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF1738BED3
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 08:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhEUGET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 02:04:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4708 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbhEUGER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 02:04:17 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmbYH0Z8Rz16Qfl;
        Fri, 21 May 2021 14:00:03 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:02:50 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 21 May
 2021 14:02:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v2 00/12] net/Bluetooth: correct the use of print format
Date:   Fri, 21 May 2021 13:59:36 +0800
Message-ID: <1621576788-48092-1-git-send-email-yekai13@huawei.com>
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

changes v1 -> v2:
	fix some style problems

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

 net/bluetooth/6lowpan.c     | 16 +++++------
 net/bluetooth/a2mp.c        | 24 ++++++++--------
 net/bluetooth/amp.c         |  6 ++--
 net/bluetooth/bnep/core.c   |  8 +++---
 net/bluetooth/cmtp/capi.c   | 22 +++++++--------
 net/bluetooth/hci_conn.c    |  8 +++---
 net/bluetooth/hci_core.c    | 48 ++++++++++++++++----------------
 net/bluetooth/hci_event.c   | 24 ++++++++--------
 net/bluetooth/hci_request.c |  8 +++---
 net/bluetooth/hci_sock.c    |  6 ++--
 net/bluetooth/hci_sysfs.c   |  2 +-
 net/bluetooth/hidp/core.c   |  6 ++--
 net/bluetooth/mgmt.c        | 16 +++++------
 net/bluetooth/mgmt_config.c |  4 +--
 net/bluetooth/msft.c        |  2 +-
 net/bluetooth/rfcomm/core.c | 68 ++++++++++++++++++++++-----------------------
 net/bluetooth/rfcomm/sock.c |  8 +++---
 net/bluetooth/rfcomm/tty.c  | 10 +++----
 net/bluetooth/sco.c         |  8 +++---
 net/bluetooth/smp.c         |  6 ++--
 20 files changed, 150 insertions(+), 150 deletions(-)

-- 
2.8.1

