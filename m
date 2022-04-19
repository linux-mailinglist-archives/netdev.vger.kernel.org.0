Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165055062C3
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 05:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348025AbiDSDfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 23:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347585AbiDSDfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 23:35:36 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E762B264;
        Mon, 18 Apr 2022 20:32:55 -0700 (PDT)
Received: from kwepemi100012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kj8Wh1jbhzdZqH;
        Tue, 19 Apr 2022 11:32:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100012.china.huawei.com (7.221.188.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 11:32:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 11:32:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH V2 net-next 0/9] net: hns3: updates for -next
Date:   Tue, 19 Apr 2022 11:27:00 +0800
Message-ID: <20220419032709.15408-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some updates for the HNS3 ethernet driver.

Change logs:
V1 -> V2:
 - Fix failed to apply to net-next problem.

Hao Chen (3):
  net: hns3: refactor hns3_set_ringparam()
  net: hns3: add log for setting tx spare buf size
  net: hns3: remove unnecessary line wrap for hns3_set_tunable

Jian Shen (1):
  net: hns3: refine the definition for struct hclge_pf_to_vf_msg

Jie Wang (1):
  net: hns3: add failure logs in hclge_set_vport_mtu

Peng Li (3):
  net: hns3: update the comment of function hclgevf_get_mbx_resp
  net: hns3: fix the wrong words in comments
  net: hns3: replace magic value by HCLGE_RING_REG_OFFSET

Yufeng Mo (1):
  net: hns3: add ethtool parameter check for CQE/EQE mode

 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  17 ++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   4 +
 .../hns3/hns3_common/hclge_comm_cmd.c         |   2 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |   1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   5 +-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 108 +++++++++++++-----
 .../ethernet/hisilicon/hns3/hns3_ethtool.h    |   6 +
 .../hisilicon/hns3/hns3pf/hclge_err.c         |   2 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   3 +
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |   2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |   4 +-
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |   8 +-
 12 files changed, 116 insertions(+), 46 deletions(-)

-- 
2.33.0

