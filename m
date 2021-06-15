Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C633A8187
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhFON7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:59:46 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7276 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhFON7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:59:41 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G48rz1ql2z1BMWN;
        Tue, 15 Jun 2021 21:52:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 21:57:35 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/6] net: pci200syn: clean up some code style issues
Date:   Tue, 15 Jun 2021 21:54:17 +0800
Message-ID: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset clean up some code style issues.

Peng Li (6):
  net: pci200syn: remove redundant blank lines
  net: pci200syn: add blank line after declarations
  net: pci200syn: replace comparison to NULL with "!card"
  net: pci200syn: add some required spaces
  net: pci200syn: add necessary () to macro argument
  net: pci200syn: fix the comments style issue

 drivers/net/wan/pci200syn.c | 51 +++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

-- 
2.8.1

