Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDC438EA4E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhEXOyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:54:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5688 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhEXOvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:51:54 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fpg6S1Bytz1BRGQ;
        Mon, 24 May 2021 22:47:28 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:16 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 00/10] net: wan: clean up some code style issues
Date:   Mon, 24 May 2021 22:47:07 +0800
Message-ID: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
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

Peng Li (10):
  net: wan: remove redundant blank lines
  net: wan: fix an code style issue about "foo* bar"
  net: wan: add blank line after declarations
  net: wan: code indent use tabs where possible
  net: wan: fix the code style issue about trailing statements
  net: wan: add some required spaces
  net: wan: move out assignment in if condition
  net: wan: replace comparison to NULL with "!card"
  net: wan: fix the comments style issue
  net: wan: add braces {} to all arms of the statement

 drivers/net/wan/wanxl.c | 186 ++++++++++++++++++++++++------------------------
 1 file changed, 94 insertions(+), 92 deletions(-)

-- 
2.8.1

