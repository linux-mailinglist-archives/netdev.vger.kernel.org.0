Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCDC4ED3D
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfFUQkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:40:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45960 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUQkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:40:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so3867178pfq.12;
        Fri, 21 Jun 2019 09:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2IgUDhVqnZ8k9zguuMKJ5AeaSmmdRNsRB+Xd+mp5hgs=;
        b=Ud99mkFqZdT93NgONfoC7H1liw3Br8yMsWJ1tKy5eZOl35FyKD3b+R8hNIaxqJSUOp
         hlwKBSZURFw5kD5bbct9rsiOgrWonsrGOrUjIXsJJaqQncpbLztQuagcmCBld8GJPbpa
         1GtnF6nY0Yk65VuaRhOpO6Dm+0zxD0WmT1lTbOly816f8oqoT2Or9Kv8dNcS2I5yZRmR
         Ux0As5qkUaJzk0wiL+cPWVnvj4PiEFnR2SLAPck3kfkk50E7YA6o378KpUQtIS1NExkC
         XpHlgNQ5WwjoGCylqP3szEpNaQlRyvVPHlfCdTt3oZb2b7zokYRFY5NLRo/75/dwZxpb
         5X8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2IgUDhVqnZ8k9zguuMKJ5AeaSmmdRNsRB+Xd+mp5hgs=;
        b=jZXrfcqusf3DrV21sed73FNmoIbqXtiCFGqhsSSrWAlLbeqwRu9h9vTTY+Kc0we69m
         I5D/eU8pTHyQnNCSSl8WWUqqnPB6gri1tnPMDWg+of+qv9Ydsw4BoWx3gyfJqUpVHFtt
         WhOs/EldoZWGgnQgZorS6b6i+ZWkE81gqE08PsSuXxxc5972d7J18awvR9mdMDX69l3K
         qpDNyfqSqq/MYMg2zWdzDlXf/a00z91vSRS8Hwr7Vv9BLqDTMyvYxLG3rrwijQ/cAQBd
         W+VXFqhAzJ5Vjq75cQMNOrIS7ANj/XA21L3gTlQx1clHJOTfvyqg6zLaGmDaNA3vPRzu
         XOwA==
X-Gm-Message-State: APjAAAX3AyVYvPP/nAg96E0Pvg/rYU9ePaZbPe/vQmESkZW+rmaIV7w/
        D6WaLei4vVgKiEftDYSej7o=
X-Google-Smtp-Source: APXvYqyXbcJjprGeaBIgVzs96UiAfpSm2B+Tj1uMXB/VRI5m36QXniyeA1HZFkG67i83JewfIahBWw==
X-Received: by 2002:a63:c20e:: with SMTP id b14mr18670962pgd.96.1561135213429;
        Fri, 21 Jun 2019 09:40:13 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id n89sm25702450pjc.0.2019.06.21.09.39.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 09:40:13 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 1/3] net: ethernet: atheros: atlx: Rename local PCI defines to generic names
Date:   Fri, 21 Jun 2019 22:09:19 +0530
Message-Id: <20190621163921.26188-2-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621163921.26188-1-puranjay12@gmail.com>
References: <20190621163921.26188-1-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename all local PCI definitons to Generic PCI definitions to make them
compatible with generic definitions present in pci_regs.h

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/ethernet/atheros/atlx/atl2.c | 4 ++--
 drivers/net/ethernet/atheros/atlx/atl2.h | 2 +-
 drivers/net/ethernet/atheros/atlx/atlx.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 3a3fb5ce0fee..478db3fe920a 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -2103,13 +2103,13 @@ static s32 atl2_reset_hw(struct atl2_hw *hw)
 	int i;
 
 	/* Workaround for PCI problem when BIOS sets MMRBC incorrectly. */
-	atl2_read_pci_cfg(hw, PCI_REG_COMMAND, &pci_cfg_cmd_word);
+	atl2_read_pci_cfg(hw, PCI_COMMAND, &pci_cfg_cmd_word);
 	if ((pci_cfg_cmd_word &
 		(CMD_IO_SPACE|CMD_MEMORY_SPACE|CMD_BUS_MASTER)) !=
 		(CMD_IO_SPACE|CMD_MEMORY_SPACE|CMD_BUS_MASTER)) {
 		pci_cfg_cmd_word |=
 			(CMD_IO_SPACE|CMD_MEMORY_SPACE|CMD_BUS_MASTER);
-		atl2_write_pci_cfg(hw, PCI_REG_COMMAND, &pci_cfg_cmd_word);
+		atl2_write_pci_cfg(hw, PCI_COMMAND, &pci_cfg_cmd_word);
 	}
 
 	/* Clear Interrupt mask to stop board from generating
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.h b/drivers/net/ethernet/atheros/atlx/atl2.h
index d97613bd15d5..c53b810a831d 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.h
+++ b/drivers/net/ethernet/atheros/atlx/atl2.h
@@ -202,7 +202,7 @@ static void atl2_force_ps(struct atl2_hw *hw);
 #define MII_DBG_DATA	0x1E
 
 /* PCI Command Register Bit Definitions */
-#define PCI_REG_COMMAND		0x04
+#define PCI_COMMAND		0x04
 #define CMD_IO_SPACE		0x0001
 #define CMD_MEMORY_SPACE	0x0002
 #define CMD_BUS_MASTER		0x0004
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.h b/drivers/net/ethernet/atheros/atlx/atlx.h
index 7f5d4e24eb9f..09464cb02ce0 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.h
+++ b/drivers/net/ethernet/atheros/atlx/atlx.h
@@ -445,7 +445,7 @@
 #define MII_DBG_DATA			0x1E
 
 /* PCI Command Register Bit Definitions */
-#define PCI_REG_COMMAND			0x04	/* PCI Command Register */
+#define PCI_COMMAND			0x04	/* PCI Command Register */
 #define CMD_IO_SPACE			0x0001
 #define CMD_MEMORY_SPACE		0x0002
 #define CMD_BUS_MASTER			0x0004
-- 
2.21.0

