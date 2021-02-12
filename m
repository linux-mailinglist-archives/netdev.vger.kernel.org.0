Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640B83198B4
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBLDWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:22:42 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12509 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhBLDW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:22:28 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DcJfC4YDpzjMHN;
        Fri, 12 Feb 2021 11:20:19 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:21:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 00/13] net: hns3: some cleanups for -next
Date:   Fri, 12 Feb 2021 11:21:00 +0800
Message-ID: <20210212032113.5384-1-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve code readability and maintainability, the series
refactor out some bloated functions in the HNS3 ethernet driver.

change log:
V2: remove an unused variable in #5

previous version:
V1: https://patchwork.kernel.org/project/netdevbpf/cover/1612943005-59416-1-git-send-email-tanhuazhong@huawei.com/

Hao Chen (1):
  net: hns3: refactor out hclge_rm_vport_all_mac_table()

Huazhong Tan (2):
  net: hns3: refactor out hclge_set_rss_tuple()
  net: hns3: refactor out hclgevf_set_rss_tuple()

Jian Shen (3):
  net: hns3: refactor out hclge_get_rss_tuple()
  net: hns3: refactor out hclgevf_get_rss_tuple()
  net: hns3: split out hclge_dbg_dump_qos_buf_cfg()

Jiaran Zhang (1):
  net: hns3: use ipv6_addr_any() helper

Peng Li (4):
  net: hns3: refactor out hclge_cmd_convert_err_code()
  net: hns3: refactor out hclgevf_cmd_convert_err_code()
  net: hns3: clean up hns3_dbg_cmd_write()
  net: hns3: refactor out hclge_set_vf_vlan_common()

Yufeng Mo (2):
  net: hns3: split out hclge_cmd_send()
  net: hns3: split out hclgevf_cmd_send()

 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  44 +--
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 155 ++++++-----
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 158 ++++++++---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 254 +++++++++++-------
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 194 +++++++------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 114 +++++---
 6 files changed, 571 insertions(+), 348 deletions(-)

-- 
2.25.1

