Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACDA38FF3D
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhEYKdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhEYKca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:32:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EF8C061360
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b66-20020a25cb450000b02905076ea039f1so41221979ybg.1
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UE+HjfxcPfNKpn+LLD6KzEjtEN8+VZDaYe+49pvXWPU=;
        b=QMhzADDD4vjHpgsAMk+pmQTaEaoyxrtF2UEO7FPsS6CnyI/EzysxrHEiVbLuFFC3z7
         KQbcdgDJBgI9BLyMV1tWqaZUi2yOU8KdE2d+j7BGdyoqOAudIt+UmRfS1OoBC8nvvl1W
         LK2+Q2etUTP4qt5mCoQOnlaYOTxgOrVtvjg4iFl4/NdBvW1XGzr6f00sJvgbxXVFKbAw
         Dt3rLVgFTf3hZRApDPA5eQD5OvWQcUEyjPmukOZX51geK+0zkCVevBv50rZf69Nr51NV
         gAWHfcT7aam2W02g8y+JdzddcXTnKZ5ITv8EvsVmHAF7Hlgie5yrh+Uo/W5J5dr+8eF3
         Odxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UE+HjfxcPfNKpn+LLD6KzEjtEN8+VZDaYe+49pvXWPU=;
        b=fVNldMEMuhO1wRNpz83GgzxaPxoQHPeptHogBYaEwOXtR6ZU4mPYahu8dD60VcQHuk
         C3aT1r1X/53gr1YpQZQnFt/qC9rPUBbxW1bDfdv800v6uGIcrDOXv2YlrSWcSX0cS+nh
         U5hXeVsgEgwjxCi2g/uVtkkmcZlLgWAe5K9dF2khTBSHoOwh3wuDuZ+vTIvkQgtR1+WK
         /q4v2lrTFmoGHZG3oXzxpkDqDfiqCNnnJMOQHPpRNqm8/4mc4rUn33VM2aeBdOa9KdLb
         U1nM985byE1sB0ilDLU9YaseWSt5BseYdrgt1sJ8jsAuFPigQGV32KZf1SdpVT3+7/80
         ghkA==
X-Gm-Message-State: AOAM5329eS5RzduZccs5Zckqh8/IDm2UWvSkHdyuHsKtp8JiQmHzYMMu
        fpqLexdFD2JpN9BAIcUnKQ97XnqsphB6
X-Google-Smtp-Source: ABdhPJygxgBulrT00wOguSwfF/d8ZvHmkECBGZgdlJ0iVF9sNRdImdzL5wI/h5tiQ8cKGAKTOYAtYLKSe/7p
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:8806:6b98:8ae6:8824])
 (user=apusaka job=sendgmr) by 2002:a25:6f85:: with SMTP id
 k127mr42739944ybc.270.1621938626302; Tue, 25 May 2021 03:30:26 -0700 (PDT)
Date:   Tue, 25 May 2021 18:29:38 +0800
In-Reply-To: <20210525102941.3958649-1-apusaka@google.com>
Message-Id: <20210525182900.9.I3e7a04aaf5320cdfcf3457536e7d4f33eb6d26fa@changeid>
Mime-Version: 1.0
References: <20210525102941.3958649-1-apusaka@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 09/12] Bluetooth: use inclusive language in debugfs
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

Use "accept list" and "reject list".

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---

 net/bluetooth/hci_debugfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 47f4f21fbc1a..3352e831af3d 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -138,7 +138,7 @@ static int device_list_show(struct seq_file *f, void *ptr)
 
 DEFINE_SHOW_ATTRIBUTE(device_list);
 
-static int blacklist_show(struct seq_file *f, void *p)
+static int reject_list_show(struct seq_file *f, void *p)
 {
 	struct hci_dev *hdev = f->private;
 	struct bdaddr_list *b;
@@ -151,7 +151,7 @@ static int blacklist_show(struct seq_file *f, void *p)
 	return 0;
 }
 
-DEFINE_SHOW_ATTRIBUTE(blacklist);
+DEFINE_SHOW_ATTRIBUTE(reject_list);
 
 static int blocked_keys_show(struct seq_file *f, void *p)
 {
@@ -323,7 +323,7 @@ void hci_debugfs_create_common(struct hci_dev *hdev)
 	debugfs_create_file("device_list", 0444, hdev->debugfs, hdev,
 			    &device_list_fops);
 	debugfs_create_file("blacklist", 0444, hdev->debugfs, hdev,
-			    &blacklist_fops);
+			    &reject_list_fops);
 	debugfs_create_file("blocked_keys", 0444, hdev->debugfs, hdev,
 			    &blocked_keys_fops);
 	debugfs_create_file("uuids", 0444, hdev->debugfs, hdev, &uuids_fops);
@@ -778,7 +778,7 @@ static const struct file_operations force_static_address_fops = {
 	.llseek		= default_llseek,
 };
 
-static int white_list_show(struct seq_file *f, void *ptr)
+static int accept_list_show(struct seq_file *f, void *ptr)
 {
 	struct hci_dev *hdev = f->private;
 	struct bdaddr_list *b;
@@ -791,7 +791,7 @@ static int white_list_show(struct seq_file *f, void *ptr)
 	return 0;
 }
 
-DEFINE_SHOW_ATTRIBUTE(white_list);
+DEFINE_SHOW_ATTRIBUTE(accept_list);
 
 static int resolv_list_show(struct seq_file *f, void *ptr)
 {
@@ -1197,7 +1197,7 @@ void hci_debugfs_create_le(struct hci_dev *hdev)
 	debugfs_create_u8("white_list_size", 0444, hdev->debugfs,
 			  &hdev->le_white_list_size);
 	debugfs_create_file("white_list", 0444, hdev->debugfs, hdev,
-			    &white_list_fops);
+			    &accept_list_fops);
 	debugfs_create_u8("resolv_list_size", 0444, hdev->debugfs,
 			  &hdev->le_resolv_list_size);
 	debugfs_create_file("resolv_list", 0444, hdev->debugfs, hdev,
-- 
2.31.1.818.g46aad6cb9e-goog

