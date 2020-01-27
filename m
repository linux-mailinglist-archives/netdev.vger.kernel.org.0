Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF6B14A629
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgA0ObR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:31:17 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41704 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgA0ObR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:31:17 -0500
Received: by mail-pl1-f196.google.com with SMTP id t14so3809131plr.8
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 06:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4lFy+Z3vbhpMmzpcZLstEix7Vd2C2/L8RiV4vAfWX6w=;
        b=LU9/gXGQ2PB5wC1LkEnRJr34gTs4Fn87pcSXr0Keu3d9hc2gDZuxyD4KYGE3l4Ub8w
         EEFl0LUJJfumBkIie+519S7FuuUQP3xITc3jOzgBj39c7MzzwzGeQGIFZrkHLcps30L2
         x4kdIVKMt/QFQCpX6Mn1n+pGJ9cNbrbyyqJa82gpMmUxAhJ2Rvvh5dQ5C7duv8Z+IYMv
         2nI1jXAK6A3dYMDYweUSO10EhhBamqKILvB9Abu40HP/PAGp3evdR+t+M82UJ/H1xF9n
         svD9w1BQA2uTcSBbJb1/3ARVffYzDSla7AQJaYclY7awLCkgOmABi6XwYqkd4BhLpcSB
         LjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4lFy+Z3vbhpMmzpcZLstEix7Vd2C2/L8RiV4vAfWX6w=;
        b=aF2Qtg0hK7fT0ToyBYQhpxdxgmDGLTOv5WzTGNiqXoVhBcWYBRwTMaFWUZlk3atXDL
         LGBpiW+vZkKWY/3ksyN4qqmXzmoWemfZkXC3BedJT7coJkRRFyWQBkY6ojNY9TcmEVJM
         YdYp2c73pNrWi92mrpIt96U+SaPjp6TJ7tSV0CkbizrrKekPH5bXjstquSrgA3T9Sijx
         gUWQqinrde+6RQEgQ1ztB8+jdvKkxUt5E8VAb2FC4FVfFDYSOlejxZa7O10JeLMOPmZw
         Yi1MC9oipb5u1re4hubNmvRw5ShWUBRrckreywQW8U/oQUcuktfFsND+/C4o1G5KMLAm
         5v3A==
X-Gm-Message-State: APjAAAVAq2JDrJ5qX5/vJ18foSaqVqQLPk2Xhgd59tai9qpGOsbmDZns
        o9QtilCSSSDS+bWqiKfEfTw=
X-Google-Smtp-Source: APXvYqxelmJPWCo8wd/XX83mqDeQMcXekZ/Qw6JMcITPv72clsNG+CBEvG4G37jH3U+bH+6PyXdTsA==
X-Received: by 2002:a17:90a:c705:: with SMTP id o5mr14498836pjt.67.1580135476338;
        Mon, 27 Jan 2020 06:31:16 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id d189sm16366498pga.70.2020.01.27.06.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 06:31:15 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 6/6] netdevsim: remove unused sdev code
Date:   Mon, 27 Jan 2020 14:31:09 +0000
Message-Id: <20200127143109.1644-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdev.c code is merged into dev.c and is not used anymore.
it would be removed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
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

