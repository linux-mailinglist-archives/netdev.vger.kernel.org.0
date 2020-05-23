Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F741DF762
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 15:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgEWNNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 09:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731347AbgEWNNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 09:13:41 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE98FC061A0E;
        Sat, 23 May 2020 06:13:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id v2so1406372pfv.7;
        Sat, 23 May 2020 06:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H8pDFipnynsk4X9dPZFc4G5VJ+Iod2lTWU7AAQ+F64A=;
        b=d6zPa6bfCge/OEzuOBCipFM61kSveZ6IXS80k0pe1JMnCxANiMUBC02P4pEPgCpX/l
         9fJASJNGlA0D9XCySR6of+WKuRVF6ib+xx/w5yzyWAU3/XsLymxnnFVjO+EoAxyOpeyY
         YVV+GhbUUVACDNKJSD0H+M9Oe/F71/se6K2owzEQ9U3kM4ICyKbWmP6NL8o2c6aBzZNI
         SyNP/pLd9Nf7YuK5F4RtYN/P40h1Pgo0vZXW2XcHaa592A5ZGl5isA0R01TT8+xhA2CE
         T3fXp47j1hrWJXWvocf0kfuuvOHHmq70H9hSFrcL7y8Day2a4JWhJmcUOW1U6Wb4y3ae
         4rCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H8pDFipnynsk4X9dPZFc4G5VJ+Iod2lTWU7AAQ+F64A=;
        b=s/BnEYb3gruZKAXswYZNpUVD4ebKtrwvsDldAd/Mws0aA/aGhFIuA2yJrfdS+BKgjr
         Pcaaf+TiZBiH9amHahGLtk3gUK1sq6LDTEeay/yhUgf/fahBAAZ7Jqm2tPL7uQEtI+yu
         4FzlgucrSy5a9f0PqXkOFgS+8XSM6m2OzVSXVlyHrKfgpBXcJKa/VQoBPE05pYJNBJ6F
         rfkKadmaiO8ogDIMJR61Pzw3BVytFICybBX5oO9tUUUJXdFg60MA0hYt3Qf+h2+yIJ3r
         3NBVM5Kf9oHpcoLeBbCGaZyIhOU69Ta3tGrutLFrXE1LG50Em+XRil62UBs6YYn4OlaV
         +fvQ==
X-Gm-Message-State: AOAM531ePq4uGU+NGh6otdPXOC+gBbgf7Y79UaT4Vbp5rJ58uK+AjML9
        QUemQT/AGBanKlJiLP+MxYeR8KXAAeqAXg==
X-Google-Smtp-Source: ABdhPJzn4ahbjc4uF3F0G80Mlr9dXdVeoYkcPPDAUFoQXK30/ymi69aOdssi+fEGEZNakIN+xRFn3A==
X-Received: by 2002:a63:774d:: with SMTP id s74mr9438pgc.315.1590239621095;
        Sat, 23 May 2020 06:13:41 -0700 (PDT)
Received: from localhost.localdomain ([157.51.175.150])
        by smtp.gmail.com with ESMTPSA id 9sm8741528pju.1.2020.05.23.06.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 06:13:40 -0700 (PDT)
From:   Hari <harichandrakanthan@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Hari <harichandrakanthan@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH] e1000: Fix typo in the comment
Date:   Sat, 23 May 2020 18:43:26 +0530
Message-Id: <20200523131326.23409-1-harichandrakanthan@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continuous Double "the" in a comment. Changed it to single "the"

Signed-off-by: Hari <harichandrakanthan@gmail.com>
---
 drivers/net/ethernet/intel/e1000/e1000_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 48428d6a00be..623e516a9630 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -3960,7 +3960,7 @@ static s32 e1000_do_read_eeprom(struct e1000_hw *hw, u16 offset, u16 words,
  * @hw: Struct containing variables accessed by shared code
  *
  * Reads the first 64 16 bit words of the EEPROM and sums the values read.
- * If the the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
+ * If the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
  * valid.
  */
 s32 e1000_validate_eeprom_checksum(struct e1000_hw *hw)
-- 
2.17.1

