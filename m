Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64541418838
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 13:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhIZLDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 07:03:47 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11027 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhIZLDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 07:03:46 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HHN9K19W8zW6QG;
        Sun, 26 Sep 2021 19:00:53 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Sun, 26 Sep 2021 19:02:07 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>
CC:     <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/2] fix tx buffer concurrent access protection
Date:   Sun, 26 Sep 2021 19:01:07 +0800
Message-ID: <cover.1632653477.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix tx buffer concurrent access protection in isotp_sendmsg().

Ziyang Xuan (2):
  can: isotp: add result check for wait_event_interruptible()
  can: isotp: fix tx buffer concurrent access in isotp_sendmsg()

 net/can/isotp.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

-- 
2.25.1

