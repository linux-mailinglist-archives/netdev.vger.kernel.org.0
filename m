Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199D2388769
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbhESGTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:19:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3034 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhESGTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 02:19:02 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlMzx4pPFzmXG5;
        Wed, 19 May 2021 14:15:25 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 14:17:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 14:17:41 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/5] net: intel: some cleanups
Date:   Wed, 19 May 2021 14:14:40 +0800
Message-ID: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds some cleanups for intel e1000/e1000e ethernet driver.

Hao Chen (5):
  net: e1000: remove repeated word "slot" for e1000_main.c
  net: e1000: remove repeated words for e1000_hw.c
  net: e1000e: remove repeated word "the" for ich8lan.c
  net: e1000e: remove repeated word "slot" for netdev.c
  net: e1000e: fix misspell word "retreived"

 drivers/net/ethernet/intel/e1000/e1000_hw.c   | 4 ++--
 drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c   | 2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    | 2 +-
 drivers/net/ethernet/intel/e1000e/phy.c       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.8.1

