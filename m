Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C79324E4
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfFBVMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:12:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37562 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfFBVMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:12:35 -0400
Received: by mail-wr1-f67.google.com with SMTP id h1so9976573wro.4
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1CzywQKWR8l8+0v7JkCrcMlW0rK00Kzd9BC4KmPsbks=;
        b=TJhg/oQgzDgE15PM1Z/ZQCvovlX92II2L+UH51pnYDzAnvAJ6NzMTOjO+Vl4ePlvg8
         1DZP++nkQTVyknZbEKHk7kQ1EV679ojE5JtcaGT22efk2OZP0jcPWB4xV48s6/GrwuUS
         JwYCVVVmrKVW3Yd6lbzDIUtST484l3TbODpGTmRpxQRRGp7kHtlt7zbtw84I7/S80rQQ
         WRfbWQa3KNt0VJyukRQIpbW3ilr87E8D4OgVNNmJN+O5zPGno6RzkA2/3NaF0ZXW9GbI
         MhfgOULOUbIIBxnqyhOZeCfDdrv2+6ifLtX8WI3Q9fdIUtvJHjeln4Kp/Bd2Sv7aA82x
         BiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1CzywQKWR8l8+0v7JkCrcMlW0rK00Kzd9BC4KmPsbks=;
        b=cS3ub4m3Sb3Gmc2ZafENj0yMwp5nODy8D2oJtLJufsOna9TzyejynW50jLLZ3gu6Zg
         jleDTMBATs3xxMSk1GKTJrSE1onk7kWAxQtGDy2YSN4Wp38YjEB6FyT3MkjbskQ4CCqI
         dPidBDnEn6IMgl6WSCWMM+bjGOyVz0g9aRCFhpHoKuCu4YJqbg6DMr+D3bRjsI6PRP7o
         Z/tUWdrZgLM2EZ1nK7p12bTNPaBHPoBncOjWlG79YQhM/I6Mf8wlKrGV6LL8z2CD2NzG
         i9rSIc1cmJT33wPiaNXlOLYVrrruS7H5RJ99rAzDugYlC/hpvFdnHk87+k+n2AsRdpb8
         8QCw==
X-Gm-Message-State: APjAAAVDKDz2OunU6eAEOTpEf80FNTGhbKCbBLRv7DuYGAR5zL0V2Jg4
        qEH+D4sFLIfhuX15eG3X5Uo=
X-Google-Smtp-Source: APXvYqyXgJMOT439lDmcZzegaJaCBUKOlOI3AFXw7SUY8UnVXbyUxJCp5JDjSukAVvQLatMmTum0JA==
X-Received: by 2002:a5d:63cb:: with SMTP id c11mr13809266wrw.65.1559509953671;
        Sun, 02 Jun 2019 14:12:33 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id q11sm9548193wmc.15.2019.06.02.14.12.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:12:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 01/11] net: dsa: sja1105: Shim declaration of struct sja1105_dyn_cmd
Date:   Mon,  3 Jun 2019 00:11:53 +0300
Message-Id: <20190602211203.17773-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602211203.17773-1-olteanv@gmail.com>
References: <20190602211203.17773-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This structure is merely an implementation detail and should be hidden
from the sja1105_dynamic_config.h header, which provides to the rest of
the driver an abstract access to the dynamic configuration interface of
the switch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 8 ++++++++
 drivers/net/dsa/sja1105/sja1105_dynamic_config.h | 8 +-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index e73ab28bf632..c981c12eb181 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -35,6 +35,14 @@
 #define SJA1105_MAX_DYN_CMD_SIZE				\
 	SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD
 
+struct sja1105_dyn_cmd {
+	u64 valid;
+	u64 rdwrset;
+	u64 errors;
+	u64 valident;
+	u64 index;
+};
+
 static void
 sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				  enum packing_op op)
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
index 77be59546a55..49c611eb02cb 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
@@ -7,13 +7,7 @@
 #include "sja1105.h"
 #include <linux/packing.h>
 
-struct sja1105_dyn_cmd {
-	u64 valid;
-	u64 rdwrset;
-	u64 errors;
-	u64 valident;
-	u64 index;
-};
+struct sja1105_dyn_cmd;
 
 struct sja1105_dynamic_table_ops {
 	/* This returns size_t just to keep same prototype as the
-- 
2.17.1

