Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D5061D9DB
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 13:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiKEMUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 08:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiKEMT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 08:19:58 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B8BE09B
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 05:19:57 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N4GgN1BDvzpW8r;
        Sat,  5 Nov 2022 20:16:16 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 5 Nov 2022 20:19:52 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 5 Nov
 2022 20:19:51 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <jiaxun.yang@flygoat.com>, <zhangqing@loongson.cn>,
        <liupeibao@loongson.cn>, <andrew@lunn.ch>, <kuba@kernel.org>
Subject: [PATCH net 0/3] stmmac: dwmac-loongson: fixes three leaks
Date:   Sat, 5 Nov 2022 20:18:37 +0800
Message-ID: <20221105121840.3654266-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch #2 fixes missing pci_disable_device() in the error path in probe()
patch #1 and pach #3 fix missing pci_disable_msi() and of_node_put() in
error and remove() path.

Yang Yingliang (3):
  stmmac: dwmac-loongson: fix missing pci_disable_msi() while module
    exiting
  stmmac: dwmac-loongson: fix missing pci_disable_device() in
    loongson_dwmac_probe()
  stmmac: dwmac-loongson: fix missing of_node_put() while module exiting

 .../ethernet/stmicro/stmmac/dwmac-loongson.c  | 37 +++++++++++++++----
 1 file changed, 29 insertions(+), 8 deletions(-)

-- 
2.25.1

