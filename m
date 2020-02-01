Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03AAA14F902
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgBAQn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:43:56 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51767 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:43:56 -0500
Received: by mail-pj1-f68.google.com with SMTP id fa20so4341353pjb.1
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YTGkJu+m4v8swIov2QhsLT2nGbC1Aymk5/iW43KkcEs=;
        b=i31OC3WsF2V6i6uaMkakCSpGHm2ZtFPjF9P1MIBXrKTpWA9NUyr7cbDwtmc2ZqN8Vh
         thG8crnsm73KmVEf2IyyLqpqHjIjtj0bG2Xf7J6C3IJyvhusnJ+SPQZmEvA4LD7QrN33
         30Um9ir3TC2BydZu3OMoWKS3iff+3uckcfp2dRCslftsUfU0olXIb38jPKL0slcSLH52
         lkWhyFcza5Mj4MyoVUhTe7AKPLzCEWBEdla1R+CjlcyvwbTBZ1zde8371l9IQ4Bm2TRV
         f/ZwJTx05haRcFppPfc1DEWMn18CJ2hohgUxL6IEeVoqvWPwiDHHPWbkSZy13bTVIhmr
         zV/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YTGkJu+m4v8swIov2QhsLT2nGbC1Aymk5/iW43KkcEs=;
        b=L330eE284ysCWc06wK/A+FY8d7gS2nggwKrxPxeUkMQK9Rxo5k3zguB119Ft8Fhq64
         eukzQYjTPz4dg+pa9eUv0hUs1oQL6IoEi4ePRlod5MiZTBv51Fo2bm7By3aGtCB9J6fc
         dxs/7o/ZBurRQ0D0hcGuaU0g7sWEeL7fK58uXciq9/72z98xCKpFO+tdFbTXXYSANKgH
         zckmBgXuz23MvfFHBAdUR4RaQpsYc/mv5gPqz+5PuVIaNyVubrhM92sHfTUobVyps90O
         zYxPZQdBpudQCHwb0bqZUm8vTXoA5P3Pc4idSzRlwuwniQFhxMkXb9ZL0k3zUjqapbZf
         qY4Q==
X-Gm-Message-State: APjAAAWXAKyNJxw74NiU0xw8TL29YoTUtcL65gWxAm16KI+xc3322RuJ
        XZgKXLmRYI1r9ZbcXzffAo6PXfYw
X-Google-Smtp-Source: APXvYqzKgCyuHvKToJZJZyVuixgCx/5zgzlBJWUVyFUvyqj+WFrtYjAVZxH+bjQr+w2qNZCFlbFdVg==
X-Received: by 2002:a17:90a:1951:: with SMTP id 17mr19513689pjh.101.1580575435200;
        Sat, 01 Feb 2020 08:43:55 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s7sm14849775pjk.22.2020.02.01.08.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:43:54 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 7/7] netdevsim: remove unused sdev code
Date:   Sat,  1 Feb 2020 16:43:48 +0000
Message-Id: <20200201164348.10317-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdev.c code is merged into dev.c and is not used anymore.
it would be removed.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3:
 - Include Reviewed-by tag

v2:
 - Initial patch

 drivers/net/netdevsim/sdev.c | 69 ------------------------------------
 1 file changed, 69 deletions(-)
 delete mode 100644 drivers/net/netdevsim/sdev.c

diff --git a/drivers/net/netdevsim/sdev.c b/drivers/net/netdevsim/sdev.c
deleted file mode 100644
index 6712da3340d6..000000000000
--- a/drivers/net/netdevsim/sdev.c
+++ /dev/null
@@ -1,69 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2019 Mellanox Technologies. All rights reserved */
-
-#include <linux/debugfs.h>
-#include <linux/err.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-
-#include "netdevsim.h"
-
-static struct dentry *nsim_sdev_ddir;
-
-static u32 nsim_sdev_id;
-
-struct netdevsim_shared_dev *nsim_sdev_get(struct netdevsim *joinns)
-{
-	struct netdevsim_shared_dev *sdev;
-	char sdev_ddir_name[10];
-	int err;
-
-	if (joinns) {
-		if (WARN_ON(!joinns->sdev))
-			return ERR_PTR(-EINVAL);
-		sdev = joinns->sdev;
-		sdev->refcnt++;
-		return sdev;
-	}
-
-	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
-	if (!sdev)
-		return ERR_PTR(-ENOMEM);
-	sdev->refcnt = 1;
-	sdev->switch_id = nsim_sdev_id++;
-
-	sprintf(sdev_ddir_name, "%u", sdev->switch_id);
-	sdev->ddir = debugfs_create_dir(sdev_ddir_name, nsim_sdev_ddir);
-	if (IS_ERR_OR_NULL(sdev->ddir)) {
-		err = PTR_ERR_OR_ZERO(sdev->ddir) ?: -EINVAL;
-		goto err_sdev_free;
-	}
-
-	return sdev;
-
-err_sdev_free:
-	nsim_sdev_id--;
-	kfree(sdev);
-	return ERR_PTR(err);
-}
-
-void nsim_sdev_put(struct netdevsim_shared_dev *sdev)
-{
-	if (--sdev->refcnt)
-		return;
-	debugfs_remove_recursive(sdev->ddir);
-	kfree(sdev);
-}
-
-int nsim_sdev_init(void)
-{
-	nsim_sdev_ddir = debugfs_create_dir(DRV_NAME "_sdev", NULL);
-	if (IS_ERR_OR_NULL(nsim_sdev_ddir))
-		return -ENOMEM;
-	return 0;
-}
-
-void nsim_sdev_exit(void)
-{
-	debugfs_remove_recursive(nsim_sdev_ddir);
-}
-- 
2.17.1

