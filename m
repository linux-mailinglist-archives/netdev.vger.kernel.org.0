Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2DE39813B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhFBGmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:42:36 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3333 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhFBGmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:42:35 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvznM1zldz19S9n;
        Wed,  2 Jun 2021 14:36:07 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:40:48 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] ethtool: Fix a typo
Date:   Wed, 2 Jun 2021 14:54:28 +0800
Message-ID: <20210602065428.104529-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

atribute  ==> attribute

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ethtool/netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 8abcbc10796c..90b10966b16b 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -138,7 +138,7 @@ static inline void ethnl_update_bool32(u32 *dst, const struct nlattr *attr,
 }
 
 /**
- * ethnl_update_binary() - update binary data from NLA_BINARY atribute
+ * ethnl_update_binary() - update binary data from NLA_BINARY attribute
  * @dst:  value to update
  * @len:  destination buffer length
  * @attr: netlink attribute with new value or null
-- 
2.25.1

