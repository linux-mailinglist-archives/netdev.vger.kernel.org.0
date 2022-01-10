Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC798488E77
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbiAJB4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238054AbiAJB4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:56:40 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1FCC061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 17:56:39 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id i6so10706912pla.0
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 17:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mkYHuJw67a3LbulvnX5SF5Jwp91Xp1LWbpzZ01T5e78=;
        b=Y+pE1fqHcd+rDLcOYZjxlKuafsrt6n+9nLd8OWB/b8Ip8c1QX07h1F0vWc2fR5FbwR
         kpl3JpsNXb0Acxqaf6dvuNwn7vlme6TwtR0EoXnh27FaADB7LKyZryzD/YgbxAWK3L0Q
         rUWNTmO7yY06HN8lvxV9Bf8DJbJb2GlDDMSXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mkYHuJw67a3LbulvnX5SF5Jwp91Xp1LWbpzZ01T5e78=;
        b=QgNVjcXGRsoiG0QQfMXzJ+ru9jEliNAgRPEU4iJLYHd4sPYwACn/wrlE1yw4pj6Qk4
         ouUDhAmx2ydSB6yBTI2G8oW1PPNm3aI1c8/KWAyvyyRqgbbpHuYDKOMcEaFVG2Bh7Kd0
         frpAWQ2Jw7yxpP3pA3zE3U52iLeTSGIy37gwYuSXo7Seum/47Xz/bIs5DHdq6HQeEQ0Q
         y5NbOihN7bqaX/Uq+6290k3/maqrTM+zZB1rJihsYC4/pZWiyQVfhUrQAoMJZsqhEfXc
         5T+efxOWsnyotLWEkRoLfL5f5HiPN0MULZ9+Q+0Hyj6Aa5nriFAQ/FT0AhNEcSzwwNRU
         BJzw==
X-Gm-Message-State: AOAM5311X3AHjxT9Oe7X/XxfxTWTXK/8y2X5uk1hlNwY6+cELujZHUt0
        cpgQIJLDGF+XnEZjMmAOi6BOXA==
X-Google-Smtp-Source: ABdhPJx7N5pSatkNIjYxs21kxaRiwOfmy94ujvV5rWllmtNldh8/pzuz3CWpnzBmXiqm3A6bOAT7Yw==
X-Received: by 2002:a17:90b:3b83:: with SMTP id pc3mr28155778pjb.3.1641779799446;
        Sun, 09 Jan 2022 17:56:39 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id rm3sm6909535pjb.8.2022.01.09.17.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 17:56:38 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: [PATCH net-next v6 1/8] PCI: Add Fungible Vendor ID to pci_ids.h
Date:   Sun,  9 Jan 2022 17:56:29 -0800
Message-Id: <20220110015636.245666-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110015636.245666-1-dmichail@fungible.com>
References: <20220110015636.245666-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

