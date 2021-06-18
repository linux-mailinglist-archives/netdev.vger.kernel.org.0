Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9FC3AC0D1
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhFRChs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 22:37:48 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8266 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhFRChr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 22:37:47 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5jZd4vGLz1BNlX;
        Fri, 18 Jun 2021 10:30:33 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 10:35:36 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 0/7] net: hostess_sv11: clean up some code style issues
Date:   Fri, 18 Jun 2021 10:32:17 +0800
Message-ID: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset clean up some code style issues.

---
Change Log：
V1 -> V2:
1. Add patch "[patch 5/7] net: hostess_sv11: remove dead code"
suggested by Andrew Lunn.
---

Peng Li (7):
  net: hostess_sv11: fix the code style issue about "foo* bar"
  net: hostess_sv11: move out assignment in if condition
  net: hostess_sv11: remove trailing whitespace
  net: hostess_sv11: fix the code style issue about switch and case
  net: hostess_sv11: remove dead code
  net: hostess_sv11: fix the comments style issue
  net: hostess_sv11: fix the alignment issue

 drivers/net/wan/hostess_sv11.c | 113 ++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 63 deletions(-)

-- 
2.8.1

