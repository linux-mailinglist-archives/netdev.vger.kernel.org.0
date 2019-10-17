Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8105DB5FE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438774AbfJQSWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37685 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441347AbfJQSWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id y5so2167064pfo.4
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f3UqFx1VuGM6+vA7jOCpdrnhTgmIiOuWm+Cr+iWrrv8=;
        b=BcG6nCKXLv4yuhjhMGoQ+WtAU83EOcrveljM5yLQsoGwg91DRAFuozFJe7+gOTRG7r
         B1y4HW0aPtkczN1AouXITtbvLhnocmmb6uC7ob9QrR14rspvODcnO3n8ygnJD4YtFc2+
         +53ZJ7JcZkSl9ABH4oTpR9h573Wv9LVw4TIYyUtdJUNpv4eGdvzRTLcp+2DbZjy1Y7Yx
         ac41lobTQB7Ject2LUXsb4+21nug5InwvDNWmrdEQDhIaC2s5g/PLJV/ombf9bj/D8lp
         GA/zqglia+8mAFz/KvsISPjN4YbFA3V3laFarsvVzHhCitS/DEUe+ug3N0WQHOF/k4Qi
         SWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f3UqFx1VuGM6+vA7jOCpdrnhTgmIiOuWm+Cr+iWrrv8=;
        b=PzWvPQXbP/wtWroK1+1IBYGfcEkTX/xB5/WU8c78WzJmMJPcyX2bfcVU4WhaJo6BNa
         1PyVgETH2Rlq6qR5/3zKuaAM2rJ/eXG85jZtR8j9vBdL4m9qrD3vjlDn6gsaMbXgh2gS
         KC8tLwJ7mVJdiS+2qkEWl0920e+gQuhM92+5X1coQiZNOQ6QGPHLuhUbSbNTN3Mi/Q2q
         OkxHLx0MlrJHRXuylVjJlvJCzPVAKzNjAQ0sP7dxyE2nj6ay+figwT/m/dvDjRYcyxUt
         bM45xTSJ0Fl+l1UQYezUIZhCFmLji4zEOH0jrhP92TRedupMV8s+HV0BO8BYTG1MeEAY
         HI7Q==
X-Gm-Message-State: APjAAAWHr6KmJno/fTxNs/H9sFvccduq+fCpyIi5SI8P3GDDYfzNlApU
        pBGyLKynZv8la6gzD6VOcO0b4Pwr
X-Google-Smtp-Source: APXvYqzj+IFDbHQCHMcoYG7ivjMpG9+tQtCHnRmim6/du7chH76QG1hRNoxcW/CiMFaJa8TgWF78ww==
X-Received: by 2002:a63:4e1e:: with SMTP id c30mr5405928pgb.89.1571336527308;
        Thu, 17 Oct 2019 11:22:07 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:06 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 22/33] fix unused parameter warning in de2104[01]_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:10 -0700
Message-Id: <20191017182121.103569-22-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/de2104x.c:115:43: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  de21040_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

  external/ethtool/de2104x.c:421:43: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  de21041_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I154a2a283f83e22180217b9aeec46bd8290a2200
---
 de2104x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/de2104x.c b/de2104x.c
index 856e0c0..cc03533 100644
--- a/de2104x.c
+++ b/de2104x.c
@@ -111,8 +111,8 @@ print_rx_missed(u32 csr8)
 	}
 }
 
-static void
-de21040_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+static void de21040_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+			      struct ethtool_regs *regs)
 {
 	u32 tmp, v, *data = (u32 *)regs->data;
 
@@ -417,8 +417,8 @@ de21040_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 		v & (1<<0) ? "      Jabber disable\n" : "");
 }
 
-static void
-de21041_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+static void de21041_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+			      struct ethtool_regs *regs)
 {
 	u32 tmp, v, *data = (u32 *)regs->data;
 
-- 
2.23.0.866.gb869b98d4c-goog

