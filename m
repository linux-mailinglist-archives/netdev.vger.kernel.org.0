Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28F12486AB
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 16:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHROGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 10:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHROGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 10:06:14 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F28C061389;
        Tue, 18 Aug 2020 07:06:14 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r2so18414458wrs.8;
        Tue, 18 Aug 2020 07:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6XCHTd5ea+manFN5ZnDSNxDPAmKEbKZ4FuklgYQK38A=;
        b=r2HnbCDSdHeVFE+HL+xnKpgAycGEd59XsVjEUooADYEz1dQcF1KhAH/7aQnwvZq7mm
         xcrmvZEWGdRfFFyimMKl3Z15wk9iKp43spC9Us5FdmA5p/uLQX89O73aV/tQE3cG4Fn+
         LilUoRqyHqH0VtBTrgaVTtk20ikPFpSQ+wtFDTfdl0yP7mLLS2XZcg99Dpd5OHP06hY/
         VtnLJei6AFTiOJ50V5AJIX8arEkkndX/NfxcU+pmiXIQKUEmziBoumVMSHhZRc0A9kKW
         Uc1cwtSwEZ5cOXQKOqmQ0Jbug1Usc4nRbUwIk5/dzwiA81duJ1DMyITykwkEbkaC41GJ
         vIsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6XCHTd5ea+manFN5ZnDSNxDPAmKEbKZ4FuklgYQK38A=;
        b=CAUZlfXgx0P59wkjztjF081aK1BQggxcIeUnAJX6HwU3DFvijgg1pweN4pvN5Lv1nU
         ENcodkciCxnAqhZgZnbk0WT7hkHyEkqWUVvlJS/FJC0xo/Q7U0ir9L6Q/ukdWCvPGLQv
         koOiJfJQwOWTqJ9hBlI6Qct8QPWPQGzA6ktnaeUteQOMYGW7yJlHnkPEiKxCgBkZus5P
         uPV6o/wo7ccqMszMNzGR74rEmD6xZd7E9eIw2CIXpa3iSqGHXRbjoAulSpimG3tAqv5a
         Hb43fR4ljYrN3xSa83FcjPkkjhp+nO8lbf3BqXLwsg9HV5zgCtiABblwjYL4ElHgj6E8
         6Ipg==
X-Gm-Message-State: AOAM530lhSK2O3an+uCsAU3Q23XyGk60arqT/6u23RNWtMj5PDog/YpO
        JawLKOixVJ2vD6zmgUbbFHc=
X-Google-Smtp-Source: ABdhPJw3ujEqayIEQgjgWRHGD08+UYMk/guKmctdhGm41XrkprdC2S+Tw+3+NLOXE/48xnooRHzNRA==
X-Received: by 2002:adf:a15c:: with SMTP id r28mr20416094wrr.151.1597759573120;
        Tue, 18 Aug 2020 07:06:13 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id e16sm35186078wrx.30.2020.08.18.07.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 07:06:12 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Dewar <alex.dewar90@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ethernet: cirrus: Remove unused macros
Date:   Tue, 18 Aug 2020 15:06:01 +0100
Message-Id: <20200818140605.442958-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a couple of unused #defines in cs89x0.h.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/ethernet/cirrus/cs89x0.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/cs89x0.h b/drivers/net/ethernet/cirrus/cs89x0.h
index 91423b70bb45..210f9ec9af4b 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.h
+++ b/drivers/net/ethernet/cirrus/cs89x0.h
@@ -459,7 +459,3 @@
 #define PNP_CNF_INT 0x70
 #define PNP_CNF_DMA 0x74
 #define PNP_CNF_MEM 0x48
-
-#define BIT0 1
-#define BIT15 0x8000
-
-- 
2.28.0

