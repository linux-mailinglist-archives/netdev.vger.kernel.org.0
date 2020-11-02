Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F0A2A2919
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgKBLZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgKBLZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:25:13 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB938C061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:25:12 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c16so9132239wmd.2
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H6cdhCKSV+e73IF059XTYbnS4xki9YceyWLt1d9tAnQ=;
        b=kjIRWtT2G1NDh+U38Rv7FfAtYfkysDEGZtHw5TH2vid5+NKIXzmhRCBeUQBm0i6rmD
         DvEtQF9SB1RCFYbfjkYC6GzPyb5orD2t7povv+ioDwtbaEk6XUMibMktPjJOXDJo6wGf
         lNJ/KAF89yLrKtfQnIz71cLLcwypx5jB7zAYx3A8P23YT3saMLL7GQLV75BHtiGuoqph
         xPLBdJVmD+nkUYCDMjRh/sVCz5aTAxm+wpko30RyclSwVR7wwbRRGZ/Il2GF05RE2NaG
         T45PwQcc9oe0/ekJ26MluU5sESU6motRpIsCfo4vWBNFYlMzWiBPSnverdYvQpbBt1uI
         bDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H6cdhCKSV+e73IF059XTYbnS4xki9YceyWLt1d9tAnQ=;
        b=qUoZz2Gz1/vdWNCYD4j9V9+bwq1YBYWi6XmlwW76i5Y2vS/XQlYyB+/rqobnXWwCa6
         GNsA9EFeKAELoQKoY86W9WrM9RXlb2oULSUrAGcgJJ/bE0pmEEdrNsEeYs1DxECMhPxF
         U7QFfqS4rdX7+JWJl8eQomwh+FRyuYCrAC0B+gAV823Lwg54BAqAw5nsrkoZpNu6RZwU
         0KTLmj6stH5fKn07EEK2OZflxAtFYyRfT6B+Rm6e87o19JVOHKYEmPT5IP6e2tqlhc5S
         v92Z6ay/2wMAutdVU7zrxv8g18/TfugFa/gxsG5wp0FUqvT6w41mM1UvTeEnZHhgHcn+
         xWFw==
X-Gm-Message-State: AOAM533TexPyKhP2AL8coi5bQdFujwtDusfkh1+qfLoYlhnkt7QBBWlJ
        iOCP5qTun1KSGupOWhlxt/TXEQ==
X-Google-Smtp-Source: ABdhPJyIwYcuEegu2lamPvWHAIqF6Vi2NTmBnd9CkNt4PE4Bls9W2ZyKizwMFz2Xed+Kelo4AnAbJg==
X-Received: by 2002:a1c:103:: with SMTP id 3mr16983122wmb.81.1604316311669;
        Mon, 02 Nov 2020 03:25:11 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:25:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 41/41] realtek: rtw88: pci: Add prototypes for .probe, .remove and .shutdown
Date:   Mon,  2 Nov 2020 11:24:10 +0000
Message-Id: <20201102112410.1049272-42-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 drivers/net/wireless/realtek/rtw88/pci.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index ca17aa9cf7dc7..7cdbb9533a09a 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -212,6 +212,10 @@ struct rtw_pci {
 	void __iomem *mmap;
 };
 
+int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
+void rtw_pci_remove(struct pci_dev *pdev);
+void rtw_pci_shutdown(struct pci_dev *pdev);
+
 static inline u32 max_num_of_tx_queue(u8 queue)
 {
 	u32 max_num;
-- 
2.25.1

