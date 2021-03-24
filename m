Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696DD3472FF
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 08:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhCXHum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 03:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbhCXHua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 03:50:30 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3C0C0613DC;
        Wed, 24 Mar 2021 00:50:27 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id 7so17150232qka.7;
        Wed, 24 Mar 2021 00:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FcDFw9pS59FCq2dC+L/DGMsyyk+zow0NP8EkShBfK2o=;
        b=Bu8GCUgNMJO3TVDbP6lVmx5CN80PBNhZd3K9MT6rKDynjZZmQq7JO+5/rJSMap6Caj
         O7hjj7mRUKx97eQi5u452Alnojt3A//aBiA26W57ZkWPsMvRBeCJiH2MYzVMMujl5kaG
         zINreFsQ6VW1i8Wv0AjYYMF81o3b3yido31exE6VDNSmQttdFWEHIrZTF7nVVWABGoZK
         ejRA6CanzRLIHrRYttddrL3dD7H8xsO5F6vpgGoBMcSuLToVaWPEfEbqeA8m5e/S3S14
         6so1t8kECHs/xfRJOCbMJ+FeY5C3Cp53mNYzC5X0T2xhiCGgvygNv4zT1VJizdD7IYH3
         KG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FcDFw9pS59FCq2dC+L/DGMsyyk+zow0NP8EkShBfK2o=;
        b=RN/q44KQniRYKDb703LcIa6LAHu5l85zCjzqfS/E3naxiOchSpx9fZ9VTnjDXUBq/o
         k962D9RBAxlmMM22v77Y7QM6sx+CzVFJHz8bOJfwd+hDIAVUR1RZwzrk86geoV8P/Ira
         jcaGY9bqUeABuT09kQ5Tv76JifaTARxdn7Z5TKgrD3uRWFMyYGbwRJ2Hc4Z3gnFVGe6H
         xyz97hVSGgkyz5tyzJBqHeyMH+tiOfpWOGZ1ve+lTWk89h997s7jWluB8WnCl1z+1hkK
         JvG9ux4rclLBT2emMeJ9idkrxDsclg0HLqMD4otioi6lUDHz6uBLDT/Ljgt8LxSwRk1d
         SWQQ==
X-Gm-Message-State: AOAM532+x2K5br40lMRA595l5C2C5eraD/FrJRcaZMs33I8oeF+bmfRh
        uG23K53gGY5Iv1hjmcZboo0=
X-Google-Smtp-Source: ABdhPJyo16QC/XvwQjj2JesxoeOcA4VYtCOtH9vRQ0rOdHSAEABEoZx6xB7Pi17BmAAEBtIXnfAYig==
X-Received: by 2002:a37:a38e:: with SMTP id m136mr1829230qke.250.1616572226377;
        Wed, 24 Mar 2021 00:50:26 -0700 (PDT)
Received: from Slackware.localdomain ([156.146.37.194])
        by smtp.gmail.com with ESMTPSA id c13sm1098481qkc.99.2021.03.24.00.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 00:50:25 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, unixbhaskar@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] sfc-falcon: Fix a typo
Date:   Wed, 24 Mar 2021 13:22:04 +0530
Message-Id: <20210324075204.29645-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/maintaning/maintaining/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/sfc/falcon/net_driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index a529ff395ead..a381cf9ec4f3 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -637,7 +637,7 @@ union ef4_multicast_hash {
  * struct ef4_nic - an Efx NIC
  * @name: Device name (net device name or bus id before net device registered)
  * @pci_dev: The PCI device
- * @node: List node for maintaning primary/secondary function lists
+ * @node: List node for maintaining primary/secondary function lists
  * @primary: &struct ef4_nic instance for the primary function of this
  *	controller.  May be the same structure, and may be %NULL if no
  *	primary function is bound.  Serialised by rtnl_lock.
--
2.30.1

