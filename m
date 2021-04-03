Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44563531F8
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 03:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhDCBgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 21:36:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14687 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbhDCBgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 21:36:35 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FBzwG4WHKznXpb;
        Sat,  3 Apr 2021 09:33:50 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.74.55) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sat, 3 Apr 2021 09:36:25 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH net 0/2] Misc. fixes for hns3 driver
Date:   Sat, 3 Apr 2021 02:35:18 +0100
Message-ID: <20210403013520.22108-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.74.55]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes for the miscellaneous problems found during the review of the code.

Salil Mehta (2):
  net: hns3: Remove the left over redundant check & assignment
  net: hns3: Remove un-necessary 'else-if' in the hclge_reset_event()

 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.17.1

