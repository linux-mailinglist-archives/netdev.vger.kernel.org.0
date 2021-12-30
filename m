Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AAC481E3C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 17:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbhL3QjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 11:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbhL3QjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 11:39:13 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECD4C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 08:39:13 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x15so18592909plg.1
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 08:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SmwDPVQJK27U8+rXr3U+rdj1GanWwhnhi+Q33MCEz48=;
        b=DnGrZM7fV5OIwEuOdcXEty4rDQyh9fYiiN96h/nX84EKtbHaBK6ynXUjM4HPyPHWcc
         kgK7f/RN9krT1M8SHAb8XgVkagRgeJiPuKmPneULy8DHS9N5T45zpy01ixiTvmDCYpaU
         2ahtJQ1PL6SPzDZbb/SB1M17AKNiZNKJJCdeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SmwDPVQJK27U8+rXr3U+rdj1GanWwhnhi+Q33MCEz48=;
        b=YiAsbllc7w//P9goEJQY45Eg4KxQWMddUJy1Z+s76XfuJii9gdPDx4FMIuiyVrhpSe
         VQHMH1vEnsSv+nSJpoIVn5HYGa/Gorzx1ZoVZacj9RGQpFi6CcisT4QUlmWQFpq5hq0x
         Ug10hKuqmkNYelwRT0gVnguqynwLjjfaRYpoDdZA09uIi5LsVEQjhgBOPRo6DbFTDXrw
         vG+T9HxLHt9HfMDaSFbX8uzcmDITo/Q+h30y8vTeBYioH4qzJRJaNCGB2ga2ke/2MThk
         6GAt4RfDx6ik/q9MJMBylJm0aFECNuIqtfBWHEhZgdtvrJAXXSLo3d9Mdwz9i+RJK8Ty
         fOxw==
X-Gm-Message-State: AOAM530k7+/dlsKyJYN+bxLIHzlOIBDiRbEwlDIzBvGk4bDr+H9or4FS
        ekBD1fv7SSD0ZywMUJawTq/mcu/6LtwzwQ==
X-Google-Smtp-Source: ABdhPJz+FPzFbeIrHs84xu3t1PbhvVCxaC2WJP62MXxA+7owmbucvXGORbk0tlgklDqgw1ylj9W2iQ==
X-Received: by 2002:a17:90a:8041:: with SMTP id e1mr38646083pjw.60.1640882352750;
        Thu, 30 Dec 2021 08:39:12 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id l6sm27390380pfu.63.2021.12.30.08.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 08:39:12 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/8] PCI: add Fungible vendor ID to pci_ids.h
Date:   Thu, 30 Dec 2021 08:39:02 -0800
Message-Id: <20211230163909.160269-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230163909.160269-1-dmichail@fungible.com>
References: <20211230163909.160269-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 011f2f1ea5bb..c4299dbade98 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2578,6 +2578,8 @@
 
 #define PCI_VENDOR_ID_HYGON		0x1d94
 
+#define PCI_VENDOR_ID_FUNGIBLE		0x1dad
+
 #define PCI_VENDOR_ID_HXT		0x1dbf
 
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
-- 
2.25.1

