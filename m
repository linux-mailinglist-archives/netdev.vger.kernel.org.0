Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9A33A7450
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhFOCtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:49:17 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10059 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhFOCtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:49:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3t1Z6KgJzZdGK;
        Tue, 15 Jun 2021 10:44:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 10:46:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 10:46:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 00/10] net: z85230: clean up some code style issues
Date:   Tue, 15 Jun 2021 10:43:35 +0800
Message-ID: <1623725025-50976-1-git-send-email-huangguangbin2@huawei.com>
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

From: Peng Li <lipeng321@huawei.com>

This patchset clean up some code style issues.

---
Change Log:
V1 -> V2:
1, Remove patch "net: z85230: remove redundant initialization for statics"
from this patchset.
---

Peng Li (10):
  net: z85230: remove redundant blank lines
  net: z85230: add blank line after declarations
  net: z85230: fix the code style issue about EXPORT_SYMBOL(foo)
  net: z85230: replace comparison to NULL with "!skb"
  net: z85230: fix the comments style issue
  net: z85230: fix the code style issue about "if..else.."
  net: z85230: remove trailing whitespaces
  net: z85230: add some required spaces
  net: z85230: fix the code style issue about open brace {
  net: z85230: remove unnecessary out of memory message

 drivers/net/wan/z85230.c | 993 ++++++++++++++++++++---------------------------
 1 file changed, 422 insertions(+), 571 deletions(-)

-- 
2.8.1

