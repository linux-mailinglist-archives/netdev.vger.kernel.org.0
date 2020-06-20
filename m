Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C562024DE
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgFTPoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgFTPoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:00 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C7FC0613EE
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:00 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id k11so13490737ejr.9
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OwTejOkNLSkvL9cHgm9ehWj1smKq29AQ8Kmwk6WwPyg=;
        b=Z6f6B4eFE1SbwaPgo0fW/yZDDPMhYIMd/q4vXEeDCiakPVecZ6GNTuXfaJFrBsNbQY
         lCaa+9jLn/ctuX2Aswp3mqwKCALWH4w290v4Ih+7Z3qiY3NFOwxgyvLcTtWYwGjxUYA4
         Sz4lMaR/gAtqJf/4+/OOjIPgo62AJ0BXJ5J0cjXoPv9LZiJC6lI53jOrQJLvQSku1bxQ
         L1vKsIBJ7+4NDfqn8fzACbHalRJUmz0f0qttkVpNe4qjf5kQzuv97nGPqlIDJNqvDihM
         kv+wjcQwTMsJc9VE7lq+2sXCCu5UixGnRP8EZ2YtknVe4oummpYJehVIJ8WqT22ONXT5
         YitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OwTejOkNLSkvL9cHgm9ehWj1smKq29AQ8Kmwk6WwPyg=;
        b=GbgVLgolsLkzgI2j3K/GtJCQosgO4+wPnOIeilideO+gjTV//qwCXubSoAt9DhIsKq
         NUqHGMnoiueXstPSYZAeIb7vOO9gsVHu8lkrTDKPIsquzqCKTfSKyPrHAE8CLsIlLob+
         /nmZ9VUXXwP5AY/Yw3yK9fYu6n5AQs+0TxSpPUdVwZbsPA+66L5T0gIPFEF1pg+G54t/
         cFYSf5wChjhoVnLWp9tgtPq9AlgPo7V7voa8AiNY0+Rja78t6NwTF/XerlAp8Toclt0S
         Aq01PZluboF2KAFKqKKPkon2RoA8UMq7jJNzuyzuWPgDz1WyjhqBUrqoMzoJm0zrHPU8
         8G/w==
X-Gm-Message-State: AOAM532cHbxFOIzPoG7kLtCd3pkTbwua+OUOkRXD+AkcbfYSz6mE19m7
        dcbMkm4S3poRhWvfDSca2ng=
X-Google-Smtp-Source: ABdhPJy7BmwmFfnMGn7970WZQlY6R55OABjnMWGCPMaGh2eiZlVX6Ip6iPfLj1dfpCulL8DIOJUa/Q==
X-Received: by 2002:a17:906:af48:: with SMTP id ly8mr8303690ejb.28.1592667839127;
        Sat, 20 Jun 2020 08:43:59 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:43:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 04/12] net: mscc: ocelot: rename ocelot_board.c to ocelot_vsc7514.c
Date:   Sat, 20 Jun 2020 18:43:39 +0300
Message-Id: <20200620154347.3587114-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

To follow the model of felix and seville where we have one
platform-specific file, rename this file to the actual SoC it serves.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Makefile                             | 2 +-
 drivers/net/ethernet/mscc/{ocelot_board.c => ocelot_vsc7514.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/net/ethernet/mscc/{ocelot_board.c => ocelot_vsc7514.c} (100%)

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 91b33b55054e..ad97a5cca6f9 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -2,4 +2,4 @@
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
 mscc_ocelot_common-y := ocelot.o ocelot_io.o
 mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o ocelot_ptp.o
-obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_board.o
+obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_vsc7514.o
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
similarity index 100%
rename from drivers/net/ethernet/mscc/ocelot_board.c
rename to drivers/net/ethernet/mscc/ocelot_vsc7514.c
-- 
2.25.1

