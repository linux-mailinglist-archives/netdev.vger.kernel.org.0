Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892FE38045D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhENHfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:35:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2921 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhENHft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:35:49 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FhKwV3kGGzBv1V;
        Fri, 14 May 2021 15:31:54 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 15:34:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 15:34:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/4] net: hns: clean up some code style issues
Date:   Fri, 14 May 2021 15:31:38 +0800
Message-ID: <1620977502-27236-1-git-send-email-huangguangbin2@huawei.com>
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

This patchset clean up some code style issues.

Peng Li (4):
  net: hns: fix the comments style issue
  net: hns: fix some code style issue about space
  net: hns: space required before the open brace '{'
  net: hns: remove redundant return int void function

 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |  2 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |  3 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 72 +++++++++++-----------
 3 files changed, 37 insertions(+), 40 deletions(-)

-- 
2.7.4

