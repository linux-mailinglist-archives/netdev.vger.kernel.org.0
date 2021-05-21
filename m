Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B84038BB4B
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhEUBMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:12:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3449 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbhEUBMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:12:38 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FmT4q2KbJzBvPW;
        Fri, 21 May 2021 09:08:27 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/6] net: wan: clean up some code style issues
Date:   Fri, 21 May 2021 09:08:11 +0800
Message-ID: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset clean up some code style issues.

Peng Li (6):
  net: wan: fix an code style issue about "foo* bar"
  net: wan: add some required spaces
  net: wan: fix the code style issue about trailing statements
  net: wan: remove redundant blank lines
  net: wan: add braces {} to all arms of the statement
  net: wan: add necessary () to macro argument

 drivers/net/wan/hd64572.c | 95 +++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 48 deletions(-)

-- 
2.8.1

