Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B38274335
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIVNev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:34:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58276 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726573AbgIVNev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 09:34:51 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CBCBD73E11DE685DCD63;
        Tue, 22 Sep 2020 21:34:47 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 22 Sep 2020 21:34:45 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] net: switchdev: Fixed kerneldoc warning
Date:   Tue, 22 Sep 2020 21:32:19 +0800
Message-ID: <1600781539-31676-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel-doc line comments to fix warnings reported by make W=1.
net/switchdev/switchdev.c:413: warning: Function parameter or
member 'extack' not described in 'call_switchdev_notifiers'

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 net/switchdev/switchdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 865f3e0..23d8685 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -404,7 +404,7 @@ EXPORT_SYMBOL_GPL(unregister_switchdev_notifier);
  *	@val: value passed unmodified to notifier function
  *	@dev: port device
  *	@info: notifier information data
- *
+ *	@extack: netlink extended ack
  *	Call all network notifier blocks.
  */
 int call_switchdev_notifiers(unsigned long val, struct net_device *dev,
-- 
2.7.4

