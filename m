Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49FE2C55B1
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389684AbgKZNc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390336AbgKZNcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:32:21 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F069C061A04
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:20 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 64so2138871wra.11
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WOPpp6HIgOcad1W0yfFfa1/Wy9WX17Rmpe1tMayS4HI=;
        b=IJKrKLXlEdbjjcRCFvRL1iTnWYhhIqcjEsenkEgZGOdVW7caoAQZPdSzf9q+0TDL1R
         Rv54vzF/hbcPiBYkShfjFH+xCa/L24Iq5UV3X7aMzmfSmnl2NZ+Hfy0SAlQbpzRDhAVR
         6TCbs6gTAUplQFlusL7f/X2ITdQ33zUI+qVN5ngvGv6NSNR8vpN1QYy9KV/rufaGf69O
         331G6hx/qanbzDNjYqHtmsPDTPtzVPSH/Gl/X/Dnw1baucosDCBK3CrHKXzBYnvTkGdA
         D01pqh/BUgXlQsfdMoyDGnRHPDSJ/tHaysYsqYlxraLeHDEfUF+lTQ+vdkrSfjrc5T2c
         AP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WOPpp6HIgOcad1W0yfFfa1/Wy9WX17Rmpe1tMayS4HI=;
        b=OTAOtto8A0lC6ugjxo9lpGvSMYUkyIqB4cqhaQrQ2fN9TOuoQM4jwdntZc+F8mI79J
         CqRjAXRSk1zvbETZW5rrsCiOuvBCu+Pe+JjfHTh5PpXLXhymIzczSZ09ebCctt+Tzdpi
         14DdgKv9ftFsog/VIEB0IFG/p2Y5M9/uGT3U0PDhSSq7329lW71Ly8DxEfWmPsrMcOd1
         +tPmUWVlIgot+SD/J9dKVp/eKLCvnDe2EbmdTPwyFOVcP9QYYCgKd4x/O8SRA/LCKS39
         iZtwrKdTs0P79bVHyaQoZfG1lxdl7nz5H10DtGQH10MmZgH+pbzmn5FVIB7hOqtnj8rJ
         wInw==
X-Gm-Message-State: AOAM531gcfETFbaCj/WMTOWe9pUo71+3BfXS2afhvSZ6JOhPA2fjg2Kg
        8u1d7mf2CKKdylGGbfyhXjBXJA==
X-Google-Smtp-Source: ABdhPJz5JanrQA5T2e5MhcTaKmi3Rr5awkz/j5dYdTosg06LwfkbLMK27zcgfXcL/8U30DN6fFHbeQ==
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr3890245wrt.176.1606397538176;
        Thu, 26 Nov 2020 05:32:18 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:32:17 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe, .remove and .shutdown
Date:   Thu, 26 Nov 2020 13:31:52 +0000
Message-Id: <20201126133152.3211309-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also strip out other duplicates from driver specific headers.

Ensure 'main.h' is explicitly included in 'pci.h' since the latter
uses some defines from the former.  It avoids issues like:

 from drivers/net/wireless/realtek/rtw88/rtw8822be.c:5:
 drivers/net/wireless/realtek/rtw88/pci.h:209:28: error: ‘RTK_MAX_TX_QUEUE_NUM’ undeclared here (not in a function); did you mean ‘RTK_MAX_RX_DESC_NUM’?
 209 | DECLARE_BITMAP(tx_queued, RTK_MAX_TX_QUEUE_NUM);
 | ^~~~~~~~~~~~~~~~~~~~

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtw88/pci.c:1488:5: warning: no previous prototype for ‘rtw_pci_probe’ [-Wmissing-prototypes]
 1488 | int rtw_pci_probe(struct pci_dev *pdev,
 | ^~~~~~~~~~~~~
 drivers/net/wireless/realtek/rtw88/pci.c:1568:6: warning: no previous prototype for ‘rtw_pci_remove’ [-Wmissing-prototypes]
 1568 | void rtw_pci_remove(struct pci_dev *pdev)
 | ^~~~~~~~~~~~~~
 drivers/net/wireless/realtek/rtw88/pci.c:1590:6: warning: no previous prototype for ‘rtw_pci_shutdown’ [-Wmissing-prototypes]
 1590 | void rtw_pci_shutdown(struct pci_dev *pdev)
 | ^~~~~~~~~~~~~~~~

Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtw88/pci.h       | 8 ++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723de.c | 1 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.h | 4 ----
 drivers/net/wireless/realtek/rtw88/rtw8821ce.c | 1 +
 drivers/net/wireless/realtek/rtw88/rtw8821ce.h | 4 ----
 drivers/net/wireless/realtek/rtw88/rtw8822be.c | 1 +
 drivers/net/wireless/realtek/rtw88/rtw8822be.h | 4 ----
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 1 +
 drivers/net/wireless/realtek/rtw88/rtw8822ce.h | 4 ----
 9 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index ca17aa9cf7dc7..cda56919a5f0f 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -5,6 +5,8 @@
 #ifndef __RTK_PCI_H_
 #define __RTK_PCI_H_
 
+#include "main.h"
+
 #define RTK_DEFAULT_TX_DESC_NUM 128
 #define RTK_BEQ_TX_DESC_NUM	256
 
@@ -212,6 +214,12 @@ struct rtw_pci {
 	void __iomem *mmap;
 };
 
+const struct dev_pm_ops rtw_pm_ops;
+
+int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
+void rtw_pci_remove(struct pci_dev *pdev);
+void rtw_pci_shutdown(struct pci_dev *pdev);
+
 static inline u32 max_num_of_tx_queue(u8 queue)
 {
 	u32 max_num;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723de.c b/drivers/net/wireless/realtek/rtw88/rtw8723de.c
index c81eb4c336425..2dd689441e8dc 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723de.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723de.c
@@ -4,6 +4,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include "pci.h"
 #include "rtw8723de.h"
 
 static const struct pci_device_id rtw_8723de_id_table[] = {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723de.h b/drivers/net/wireless/realtek/rtw88/rtw8723de.h
index ba3842360c20a..2b4894846a07f 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723de.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723de.h
@@ -5,10 +5,6 @@
 #ifndef __RTW_8723DE_H_
 #define __RTW_8723DE_H_
 
-extern const struct dev_pm_ops rtw_pm_ops;
 extern struct rtw_chip_info rtw8723d_hw_spec;
-int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
-void rtw_pci_remove(struct pci_dev *pdev);
-void rtw_pci_shutdown(struct pci_dev *pdev);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821ce.c b/drivers/net/wireless/realtek/rtw88/rtw8821ce.c
index 616fdcfd62c98..f34de115e4bc4 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821ce.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821ce.c
@@ -4,6 +4,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include "pci.h"
 #include "rtw8821ce.h"
 
 static const struct pci_device_id rtw_8821ce_id_table[] = {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821ce.h b/drivers/net/wireless/realtek/rtw88/rtw8821ce.h
index 8d3eb77a876be..54142acca5344 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821ce.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821ce.h
@@ -5,10 +5,6 @@
 #ifndef __RTW_8821CE_H_
 #define __RTW_8821CE_H_
 
-extern const struct dev_pm_ops rtw_pm_ops;
 extern struct rtw_chip_info rtw8821c_hw_spec;
-int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
-void rtw_pci_remove(struct pci_dev *pdev);
-void rtw_pci_shutdown(struct pci_dev *pdev);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822be.c b/drivers/net/wireless/realtek/rtw88/rtw8822be.c
index 921916ae15cab..62ee7e62cac02 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822be.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822be.c
@@ -4,6 +4,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include "pci.h"
 #include "rtw8822be.h"
 
 static const struct pci_device_id rtw_8822be_id_table[] = {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822be.h b/drivers/net/wireless/realtek/rtw88/rtw8822be.h
index d823ca059f5c9..6668460d664da 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822be.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822be.h
@@ -5,10 +5,6 @@
 #ifndef __RTW_8822BE_H_
 #define __RTW_8822BE_H_
 
-extern const struct dev_pm_ops rtw_pm_ops;
 extern struct rtw_chip_info rtw8822b_hw_spec;
-int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
-void rtw_pci_remove(struct pci_dev *pdev);
-void rtw_pci_shutdown(struct pci_dev *pdev);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
index 026ac49ce6e3c..3845b1333dc39 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
@@ -4,6 +4,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include "pci.h"
 #include "rtw8822ce.h"
 
 static const struct pci_device_id rtw_8822ce_id_table[] = {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.h b/drivers/net/wireless/realtek/rtw88/rtw8822ce.h
index c2c0e8675d742..fee32d7a45047 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.h
@@ -5,10 +5,6 @@
 #ifndef __RTW_8822CE_H_
 #define __RTW_8822CE_H_
 
-extern const struct dev_pm_ops rtw_pm_ops;
 extern struct rtw_chip_info rtw8822c_hw_spec;
-int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
-void rtw_pci_remove(struct pci_dev *pdev);
-void rtw_pci_shutdown(struct pci_dev *pdev);
 
 #endif
-- 
2.25.1

