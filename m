Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B294277EB
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 09:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhJIHnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 03:43:15 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25112 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhJIHnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 03:43:14 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HRH5D6gbgz1DGn9;
        Sat,  9 Oct 2021 15:39:44 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Sat, 9 Oct 2021 15:41:16 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2 0/2] fix tx buffer concurrent access protection
Date:   Sat, 9 Oct 2021 15:40:08 +0800
Message-ID: <cover.1633764159.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix tx buffer concurrent access protection in isotp_sendmsg().

v2:
 - Change state of struct tpcon to u32 for cmpxchg just support 4-byte
   and 8-byte in some architectures.

Ziyang Xuan (2):
  can: isotp: add result check for wait_event_interruptible()
  can: isotp: fix tx buffer concurrent access in isotp_sendmsg()

 net/can/isotp.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

-- 
2.25.1

