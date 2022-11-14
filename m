Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA69562779F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbiKNI22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236313AbiKNI21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:28:27 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C57BC3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:28:25 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N9j5x6C0jzqSPB;
        Mon, 14 Nov 2022 16:24:37 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 16:28:23 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <alexander.h.duyck@intel.com>,
        <jeffrey.t.kirsher@intel.com>, <matthew.vick@intel.com>,
        <jacob.e.keller@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH 0/2] Fix error handling path
Date:   Mon, 14 Nov 2022 08:26:38 +0000
Message-ID: <20221114082640.91128-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
  fm10k: Fix error handling in fm10k_init_module()
  iavf: Fix error handling in iavf_init_module()

 drivers/net/ethernet/intel/fm10k/fm10k_main.c | 10 +++++++++-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  9 ++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

-- 
2.17.1

