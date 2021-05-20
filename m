Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5838B651
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhETSuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbhETSut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 14:50:49 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC3DC061574;
        Thu, 20 May 2021 11:49:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j12so12491096pgh.7;
        Thu, 20 May 2021 11:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3bJ6aCi358D6gLPHam70m7qIlIxiB35FHIyn3aer04k=;
        b=KxTNQW9/gvB1b9rfZC4RriR6oyJ22kiVpjF/C99eettZzJ9DMuNgPCFBEwg7hy14bu
         oOAPzAbGWao69tzW255IDM5PB3HE2nVj5yVUqJLA4cSgeDLry53UIjhSCLVrQMnK6c/i
         a8+BHXE7SzYR443eVXCrmIrabGFhjYPGERcq8YVKxS8625Fb3U8N/tpiqQs0WAaANXhC
         WZ4QDc+5wNdS1wWcd4G0YH8iuIHOTxKqy5+xzw2BUzrmZiBod2L40P45p5WTfXNDiond
         WsLgRV51k41qGOSB0GIPar1wtq+21CqVUytXitppHOSZqAH2Vav3rXsjSpukPTd8Fx6t
         BnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3bJ6aCi358D6gLPHam70m7qIlIxiB35FHIyn3aer04k=;
        b=B4trR7vflWiQsoxnk+Q3pSJB3eJrRGz35YinRVhfLYLxmKl66AypgSwuHcFl00/tze
         cWsZRfwf9VvdyFKVKHOwuGsK9QX9ZeO3pL+FGxTFFQB1aLYMebHfWm11F21TqJqGcCj8
         y2jcy1SK4TclTkS7E4pxEL+Bl70kAld09JZZRpvbvoKnikN0XZxSZ330LrZtrUPOSfkn
         K5CGBkg+fFL7QEHVTo1EssCnUdwtXC+NkyWgVC1abmIxBlC8ihpGKzZIEj2QwNTKuRSu
         /EybjLUxg6vB1NbNkqiMDCNFGTNYa+2wdr3OytheATjQotXlZznL+yswD2wh5FSBCAit
         6/7w==
X-Gm-Message-State: AOAM530Khroh7nCN2ODs7zPbFs0kQPSqAdWIIKxmD+e4JySNcaKSf0ZT
        96+sc7wfbpql392E2d7LT2A=
X-Google-Smtp-Source: ABdhPJxxGJ2l0KhcECjJ8y0p4tXKuyfnCVIopqfN8F2ZIwSg2T93Y2vTlT/+TBnoradgW6ZEMixlYA==
X-Received: by 2002:a62:2e04:0:b029:2db:4c99:614f with SMTP id u4-20020a622e040000b02902db4c99614fmr6078229pfu.47.1621536566193;
        Thu, 20 May 2021 11:49:26 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a93f:4822:12f2:8c52:6d8b])
        by smtp.googlemail.com with ESMTPSA id n30sm2741230pgd.8.2021.05.20.11.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 11:49:25 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     davem@davemloft.net
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        rdunlap@infradead.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: encx24j600: fix kernel-doc syntax in file headers
Date:   Fri, 21 May 2021 00:19:15 +0530
Message-Id: <20210520184915.588-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
The header for drivers/net/ethernet/microchip/encx24j600 files follows
this syntax, but the content inside does not comply with kernel-doc.

This line was probably not meant for kernel-doc parsing, but is parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warning from kernel-doc.
For e.g., running scripts/kernel-doc -none
drivers/net/ethernet/microchip/encx24j600_hw.h emits:
warning: expecting prototype for h(). Prototype was for _ENCX24J600_HW_H() instead

Provide a simple fix by replacing such occurrences with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/ethernet/microchip/encx24j600.c    | 2 +-
 drivers/net/ethernet/microchip/encx24j600_hw.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index 3658c4ae3c37..ee921a99e439 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/**
+/*
  * Microchip ENCX24J600 ethernet driver
  *
  * Copyright (C) 2015 Gridpoint
diff --git a/drivers/net/ethernet/microchip/encx24j600_hw.h b/drivers/net/ethernet/microchip/encx24j600_hw.h
index f604a260ede7..fac61a8fbd02 100644
--- a/drivers/net/ethernet/microchip/encx24j600_hw.h
+++ b/drivers/net/ethernet/microchip/encx24j600_hw.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
+/*
  * encx24j600_hw.h: Register definitions
  *
  */
-- 
2.17.1

