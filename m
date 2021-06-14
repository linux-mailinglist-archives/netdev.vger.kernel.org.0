Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB42E3A6545
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhFNLgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:36:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:6300 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235724AbhFNLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:34:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G3TgX4Qkqz1BMKh;
        Mon, 14 Jun 2021 19:27:04 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:02 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 00/11] net: z85230: clean up some code style issues
Date:   Mon, 14 Jun 2021 19:28:40 +0800
Message-ID: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
1, fix the comments from Andrew, add commit message to [patch 04/11]
   about remove volatile.
---

Peng Li (11):
  net: z85230: remove redundant blank lines
  net: z85230: add blank line after declarations
  net: z85230: fix the code style issue about EXPORT_SYMBOL(foo)
  net: z85230: remove redundant initialization for statics
  net: z85230: replace comparison to NULL with "!skb"
  net: z85230: fix the comments style issue
  net: z85230: fix the code style issue about "if..else.."
  net: z85230: remove trailing whitespaces
  net: z85230: add some required spaces
  net: z85230: fix the code style issue about open brace {
  net: z85230: remove unnecessary out of memory message

 drivers/net/wan/z85230.c | 995 ++++++++++++++++++++---------------------------
 1 file changed, 423 insertions(+), 572 deletions(-)

-- 
2.8.1

