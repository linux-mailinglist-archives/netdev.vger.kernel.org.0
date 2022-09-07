Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650F15AFC5E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIGG27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIGG25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:28:57 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3D39BB78;
        Tue,  6 Sep 2022 23:28:56 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MMsjb2RvGzHnnD;
        Wed,  7 Sep 2022 14:26:59 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 14:28:53 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 14:28:53 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xuhaoyue1@hisilicon.com>, <pabeni@redhat.com>,
        <edumazet@google.com>, <huangdaode@huawei.com>,
        <liangwenpeng@huawei.com>, <liyangyang20@huawei.com>
Subject: [PATCH net-next 0/3] net: amd: Cleanup for clearing static warnings
Date:   Wed, 7 Sep 2022 14:28:09 +0800
Message-ID: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most static warnings are detected by tools, mainly about:

(1) #1: About the if stament.
(2) #2: About the spelling.
(2) #3: About the indent.

Guofeng Yue (3):
  net: amd: Unified the comparison between pointers and NULL to the same
    writing
  net: amd: Correct spelling errors
  net: amd: Switch and case should be at the same indent

 drivers/net/ethernet/amd/a2065.c      |  2 +-
 drivers/net/ethernet/amd/amd8111e.c   | 45 +++++++++++++--------------
 drivers/net/ethernet/amd/amd8111e.h   |  2 +-
 drivers/net/ethernet/amd/ariadne.c    |  4 +--
 drivers/net/ethernet/amd/atarilance.c | 10 +++---
 drivers/net/ethernet/amd/au1000_eth.c |  6 ++--
 drivers/net/ethernet/amd/lance.c      |  4 +--
 drivers/net/ethernet/amd/nmclan_cs.c  | 18 +++++------
 drivers/net/ethernet/amd/pcnet32.c    | 12 +++----
 drivers/net/ethernet/amd/sun3lance.c  |  4 +--
 drivers/net/ethernet/amd/sunlance.c   |  4 +--
 11 files changed, 55 insertions(+), 56 deletions(-)

-- 
2.30.0

