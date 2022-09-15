Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904085B99AB
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 13:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiIOLf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 07:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIOLfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 07:35:25 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3566015A29
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 04:35:23 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSw563nJ9z14QNF;
        Thu, 15 Sep 2022 19:31:22 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 19:35:21 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 15 Sep
 2022 19:35:20 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hauke@hauke-m.de>,
        <andrew@lunn.ch>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>
Subject: [PATCH -next 0/7] net: drivers: Switch to use dev_err_probe() helper
Date:   Thu, 15 Sep 2022 19:42:07 +0800
Message-ID: <20220915114214.3145427-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the probe path, dev_err() can be replace with dev_err_probe()
which will check if error code is -EPROBE_DEFER. It will print
error code in a human readable way and simplify the code.

Yang Yingliang (7):
  net: ethernet: ti: am65-cpts: Switch to use dev_err_probe() helper
  net: ethernet: ti: cpsw: Switch to use dev_err_probe() helper
  net: ethernet: ti: cpsw_new: Switch to use dev_err_probe() helper
  net: dsa: lantiq: Switch to use dev_err_probe() helper
  net: ibm: emac: Switch to use dev_err_probe() helper
  net: stmmac: dwc-qos: Switch to use dev_err_probe() helper
  net: ll_temac: Switch to use dev_err_probe() helper

 drivers/net/dsa/lantiq_gswip.c                   |  8 +++-----
 drivers/net/ethernet/ibm/emac/core.c             |  8 +++-----
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c  |  4 +---
 drivers/net/ethernet/ti/am65-cpts.c              |  7 ++-----
 drivers/net/ethernet/ti/cpsw.c                   |  3 +--
 drivers/net/ethernet/ti/cpsw_new.c               |  5 ++---
 drivers/net/ethernet/xilinx/ll_temac_main.c      | 16 ++++++----------
 7 files changed, 18 insertions(+), 33 deletions(-)

-- 
2.25.1

