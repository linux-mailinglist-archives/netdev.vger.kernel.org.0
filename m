Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A026345FDB5
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 10:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353747AbhK0JoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 04:44:00 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27302 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353211AbhK0Jl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 04:41:58 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J1RPp0nk0zbj48;
        Sat, 27 Nov 2021 17:38:38 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 27 Nov 2021 17:38:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 27 Nov 2021 17:38:41 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 0/2] net: vxlan: add macro definition for number of IANA VXLAN-GPE port
Date:   Sat, 27 Nov 2021 17:34:03 +0800
Message-ID: <20211127093405.47218-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add macro definition for number of IANA VXLAN-GPE port for
cleanup.

Hao Chen (2):
  net: vxlan: add macro definition for number of IANA VXLAN-GPE port
  net: hns3: use macro IANA_VXLAN_GPE_UDP_PORT to replace number 4790

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 drivers/net/vxlan.c                             | 2 +-
 include/net/vxlan.h                             | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.33.0

