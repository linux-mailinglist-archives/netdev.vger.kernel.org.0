Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09E69B6DC
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388918AbfHWTOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:14:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36102 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbfHWTOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 15:14:38 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so6078588plr.3;
        Fri, 23 Aug 2019 12:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KfyCvX/wLd+xBmfJHt9z6f1mRRr5A8kveHSdf9q4hGs=;
        b=M8S8yGC7LZgC1vErDOoHct/w8T0Ps0GwHoxdt7XCW/IfGlv+EVwtweMFpwIQFAE4SD
         zVFIw0jNxfwQSqcSdGv7cN+S4s+iFP4Sb2vQbcC1TyP4fYa+0yaGs3YTCeHH2M4If8yW
         gXSxWTSeyXU54BisNezLnafFi1zDnev2HfUu8PAP4YLu7GkleyOEeaG0SRglUWQEmTzC
         D4FtgMwDXQ+8RKtyx04LwGz0XZ2VE+ntrggi+3qGwweHUQr8tH+knrFCt78IrSZoRr2J
         AUOt/k3rAB0FB/3geWDUNDkkJrIFYxMs5WUIvJycEFu/O68BpG3BwnkPYGPAa/gn/NN9
         fJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KfyCvX/wLd+xBmfJHt9z6f1mRRr5A8kveHSdf9q4hGs=;
        b=tZ/0+WAYW65FTNE35YmJj+3V5MI0tlOt41yLb4pavPaCVH+nUwqLgEmD3dyMrqkjzK
         dBf1CGEZF38Ho9hVsYT+PbyvyP2Dam7nTE/3z7q1Ojecr9GYCyX9GvzWxjzeseuttbTW
         W6Pw8uT0+gXZx/dVW8Jm1IodMIcJYHBNihEvpKprLvZC5zSnS0Dl4FaX1lgfGkvIiAC+
         e9R3DxMdfGcjYNW8jH4TcKIvEMGYshaUXvwnc/8w0TVTNNjwDBxqYV2yHs2QyQ/yPt2C
         +6urDN+PdHbfX9dcYT5MjLdJ96OjYgNfa4yS3OV09ztLVC8wEVc3ia8nj1t9uTc70pI3
         tPsg==
X-Gm-Message-State: APjAAAVV7FwlgOoLn2kkc8vwlUoV7STOLs5iB0qzfkxqEC8Ff78ysp9j
        ZXPKad+4y4m2GjZSbX+3m9GG6dl6
X-Google-Smtp-Source: APXvYqy+0eDy7inwc30A38gZ65ippwvVtu3pIyFRgieb00b8trbyEm9Bnp8DP8TU36jggEXda6+rkA==
X-Received: by 2002:a17:902:3:: with SMTP id 3mr6767876pla.41.1566587677471;
        Fri, 23 Aug 2019 12:14:37 -0700 (PDT)
Received: from vm ([104.133.9.111])
        by smtp.gmail.com with ESMTPSA id h17sm4685829pfo.24.2019.08.23.12.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 12:14:37 -0700 (PDT)
From:   Forrest Fleming <ffleming@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Forrest Fleming <ffleming@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: intel: Cleanup e1000 - add space between }}
Date:   Fri, 23 Aug 2019 19:14:21 +0000
Message-Id: <20190823191421.3318-1-ffleming@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

suggested by checkpatch

Signed-off-by: Forrest Fleming <ffleming@gmail.com>
---
 .../net/ethernet/intel/e1000/e1000_param.c    | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_param.c b/drivers/net/ethernet/intel/e1000/e1000_param.c
index d3f29ffe1e47..1a1f2f0237f9 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_param.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_param.c
@@ -266,7 +266,7 @@ void e1000_check_options(struct e1000_adapter *adapter)
 			.arg  = { .r = {
 				.min = E1000_MIN_TXD,
 				.max = mac_type < e1000_82544 ? E1000_MAX_TXD : E1000_MAX_82544_TXD
-				}}
+				} }
 		};
 
 		if (num_TxDescriptors > bd) {
@@ -295,7 +295,7 @@ void e1000_check_options(struct e1000_adapter *adapter)
 				.min = E1000_MIN_RXD,
 				.max = mac_type < e1000_82544 ? E1000_MAX_RXD :
 				       E1000_MAX_82544_RXD
-			}}
+			} }
 		};
 
 		if (num_RxDescriptors > bd) {
@@ -341,7 +341,7 @@ void e1000_check_options(struct e1000_adapter *adapter)
 			.err  = "reading default settings from EEPROM",
 			.def  = E1000_FC_DEFAULT,
 			.arg  = { .l = { .nr = ARRAY_SIZE(fc_list),
-					 .p = fc_list }}
+					 .p = fc_list } }
 		};
 
 		if (num_FlowControl > bd) {
@@ -359,7 +359,7 @@ void e1000_check_options(struct e1000_adapter *adapter)
 			.err  = "using default of " __MODULE_STRING(DEFAULT_TIDV),
 			.def  = DEFAULT_TIDV,
 			.arg  = { .r = { .min = MIN_TXDELAY,
-					 .max = MAX_TXDELAY }}
+					 .max = MAX_TXDELAY } }
 		};
 
 		if (num_TxIntDelay > bd) {
@@ -377,7 +377,7 @@ void e1000_check_options(struct e1000_adapter *adapter)
 			.err  = "using default of " __MODULE_STRING(DEFAULT_TADV),
 			.def  = DEFAULT_TADV,
 			.arg  = { .r = { .min = MIN_TXABSDELAY,
-					 .max = MAX_TXABSDELAY }}
+					 .max = MAX_TXABSDELAY } }
 		};
 
 		if (num_TxAbsIntDelay > bd) {
@@ -395,7 +395,7 @@ void e1000_check_options(struct e1000_adapter *adapter)
 			.err  = "using default of " __MODULE_STRING(DEFAULT_RDTR),
 			.def  = DEFAULT_RDTR,
 			.arg  = { .r = { .min = MIN_RXDELAY,
-					 .max = MAX_RXDELAY }}
+					 .max = MAX_RXDELAY } }
 		};
 
 		if (num_RxIntDelay > bd) {
@@ -413,7 +413,7 @@ void e1000_check_options(struct e1000_adapter *adapter)
 			.err  = "using default of " __MODULE_STRING(DEFAULT_RADV),
 			.def  = DEFAULT_RADV,
 			.arg  = { .r = { .min = MIN_RXABSDELAY,
-					 .max = MAX_RXABSDELAY }}
+					 .max = MAX_RXABSDELAY } }
 		};
 
 		if (num_RxAbsIntDelay > bd) {
@@ -431,7 +431,7 @@ void e1000_check_options(struct e1000_adapter *adapter)
 			.err  = "using default of " __MODULE_STRING(DEFAULT_ITR),
 			.def  = DEFAULT_ITR,
 			.arg  = { .r = { .min = MIN_ITR,
-					 .max = MAX_ITR }}
+					 .max = MAX_ITR } }
 		};
 
 		if (num_InterruptThrottleRate > bd) {
@@ -545,7 +545,7 @@ static void e1000_check_copper_options(struct e1000_adapter *adapter)
 			{          0, "" },
 			{   SPEED_10, "" },
 			{  SPEED_100, "" },
-			{ SPEED_1000, "" }};
+			{ SPEED_1000, "" } };
 
 		opt = (struct e1000_option) {
 			.type = list_option,
@@ -553,7 +553,7 @@ static void e1000_check_copper_options(struct e1000_adapter *adapter)
 			.err  = "parameter ignored",
 			.def  = 0,
 			.arg  = { .l = { .nr = ARRAY_SIZE(speed_list),
-					 .p = speed_list }}
+					 .p = speed_list } }
 		};
 
 		if (num_Speed > bd) {
@@ -567,7 +567,7 @@ static void e1000_check_copper_options(struct e1000_adapter *adapter)
 		static const struct e1000_opt_list dplx_list[] = {
 			{           0, "" },
 			{ HALF_DUPLEX, "" },
-			{ FULL_DUPLEX, "" }};
+			{ FULL_DUPLEX, "" } };
 
 		opt = (struct e1000_option) {
 			.type = list_option,
@@ -575,7 +575,7 @@ static void e1000_check_copper_options(struct e1000_adapter *adapter)
 			.err  = "parameter ignored",
 			.def  = 0,
 			.arg  = { .l = { .nr = ARRAY_SIZE(dplx_list),
-					 .p = dplx_list }}
+					 .p = dplx_list } }
 		};
 
 		if (num_Duplex > bd) {
@@ -623,7 +623,7 @@ static void e1000_check_copper_options(struct e1000_adapter *adapter)
 			 { 0x2c, AA "1000/FD, 100/FD, 100/HD" },
 			 { 0x2d, AA "1000/FD, 100/FD, 100/HD, 10/HD" },
 			 { 0x2e, AA "1000/FD, 100/FD, 100/HD, 10/FD" },
-			 { 0x2f, AA "1000/FD, 100/FD, 100/HD, 10/FD, 10/HD" }};
+			 { 0x2f, AA "1000/FD, 100/FD, 100/HD, 10/FD, 10/HD" } };
 
 		opt = (struct e1000_option) {
 			.type = list_option,
@@ -631,7 +631,7 @@ static void e1000_check_copper_options(struct e1000_adapter *adapter)
 			.err  = "parameter ignored",
 			.def  = AUTONEG_ADV_DEFAULT,
 			.arg  = { .l = { .nr = ARRAY_SIZE(an_list),
-					 .p = an_list }}
+					 .p = an_list } }
 		};
 
 		if (num_AutoNeg > bd) {
-- 
2.17.1

