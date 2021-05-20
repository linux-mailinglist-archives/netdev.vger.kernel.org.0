Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E443E389DA6
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhETGXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:23:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4763 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhETGW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:22:56 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fm00X00NWzqV3p;
        Thu, 20 May 2021 14:18:03 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 14:21:33 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 14:21:32 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/4] net: bonding: clean up some code style issues
Date:   Thu, 20 May 2021 14:18:31 +0800
Message-ID: <1621491515-53459-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset cleans up some code style issues.

Yufeng Mo (4):
  net: bonding: add some required blank lines
  net: bonding: fix code indent for conditional statements
  net: bonding: remove unnecessary braces
  net: bonding: use tabs instead of space for code indent

 drivers/net/bonding/bond_alb.c     | 5 ++++-
 drivers/net/bonding/bond_debugfs.c | 3 +--
 drivers/net/bonding/bond_main.c    | 5 +++--
 drivers/net/bonding/bond_netlink.c | 2 +-
 drivers/net/bonding/bond_procfs.c  | 1 +
 drivers/net/bonding/bond_sysfs.c   | 7 +++++++
 6 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.8.1

