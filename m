Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8D843E3A8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhJ1O3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:29:39 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29947 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhJ1O3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:29:38 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hg7761FS7zbnB3;
        Thu, 28 Oct 2021 22:22:26 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 22:27:05 +0800
Received: from compute.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 22:27:05 +0800
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
Subject: [PATCH net v2 0/3] can: j1939: fix some standard conformance problems
Date:   Thu, 28 Oct 2021 22:38:24 +0800
Message-ID: <1635431907-15617-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes 3 standard conformance problems in the j1939 stack.

v2:
- Add netdev_err_once() to indicate bad messages on the bus.
- Fix the if statement in the third patch to avoid breaking ETP
  functionality.

Zhang Changzhong (3):
  can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM
    transport
  can: j1939: j1939_can_recv(): ignore messages with invalid source
    address
  can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM

 net/can/j1939/main.c      |  6 ++++++
 net/can/j1939/transport.c | 11 +++++++++++
 2 files changed, 17 insertions(+)

-- 
2.9.5

