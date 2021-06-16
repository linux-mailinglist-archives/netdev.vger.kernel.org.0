Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE82A3A965D
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhFPJjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:39:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7457 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhFPJjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:39:17 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4g4Q07N1zZhkZ;
        Wed, 16 Jun 2021 17:34:14 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:09 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/8] net: hdlc_ppp: clean up some code style issues
Date:   Wed, 16 Jun 2021 17:33:49 +0800
Message-ID: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
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

From: Peng Li <lipeng321@huawei.com>

This patchset clean up some code style issues.

Peng Li (8):
  net: hdlc_ppp: remove redundant blank lines
  net: hdlc_ppp: add blank line after declarations
  net: hdlc_ppp: fix the code style issue about "foo* bar"
  net: hdlc_ppp: move out assignment in if condition
  net: hdlc_ppp: fix the comments style issue
  net: hdlc_ppp: remove unnecessary out of memory message
  net: hdlc_ppp: remove redundant spaces
  net: hdlc_ppp: add required space

 drivers/net/wan/hdlc_ppp.c | 90 ++++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 48 deletions(-)

-- 
2.8.1

