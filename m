Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BF513002C
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgADCtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727074AbgADCtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:35 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 86F0A467A47E4DDE2BF0;
        Sat,  4 Jan 2020 10:49:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Sat, 4 Jan 2020 10:49:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/8] net: hns3: misc updates for -net-next
Date:   Sat, 4 Jan 2020 10:49:23 +0800
Message-ID: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some misc updates for the HNS3 ethernet driver.

[patch 1] adds trace events support.
[patch 2] re-organizes TQP's vector handling.
[patch 3] renames the name of TQP vector.
[patch 4] rewrites a log in the hclge_map_ring_to_vector().
[patch 5] modifies the name of misc IRQ vector.
[patch 6] handles the unexpected speed 0 return from HW.
[patch 7] replaces an unsuitable variable type.
[patch 8] modifies an unsuitable reset level for HW error.

Guojia Liao (1):
  net: hns3: add protection when get SFP speed as 0

Huazhong Tan (2):
  net: hns3: replace an unsuitable variable type in
    hclge_inform_reset_assert_to_vf()
  net: hns3: modify an unsuitable reset level for hardware error

Yonglong Liu (4):
  net: hns3: re-organize vector handle
  net: hns3: modify the IRQ name of TQP vector
  net: hns3: modify an unsuitable log in hclge_map_ring_to_vector()
  net: hns3: modify the IRQ name of misc vectors

Yunsheng Lin (1):
  net: hns3: add trace event support for HNS3 driver

 drivers/net/ethernet/hisilicon/hns3/Makefile       |   2 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 153 +++++++++++++--------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_trace.h   | 139 +++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  12 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 11 files changed, 259 insertions(+), 67 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_trace.h

-- 
2.7.4

