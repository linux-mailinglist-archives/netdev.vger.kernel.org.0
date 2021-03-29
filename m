Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF5534C604
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhC2IEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:04:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15370 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbhC2IDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:03:48 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F84m71rhdz9sDj;
        Mon, 29 Mar 2021 16:01:43 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 16:03:40 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sebastian.hesselbarth@gmail.com>, <thomas.petazzoni@bootlin.com>,
        <mlindner@marvell.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 0/4] net: marvell: fix some coding style
Date:   Mon, 29 Mar 2021 16:01:08 +0800
Message-ID: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do some cleanups according to the coding style of kernel.

Yangyang Li (4):
  net: marvell: Delete duplicate word in comments
  net: marvell: Fix the trailing format of some block comments
  net: marvell: Delete extra spaces
  net: marvell: Fix an alignment problem

 drivers/net/ethernet/marvell/mv643xx_eth.c |  6 ++++--
 drivers/net/ethernet/marvell/mvneta.c      | 12 ++++++------
 drivers/net/ethernet/marvell/skge.c        |  9 +++++----
 drivers/net/ethernet/marvell/sky2.c        |  9 ++++++---
 4 files changed, 21 insertions(+), 15 deletions(-)

-- 
2.8.1

