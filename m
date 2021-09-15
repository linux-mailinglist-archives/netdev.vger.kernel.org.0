Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9621B40C6CE
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 15:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbhION5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 09:57:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9053 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbhION5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 09:57:38 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H8hYY4G3zzVr0w;
        Wed, 15 Sep 2021 21:55:13 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 0/6] net: hns3: add some fixes for -net
Date:   Wed, 15 Sep 2021 21:52:05 +0800
Message-ID: <20210915135211.9129-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Jian Shen (2):
  net: hns3: fix change RSS 'hfunc' ineffective issue
  net: hns3: fix inconsistent vf id print

Jiaran Zhang (1):
  net: hns3: fix misuse vf id and vport id in some logs

Yufeng Mo (2):
  net: hns3: check queue id range before using
  net: hns3: fix a return value error in hclge_get_reset_status()

liaoguojia (1):
  net: hns3: check vlan id before using it

 .../hisilicon/hns3/hns3pf/hclge_err.c         |  8 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 80 +++++++++++++------
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 10 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 52 +++++++-----
 5 files changed, 103 insertions(+), 49 deletions(-)

-- 
2.33.0

