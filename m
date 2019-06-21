Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24FD4ED45
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfFUQka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:40:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38913 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUQka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:40:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so3640314pgc.6;
        Fri, 21 Jun 2019 09:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W/+t2oF2T5eKqD5lT+8QUcLyNJmob85epyf9XJ3GxDw=;
        b=Kgf4e/ku7hwdnwqim/1SbJpQ5kGBJoNmQYquTn1A1plv/H2fh0Jh6AAm3KZKVNaZgq
         nPgi8op6X+XC1c8R6/CfKv60wnU26d02nUWIfLpLSUcmslW12tUJinjzcG3j7/l/hbSR
         7P8Bo2dpSY5sWum/w7s/L9LxjnAaGyWqIc5QZyRxb562ln+nmQFeToUep5+cU887hTt+
         oLrIDgTRKu/cO0GdfiYz1wqmnX2M/4Sq0/PLjiqVFyKqiKH8y9iOGv2IPIHDqgZACv+8
         OPewJQ7/K9UvnWnt1lAQKSW9iWQutAdxmHKzkNFZiSESLvD+NGeQXbu4dtO1HJAOgxpq
         M/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/+t2oF2T5eKqD5lT+8QUcLyNJmob85epyf9XJ3GxDw=;
        b=K5EC0JCwrVzbTuYQzcBXW3Kp7ttVIvR+u5Xv0j5kNzUeJQa/Pr/amAfjAeyNc0mecJ
         tbjapbJ4h2rz7EXS1FVsT+cpl54SahUDQEY3kACHWuarhbdDMq5T2e9FfIGSnIAWK4Nf
         Hm18R13VZtpQCmPs716f1lt5fDdhD0prFzrycV+a6BzPyCRLKsKDiYcMMpfJTWVgtnPr
         0jb3SI8m0jKIN5mb9fIXhDzws7nJQIpzattPK8UFN9dZQCb04Pkn3ny56XXGL2vwfOUa
         5+jxouETyxsmrreW40T3Is+VwZWlHpDHY2Eit/HbaDq6Hq5v14lUztmylcZ/Jhj8G7DE
         fjOg==
X-Gm-Message-State: APjAAAV6+gPxgJvWNTnsbAvkn2k+z/w+Un39Tc/KW+9CS4HIc+cWY18V
        dfokq4Zz3iIIwG0Y4gMSKOU=
X-Google-Smtp-Source: APXvYqynM1s+PyD4cl/ai3zSbzmA/prIyg8EVBjmhCpUibSYWaTLbyW66gmF1EipEN4MivuwfBBQqg==
X-Received: by 2002:a17:90a:b78b:: with SMTP id m11mr7978235pjr.106.1561135229262;
        Fri, 21 Jun 2019 09:40:29 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id n89sm25702450pjc.0.2019.06.21.09.40.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 09:40:28 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 3/3] net: ethernet: atheros: atlx: Remove unused and private PCI definitions
Date:   Fri, 21 Jun 2019 22:09:21 +0530
Message-Id: <20190621163921.26188-4-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621163921.26188-1-puranjay12@gmail.com>
References: <20190621163921.26188-1-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused private PCI definitions from skfbi.h because generic PCI
symbols are already included from pci_regs.h.

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/ethernet/atheros/atlx/atl2.h | 2 --
 drivers/net/ethernet/atheros/atlx/atlx.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.h b/drivers/net/ethernet/atheros/atlx/atl2.h
index c53b810a831d..1b25d6d747de 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.h
+++ b/drivers/net/ethernet/atheros/atlx/atl2.h
@@ -32,7 +32,6 @@
 int ethtool_ioctl(struct ifreq *ifr);
 #endif
 
-#define PCI_COMMAND_REGISTER	PCI_COMMAND
 #define CMD_MEM_WRT_INVALIDATE	PCI_COMMAND_INVALIDATE
 
 #define ATL2_WRITE_REG(a, reg, value) (iowrite32((value), \
@@ -202,7 +201,6 @@ static void atl2_force_ps(struct atl2_hw *hw);
 #define MII_DBG_DATA	0x1E
 
 /* PCI Command Register Bit Definitions */
-#define PCI_COMMAND		0x04
 #define CMD_IO_SPACE		0x0001
 #define CMD_MEMORY_SPACE	0x0002
 #define CMD_BUS_MASTER		0x0004
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.h b/drivers/net/ethernet/atheros/atlx/atlx.h
index 09464cb02ce0..4d355dbc2d01 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.h
+++ b/drivers/net/ethernet/atheros/atlx/atlx.h
@@ -445,7 +445,6 @@
 #define MII_DBG_DATA			0x1E
 
 /* PCI Command Register Bit Definitions */
-#define PCI_COMMAND			0x04	/* PCI Command Register */
 #define CMD_IO_SPACE			0x0001
 #define CMD_MEMORY_SPACE		0x0002
 #define CMD_BUS_MASTER			0x0004
-- 
2.21.0

