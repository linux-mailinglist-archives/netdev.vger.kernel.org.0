Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1E143637C
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhJUN4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:56:30 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26178 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhJUN43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 09:56:29 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HZppH3t3lz8tmB;
        Thu, 21 Oct 2021 21:52:55 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 21 Oct 2021 21:54:11 +0800
Received: from compute.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 21 Oct 2021 21:54:10 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/3] can: j1939: fix some standard conformance problems
Date:   Thu, 21 Oct 2021 22:04:14 +0800
Message-ID: <1634825057-47915-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes 3 standard conformance problems in the j1939 stack.

Zhang Changzhong (3):
  can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM
    transport
  can: j1939: j1939_can_recv(): ignore messages with invalid source
    address
  can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM

 net/can/j1939/main.c      | 4 ++++
 net/can/j1939/transport.c | 5 +++++
 2 files changed, 9 insertions(+)

-- 
2.9.5

