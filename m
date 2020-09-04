Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A7C25D3C4
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgIDIgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:36:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51078 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726655AbgIDIgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 04:36:37 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D3F42CBFBBCC4E94F34A;
        Fri,  4 Sep 2020 16:36:35 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Sep 2020 16:36:26 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net v1 0/2] hinic: BugFixes
Date:   Fri, 4 Sep 2020 16:37:27 +0800
Message-ID: <20200904083729.1923-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bugs fixed in this patchset have been present since the following
commits:
patch #1: Fixes: 00e57a6d4ad3 ("net-next/hinic: Add Tx operation")
patch #2: Fixes: 5e126e7c4e52 ("hinic: add firmware update support")

Luo bin (2):
  hinic: bump up the timeout of SET_FUNC_STATE cmd
  hinic: bump up the timeout of UPDATE_FW cmd

 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 20 ++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

-- 
2.17.1

