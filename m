Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069732BFE10
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 02:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgKWBr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 20:47:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7665 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgKWBr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 20:47:28 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CfVQ21d77z15QZg;
        Mon, 23 Nov 2020 09:47:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 09:47:19 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] wlcore: Switch to using the new API kobj_to_dev()
Date:   Mon, 23 Nov 2020 09:47:42 +0800
Message-ID: <1606096062-32251-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to using the new API kobj_to_dev().

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/net/wireless/ti/wlcore/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
index 7ac1814..5cf0379 100644
--- a/drivers/net/wireless/ti/wlcore/sysfs.c
+++ b/drivers/net/wireless/ti/wlcore/sysfs.c
@@ -100,7 +100,7 @@ static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
 				       struct bin_attribute *bin_attr,
 				       char *buffer, loff_t pos, size_t count)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct wl1271 *wl = dev_get_drvdata(dev);
 	ssize_t len;
 	int ret;
-- 
2.7.4

