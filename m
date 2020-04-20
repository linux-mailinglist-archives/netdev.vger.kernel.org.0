Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B8D1AFFD4
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDTCSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:18:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54782 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgDTCSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:18:43 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2201D5DD84E3FAA0EAFB;
        Mon, 20 Apr 2020 10:18:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Apr 2020 10:18:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 00/10] net: hns3: misc updates for -next
Date:   Mon, 20 Apr 2020 10:17:25 +0800
Message-ID: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes some misc updates for the HNS3 ethernet driver.

[patch 1&2] separates two bloated function.
[patch 3-5] removes some redundant code.
[patch 6-7] cleans up some coding style issues.
[patch 8-10] adds some debugging information.

Change log:
V1->V2:	removes an unnecessary initialization in [patch 1] which
	suggested by David Miller.
	modified some print format issue and commit log in [patch 8].

Guojia Liao (4):
  net: hns3: remove useless proto_support field in struct hclge_fd_cfg
  net: hns3: remove two unused structures in hclge_cmd.h
  net: hns3: modify some unsuitable type declaration
  net: hns3: add debug information for flow table when failed

Huazhong Tan (2):
  net: hns3: remove an unnecessary case 0 in hclge_fd_convert_tuple()
  net: hns3: clean up some coding style issue

Jian Shen (2):
  net: hns3: split out hclge_fd_check_ether_tuple()
  net: hns3: split out hclge_get_fd_rule_info()

Yufeng Mo (2):
  net: hns3: add support for dumping MAC reg in debugfs
  net: hns3: add trace event support for PF/VF mailbox

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  25 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 115 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 650 ++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   7 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_trace.h   |  87 +++
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   7 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h |  87 +++
 11 files changed, 675 insertions(+), 308 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h

-- 
2.7.4

