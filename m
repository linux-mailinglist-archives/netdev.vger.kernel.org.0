Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B48391679
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhEZLta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:49:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3977 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhEZLt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:49:28 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FqpyB3TF9zQntw;
        Wed, 26 May 2021 19:44:18 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 00/10] net: wan: clean up some code style issues
Date:   Wed, 26 May 2021 19:44:45 +0800
Message-ID: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
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

Peng Li (10):
  net: wan: remove redundant blank lines
  net: wan: add blank line after declarations
  net: wan: fix an code style issue about "foo* bar"
  net: wan: add some required spaces
  net: wan: move out assignment in if condition
  net: wan: code indent use tabs where possible
  net: wan: remove space after '!'
  net: wan: add braces {} to all arms of the statement
  net: wan: remove redundant braces {}
  net: wan: remove unnecessary out of memory message

 drivers/net/wan/hdlc_fr.c | 101 ++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 67 deletions(-)

-- 
2.8.1

