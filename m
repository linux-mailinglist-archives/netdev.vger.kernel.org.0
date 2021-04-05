Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8011E3545D3
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhDERI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:08:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16339 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhDERIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 13:08:18 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FDcVs1KHvz9wyg;
        Tue,  6 Apr 2021 01:05:57 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.69.183) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 01:07:58 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH V2 net 0/2] Misc. fixes for hns3 driver
Date:   Mon, 5 Apr 2021 18:06:43 +0100
Message-ID: <20210405170645.29620-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.69.183]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes for the miscellaneous problems found during the review of the code.

Change Summary:
 Patch 1/2, Change V1->V2:
   [1] Fixed comments from Leon Romanovsky
       Link: https://lkml.org/lkml/2021/4/4/14
 Patch 2/2, Change V1->V2:
   None

Salil Mehta (2):
  net: hns3: Remove the left over redundant check & assignment
  net: hns3: Remove un-necessary 'else-if' in the hclge_reset_event()

 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
2.17.1

