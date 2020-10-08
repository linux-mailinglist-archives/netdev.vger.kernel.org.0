Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841862878B3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbgJHPzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731693AbgJHPzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:15 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD066C061755;
        Thu,  8 Oct 2020 08:55:15 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p11so2967376pld.5;
        Thu, 08 Oct 2020 08:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PjMPUzslxCGQDyXvyuPHPYzPztdfah40fjrfibkkXbQ=;
        b=HbTSmACkNvEi1Ke+LLQfy91/CaM3puNEeRbZb4nB/5sVVVBfrY+vo6VhL5mGgzX+b7
         jk8t1AfFRZOOWyAToBp2ljP4bMEyt2409vxzj0PtL01IeLHdUAq6J6EIrR+RF2vYSXBB
         s3OQNTbzRMuN1rh3VMztU3yo9H77mbSB4S7LhYeVI4AtF+rQUe3CAsR2aQF7/XQGvW2a
         aQ+ckaC8Zn3l7oaiT+qQjs2TcfIwCgA7PUQTgBl5QLk5/MJ+u5h8pqAeEFsZDySXaKwW
         oQ3Ci1ss+NBJpsTYo2W5watoyrcJnzjZFG1gZNSql8Pa/zuJpZVmuOG6EQK86DRLmK+5
         FryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PjMPUzslxCGQDyXvyuPHPYzPztdfah40fjrfibkkXbQ=;
        b=J4LEY6uXb4Cjhyii6MpMNR03wMsggpl+pxmd53ZQbsNNYs3Gt0m3vRefn1915CVkbh
         hCwmCs5e+q99QNJWXKqvi5utO+l//aTYEpT/t6D5wMYP9s1aFHGHkcIRR0mj/M8dkyNL
         Xktw3FyA0AGtCkIbfMmtRQOpa52csWXvpjCmAwClQNtJu7btnZ725X/EmBw4z3Zx5r8M
         NpXCEaOZbvq6SOkUfyH1Bg3Gh+kmz9ecBHmkDmcLWYjGqIs30jb49cnDm6gkcULPWyUD
         Sp6hANFt+Knoo8U2296t2byK/CpEvtL4tpSY0+WCC+qxnuKH17f5Fk8KxWJZb/ihmVF+
         HLUg==
X-Gm-Message-State: AOAM5304I6+m+4v9WkiSdK59QJWreEYgQbcm/E3B//PLxTaP7AT12rPW
        3FRi4Kzri6rDvkm9OgvSLUQ=
X-Google-Smtp-Source: ABdhPJwmcYmA3b1n3Az4gr2Z1T50VkAgeVR9zO2tao4hCrZ4YXQ2larX+shYnx7aZkx4cQeUrq6xbQ==
X-Received: by 2002:a17:902:6a86:b029:d3:b2d4:4a6 with SMTP id n6-20020a1709026a86b02900d3b2d404a6mr7942678plk.73.1602172515303;
        Thu, 08 Oct 2020 08:55:15 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:14 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 056/117] iwlwifi: set rs_sta_dbgfs_scale_table_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:08 +0000
Message-Id: <20201008155209.18025-56-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 1f196665d21f..43fff3fd18e7 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2669,6 +2669,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.read = il4965_rs_sta_dbgfs_scale_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t
-- 
2.17.1

