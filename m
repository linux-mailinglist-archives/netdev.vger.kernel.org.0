Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C3348AF8
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCYIBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:01:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13693 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCYIAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 04:00:37 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5csg0BZ3znVP1;
        Thu, 25 Mar 2021 15:57:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 16:00:29 +0800
From:   Daode Huang <huangdaode@huawei.com>
To:     <csully@google.com>, <sagis@google.com>, <jonolson@google.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <awogbemila@google.com>,
        <yangchun@google.com>, <kuozhao@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/2] net: gve: make cleanup for gve
Date:   Thu, 25 Mar 2021 15:56:30 +0800
Message-ID: <1616658992-135804-1-git-send-email-huangdaode@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set replace deprecated strlcpy by strscpy, remove
repeat word "allowed" in gve driver.
for more details, please refer to each patch.

Daode Huang (2):
  net: gve: convert strlcpy to strscpy
  net: gve: remove duplicated allowed

 drivers/net/ethernet/google/gve/gve_ethtool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.8.1

