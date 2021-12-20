Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB3247A617
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbhLTIgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:36:47 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16832 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbhLTIgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 03:36:46 -0500
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JHXwr1lFpz91Mk;
        Mon, 20 Dec 2021 16:35:56 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 16:36:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 16:36:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>
Subject: [PATCH ethtool-next 0/2] add some supports for netlink
Date:   Mon, 20 Dec 2021 16:31:53 +0800
Message-ID: <20211220083155.39882-1-huangguangbin2@huawei.com>
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

Add support for "ethtool -G/g <dev>" to set/get rx buf len
and support for "ethtool --set/get-tunable <dev>" to
set/get tx copybreak buf size.

Hao Chen (2):
  ethtool: netlink: add support to set/get rx buf len
  ethtool: netlink: add support to get/set tx copybreak buf size

 ethtool.c       | 9 +++++++++
 netlink/rings.c | 7 +++++++
 2 files changed, 16 insertions(+)

-- 
2.33.0

