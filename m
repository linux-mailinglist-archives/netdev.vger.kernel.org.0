Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65444338664
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhCLHIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbhCLHIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:08:13 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5EAC061574;
        Thu, 11 Mar 2021 23:08:13 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id f12so3085942qtq.4;
        Thu, 11 Mar 2021 23:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DvgmjGd5npZcPxA1X72is4z6QiybdF+GT4ayLBGttvY=;
        b=Q7mRlVcx8SIMhCb2j8vkqdkMC4Q1arhBzdr/hbccH47+lFebC9eYJRNuoStNBOjW2A
         I6wiLGNCsjTsN3sfGWQ10sR4WAuzxS+436sL0hji1lGGdVo7ERHBWxGpX/xsMSQYqYtl
         r5WgMujO7q95FJorLmpR1NltARuuRJrKlyANd2Ec3TPw9beb6uyUEOxI3OyH9XxPsIH8
         h5u3iot2noBD4rHCQoAbcc0NZnpqljlDqghlqrUrjup5/RUPGjeslr433H3lpudCgOE6
         KBUEyNFLiGh4mtbBSeOex1xjTzMtk0gl+FKumWbpwSQrOvbxthRcnm4O0O360usrap0R
         npQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DvgmjGd5npZcPxA1X72is4z6QiybdF+GT4ayLBGttvY=;
        b=FlJW8YFv42UVQTKvCK2zb3ymhrPbzNp8u1khOUhehZBMPlKeaSvdN/UAy4m4+NrJuh
         DEvB1agS1BpZUk1U59VpPQLv3AeeGxfjsry8rze3rjzClaegJJ/bP0CR5CGaTMk8qCI3
         xchxN8oysowcY7GBBIu5NuBfBlNMval5yoK3EgdfPYNK55DAZ3soP559+gKHGrY7CMI1
         PQpfF3tnIxGYgYMg35lQZjjv/1J5kW91A5EE5LTcaT0MTZSajgn1BhJnPkJX+wPttvN2
         jMCzgYnJ57MgPQGuJOeOSI8YLQwsnRorusIwqk1fZ/5PH09psYAEzNOLFIPL+ZzwoNqA
         OOog==
X-Gm-Message-State: AOAM530emQjysirXb5tR854/VXp2ar9rbTjYe/MKQmHoy4KOHcQibIXu
        ao60c94marApdX89Y5yibBM=
X-Google-Smtp-Source: ABdhPJykIktGOZFOaqpLdbrnH6dgVY2BrDHqyqbH3dyO+U1lJoo28ioXvnzNVxSt5crCWMtyI5VkUw==
X-Received: by 2002:ac8:5047:: with SMTP id h7mr9480366qtm.22.1615532892774;
        Thu, 11 Mar 2021 23:08:12 -0800 (PST)
Received: from localhost.localdomain ([138.199.13.196])
        by smtp.gmail.com with ESMTPSA id 7sm3870536qkm.64.2021.03.11.23.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 23:08:12 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, unixbhaskar@gmail.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] net: ethernet: dec: tulip: Random spelling fixes throughout the file pnic2.c
Date:   Fri, 12 Mar 2021 12:35:42 +0530
Message-Id: <20210312070542.31309-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Random spelling fixes throughout the file.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/dec/tulip/pnic2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/pnic2.c b/drivers/net/ethernet/dec/tulip/pnic2.c
index 412adaa7fdf8..04daffb8db2a 100644
--- a/drivers/net/ethernet/dec/tulip/pnic2.c
+++ b/drivers/net/ethernet/dec/tulip/pnic2.c
@@ -107,7 +107,7 @@ void pnic2_start_nway(struct net_device *dev)
          */
 	csr14 = (ioread32(ioaddr + CSR14) & 0xfff0ee39);

-        /* bit 17 - advetise 100baseTx-FD */
+        /* bit 17 - advertise 100baseTx-FD */
         if (tp->sym_advertise & 0x0100) csr14 |= 0x00020000;

         /* bit 16 - advertise 100baseTx-HD */
@@ -116,7 +116,7 @@ void pnic2_start_nway(struct net_device *dev)
         /* bit 6 - advertise 10baseT-HD */
         if (tp->sym_advertise & 0x0020) csr14 |= 0x00000040;

-        /* Now set bit 12 Link Test Enable, Bit 7 Autonegotiation Enable
+        /* Now set bit 12 Link Test Enable, Bit 7 Auto negotiation Enable
          * and bit 0 Don't PowerDown 10baseT
          */
         csr14 |= 0x00001184;
@@ -157,7 +157,7 @@ void pnic2_start_nway(struct net_device *dev)
         /* all set up so now force the negotiation to begin */

         /* read in current values and mask off all but the
-	 * Autonegotiation bits 14:12.  Writing a 001 to those bits
+	 * Auto negotiation bits 14:12.  Writing a 001 to those bits
          * should start the autonegotiation
          */
         csr12 = (ioread32(ioaddr + CSR12) & 0xffff8fff);
@@ -290,7 +290,7 @@ void pnic2_lnk_change(struct net_device *dev, int csr5)
 	                csr14 = (ioread32(ioaddr + CSR14) & 0xffffff7f);
                         iowrite32(csr14,ioaddr + CSR14);

-                        /* what should we do when autonegotiate fails?
+                        /* what should we do when auto negotiate fails?
                          * should we try again or default to baseline
                          * case.  I just don't know.
                          *
--
2.26.2

