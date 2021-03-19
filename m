Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3210D34160B
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 07:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhCSGk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 02:40:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13204 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbhCSGkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 02:40:24 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F1vN40J99zmYXd;
        Fri, 19 Mar 2021 14:37:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 14:40:20 +0800
From:   Daode Huang <huangdaode@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/4] net: hinic; make some cleanup for hinic
Date:   Fri, 19 Mar 2021 14:36:21 +0800
Message-ID: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set try to remove the unnecessary output message, add a blank line,
remove the dupliate word and change the deprecated strlcp functions in
hinic driver, for details, please refer to each patch.

Daode Huang (4):
  net: hinic: Remove unnecessary 'out of memory' message
  net: hinic: add a blank line after declarations
  net: hinic: remove the repeat word "the" in comment.
  net: hinic: convert strlcpy to strscpy

 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c    | 4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c | 8 ++------
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c      | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c    | 5 +----
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c      | 1 -
 drivers/net/ethernet/huawei/hinic/hinic_rx.c         | 8 ++------
 drivers/net/ethernet/huawei/hinic/hinic_tx.c         | 1 +
 7 files changed, 9 insertions(+), 20 deletions(-)

-- 
2.8.1

