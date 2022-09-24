Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67635E8773
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiIXCdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiIXCdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541461514FE;
        Fri, 23 Sep 2022 19:33:13 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MZCdN1YJszWgsX;
        Sat, 24 Sep 2022 10:29:12 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:11 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:11 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 00/14] redefine some macros of feature abilities judgement
Date:   Sat, 24 Sep 2022 10:30:10 +0800
Message-ID: <20220924023024.14219-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macros hnae3_dev_XXX_supported just can be used in hclge layer, but
hns3_enet layer may need to use, so this serial redefine these macros.

Guangbin Huang (14):
  net: hns3: modify macro hnae3_dev_fec_supported
  net: hns3: modify macro hnae3_dev_udp_gso_supported
  net: hns3: modify macro hnae3_dev_qb_supported
  net: hns3: modify macro hnae3_dev_fd_forward_tc_supported
  net: hns3: modify macro hnae3_dev_ptp_supported
  net: hns3: modify macro hnae3_dev_int_ql_supported
  net: hns3: modify macro hnae3_dev_hw_csum_supported
  net: hns3: modify macro hnae3_dev_tx_push_supported
  net: hns3: modify macro hnae3_dev_phy_imp_supported
  net: hns3: modify macro hnae3_dev_ras_imp_supported
  net: hns3: delete redundant macro hnae3_dev_tqp_txrx_indep_supported
  net: hns3: modify macro hnae3_dev_hw_pad_supported
  net: hns3: modify macro hnae3_dev_stash_supported
  net: hns3: modify macro hnae3_dev_pause_supported

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   | 55 +++++++++----------
 .../hns3/hns3_common/hclge_comm_cmd.c         |  2 +-
 .../hns3/hns3_common/hclge_comm_cmd.h         |  3 -
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 10 ++--
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 14 ++---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  2 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 38 ++++++-------
 .../hisilicon/hns3/hns3pf/hclge_ptp.c         |  2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 +-
 10 files changed, 62 insertions(+), 68 deletions(-)

-- 
2.33.0

