Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C46139DB1A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhFGLXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:23:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7126 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFGLXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:23:12 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fz9pv2MqszYsmR;
        Mon,  7 Jun 2021 19:18:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 19:21:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 19:21:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/3] net: hns3: refactors and decouples the error handling logic
Date:   Mon, 7 Jun 2021 19:18:09 +0800
Message-ID: <1623064692-24205-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset refactors and decouples the error handling logic from reset
logic, it is the preset patch of the RAS feature. It mainly implements the
function that reset logic remains independent of the error handling logic,
this will ensure that common misellaneous MSI-X interrupt are re-enabled
quickly.

Jiaran Zhang (2):
  net: hns3: add a separate error handling task
  net: hns3: add scheduling logic for error handling task

Yufeng Mo (1):
  net: hns3: remove now redundant logic related to HNAE3_UNKNOWN_RESET

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 80 ++++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 4 files changed, 47 insertions(+), 39 deletions(-)

-- 
2.8.1

