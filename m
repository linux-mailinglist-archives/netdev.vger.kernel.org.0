Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06FD2C7423
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731761AbgK1Vtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:47 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8882 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgK1SZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:25:06 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CjsvG41slz6vRv;
        Sat, 28 Nov 2020 21:35:38 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Sat, 28 Nov 2020
 21:35:58 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
Subject: [PATCH 0/2] can: Fix the error handling in c_can_power_up and kvaser_pciefd_open
Date:   Sat, 28 Nov 2020 21:39:20 +0800
Message-ID: <20201128133922.3276973-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series fix the error handling to avoid the reference
leak and wrong state for the net device.

Zhang Qilong (2):
  can: c_can: Fix error handling in c_can_power_up
  can: kvaser_pciefd: Fix error handling in kvaser_pciefd_open

 drivers/net/can/c_can/c_can.c   | 18 ++++++++++++++----
 drivers/net/can/kvaser_pciefd.c |  4 +++-
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.25.4

