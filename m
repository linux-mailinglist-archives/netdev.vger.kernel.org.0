Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03427394FC2
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhE3G3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:29:18 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2410 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhE3G3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:29:17 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Ft7fh2lkvz663G;
        Sun, 30 May 2021 14:23:56 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 00/10] net: sealevel: clean up some code style issues
Date:   Sun, 30 May 2021 14:24:24 +0800
Message-ID: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset clean up some code style issues.

Peng Li (10):
  net: sealevel: remove redundant blank lines
  net: sealevel: add blank line after declarations
  net: sealevel: fix the code style issue about "foo* bar"
  net: sealevel: open brace '{' following struct go on the same line
  net: sealevel: add some required spaces
  net: sealevel: remove redundant initialization for statics
  net: sealevel: fix a code style issue about switch and case
  net: sealevel: remove meaningless comments
  net: sealevel: fix the comments style issue
  net: sealevel: fix the alignment issue

 drivers/net/wan/sealevel.c | 126 +++++++++++++++++----------------------------
 1 file changed, 47 insertions(+), 79 deletions(-)

-- 
2.8.1

