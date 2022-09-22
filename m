Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD505E5DA2
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiIVIjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIVIjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:39:01 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A64A6AE7
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:39:00 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MY7tS1sKnzHqK1;
        Thu, 22 Sep 2022 16:36:48 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 16:38:58 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <cuigaosheng1@huawei.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next,v2 0/4] Remove useless inline functions from net
Date:   Thu, 22 Sep 2022 16:38:53 +0800
Message-ID: <20220922083857.1430811-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
  1. Take the wireless patch("mlxsw: reg: Remove unused inline function
  mlxsw_reg_sftr2_pack()")out of the series.
  2. Remove the entire SFTR-V2 register in the patch("mlxsw: reg: Remove
  deprecated code about SFTR-V2 Register").
  3. Change Subject prefix to "PATCH net-next".
  Thanks for taking time to review the patch.

v1:
  This series contains a few cleanup patches, to remove unused
  inline functions who's caller have been removed. Thanks!

Gaosheng Cui (4):
  mlxsw: reg: Remove deprecated code about SFTR-V2 Register
  neighbour: Remove unused inline function neigh_key_eq16()
  net: Remove unused inline function sk_nulls_node_init()
  net: Remove unused inline function dst_hold_and_use()

 drivers/net/ethernet/mellanox/mlxsw/reg.h | 71 -----------------------
 include/net/dst.h                         |  6 --
 include/net/neighbour.h                   |  5 --
 include/net/sock.h                        |  5 --
 4 files changed, 87 deletions(-)

-- 
2.25.1

