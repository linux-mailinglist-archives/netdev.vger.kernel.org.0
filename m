Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2650D5020E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfFXGTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:19:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41885 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfFXGTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:19:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id m7so6253903pls.8
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 23:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding:cc:from:to;
        bh=rpm1wCgAEfHZvBGxttYyRQHFsJlX3sGmqafd0katLnk=;
        b=Ipq8WIGSgAswuTuRxYpIm0iHGL0DxdsDdTVCieMq+tB8uHTI3Z71YKzENBMaNekFO1
         0CtGss3K0oK7bU3QfmUIWeH0IcdDMAUAitK69I5Rc0A6jv1wuVB8xMHGmlFoHaaqF3vj
         2VHTvCFQJg6ZAAFcWYwHH5QIshVk7vRLb2WcjnPfLvzbguBs4kkMVqO7uSsZPRFIpf50
         jB6ehJ8yDBPkoFJbnESiRCWY+PqUCCKNb1HNo67bT5Mzl+sbRNfdUhNXA/3hm62OAMaA
         6eKsPTe6ehR4+RxdMVvnIYoPXbaWwdhi+lPFPiJWs/MZ72h/4+SgvmwLoC0eUben5G8r
         4JPw==
X-Gm-Message-State: APjAAAVfmCt8pCn2lNX1PQ2SUJvnm5t/DqeHYMGsc6TfTzewGm8+X8qY
        n0sZWjpC5AzNk+XVuU+eeND5xDu8x+pKJQ==
X-Google-Smtp-Source: APXvYqx7B25IHDAa5NnQtkwIFYSIlYT6MSecbPmUB5KuKZtiiJBO+jVepUmZEtl3wQMqCBGXNbYsTw==
X-Received: by 2002:a17:902:9a82:: with SMTP id w2mr127519179plp.291.1561357148911;
        Sun, 23 Jun 2019 23:19:08 -0700 (PDT)
Received: from localhost (220-132-236-182.HINET-IP.hinet.net. [220.132.236.182])
        by smtp.gmail.com with ESMTPSA id r188sm3524198pfr.16.2019.06.23.23.19.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 23:19:08 -0700 (PDT)
Subject: [PATCH 2/2] net: macb: Kconfig: Rename Atmel to Cadence
Date:   Sun, 23 Jun 2019 23:16:03 -0700
Message-Id: <20190624061603.1704-3-palmer@sifive.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190624061603.1704-1-palmer@sifive.com>
References: <20190624061603.1704-1-palmer@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>
From:   Palmer Dabbelt <palmer@sifive.com>
To:     davem@davemloft.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When touching the Kconfig for this driver I noticed that both the
Kconfig help text and a comment referred to this being an Atmel driver.
As far as I know, this is a Cadence driver.  The fix is just
s/Atmel/Cadence/, but I did go and re-wrap the Kconfig help text as that
change caused it to go over 80 characters.

Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
---
 drivers/net/ethernet/cadence/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 74ee2bfd2369..29b6132b418e 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Atmel device configuration
+# Cadence device configuration
 #
 
 config NET_VENDOR_CADENCE
@@ -13,8 +13,8 @@ config NET_VENDOR_CADENCE
 	  If unsure, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the remaining Atmel network card questions. If you say Y, you will be
+	  kernel: saying N will just cause the configurator to skip all the
+	  remaining Cadence network card questions. If you say Y, you will be
 	  asked for your specific card in the following questions.
 
 if NET_VENDOR_CADENCE
-- 
2.21.0

