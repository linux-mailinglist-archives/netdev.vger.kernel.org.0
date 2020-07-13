Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC8721D6E2
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgGMNY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729975AbgGMNXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:23:07 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0774DC061755;
        Mon, 13 Jul 2020 06:23:07 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so13716203edz.0;
        Mon, 13 Jul 2020 06:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1igF4d0BlRch6oTsOMsklRo2hJykPi64NTGjSwxBH2w=;
        b=GfVbLOBwTQM68ys28gmEsLzbrBK1b+c6gCAsHBPLuU1sBU4FxzUQzy/FNV+5JwZOZm
         kR1VcVfpphRXsdfwIXVx0TAIiRR2ezTv5Ddtc5q6AGYct5hmINAtuH2sc4z+kABGsA3q
         MZpWVLyzERoP5ZgKwWxgZ/Bwb6KkGfAYQ9yYfsAF7q7g9s64zC4q4x7y4lMUurO7OOP+
         GRtkarmdVJUSPnTc67hb7A1PCAolXIJeajY5fisQ/pGpWykWJ6NKryHtSJ+mG/rXcimM
         ZkVft5Cj3VHZrbAZSjJNYb5UM7QM1G0i5UELVPbI1106MfxiHosmC6D9IGT7Iu7SHFu8
         L03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1igF4d0BlRch6oTsOMsklRo2hJykPi64NTGjSwxBH2w=;
        b=gJSX5mC990yYxLc5htqCy0iSJF9M0lYNw2NsATvQF5+IlKKoJiRV/kEymYvPq6A89b
         61n5pcpPVbscu8p4Wd19aQarKcOuF6u5mLGCTHZL/8jJMAupjY/OVfTOQ9OBMtjwoekV
         Vx6x3FpcwJIi68OlhEnj8JM5gyFxk5ZORfsASja4jFgBtVXM9vVyeWQwrXBs+5GJQsA3
         5nIgl7vbCJO97iajzgXlBVu62i18LmWgOYfHXT3/n7DmkNccfD/4W6QYz3M5aAnyyzAr
         jVpubpflV77APN357c0SE3v/zGhVqKaTpzjkLHMt14hGogtSRZNxdFl4Fr+5VdiYEUtj
         PJfw==
X-Gm-Message-State: AOAM532D2mUbi7boe1G7SYNQPUeetqFwx3i+XHlxVhxBR/NjFIUPtOtQ
        kD9BsZFoLVxrptCYcWqp2BU=
X-Google-Smtp-Source: ABdhPJxLeJeo/pnR11earKOB22YmNVCGTeYK935Hvqyg5TcDWyXANgwsI03EL03zM4adEjgBZ464zw==
X-Received: by 2002:a50:f392:: with SMTP id g18mr67987969edm.151.1594646585767;
        Mon, 13 Jul 2020 06:23:05 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id n9sm11806540edr.46.2020.07.13.06.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 06:23:05 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org, Chas Williams <3chas3@gmail.com>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [RFC PATCH 21/35] atm: Fix Style ERROR- assignment in if condition
Date:   Mon, 13 Jul 2020 14:22:33 +0200
Message-Id: <20200713122247.10985-22-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200713122247.10985-1-refactormyself@gmail.com>
References: <20200713122247.10985-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move assignment out of the if condition
Fix style issues in the for-loop

Signed-off-by: "Saheed O. Bolarinwa" <refactormyself@gmail.com>
---
This patch depends on PATCH 20/35

 drivers/atm/iphase.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 2c75b82b4e7f..584d9be5fa73 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2294,13 +2294,19 @@ static int reset_sar(struct atm_dev *dev)
 	unsigned int pci[64];  
 	  
 	iadev = INPH_IA_DEV(dev);  
-	for(i=0; i<64; i++)  
-		if ((error = pci_read_config_dword(iadev->pci, i*4, &pci[i])))
+	for (i = 0; i < 64; i++) {
+		error = pci_read_config_dword(iadev->pci, i*4, &pci[i]);
+		if (error)
 			return error;
+	}
+
 	writel(0, iadev->reg+IPHASE5575_EXT_RESET);  
-	for(i=0; i<64; i++)  
-		if ((error = pci_write_config_dword(iadev->pci, i*4, pci[i])))
+	for (i = 0; i < 64; i++) {
+		error = pci_write_config_dword(iadev->pci, i*4, pci[i]);
+		if (error)
 			return error;
+	}
+
 	udelay(5);  
 	return 0;  
 }  
-- 
2.18.2

