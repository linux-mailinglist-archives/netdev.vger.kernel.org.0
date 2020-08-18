Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011E3248426
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHRLuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:50:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9763 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726391AbgHRLuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 07:50:04 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1E2F44D42F6938B08976;
        Tue, 18 Aug 2020 19:50:02 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 19:49:51 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <tiwei.bie@intel.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] vdpa: Remove duplicate include
Date:   Tue, 18 Aug 2020 19:49:06 +0800
Message-ID: <20200818114906.58304-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicate include file

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/vhost/vdpa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3fab94f88894..95e2b8307a2a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -22,7 +22,6 @@
 #include <linux/nospec.h>
 #include <linux/vhost.h>
 #include <linux/virtio_net.h>
-#include <linux/kernel.h>
 
 #include "vhost.h"
 
-- 
2.17.1


