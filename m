Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048B259F0FD
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 03:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiHXBdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 21:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiHXBdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 21:33:40 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C514D82B;
        Tue, 23 Aug 2022 18:33:39 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MC7mc2Z3WzXdh2;
        Wed, 24 Aug 2022 09:29:20 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 24 Aug
 2022 09:33:37 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] netlink: fix some kernel-doc comments
Date:   Wed, 24 Aug 2022 09:36:21 +0800
Message-ID: <20220824013621.365103-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the comment of input parameter of nlmsg_ and nla_ function.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/netlink.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 7a2a9d3144ba..e658d18afa67 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -741,6 +741,7 @@ static inline int __nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
  * @hdrlen: length of family specific header
  * @tb: destination array with maxtype+1 elements
  * @maxtype: maximum attribute type to be expected
+ * @policy: validation policy
  * @extack: extended ACK report struct
  *
  * See nla_parse()
@@ -760,6 +761,7 @@ static inline int nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
  * @hdrlen: length of family specific header
  * @tb: destination array with maxtype+1 elements
  * @maxtype: maximum attribute type to be expected
+ * @policy: validation policy
  * @extack: extended ACK report struct
  *
  * See nla_parse_deprecated()
@@ -779,6 +781,7 @@ static inline int nlmsg_parse_deprecated(const struct nlmsghdr *nlh, int hdrlen,
  * @hdrlen: length of family specific header
  * @tb: destination array with maxtype+1 elements
  * @maxtype: maximum attribute type to be expected
+ * @policy: validation policy
  * @extack: extended ACK report struct
  *
  * See nla_parse_deprecated_strict()
@@ -814,7 +817,6 @@ static inline struct nlattr *nlmsg_find_attr(const struct nlmsghdr *nlh,
  * @len: length of attribute stream
  * @maxtype: maximum attribute type to be expected
  * @policy: validation policy
- * @validate: validation strictness
  * @extack: extended ACK report struct
  *
  * Validates all attributes in the specified attribute stream against the
-- 
2.17.1

