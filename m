Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967EF5BFA10
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiIUJFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiIUJFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:05:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97F232D86;
        Wed, 21 Sep 2022 02:04:58 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXXSd3Hz5zlWlg;
        Wed, 21 Sep 2022 17:00:49 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 17:04:55 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <nbd@nbd.name>, <lorenzo@kernel.org>, <ryder.lee@mediatek.com>,
        <shayne.chen@mediatek.com>, <sean.wang@mediatek.com>,
        <kvalo@kernel.org>, <matthias.bgg@gmail.com>, <amcohen@nvidia.com>,
        <stephen@networkplumber.org>, <cuigaosheng1@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 0/5] Remove useless inline functions from net
Date:   Wed, 21 Sep 2022 17:04:50 +0800
Message-ID: <20220921090455.752011-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a few cleanup patches, to remove unused
inline functions who's caller have been removed. Thanks!

Gaosheng Cui (5):
  mlxsw: reg: Remove unused inline function mlxsw_reg_sftr2_pack()
  mt76: Remove unused inline function mt76_wcid_mask_test()
  neighbour: Remove unused inline function neigh_key_eq16()
  net: Remove unused inline function sk_nulls_node_init()
  net: Remove unused inline function dst_hold_and_use()

 drivers/net/ethernet/mellanox/mlxsw/reg.h | 16 ----------------
 drivers/net/wireless/mediatek/mt76/util.h |  6 ------
 include/net/dst.h                         |  6 ------
 include/net/neighbour.h                   |  5 -----
 include/net/sock.h                        |  5 -----
 5 files changed, 38 deletions(-)

-- 
2.25.1

