Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391381FDAAF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgFRBEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:04:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6357 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgFRBEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:04:16 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 06DC7CEB704294C3E634;
        Thu, 18 Jun 2020 09:04:14 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.203.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 09:04:06 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <netdev@vger.kernel.org>, <linyunsheng@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 0/5] net: hns3: a bundle of minor cleanup and fixes
Date:   Thu, 18 Jun 2020 13:02:06 +1200
Message-ID: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.203.42]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

some minor changes to either improve the readability or make the code align
with linux APIs better.

Barry Song (5):
  net: hns3: remove unnecessary devm_kfree
  net: hns3: pointer type of buffer should be void
  net: hns3: rename buffer-related functions
  net: hns3: replace disable_irq by IRQ_NOAUTOEN flag
  net: hns3: streaming dma buffer sync between cpu and device

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 41 ++++++++++++-------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  2 +-
 2 files changed, 28 insertions(+), 15 deletions(-)

-- 
2.23.0


