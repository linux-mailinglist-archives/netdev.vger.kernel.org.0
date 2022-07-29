Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20832584EA3
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiG2KYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiG2KYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:24:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8B8820DC;
        Fri, 29 Jul 2022 03:24:53 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LvNnz3H3rzWg24;
        Fri, 29 Jul 2022 18:20:55 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 18:24:50 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 18:24:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <snelson@pensando.io>, <brett@pensando.io>,
        <drivers@pensando.io>, <anthony.l.nguyen@intel.com>,
        <jesse.brandeburg@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net 0/2] net: fix using wrong flags to check features
Date:   Fri, 29 Jul 2022 18:17:53 +0800
Message-ID: <20220729101755.4798-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We find that some drivers may use wrong flags to check features, so fix
them.

Jian Shen (2):
  net: ice: fix error NETIF_F_HW_VLAN_CTAG_FILTER check in
    ice_vsi_sync_fltr()
  net: ionic: fix error check for vlan flags in ionic_set_nic_features()

 drivers/net/ethernet/intel/ice/ice_main.c       | 2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.33.0

