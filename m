Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91E2123863
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfLQVGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:06:25 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:52454 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbfLQVGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:06:25 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 47crKX3PpCz9vK12
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 21:06:24 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uSI5mUybxGSu for <netdev@vger.kernel.org>;
        Tue, 17 Dec 2019 15:06:24 -0600 (CST)
Received: from mail-yw1-f71.google.com (mail-yw1-f71.google.com [209.85.161.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 47crKX20xjz9vK1d
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 15:06:24 -0600 (CST)
Received: by mail-yw1-f71.google.com with SMTP id l12so9121782ywk.6
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RVnukGaiui+du4+M3rktd/RcuLA80ABz3WVIbi2xHtI=;
        b=KBmfJyYowdx1h9k2Ktvy/CuZa7KBLKl+kv2WSWq4E1LLh/iGH1BZ2uKtukY/W2uzVo
         TpOpE0M/TjXJBydFNILe7JcWTtYgiVQq2UeznWuReLZCjbu5K78i6Cls+VL3XtsWT2fQ
         XqEb708qgSlCd/b2D+Rd3w2WrFn4lkITSTNECAMlkziteLnFv3NCZJMSGRpMZxt7LFwz
         qrHA64qCQ192u2heFfyU9uhQM/LWbb68NUezxaKZnEDdVrKoyC2KtmnmQWcdvb07iARW
         PMlTvvt7+lbf30tRWppvhTekxCkugnWrCjXMRCIrRGISPvcs/vncRp/4eZWU732GnxE0
         U0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RVnukGaiui+du4+M3rktd/RcuLA80ABz3WVIbi2xHtI=;
        b=Qhu4FW0sV+57meWvSRDRYfgfIK7ESrXokz1xb1IfyzxYsGkey/rtby6uZUgRtopRKJ
         k9RnSCe1gSfOJj7js66JAWXP22uOZjLdieXCBrq9ubXHFdV/aAylQzK/wqEc90NxnXu+
         Eaag3fSXyEUgKXvs1aUcfSUEDNS+dqvkxDpJzhBg8XH13IJwE/3hbYAjQBZBTjrO2/1b
         lqXZNHQcYBeYrsb7VH9s+6MfavpYHkuO7UYVQGpZ9BbkYhGHn1Bs4ZDZCwoSYOuG9CfO
         9YKynKvHX3UBz1s3c9V0FCJ/kezQTP+KUzWOEzQk0A/fMqmxGuah1HGuApVgqhU0uC+X
         CPEQ==
X-Gm-Message-State: APjAAAXu9Hk6qNDhiCN6enSXo2v0a8DwHUYeq5CtqdCudLRw0WKB0RgU
        jy/4/08w05IJLXh/Z6VfwJxC/sAxNuj/FN3UQVw9tzYP55qebxyBZjnJUbAvuuGEFm7Ifo4MD4F
        nz34+4wt6/OGkAUd7Sq5X
X-Received: by 2002:a0d:dbd5:: with SMTP id d204mr640597ywe.22.1576616783708;
        Tue, 17 Dec 2019 13:06:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqxobVgJolFCbVUp/qKSoQ1G1fQbOomuh913hWdYuOGTVfl6p/BvJ6GamqZF59q/3T4hYM6AfA==
X-Received: by 2002:a0d:dbd5:: with SMTP id d204mr640571ywe.22.1576616783505;
        Tue, 17 Dec 2019 13:06:23 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id w138sm6913670ywd.89.2019.12.17.13.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 13:06:23 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] hdlcdrv: replace unnecessary assertion in hdlcdrv_register
Date:   Tue, 17 Dec 2019 15:06:19 -0600
Message-Id: <20191217210620.29775-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hdlcdrv_register, failure to register the driver causes a crash.
The three callers of hdlcdrv_register all pass valid pointers and
do not fail. The patch eliminates the unnecessary BUG_ON assertion.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
v1: Changed from returning -EINVAL to deleting BUG_ON as identified
by Stephen Hemminger.
---
 drivers/net/hamradio/hdlcdrv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index df495b5595f5..e7413a643929 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -687,8 +687,6 @@ struct net_device *hdlcdrv_register(const struct hdlcdrv_ops *ops,
 	struct hdlcdrv_state *s;
 	int err;
 
-	BUG_ON(ops == NULL);
-
 	if (privsize < sizeof(struct hdlcdrv_state))
 		privsize = sizeof(struct hdlcdrv_state);
 
-- 
2.20.1

