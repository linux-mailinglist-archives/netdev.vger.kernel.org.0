Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6AA3AB69F
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhFQO66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:58:58 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4958 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhFQO65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 10:58:57 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5Q6S6hRXz70rc;
        Thu, 17 Jun 2021 22:53:36 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 17 Jun 2021 22:56:47 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/6] net: hostess_sv11: clean up some code style issues
Date:   Thu, 17 Jun 2021 22:53:29 +0800
Message-ID: <1623941615-26966-1-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset clean up some code style issues.

Peng Li (6):
  net: hostess_sv11: fix the code style issue about "foo* bar"
  net: hostess_sv11: move out assignment in if condition
  net: hostess_sv11: remove trailing whitespace
  net: hostess_sv11: fix the code style issue about switch and case
  net: hostess_sv11: fix the comments style issue
  net: hostess_sv11: fix the alignment issue

 drivers/net/wan/hostess_sv11.c | 111 +++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 60 deletions(-)

-- 
2.8.1

