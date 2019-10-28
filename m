Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A99E7926
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbfJ1TXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:23:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37996 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfJ1TXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:23:20 -0400
Received: by mail-pg1-f196.google.com with SMTP id w3so7567289pgt.5;
        Mon, 28 Oct 2019 12:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=n0RrC7uGX/gZgkVMszycwSOKKQggxsrTHESmgPdcSao=;
        b=JVO5gCo+FGFjlOMHBcxSq53Vv41uaRmbgVkGHkBtMpnvMnOyAF/nFx30yNzJUN8PHd
         UKnOLa6bvQOcLPPFd3/hu/KPDaD77nsRTwiT/TeW+cuyjRhw/aqVFmturud8jQq3wO4Q
         3oot5uzAeHHwnxHn8rAU8Qd3AKSVteeMn62Bxee+pOt96Ni4bqs+0JUrjtBfYHYmuZUb
         eTO/Ow2QZ6ZekVefAewGlrBHZR3oo5pNvfFshRTufHFpRILEo4AKg5jL8KscSeNXu3U6
         xRvmNm6iCrQD/2gjt+N+YIFPzs/blpKaO+VhzMlS0ehow7EgxGK87TY6QU8XfpX2P3rl
         Xbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=n0RrC7uGX/gZgkVMszycwSOKKQggxsrTHESmgPdcSao=;
        b=OmPb6a8W35Je5UFmPS6G9ILSICE0a1taU7mcfPz+SS6IvMSCKJN+3aqRIV5Apbplhx
         YfD3SrGhjfVX7nWFhCHtmhKIIrnRRX2eFkMLqA2FoRk+GOxrRc4trylM4Rh3zninW9S4
         MA+Y6rCtluSM+Zy8OeTy1kIdljAC4iNmJELLmh83s06oKJ6OaFlaDjAix2gDEgdyAXPf
         YT7sFCDVs/lcmM5g8Deq136vJ9MZilSJgWbFBwZN0kYqw71I0d1PCK4j/UcYPGNnkGtj
         7oxFJjoJR+LfLn7LyvrTB5iF4DXcsWvSN4gJ/4WDBQzPUW/x2SutpV007y5JroRFiKyO
         kXBQ==
X-Gm-Message-State: APjAAAWO6IbJBNdIphE5zEiWRr69nTZnpRzhZEEItwK3ouKOZxkdC/dZ
        Juq53Wp6FPHuFRvcQKymn50=
X-Google-Smtp-Source: APXvYqyAslvrMNc3tZmWUPQB9FiwRftguQb9brnJWUPEvYqH10QxCEQQyeFZ3zhMVzUj+DCk2a7JmA==
X-Received: by 2002:a17:90a:8a0e:: with SMTP id w14mr1146969pjn.51.1572290597879;
        Mon, 28 Oct 2019 12:23:17 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id d127sm6035142pfc.28.2019.10.28.12.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:23:17 -0700 (PDT)
Date:   Tue, 29 Oct 2019 00:53:10 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] ath5k: eeprom.c: Remove unneeded variable
Message-ID: <20191028192310.GA27452@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unneeded ret variable from ath5k_eeprom_read_spur_chans()

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/ath/ath5k/eeprom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 94d34ee02265..307f1fea0a88 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1707,7 +1707,7 @@ ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 offset;
 	u16 val;
-	int ret = 0, i;
+	int  i;
 
 	offset = AR5K_EEPROM_CTL(ee->ee_version) +
 				AR5K_EEPROM_N_CTLS(ee->ee_version);
@@ -1730,7 +1730,7 @@ ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 
-- 
2.20.1

