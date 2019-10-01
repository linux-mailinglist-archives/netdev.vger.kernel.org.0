Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118CDC40E3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfJATS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:18:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41507 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfJATS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:18:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id h7so16877485wrw.8
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 12:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OaFWcXECzb8t/mpV12HoMbQvprlkfKQb6gQ6gxLxLzQ=;
        b=fUd3P08rRBvSBuct4sGHz9fPlkqkRW2529vFdpuDb7rVOfkD3M1x/K5rgzm/W6a9XO
         3DKOhj0PIdprGgHs4egVzmZUcdjb1TyZ5xoOO+mGPJGUP68oc9uEETygOdfYOu0rK+su
         h4/tpyUYSKBUALzPBgBuBfU9NInCnlLiGdPrYCkpmVmU2YMaslYIqPOmhgVdHUInFgEf
         2X9Qqi+QW6DZ9CJTa49ZaduHylknRQbfqNPA5cROykS/GVJe2+oi7jFINodYrJ0WA/1j
         DMiiRT864pvHkOEIcDTyQ0wOYWYRiwNbSYReNOJDMOa6CsEeWGzCXAR0m9X8h1IbkPeI
         XEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OaFWcXECzb8t/mpV12HoMbQvprlkfKQb6gQ6gxLxLzQ=;
        b=W9NuQ4uqSEO4dAEXEx1Gdcy0DTaTCshW/NYUXYxbVpPHBnZbZPUIieZKeJDPwIEo7P
         QanDmPkKmPchYohkHSBnuAw1RsCPSM2ZOHcUXlGcds1UH8FsDgB6zWZaR/TwWb6KJgcr
         ei2jk6nHB6mfzyaxY5GKuk0JkwsAT4nr/yrRtJiAM0pn+US2XtTpko5U33VOuuGhUxuP
         CwI+9uuYZeHpNHI+HGc/pdvViG28Aerpgc+Im1QHA+qqqS+zdkpcdEV4/+ebhojGM3mF
         fQbqGa4JJ0JNJknRqFexH/3vvPoNBsD8FE/vv0X4Z8iIZ5MGRWz6ezntcIWjcsjEvIWs
         WTug==
X-Gm-Message-State: APjAAAW6nwovWlxYKX5NYBzDoVW8Xk4/kWpSp+s1n/e9wd5TC/JEzDJW
        5GQMrHjcaprx4eSZd0ZW5t4=
X-Google-Smtp-Source: APXvYqzFrZkMG3TIvF9D4pRXKrUe30sBaY7UdF9ySN/Lq/+U3V4POqPZdBie5oia64vh5mo1bDEfFQ==
X-Received: by 2002:adf:e4c9:: with SMTP id v9mr593162wrm.396.1569957506683;
        Tue, 01 Oct 2019 12:18:26 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id e6sm15214299wrp.91.2019.10.01.12.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:18:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: sja1105: Don't use "inline" function declarations in C files
Date:   Tue,  1 Oct 2019 22:17:59 +0300
Message-Id: <20191001191801.9130-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001191801.9130-1-olteanv@gmail.com>
References: <20191001191801.9130-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the compiler decide.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_clocking.c | 2 +-
 drivers/net/dsa/sja1105/sja1105_main.c     | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 608126a15d72..2903f5dbd182 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -405,7 +405,7 @@ sja1105_cfg_pad_mii_id_packing(void *buf, struct sja1105_cfg_pad_mii_id *cmd,
 }
 
 /* Valid range in degrees is an integer between 73.8 and 101.7 */
-static inline u64 sja1105_rgmii_delay(u64 phase)
+static u64 sja1105_rgmii_delay(u64 phase)
 {
 	/* UM11040.pdf: The delay in degree phase is 73.8 + delay_tune * 0.9.
 	 * To avoid floating point operations we'll multiply by 10
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 7687ddcae159..1127b7a51bc8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -458,9 +458,8 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 
 #define SJA1105_RATE_MBPS(speed) (((speed) * 64000) / 1000)
 
-static inline void
-sja1105_setup_policer(struct sja1105_l2_policing_entry *policing,
-		      int index)
+static void sja1105_setup_policer(struct sja1105_l2_policing_entry *policing,
+				  int index)
 {
 	policing[index].sharindx = index;
 	policing[index].smax = 65535; /* Burst size in bytes */
@@ -951,7 +950,7 @@ sja1105_static_fdb_change(struct sja1105_private *priv, int port,
  * For the placement of a newly learnt FDB entry, the switch selects the bin
  * based on a hash function, and the way within that bin incrementally.
  */
-static inline int sja1105et_fdb_index(int bin, int way)
+static int sja1105et_fdb_index(int bin, int way)
 {
 	return bin * SJA1105ET_FDB_BIN_SIZE + way;
 }
-- 
2.17.1

