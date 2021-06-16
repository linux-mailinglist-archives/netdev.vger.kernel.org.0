Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DBA3A93BE
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhFPH3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10090 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhFPH3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:00 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4cB55k0XzZf6d;
        Wed, 16 Jun 2021 15:23:57 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 00/15] net: cosa: clean up some code style issues
Date:   Wed, 16 Jun 2021 15:23:26 +0800
Message-ID: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
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

From: Peng Li <lipeng321@huawei.com>

This patchset clean up some code style issues.

Peng Li (15):
  net: cosa: remove redundant blank lines
  net: cosa: add blank line after declarations
  net: cosa: fix the code style issue about "foo* bar"
  net: cosa: replace comparison to NULL with "!chan->rx_skb"
  net: cosa: move out assignment in if condition
  net: cosa: fix the comments style issue
  net: cosa: add braces {} to all arms of the statement
  net: cosa: remove redundant braces {}
  net: cosa: add necessary () to macro argument
  net: cosa: use BIT macro
  net: cosa: fix the alignment issue
  net: cosa: fix the code style issue about trailing statements
  net: cosa: add some required spaces
  net: cosa: remove trailing whitespaces
  net: cosa: remove redundant spaces

 drivers/net/wan/cosa.c | 493 ++++++++++++++++++++++++++-----------------------
 1 file changed, 260 insertions(+), 233 deletions(-)

-- 
2.8.1

