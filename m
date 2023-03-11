Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004FA6B5EBD
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCKRZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCKRZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:25:48 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE20367E9;
        Sat, 11 Mar 2023 09:25:47 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 16so4774163pge.11;
        Sat, 11 Mar 2023 09:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678555546;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QS/175t+MbbtSL3ZqMpuuGfGkRfZIPfXDt83uLAcCo8=;
        b=mmMeny8nknefTBsgpe/tmJD2V01bAwE0Y0HxdN301V84cphLfqInQY2dRHmk4rp+w4
         6JE/nwT8liagmbu8fdyxLAkvy/y50fUwHwo5ZSxR1RlYUK97MkSRBpD+3n5wkAoofVkv
         MNNDQH3Ys6gnCCG0ss19Jvq+pyYk4r+R1OmfAh1pW4GfHDbNUyZ/HeK15sNmy51z2AMZ
         C/6LTQXCjA1SIWHP5O5/dHgAKSH49VYEyB1CO0u8zXlTv+5n4X8IDP+mnwSJn24l5ynZ
         +QyPpSpaKzxWKLnxOSR4FuIbIbYV7aBfH9hONYKdN+RdkLCNAfw/+dFZJW9buL6bdULW
         gExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678555546;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QS/175t+MbbtSL3ZqMpuuGfGkRfZIPfXDt83uLAcCo8=;
        b=WwygGQy1R5KuvtpawpQ/OwAvl+u1BBuW35h6NkKQcNa79CtS2fs19wr4C7hKr8RzrN
         LZlhWfSN6kTBeVidsqCWMel30DRmNwqiI2EYwWOoL/lvHSWc9aSviDQ+/oFZrd9hw1X4
         wY9KeRRziLMkMw6cJ9HMrk20SrG/ELEQKSOGJb/0xZhMc9c6e2CHkYV1joZ0fdf+rDDE
         l4lqqOc94FydjOboChe+8dUu4F/6lHGDxmPgVi3HKaTncdu8KOigKHL4eVeeYQ3aWVjt
         joElweMcaawPtHqQS6BfkTD11+fIrxXjqMLWQjF7cVfQfiO25OPc01ND2yXgc5CM2Jvf
         5z5w==
X-Gm-Message-State: AO0yUKU5ojftu6AUuen5DLdgdZ6XyPKB3Ly6m/sFLDGvuyzF4/+RBRqG
        xMxZN/0H7EuxJJJ5NUnlj8L31Nl05RVwSw==
X-Google-Smtp-Source: AK7set9ftsFY4ZqIdArrt2/qtu9c+hPHjyWDoZu98KDi1eGfosfEJNXcHZqgNtwJDDaXf+zwsgBtiw==
X-Received: by 2002:aa7:9546:0:b0:5e0:c59f:b008 with SMTP id w6-20020aa79546000000b005e0c59fb008mr22132343pfq.4.1678555546323;
        Sat, 11 Mar 2023 09:25:46 -0800 (PST)
Received: from ubuntu ([117.199.152.23])
        by smtp.gmail.com with ESMTPSA id j21-20020aa78015000000b00593cd0f37dcsm1711571pfi.169.2023.03.11.09.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:25:45 -0800 (PST)
Date:   Sat, 11 Mar 2023 09:25:40 -0800
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     outreachy@lists.linux.dev, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        manishc@marvell.com, netdev@vger.kernel.org, error27@gmail.com
Cc:     outreachy@lists.linux.dev
Subject: [PATCH v2] Staging: qlge: Fix indentation in conditional statement
Message-ID: <20230311172540.GA24832@ubuntu>
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

Add tabs/spaces in conditional statements in qlge_dbg.c to fix the
indentation.

Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
---
 v2: Fix indentation in conditional statement, noted by Dan Carpenter
 <error27@gmail.com>
 
 drivers/staging/qlge/qlge_dbg.c | 35 +++++++++++++++------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index b190a2993033..c7e865f515cf 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -351,26 +351,23 @@ static int qlge_get_xgmac_regs(struct qlge_adapter *qdev, u32 *buf,
 		/* We're reading 400 xgmac registers, but we filter out
 		 * several locations that are non-responsive to reads.
 		 */
-		if (i == 0x00000114 ||
-		    i == 0x00000118 ||
-			i == 0x0000013c ||
-			i == 0x00000140 ||
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

