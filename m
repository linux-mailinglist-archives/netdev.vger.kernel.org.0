Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1BC316039
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhBJHpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:45:25 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12164 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBJHpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:45:07 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DbBYS43CWzlHCw;
        Wed, 10 Feb 2021 15:42:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:44:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/13] net: hns3: some cleanups for -next
Date:   Wed, 10 Feb 2021 15:43:12 +0800
Message-ID: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve code readability and maintainability, the series
refactor out some bloated functions in the HNS3 ethernet driver.

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

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  44 ++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 155 +++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 158 +++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 244 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 194 ++++++++--------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 114 ++++++----
 6 files changed, 567 insertions(+), 342 deletions(-)

-- 
2.7.4

