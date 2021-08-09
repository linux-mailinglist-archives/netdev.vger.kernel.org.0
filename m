Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF413E480B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 16:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhHIOy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 10:54:58 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13257 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhHIOyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 10:54:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Gjzch1YtHz1CTdM;
        Mon,  9 Aug 2021 22:54:12 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:54:24 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:54:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/4] docs: ethtool: Add two link extended substates of bad signal integrity
Date:   Mon, 9 Aug 2021 22:50:39 +0800
Message-ID: <1628520642-30839-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
References: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for two bad signal integrity substates:
ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST
ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 Documentation/networking/ethtool-netlink.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c86628e6a235..c690bb37430d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -595,6 +595,14 @@ Link extended substates:
                                                                        that is not formally
                                                                        supported, which led to
                                                                        signal integrity issues
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST``        The external clock signal for
+                                                                       SerDes is too weak or
+                                                                       unavailable.
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS``                        The received signal for
+                                                                       SerDes is too weak because
+                                                                       analog loss of signal.
   =================================================================    =============================
 
   Cable issue substates:
-- 
2.8.1

