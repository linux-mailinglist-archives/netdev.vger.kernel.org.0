Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDC759718A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbiHQOjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240199AbiHQOi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:38:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F519C1F3;
        Wed, 17 Aug 2022 07:38:00 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M79Vw42MPzXdnW;
        Wed, 17 Aug 2022 22:33:44 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 22:37:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 22:37:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <idosch@nvidia.com>,
        <linux@rempel-privat.de>, <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/2] net: ethtool add VxLAN to the NFC API
Date:   Wed, 17 Aug 2022 22:35:36 +0800
Message-ID: <20220817143538.43717-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for steering VxLAN flows using the ethtool NFC
interface, and implements it for hns3 devices.

Guangbin Huang (2):
  net: ethtool: add VxLAN to the NFC API
  net: hns3: support set/get VxLAN rule of rx flow director by ethtool

 .../hisilicon/hns3/hns3pf/hclge_main.c        | 272 +++++++++++++++++-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   2 +
 include/uapi/linux/ethtool.h                  |  48 ++++
 3 files changed, 319 insertions(+), 3 deletions(-)

-- 
2.33.0

