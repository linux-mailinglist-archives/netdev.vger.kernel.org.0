Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093E72BBE77
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 11:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgKUKRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 05:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbgKUKRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 05:17:34 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEC5C0613CF;
        Sat, 21 Nov 2020 02:17:33 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f17so1104003pge.6;
        Sat, 21 Nov 2020 02:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YT+znqx5PpPmIZxX/FLP9CFfMwZHU4kV1tsIA7vkhsU=;
        b=Eb8uZSVQ/Pp7j+L5qbCgkD3TkOBa8YoHyXBgMOr6lr4fvdRnKXQ1TyGwpLC6V/hktw
         NsTyuW/95uh4lNc4acWKXYQXkyzLYEVCb23SY5qEr6bTedfgSBmCsBL7IMVBOGbgx9T2
         w45LhvoCzfJ8plr/WgNDFyGootbBMdyo45riPdcOGIDkF5s6UngiTqDmyLDSqbmJZecv
         zntgakaBAhIMmh/4ElFQGvey2dXrF3gtr9UdDXrQK3mlHhQ+1ptw+6vWLdUEjoyBYpBc
         JjA+nZcgI6dXHxpwCBn20Fea+GzJ7DlPi2t5lc/no1gqBm1YdqHkndwHks8zM7wJhvw4
         qimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YT+znqx5PpPmIZxX/FLP9CFfMwZHU4kV1tsIA7vkhsU=;
        b=kLZLBHyKkT348v+DBZl/rZ49M/xQGoxXWmZFWjsFifTEAUWzitIALAeJJoYZKHnFu6
         r9LKb1uiAmMlK/wylx6xskiawFSJaSXqp8DI9mk2+OfMiaObTyJBnjiGL8+7qC/p24Pr
         3tXrSi6bkX1hAHp0ZZ7M4wa7TgpKJSTB9FKnMgNpU0CEQUkNFTUoFnTTc8zGn66Qc5d+
         VydwdUD9u9qU1drhMxDQer2pxSj4pf5I6J/k/P6nHJt+R0d5+VfjBFxn59+Z80GNADg/
         3fVG5pS2RcNHIqLoZWw/2l4HXHJy9ORJltCcJJvzSiBzem9UQY1Bkzop9DZRau2cYhfS
         3Kxw==
X-Gm-Message-State: AOAM530B/+6EUShVAfi4IYFtWEbWCrFe3apAPfNC6QhUXTFinefENnq0
        /j2pLAh52iUfobZjbX0A7fQm/P/SUw==
X-Google-Smtp-Source: ABdhPJyb2Wm1B6Kg1dH8CB+EuU10An/HhotkKgMdMm04yYUfOQZkC8eVM1m2UybrM2RVgFRGqggAbw==
X-Received: by 2002:a63:db09:: with SMTP id e9mr20942894pgg.60.1605953853030;
        Sat, 21 Nov 2020 02:17:33 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 198sm4530460pgd.31.2020.11.21.02.17.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Nov 2020 02:17:32 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, davem@davemloft.net
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] e1000e: remove the redundant value assignment in e1000_update_nvm_checksum_spt
Date:   Sat, 21 Nov 2020 18:17:27 +0800
Message-Id: <1605953847-12401-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Both of the statements are value assignment of the variable act_offset.
The first value assignment is overwritten by the second and is useless.
Remove it.

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 9aa6fad8ed47..f05070ed18c9 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -3875,13 +3875,6 @@ static s32 e1000_update_nvm_checksum_spt(struct e1000_hw *hw)
 	if (ret_val)
 		goto release;
 
-	/* And invalidate the previously valid segment by setting
-	 * its signature word (0x13) high_byte to 0b. This can be
-	 * done without an erase because flash erase sets all bits
-	 * to 1's. We can write 1's to 0's without an erase
-	 */
-	act_offset = (old_bank_offset + E1000_ICH_NVM_SIG_WORD) * 2 + 1;
-
 	/* offset in words but we read dword */
 	act_offset = old_bank_offset + E1000_ICH_NVM_SIG_WORD - 1;
 	ret_val = e1000_read_flash_dword_ich8lan(hw, act_offset, &dword);
-- 
2.20.0

