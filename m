Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF0E7A64
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388056AbfJ1Un1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:43:27 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38901 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfJ1Un1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:43:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id w3so7742642pgt.5;
        Mon, 28 Oct 2019 13:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=4zLDgL2Tv+U6+2fqrJoYSvbV/fzHrzrxd+zfcyEk0Mg=;
        b=fC0Arx2fP2pQajMaoYQZ8TldvHGcKz83ifiEWa3vIhZIIL4m0B2Nergp1GFdE4kms0
         heC85V7W9rGI1CCl+vSLDtKIyiPi/xWuiS5R4FVZRLLarsv1vMVWybHGsisAgwvUF8Mb
         UBNDNIlIuFmtymhcFTDeDMpJVmc2Aq09jD0+5lg12gnYMvg3UhrWVs7rnHsZfXYq+wIm
         NbYFld4OYbQl98JQkjElKmtwgsXmjXfXnP8GuQD86u/adwTy8edic8m4ByC33mIMV12t
         qfPpwbE3lZyDyyDgNq2kpw+NrlM4xhM3jZKaBFhe4s6nwmz7wO1ydIcs+A5mlbhXn1ew
         mxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=4zLDgL2Tv+U6+2fqrJoYSvbV/fzHrzrxd+zfcyEk0Mg=;
        b=Ucd3vfgeZRVTgC8RM5l4vAbBMCT7BmkgWxaTAO0IcOc/SQ4J10lskOqk3wRc4ZEy5I
         uWU6wQIGgKgu0OWLg6+jIVz/e0nuX2nM/vtt8sw1y8dqvsTlMyrqIcwO0lJQC2KVB5KI
         JzrmRDIMU+gmUmoduaWdUr9Nx+dz9iWfJxBYRW8t4WH7HXLuDpuCVJc6F+huMSbuBHDu
         IMIqPZ9vxL5n/mENlFMbAjrCkida49nad0dMDYPQuIj3ZMuI+NJQ6NmXuFvGZ9Z9+Wo1
         vib2F92skImWSXakRY1pbX8XuQssR0108oUwyIRtxAQbTLa8z3Xuht6zGN3RseDTnB6Z
         Kjyg==
X-Gm-Message-State: APjAAAWBKTtTJ/qfGl2K3fnXyaMhOsZJ3H04cxIhCqN3wcFFGgj8nbm5
        1c0onNdFl/oLUWGDYoqrbPQ=
X-Google-Smtp-Source: APXvYqycfDtHncZtnj9Mi+Cs0rySqwXwx1Y/ecr4wfkWllPbSLcM/VJPhFzr5rGuTklLWd1CPzBRWw==
X-Received: by 2002:a63:d10c:: with SMTP id k12mr14234478pgg.344.1572295406616;
        Mon, 28 Oct 2019 13:43:26 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id 13sm13705579pgq.72.2019.10.28.13.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:43:26 -0700 (PDT)
Date:   Tue, 29 Oct 2019 02:13:17 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] ath: ath9k: Remove unneeded variable
Message-ID: <20191028204317.GA29468@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove "len" variable which is not used in ath9k_dump_legacy_btcoex.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index b457e52dd365..f3d1bc02e633 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -498,14 +498,13 @@ static int ath9k_dump_legacy_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 {
 
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	u32 len = 0;
 
 	ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
 	ATH_DUMP_BTCOEX("BTCoex Period (msec)", btcoex->btcoex_period);
 	ATH_DUMP_BTCOEX("Duty Cycle", btcoex->duty_cycle);
 	ATH_DUMP_BTCOEX("BT Wait time", btcoex->bt_wait_time);
 
-	return len;
+	return 0;
 }
 
 int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
-- 
2.20.1

