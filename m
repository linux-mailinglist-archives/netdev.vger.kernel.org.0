Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E2D6B5C94
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 15:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCKOE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 09:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCKOEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 09:04:25 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD65BEABB6;
        Sat, 11 Mar 2023 06:04:15 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id ix20so1935476plb.3;
        Sat, 11 Mar 2023 06:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678543455;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kYqoBUUyzsIk/ss9ywgxsMkPFqWgNfKL1ixz5F8qfn8=;
        b=KuLW6ZaIq2jIlOSyU+lDH80+1cZqTRKsURnlgH7HOJviqbyZQNCcKt29SMXa0CuYdp
         AbvvDznDDdg3RDoiN+1yFq9o7CNi6Cse3kDjff/w8cIaFUkaeNFmtjgA7QaNDuGsXwMl
         vLjDkubrR853/pBK4v0gi4QHUPWZ2vtg6QpJmVjpfWFK3J58iSGMfwia+4GdpAVL+ILa
         mCBmGqwGSqdzTc+kIe1eF2eHtgYyT0MPYWxT8rn5YawwAJuRumCxq5VRsUOYn5unrwK1
         oeda246IfeqPw63cCWokkG7iQJpEv2KnXfCuLRsJmxb8fRS+9Clb7TRIMgJaKt0TtPvs
         fXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678543455;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYqoBUUyzsIk/ss9ywgxsMkPFqWgNfKL1ixz5F8qfn8=;
        b=CeMUt+J7a2Dy7oCQHu3B4e+GtEIP6fGKUcLPRUKOLdIaFfefwTioI9qPW8SM62KvDv
         BhAGmnMTgW1LILBpAe0DFs3Pm5KK35FshIUjXz/+JhBxNf49VMpS5QB3+kLfxXtL9w31
         KulPXTS+w7VH8XiDwfpN6QULEVNPOlelM/HWol9z1tFlAemFxyer7PcNa5jMBkrCviCc
         DNtZ9gDWAtz0YQrlk7YydksmO7iCKNWnIKV8GgwRZQUCdFToH4cop2QzIscI/ag4pufv
         CulSblllpZ8LJIl9i+fQABLPQNFdSoQHxEyxdtgzwed3FQdiTZIRzVMAqdf9Ufgi4gMS
         KWNg==
X-Gm-Message-State: AO0yUKWH4fwKWPbpkPC8XSGCQEoaWAXGuRceswEMNg/JzyZ5ZhbFh8fR
        SGQ4nkpBOp7CXRsOYhlSegUIKRsgIPPVkA==
X-Google-Smtp-Source: AK7set+5gcskv9cOYnEoWY0Belgr0Oa8Cx7t4Z/HyjU8BwbL/Lb8ms/J+2WRyYx9/NfjFQiS/aDMAg==
X-Received: by 2002:a05:6a20:3d26:b0:cb:c276:5879 with SMTP id y38-20020a056a203d2600b000cbc2765879mr31859030pzi.32.1678543455193;
        Sat, 11 Mar 2023 06:04:15 -0800 (PST)
Received: from ubuntu ([117.199.152.23])
        by smtp.gmail.com with ESMTPSA id c4-20020a62e804000000b005a8de0f4c64sm1545649pfi.82.2023.03.11.06.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 06:04:14 -0800 (PST)
Date:   Sat, 11 Mar 2023 06:04:09 -0800
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     outreachy@lists.linux.dev, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     outreachy@lists.linux.dev
Subject: [PATCH] Staging: qlge: Remove parenthesis around single condition
Message-ID: <20230311140409.GA22831@ubuntu>
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

At line #354 checkpatch.pl:
CHECK: Unnecessary parentheses around 'i == 0x00000114'
CHECK: Unnecessary parentheses around 'i == 0x00000118'
CHECK: Unnecessary parenthesis around 'i == 0x00000140'
CHECK: Unnecessary parentheses around 'i == 0x0000013c'

Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 66d28358342f..b190a2993033 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -351,10 +351,10 @@ static int qlge_get_xgmac_regs(struct qlge_adapter *qdev, u32 *buf,
 		/* We're reading 400 xgmac registers, but we filter out
 		 * several locations that are non-responsive to reads.
 		 */
-		if ((i == 0x00000114) ||
-		    (i == 0x00000118) ||
-			(i == 0x0000013c) ||
-			(i == 0x00000140) ||
+		if (i == 0x00000114 ||
+		    i == 0x00000118 ||
+			i == 0x0000013c ||
+			i == 0x00000140 ||
 			(i > 0x00000150 && i < 0x000001fc) ||
 			(i > 0x00000278 && i < 0x000002a0) ||
 			(i > 0x000002c0 && i < 0x000002cf) ||
-- 
2.25.1

