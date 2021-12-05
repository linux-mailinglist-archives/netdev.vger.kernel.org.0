Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5308C468B09
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 14:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhLEN0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 08:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbhLEN0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 08:26:32 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343B4C061714;
        Sun,  5 Dec 2021 05:23:05 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id g19so7608142pfb.8;
        Sun, 05 Dec 2021 05:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e9eTM2n98Nd7nOk/EHsIcI0GqJuPuQYYvCYB7glG4w8=;
        b=LA5cR6cBLyzKh4rG5/mchw8nDhFgApb31cf304o3t4/2uS2wI0Tqe4ofcynNRD0Nu1
         769bbaqpD+roOFZsa7AvpObSSFV1Upl/AVVnzTraHf7yR6TR7ns70wSawcT2Swug6Ttj
         IhQA2h+4ZHMGM5N8SXB6q0YX6RG9U0tExPsuf7PlkvdqNQn26cdX6DL5HMG9JoMnUotB
         XI9Cmwo9GSRkKELuo1tVRpnrDIWP1YesNskC/QjwIYNIBId2U6ghSh2Yy66X54YlBxKk
         AVmrkR+vkLhSXZh3tMs5BP8x5i2N9pZPBzoS3X14QsZPoyxQNsQoFal4k2Tbc2bz3IXx
         fZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e9eTM2n98Nd7nOk/EHsIcI0GqJuPuQYYvCYB7glG4w8=;
        b=y14sshSNQONjFxGHQGNcH8roUcSgFYvv2xOeXkJ2ZQMtMTLlrJ2Sexn0CX8oR2E3xz
         nQJXoWWBWqRVyaeoSgGmshhmfPNkVnL1tPo5zhA1QUeAeayNwdnMgLWUlxE2XQB4wiwP
         GmHWkIkD6alvk/o9EiaECR3X+aNCOA4BdpMhuQAjdvglIxzlBClO3g3i7VarvEiutFx+
         vsNZE0bqcYWN+auPkgfr5f3JJduKEDL77kfV08Wdq2INfWnp0Lw44stOwd8lWB7i8OqN
         MZSUvZaJY5Wl2LofP0O+N/wo4nDCRPrdcRLn6TpanSYO//9o3BTk44XvFyKMrADI8LY9
         ERyw==
X-Gm-Message-State: AOAM532tX7L0caLhz7vSlt0jFxn88DlTelwzuzXyb3c0JYxKSge8iDZg
        ksVw6w6YfXL9nSCi2DakjtM=
X-Google-Smtp-Source: ABdhPJzEAj+F2MfyteOLNwvj8HNkZ5bEIiYPemF/c3vfA1s2pR44qioJlo2mGj+9YWsRE2mKZWZiuQ==
X-Received: by 2002:a63:4e1c:: with SMTP id c28mr10982932pgb.318.1638710584756;
        Sun, 05 Dec 2021 05:23:04 -0800 (PST)
Received: from localhost.localdomain ([8.26.182.175])
        by smtp.gmail.com with ESMTPSA id f7sm9266376pfv.89.2021.12.05.05.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 05:23:04 -0800 (PST)
From:   Yanteng Si <siyanteng01@gmail.com>
X-Google-Original-From: Yanteng Si <siyanteng@loongson.cn>
To:     andrew@lunn.ch
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, corbet@lwn.net, chenhuacai@kernel.org,
        linux-doc@vger.kernel.org, siyanteng01@gmail.com,
        Yanteng Si <siyanteng@loongson.cn>
Subject: [PATCH] net: phy: Remove unnecessary indentation in the comments of phy_device
Date:   Sun,  5 Dec 2021 21:21:41 +0800
Message-Id: <20211205132141.4124145-1-siyanteng@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning as:

linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:543: WARNING: Unexpected indentation.
linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:544: WARNING: Block quote ends without a blank line; unexpected unindent.
linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:546: WARNING: Unexpected indentation.

Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
---
 include/linux/phy.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1e57cdd95da3..2f67273b0612 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -538,11 +538,11 @@ struct macsec_ops;
  * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
- *		Bits [15:0] are free to use by the PHY driver to communicate
- *			    driver specific behavior.
- *		Bits [23:16] are currently reserved for future use.
- *		Bits [31:24] are reserved for defining generic
- *			     PHY driver behavior.
+ * Bits [15:0] are free to use by the PHY driver to communicate
+ * driver specific behavior.
+ * Bits [23:16] are currently reserved for future use.
+ * Bits [31:24] are reserved for defining generic
+ * PHY driver behavior.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
  * @phy_timer: The timer for handling the state machine
  * @phylink: Pointer to phylink instance for this PHY
-- 
2.27.0

