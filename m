Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D9B39F085
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhFHIRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:17:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4514 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHIRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:44 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzjfP34VDzZdh8;
        Tue,  8 Jun 2021 16:13:01 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:50 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 00/16] net: farsync: clean up some code style issues
Date:   Tue, 8 Jun 2021 16:12:26 +0800
Message-ID: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patchset clean up some code style issues.

Peng Li (16):
  net: farsync: remove redundant blank lines
  net: farsync: add blank line after declarations
  net: farsync: fix the code style issue about "foo* bar"
  net: farsync: move out assignment in if condition
  net: farsync: remove redundant initialization for statics
  net: farsync: fix the comments style issue
  net: farsync: remove trailing whitespaces
  net: farsync: code indent use tabs where possible
  net: farsync: fix the code style issue about macros
  net: farsync: add some required spaces
  net: farsync: remove redundant braces {}
  net: farsync: remove redundant spaces
  net: farsync: remove unnecessary parentheses
  net: farsync: fix the alignment issue
  net: farsync: remove redundant return
  net: farsync: replace comparison to NULL with "fst_card_array[i]"

 drivers/net/wan/farsync.c | 487 +++++++++++++++++++---------------------------
 1 file changed, 204 insertions(+), 283 deletions(-)

-- 
2.8.1

