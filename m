Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35860393A1B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhE1ARa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:17:30 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2321 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhE1AR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:17:27 -0400
Received: from dggeml712-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FrlTb52DKz1BFNl;
        Fri, 28 May 2021 08:11:15 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggeml712-chm.china.huawei.com (10.3.17.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 08:15:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 08:15:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 00/10] net: hdlc_fr: clean up some code style issues
Date:   Fri, 28 May 2021 08:12:39 +0800
Message-ID: <1622160769-6678-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patchset clean up some code style issues.

---
Change log:
V1 -> V2:
1, Use appropriate commit prefix suggested by Jakub Kicinski,
replace commit prefix "net: wan" by "net: hdlc_fr".

---

Peng Li (10):
  net: hdlc_fr: remove redundant blank lines
  net: hdlc_fr: add blank line after declarations
  net: hdlc_fr: fix an code style issue about "foo* bar"
  net: hdlc_fr: add some required spaces
  net: hdlc_fr: move out assignment in if condition
  net: hdlc_fr: code indent use tabs where possible
  net: hdlc_fr: remove space after '!'
  net: hdlc_fr: add braces {} to all arms of the statement
  net: hdlc_fr: remove redundant braces {}
  net: hdlc_fr: remove unnecessary out of memory message

 drivers/net/wan/hdlc_fr.c | 101 ++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 67 deletions(-)

-- 
2.8.1

