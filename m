Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C256B92C2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCNMMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCNMMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:12:24 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64278584B3;
        Tue, 14 Mar 2023 05:11:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id fd25so9578258pfb.1;
        Tue, 14 Mar 2023 05:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678795918;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fLOiANFqOi3wCdM3FGbLFB9AhuDgThqUdwTy4yeXIF0=;
        b=jhyQ3METWoCznCYzEZEf3dooJ/wr5dURSHCk2a/blSO/+4qFYrNBc94DTB1Aj8xO+u
         6JqjjTFz+YH6HfWGY9ACeOPMJVguSlhAROm9Z1swZWZ1TJhl8ghwaSQGUKmvgxXt6KCA
         93JE3Cg11EXN3fK1vJnYYpNd0vidJUZ3Cpd6Soh1S3ceO/SvbJAVkpn0WY1Wmo81hvaJ
         mc61i9cfVtoxOYGgDgpDUYNEfE5JfdqNBQ9cSczTCTf4SB7QY561pTzgCCdcpwks8q2x
         Cu+RdjKkTf5dlpDfZZ8tFjiW5zAMu6AdMa+ftMAHEb9bOnTYw/dVIwEhf7Boo/x2WPh6
         S7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678795918;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fLOiANFqOi3wCdM3FGbLFB9AhuDgThqUdwTy4yeXIF0=;
        b=LGwjT3+PR9MTBD3acFhW610JfYMHH01Kfia7o9rR55rJsTkv91rpcKjLTo7Aodq0Zz
         H1zISfLqTVPtzVXEGigRK3ZzvyyMIcnMAYJXmM2OVSbmdGg+o+rdsEfTvCExRKd11+o3
         Hjut7qiPgrmD818y2zNcWs1tbMqldPktJDHO+NOl8LXuvPVQOeLW5dLmwI/mt33TMl07
         N3gfrkryUPGHwsuG1i5QQDmCraxfGKtOi8WRm0azWo95Fqx1i6MSpkpR2pGZ1sQDeuG+
         Q+A87N6K5OwFIg3W5lS4fyRIl/o7VR9egfptPw/l4s4DfnxyfbvUEeFnBw0W9Jhbngz+
         ZerQ==
X-Gm-Message-State: AO0yUKUA2tSRn2OxdXhuxJPPU/8TIsb7Uo5eQeboc8pde4mTeU2JQu1O
        0H+LAAe5gWh6Y4w07cxYXdPGiJexdcLgKQ==
X-Google-Smtp-Source: AK7set9kndnwILN2cfyKlOfZpDCZ4z63OhVoikttIm/+N1sMW7D5K+2f2M2Gul6Wh+L4jKMyfLf5TA==
X-Received: by 2002:aa7:9508:0:b0:5e0:3038:2300 with SMTP id b8-20020aa79508000000b005e030382300mr36080931pfp.20.1678795917706;
        Tue, 14 Mar 2023 05:11:57 -0700 (PDT)
Received: from sumitra.com ([59.89.170.99])
        by smtp.gmail.com with ESMTPSA id r3-20020a654983000000b004f27761a9e7sm1440786pgs.12.2023.03.14.05.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 05:11:57 -0700 (PDT)
Date:   Tue, 14 Mar 2023 05:11:52 -0700
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     outreachy@lists.linux.dev, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v3] Staging: qlge: Fix indentation in conditional statement
Message-ID: <20230314121152.GA38979@sumitra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tabs/spaces in conditional statements in to fix the
indentation.

Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>

---
v2: Fix indentation in conditional statement, noted by Dan Carpenter
 <error27@gmail.com>
v3: Apply changes to fresh git tree


 drivers/staging/qlge/qlge_dbg.c | 35 +++++++++++++++------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 66d28358342f..c7e865f515cf 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -351,26 +351,23 @@ static int qlge_get_xgmac_regs(struct qlge_adapter *qdev, u32 *buf,
 		/* We're reading 400 xgmac registers, but we filter out
 		 * several locations that are non-responsive to reads.
 		 */
-		if ((i == 0x00000114) ||
-		    (i == 0x00000118) ||
-			(i == 0x0000013c) ||
-			(i == 0x00000140) ||
-			(i > 0x00000150 && i < 0x000001fc) ||
-			(i > 0x00000278 && i < 0x000002a0) ||
-			(i > 0x000002c0 && i < 0x000002cf) ||
-			(i > 0x000002dc && i < 0x000002f0) ||
-			(i > 0x000003c8 && i < 0x00000400) ||
-			(i > 0x00000400 && i < 0x00000410) ||
-			(i > 0x00000410 && i < 0x00000420) ||
-			(i > 0x00000420 && i < 0x00000430) ||
-			(i > 0x00000430 && i < 0x00000440) ||
-			(i > 0x00000440 && i < 0x00000450) ||
-			(i > 0x00000450 && i < 0x00000500) ||
-			(i > 0x0000054c && i < 0x00000568) ||
-			(i > 0x000005c8 && i < 0x00000600)) {
+		if ((i == 0x00000114) || (i == 0x00000118) ||
+		    (i == 0x0000013c) || (i == 0x00000140) ||
+		    (i > 0x00000150 && i < 0x000001fc) ||
+		    (i > 0x00000278 && i < 0x000002a0) ||
+		    (i > 0x000002c0 && i < 0x000002cf) ||
+		    (i > 0x000002dc && i < 0x000002f0) ||
+		    (i > 0x000003c8 && i < 0x00000400) ||
+		    (i > 0x00000400 && i < 0x00000410) ||
+		    (i > 0x00000410 && i < 0x00000420) ||
+		    (i > 0x00000420 && i < 0x00000430) ||
+		    (i > 0x00000430 && i < 0x00000440) ||
+		    (i > 0x00000440 && i < 0x00000450) ||
+		    (i > 0x00000450 && i < 0x00000500) ||
+		    (i > 0x0000054c && i < 0x00000568) ||
+		    (i > 0x000005c8 && i < 0x00000600)) {
 			if (other_function)
-				status =
-				qlge_read_other_func_xgmac_reg(qdev, i, buf);
+				status = qlge_read_other_func_xgmac_reg(qdev, i, buf);
 			else
 				status = qlge_read_xgmac_reg(qdev, i, buf);
 
-- 
2.25.1

