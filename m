Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE2F3A3A67
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhFKDlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:41:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5332 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhFKDlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 23:41:32 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G1RKq2bHbz1BL9m;
        Fri, 11 Jun 2021 11:34:39 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 11:39:31 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 11:39:31 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/8] net: pc300too: clean up some code style issues
Date:   Fri, 11 Jun 2021 11:36:14 +0800
Message-ID: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
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

Peng Li (8):
  net: pc300too: remove redundant blank lines
  net: pc300too: add blank line after declarations
  net: pc300too: fix the code style issue about "foo * bar"
  net: pc300too: move out assignment in if condition
  net: pc300too: remove redundant initialization for statics
  net: pc300too: replace comparison to NULL with "!card->plxbase"
  net: pc300too: add some required spaces
  net: pc300too: fix the comments style issue

 drivers/net/wan/pc300too.c | 52 +++++++++++++---------------------------------
 1 file changed, 15 insertions(+), 37 deletions(-)

-- 
2.8.1

