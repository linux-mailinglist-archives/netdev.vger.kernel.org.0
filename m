Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08A9230913
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 13:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgG1Lm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 07:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729036AbgG1Lm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 07:42:58 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86944C061794;
        Tue, 28 Jul 2020 04:42:58 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k13so1949243plk.13;
        Tue, 28 Jul 2020 04:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f5JgTl1mn5uTL5N69LqaGIrNSHZWhpmutap+rp0hNP0=;
        b=qSE8zMPz4HChumx8PDMwOaYF2rRJWxIIMo8kuHhth2sYL9IYEIb3bChYfV3oa/kSKv
         sZ4OGF199JWu+Hc1qr/mGhMFHaRXzlepCvLSAD9lUJvs4uupqAIcwLgUY1I25tLGKZj/
         p4gfzXLs41fKxuUPjegTGU1x2WI2i7651GdHCCbLrmmuWrnkrVn+cH5JtI+c9dlREyde
         qyTVbXjUFVv/onHHSuhncCINST4ERMc1qBndiKDfS+lLzZ3hkItgqgJ1/lOpcyV1c5W3
         s+TEY/H1QxuhZisKKsCwnGskAYUYlW3CS1tVU9oK2b67eCA8OeJt3E8mSD+ZCDKdT6Qx
         4ZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f5JgTl1mn5uTL5N69LqaGIrNSHZWhpmutap+rp0hNP0=;
        b=X5NnrJ+KwvxNjc4mgdJe1LjO0InV61BuZRNH7CV1HgPMePzRQMbBLZ/aXPzCRRMIq4
         DlS1+BnZy9uS/YXtvp0VH/XLpLMxuaDoq6Z1kdqCCBawFEhC+cOXDToCRqeh4qAWJbIl
         ymcO/QyVqyHEdzt5agzIB9UAllixYLykz+Z4luEyBPbfYDh6h9FAnIhdR0AFSzp283cv
         baB8i/BIGUQm5nFVb679PEEaaAvd5eCXHkpkpj7qFiAv591kYdYV6luVtwT7RtNNDX3C
         /eGBpQbH1z5KjopffsiNACrIB6bjbMnSpuU07LB3mx3HfuK9Hc6vYI9He3UHhJt3baD1
         sVrA==
X-Gm-Message-State: AOAM533wnkSPTCqKoYbTQ9NVCMnhWy+HbP35lg99UsVb6VvvlWPLuGXj
        FpgbQdEhCebfM3zelqbmGxs=
X-Google-Smtp-Source: ABdhPJyp4u8cmwBfLx7giHjgA2KCYor0/RYxbOjGsQ/FZqFeau9qvpJOeeLDow5oAtz4aszE55hIVg==
X-Received: by 2002:a17:902:b18b:: with SMTP id s11mr23283675plr.152.1595936577971;
        Tue, 28 Jul 2020 04:42:57 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id 66sm19157012pfg.63.2020.07.28.04.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 04:42:57 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1] wireless: airo: use generic power management
Date:   Tue, 28 Jul 2020 17:11:28 +0530
Message-Id: <20200728114128.1218310-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers using legacy power management .suspen()/.resume() callbacks
have to manage PCI states and device's PM states themselves. They also
need to take care of standard configuration registers.

Switch to generic power management framework using a single
"struct dev_pm_ops" variable to take the unnecessary load from the driver.
This also avoids the need for the driver to directly call most of the PCI
helper functions and device power state control functions, as through
the generic framework PCI Core takes care of the necessary operations,
and drivers are required to do only device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/wireless/cisco/airo.c | 39 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 827bb6d74815..f9627fa360a2 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -74,16 +74,19 @@ MODULE_DEVICE_TABLE(pci, card_ids);
 
 static int airo_pci_probe(struct pci_dev *, const struct pci_device_id *);
 static void airo_pci_remove(struct pci_dev *);
-static int airo_pci_suspend(struct pci_dev *pdev, pm_message_t state);
-static int airo_pci_resume(struct pci_dev *pdev);
+static int __maybe_unused airo_pci_suspend(struct device *dev);
+static int __maybe_unused airo_pci_resume(struct device *dev);
+
+static SIMPLE_DEV_PM_OPS(airo_pci_pm_ops,
+			 airo_pci_suspend,
+			 airo_pci_resume);
 
 static struct pci_driver airo_driver = {
-	.name     = DRV_NAME,
-	.id_table = card_ids,
-	.probe    = airo_pci_probe,
-	.remove   = airo_pci_remove,
-	.suspend  = airo_pci_suspend,
-	.resume   = airo_pci_resume,
+	.name      = DRV_NAME,
+	.id_table  = card_ids,
+	.probe     = airo_pci_probe,
+	.remove    = airo_pci_remove,
+	.driver.pm = &airo_pci_pm_ops,
 };
 #endif /* CONFIG_PCI */
 
@@ -5573,9 +5576,9 @@ static void airo_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static int airo_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused airo_pci_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct airo_info *ai = dev->ml_priv;
 	Cmd cmd;
 	Resp rsp;
@@ -5591,25 +5594,21 @@ static int airo_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		return -EAGAIN;
 	disable_MAC(ai, 0);
 	netif_device_detach(dev);
-	ai->power = state;
+	ai->power = PMSG_SUSPEND;
 	cmd.cmd = HOSTSLEEP;
 	issuecommand(ai, &cmd, &rsp);
 
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	device_wakeup_enable(dev_d);
 	return 0;
 }
 
-static int airo_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused airo_pci_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct airo_info *ai = dev->ml_priv;
-	pci_power_t prev_state = pdev->current_state;
+	pci_power_t prev_state = to_pci_dev(dev_d)->current_state;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	pci_enable_wake(pdev, PCI_D0, 0);
+	device_wakeup_disable(dev_d);
 
 	if (prev_state != PCI_D1) {
 		reset_card(dev, 0);
-- 
2.27.0

