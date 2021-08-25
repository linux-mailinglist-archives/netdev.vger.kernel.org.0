Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10EF3F70AB
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbhHYHuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:50:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18037 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238869AbhHYHtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:49:55 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GvdLM47H3zbhdg;
        Wed, 25 Aug 2021 15:45:15 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 15:49:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 25 Aug 2021 15:49:03 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <f.fainelli@gmail.com>,
        <jacob.e.keller@intel.com>, <mlxsw@mellanox.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 ethtool-next 0/2] ethtool: add two link extended substates of bad signal
Date:   Wed, 25 Aug 2021 15:45:11 +0800
Message-ID: <1629877513-23501-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds two link extended substates of bad signal.

change log:
V1 -> V2:
1. Split the uapi header update into a separate patch according to
   Michal's opinion as follow link:
   https://lore.kernel.org/netdev/20210824173614.mkv5i72sutxtdvrk@lion.mk-sys.cz/

Guangbin Huang (2):
  update UAPI header copies
  netlink: settings: add two link extended substates of bad signal
    integrity

 netlink/settings.c   | 4 ++++
 uapi/linux/ethtool.h | 2 ++
 2 files changed, 6 insertions(+)

-- 
2.8.1

