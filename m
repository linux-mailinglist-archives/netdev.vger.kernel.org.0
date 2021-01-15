Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C2C2F7FA2
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732362AbhAOPdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:33:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728878AbhAOPdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:33:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610724702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=imD7bQ/avIn3psEhQvHOqQKgwl5Med4mXOUVVfUr0xA=;
        b=Up32vQ0Mae98pnsWGaW1uwvQOsbzrMoNQqRC9YrRE03Ca7UTvcIUcVw4v8LyOpL3fYDg9a
        /1vfubdo9V/rYceCeu/X6w6Wuve/I9Tzh0fTcxgXqOUVMgYYeA4mxa180y4Tyhibdo1UF7
        tLrwdSDAu1v46yvNXOofiXnLJsOLjkM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-dkURSsvsOZKw2iQBB7nhOg-1; Fri, 15 Jan 2021 10:31:40 -0500
X-MC-Unique: dkURSsvsOZKw2iQBB7nhOg-1
Received: by mail-qk1-f198.google.com with SMTP id d7so8300687qkb.23
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 07:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=imD7bQ/avIn3psEhQvHOqQKgwl5Med4mXOUVVfUr0xA=;
        b=uZBx3cU6o1UaEP8P6s2Q9m1ZRIcp+dJiib/HeVNmO4gU/A6iEp3rjFeb9Ob4lXlbTu
         VzC98OJS1Fcvd+tmWFZ4f7tOynSrt5D0d9FFvJwDCKtqblatRqnLuOtsECUe+md6Yyao
         0V58Kq4SraVDR6+DxIzlsBBZEjVn7wr9c2kpLUXQRSO9V8OyvVAKCn7NwxCOy9lfOUWQ
         qPpvVXeTl8fN5g2/8P1Xa3cVJhFXrD5V07eimG+AGLFk0Fe6xE6R32rY7mldDwLpelrM
         fiyAAE7Ci0Jg7RVEW4Xhvcc+qTQEVDuypa7d0R71DDelJY+EZFHEeiLlIJZNz//sYEdq
         6OSA==
X-Gm-Message-State: AOAM531fLqn7DAFaWmmScUvaPN8Z1swJWAxyfTQ2j3y2YbcRIxGkM2ja
        DINpnJYQhxZnpVbzh0qP/VNTNht2z2fuNJY+Jw1Veieo5gGcfpsfxA0qrbmHH5lcgEumoz3LCoa
        lHPQmmldo3FrOkzhg
X-Received: by 2002:a05:622a:149:: with SMTP id v9mr3955615qtw.50.1610724700278;
        Fri, 15 Jan 2021 07:31:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0oer34CWE/FRhfG7zBH9FaDJouyONzj6DL4tcL/1XumXAxbjedDe1a9KNE7twIPF8joeElg==
X-Received: by 2002:a05:622a:149:: with SMTP id v9mr3955588qtw.50.1610724700065;
        Fri, 15 Jan 2021 07:31:40 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q6sm5197519qkd.41.2021.01.15.07.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 07:31:39 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, marex@denx.de,
        andrew@lunn.ch, zhengyongjun3@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: ks8851: remove definition of DEBUG
Date:   Fri, 15 Jan 2021 07:31:28 -0800
Message-Id: <20210115153128.131026-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Defining DEBUG should only be done in development.
So remove DEBUG.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/micrel/ks8851_common.c | 2 --
 drivers/net/ethernet/micrel/ks8851_par.c    | 2 --
 drivers/net/ethernet/micrel/ks8851_spi.c    | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 058fd99bd483..2feed6ce19d3 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -8,8 +8,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define DEBUG
-
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index 3bab0cb2b1a5..2e8fcce50f9d 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -8,8 +8,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define DEBUG
-
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 4ec7f1615977..479406ecbaa3 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -8,8 +8,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define DEBUG
-
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-- 
2.27.0

