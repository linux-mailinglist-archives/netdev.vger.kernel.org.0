Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CF3626EC3
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 10:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiKMJjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 04:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKMJjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 04:39:04 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94012B7D5
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 01:39:02 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N96nt1xHGzmVt5;
        Sun, 13 Nov 2022 17:38:42 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 13 Nov
 2022 17:39:00 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <mlindner@marvell.com>, <stephen@networkplumber.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jeff@garzik.org>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH 0/2] Fix error handling path
Date:   Sun, 13 Nov 2022 09:37:17 +0000
Message-ID: <20221113093719.23687-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains two missing error handling related bugfixes.

Yuan Can (2):
  net: skge: Fix error handling in skge_init_module()
  net: sky2: Fix error handling in sky2_init_module()

 drivers/net/ethernet/marvell/skge.c | 10 ++++++++--
 drivers/net/ethernet/marvell/sky2.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

-- 
2.17.1

