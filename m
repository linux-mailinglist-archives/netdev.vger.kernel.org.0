Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D69B4A1B3
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfFRNID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:08:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726428AbfFRNIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:08:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6C28A2B94719775A3256;
        Tue, 18 Jun 2019 21:07:58 +0800 (CST)
Received: from huawei.com (10.175.100.202) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Jun 2019
 21:07:50 +0800
From:   luoshijie <luoshijie1@huawei.com>
To:     <davem@davemloft.net>, <tgraf@suug.ch>, <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <wangxiaogang3@huawei.com>, <mingfangsen@huawei.com>,
        <zhoukang7@huawei.com>
Subject: [PATCH v2 0/3] fix bugs when enable route_localnet
Date:   Tue, 18 Jun 2019 15:14:02 +0000
Message-ID: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.202]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shijie Luo <luoshijie1@huawei.com>

When enable route_localnet, route of the 127/8 address is enabled.
But in some situations like arp_announce=2, ARP requests or reply
work abnormally.

This patchset fix some bugs when enable route_localnet. 

Change History:
V2:
- Change a single patch to a patchset.
- Add bug fix for arp_ignore = 3.
- Add a couple of test for enabling route_localnet in selftests.

Shijie Luo (3):
  ipv4: fix inet_select_addr() when enable route_localnet
  ipv4: fix confirm_addr_indev() when enable route_localnet
  selftests: add route_localnet test script

 net/ipv4/devinet.c                            | 15 +++-
 tools/testing/selftests/net/route_localnet.sh | 74 +++++++++++++++++++
 2 files changed, 86 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/net/route_localnet.sh

-- 
2.19.1

