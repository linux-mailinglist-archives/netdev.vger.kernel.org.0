Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240931DE475
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 12:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgEVKbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 06:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbgEVKbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 06:31:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CD7C061A0E;
        Fri, 22 May 2020 03:31:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x10so4230940plr.4;
        Fri, 22 May 2020 03:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H8pDFipnynsk4X9dPZFc4G5VJ+Iod2lTWU7AAQ+F64A=;
        b=u7TP4XLco+GLRI32lIVLxsUEAEU8GblSNsqpkn0pxa+0NT6VHYCmPVw0ruogBA/hiI
         W6HWu7FF6igZAwDfCGztzJ++AgTDOhSoCxeVX3ZIK5gx6h+/t917y97o6dgz1ptVGOEm
         kU4n8AVKU+s2Q2Vs6RtrYVxhNCckWNQp6rjOQm5djgAZQzL66g3H3MKVvys3D1aQ9kf8
         Oo+QjeL55J4pudwwLbM6f6FC7tXp0IxU9PIorUQ0/9Go3NuYZf5G/2bdZ8rWMupiHBrM
         DsfDo/hRLvES5ysDT3gVbljvbdNkNOGFmGJ7zaFwU3hMv59jZ1XAtUxlldVXs89T9UzG
         4qsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H8pDFipnynsk4X9dPZFc4G5VJ+Iod2lTWU7AAQ+F64A=;
        b=tDaxNfppmDRVeCDhI1BuIH68Zk4mbA//OHkPqigMEAKScKBWRL21wiFUSWcKH4pGVa
         2LKc0zUcaU1gOeOSHWhID/4r1xQ0MSyWgRm5RwkR7X4f/TTtimNZJzYOEBBBGSlDCwwP
         ORmJExQHaltyDptR8E4HDb/pBB94sqivTHAmYymfLZBxxl8h3vmbwH6Pi3AY0eG+gJG6
         nG/Y9rRlHth9xtwCF7PWMr5HWlk8Wo87JUowVIbk0gCgvTdx/nd5o39ZhtH9ucyghw9k
         MD6jXBOCBqN07gyCfyLasPGgDzf9YIO5RvorPnqrxKFlkpVBtZDy0+3cikHWZIzmkxJx
         xnFA==
X-Gm-Message-State: AOAM532c60xeAGZAeQIAPeDLP81+L8q3IL0Cdns5XuF9bhgRIn/3zJfS
        YdGX55zKaARGekJmWey+va8=
X-Google-Smtp-Source: ABdhPJwujMCjom57osVJ9fq0ac205yggKIMAusPBKFt0tivdubT9md8eBXPdMbtGkI2xZyApsb8Lmg==
X-Received: by 2002:a17:902:b706:: with SMTP id d6mr14769254pls.16.1590143462980;
        Fri, 22 May 2020 03:31:02 -0700 (PDT)
Received: from localhost.localdomain ([157.51.227.23])
        by smtp.gmail.com with ESMTPSA id x14sm6488232pfi.60.2020.05.22.03.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 03:31:02 -0700 (PDT)
From:   Hari <harichandrakanthan@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Hari <harichandrakanthan@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH] Fix typo in the comment
Date:   Fri, 22 May 2020 16:00:24 +0530
Message-Id: <20200522103024.9697-1-harichandrakanthan@gmail.com>
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

