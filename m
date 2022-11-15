Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26535629C9F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiKOOv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKOOvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:51:25 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B3322500;
        Tue, 15 Nov 2022 06:51:24 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NBTd83j3czHvtZ;
        Tue, 15 Nov 2022 22:50:52 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:51:22 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:51:21 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mdf@kernel.org>, <romieu@fr.zoreil.com>
CC:     <zhangchangzhong@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2 0/3] three fixes for nixge driver
Date:   Tue, 15 Nov 2022 23:10:21 +0800
Message-ID: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset try to fix some bugs in nixge driver find by code review.
Compile tested only as I don't have the hardware to test them.

v1->v2:
 - Split tx queue handling and error handling into two patches
 - Add new patch to fix buffer descriptor overwriting issue

v1: 
 - Link: https://lore.kernel.org/lkml/1668416136-33530-1-git-send-email-zhangchangzhong@huawei.com/

Zhang Changzhong (3):
  net: nixge: fix potential memory leak in nixge_start_xmit()
  net: nixge: avoid overwriting buffer descriptor
  net: nixge: fix tx queue handling

 drivers/net/ethernet/ni/nixge.c | 58 +++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 17 deletions(-)

-- 
2.9.5

