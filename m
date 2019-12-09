Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45D8117834
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 22:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfLIVQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 16:16:31 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38202 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfLIVQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 16:16:31 -0500
Received: by mail-ot1-f66.google.com with SMTP id h20so13566359otn.5;
        Mon, 09 Dec 2019 13:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPQYv1CbF5PEoyV5DeRvhLdH9ApHt5XdOf0DWTue2HU=;
        b=QjS6ZYwgFxpo/3EKAkWOHJQjgc3+lg/XGoY+/I0Fb+FfiFr9BN3a7x+9JjDJAqlSGj
         1AEfquUPPfsAvU2H6JH7duI5fFp/GMuv1aJZ4w+CcTVsypB8MAYJRHp5yx+FluqLWuec
         iyloOOlIL5YfchuaJZ+LGklRyH+zn94xCCk0r9Np0shNXcHAAM2ZGR5sOIZz9Kem2OaZ
         H7QTzOM5jIwjU2c6n0CdSHPx+FZn5nrjr8dVkUKksd+ZxgfbLR5NaLIzKFlg5pobnDGG
         /FEinY/2W+/4wjxKj2d6PNz5/EosBGCaCcXTcy/P1TJTjejXocp/zBAKx88v1Jav47E+
         Bq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPQYv1CbF5PEoyV5DeRvhLdH9ApHt5XdOf0DWTue2HU=;
        b=UuN5h1g5/D29As4QOIeCXFKkEeqJH5x6PJJtZ1r1pd6igJudoGYPza3k+Bl93hV20W
         p+6MreDcSdupnYnA6tTOEkODNBHSFejOYgg8zaZQDEDIK+4PvAksNiGoBTPMq0wM4jfo
         IRS0YrNCz3Kj+bnxsg7cgp7wXKTLdq2V6O7bSPBKzt+vG2XdlC5gcxSDGLlOcZ3cT6Z6
         3qvidBYG1JCaSGK3jpP1HYZqPwBg5Q0/Jfs0dEqR1RrAWvke1VkAC5CjJILFUcfcKBLT
         7/FmBNv5LPDt5sVVBzsVzkoC76AlnaKEnUWUvf3qEMaQPQfb88ypUVLdAiQ3CmoxMKzC
         NwJA==
X-Gm-Message-State: APjAAAXcK0R1XoPhImJA5N8cpL6/oXOQQx4A+O5+lzeZUV8f1+zo7zEl
        tL2KacQ4WSBaaAYA2PaBe7XpdguzL7A=
X-Google-Smtp-Source: APXvYqy1MfB4bbMMrkLP5JgBCVwn6uHSi2l3IRpKKB9OtqFyxx7T73FbSy1fHrbn7gBsMT4+ZKAchw==
X-Received: by 2002:a9d:74d8:: with SMTP id a24mr24272190otl.100.1575926190314;
        Mon, 09 Dec 2019 13:16:30 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 11sm461647otz.3.2019.12.09.13.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 13:16:29 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net: tulip: Adjust indentation in {dmfe,uli526x}_init_module
Date:   Mon,  9 Dec 2019 14:16:23 -0700
Message-Id: <20191209211623.44166-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

../drivers/net/ethernet/dec/tulip/uli526x.c:1812:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
        switch (mode) {
        ^
../drivers/net/ethernet/dec/tulip/uli526x.c:1809:2: note: previous
statement is here
        if (cr6set)
        ^
1 warning generated.

../drivers/net/ethernet/dec/tulip/dmfe.c:2217:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
        switch(mode) {
        ^
../drivers/net/ethernet/dec/tulip/dmfe.c:2214:2: note: previous
statement is here
        if (cr6set)
        ^
1 warning generated.

This warning occurs because there is a space before the tab on these
lines. Remove them so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

While we are here, adjust the default block in dmfe_init_module to have
a proper break between the label and assignment and add a space between
the switch and opening parentheses to avoid a checkpatch warning.

Fixes: e1c3e5014040 ("[PATCH] initialisation cleanup for ULI526x-net-driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/795
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/dec/tulip/dmfe.c    | 7 ++++---
 drivers/net/ethernet/dec/tulip/uli526x.c | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index 0efdbd1a4a6f..32d470d4122a 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -2214,15 +2214,16 @@ static int __init dmfe_init_module(void)
 	if (cr6set)
 		dmfe_cr6_user_set = cr6set;
 
- 	switch(mode) {
-   	case DMFE_10MHF:
+	switch (mode) {
+	case DMFE_10MHF:
 	case DMFE_100MHF:
 	case DMFE_10MFD:
 	case DMFE_100MFD:
 	case DMFE_1M_HPNA:
 		dmfe_media_mode = mode;
 		break;
-	default:dmfe_media_mode = DMFE_AUTO;
+	default:
+		dmfe_media_mode = DMFE_AUTO;
 		break;
 	}
 
diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index b1f30b194300..117ffe08800d 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -1809,8 +1809,8 @@ static int __init uli526x_init_module(void)
 	if (cr6set)
 		uli526x_cr6_user_set = cr6set;
 
- 	switch (mode) {
-   	case ULI526X_10MHF:
+	switch (mode) {
+	case ULI526X_10MHF:
 	case ULI526X_100MHF:
 	case ULI526X_10MFD:
 	case ULI526X_100MFD:
-- 
2.24.0

