Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505554C3C12
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 03:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbiBYC7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 21:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiBYC7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 21:59:37 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8AD2757BA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:59:07 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z2so3606941plg.8
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R9dcpe70j9Trk9rKuKWmAu1MvnVHF87exvDoWtSGUqM=;
        b=KQoLjAf8JH3bVzNJAVgTc6i2EqQqA8oE3gAxLFZVdbVRq8STVIeVGh0qXCEms3U4Iy
         +OgCxWBwRwQ3BO+oCBOtpIlECk7zQQcKxX0EqjtFtVIZxOyNpbhelmm3k/dRtmkBEEkN
         J9DOZGM/9nQGk/SEbciSrOJxzriGAIFHlcpOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R9dcpe70j9Trk9rKuKWmAu1MvnVHF87exvDoWtSGUqM=;
        b=h5TLszL1gEO/EviOzmdguT2Bosusw6SP/k4fr1iFCoxgcewgAKk75kw/XaNFGbZXtm
         GoDLm+t3Q5FO/TUPJ7RdsC3YPaML1Wd1rGP8SQBayrTgLK6+hYUEqkWhouvv6gQTAxVG
         IgenWqKyh7P0x1OZx9BOoBzBJaUPGwr31rAUMyUIbTjieAyrJjL3RVdfY51AJ7CtUBbL
         8qYkQC6+Xq3aezMRr2RBIQGjTe2nKq9DOYFW+y6CWhbzPiLVZnyTZ3LH7/9lrDwlN80w
         23m0smdMdaeGLLm8E7+FjPDH3i0kFFi7e2V3vAYTWdFyoK/VF9pkG6XzYvWjnQ2YqpJm
         c7wg==
X-Gm-Message-State: AOAM5313v7f7+rWq0NI02QS8L1xFwX3U0+AyD5/c4TDeZtJ9DVK4TZVD
        q8dbrgGThAlyNw13NbQalK1QMg==
X-Google-Smtp-Source: ABdhPJxQZhDsbRkEFSGIqh9jmp4oIZe/o9KQ4KxxA/u7dmgTljFQcTdyChCC+P0s5+WS95oLB+oCxA==
X-Received: by 2002:a17:90a:800b:b0:1bc:1954:9640 with SMTP id b11-20020a17090a800b00b001bc19549640mr1094593pjn.89.1645757946660;
        Thu, 24 Feb 2022 18:59:06 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id q93-20020a17090a4fe600b001b9ba2a1dc3sm7397526pjh.25.2022.02.24.18.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:59:06 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: [PATCH net-next v8 1/8] PCI: Add Fungible Vendor ID to pci_ids.h
Date:   Thu, 24 Feb 2022 18:58:55 -0800
Message-Id: <20220225025902.40167-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225025902.40167-1-dmichail@fungible.com>
References: <20220225025902.40167-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index aad54c666407..c7e6f2043c7d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2561,6 +2561,8 @@
 
 #define PCI_VENDOR_ID_HYGON		0x1d94
 
+#define PCI_VENDOR_ID_FUNGIBLE		0x1dad
+
 #define PCI_VENDOR_ID_HXT		0x1dbf
 
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
-- 
2.25.1

