Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80106DB5E0
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441342AbfJQSWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40340 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732798AbfJQSWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:04 -0400
Received: by mail-pf1-f194.google.com with SMTP id x127so2162185pfb.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0wGEvZ8uc9EN+nP26IBlAt10UZEMRa5PPalimwsGEoA=;
        b=nyjJVq0lYEjjrQlVgSLHYXGo1oaNt1fiwN8GsuQcOYVn9BrI/oH72MrHmjHCdIFave
         wuweiNi4JxpNQU2/KiETReBXPIEF7Yz8jUhU7achKi+WSJEqxtqatvJM8LA5kLeQ2rQ+
         m8kHFALhpMfmnLQvWfFLDnnbehoIpr8GVH1hqNUC4Wk1kRhCC3d/LXjOt2KcZNIcb9PP
         fo33BIih0D0ENKaF3E6fZYKE0SYkeBinGXIh4DtjMsFBp4EBx7UcSxiDZ3f50gqoiO1v
         OnAmt8RcumxFs6n0WA8Ix4zZXiy6Q3c3F2/E21y3uVCVkuDkbcN9rKeIYkOykEuTtsig
         RUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0wGEvZ8uc9EN+nP26IBlAt10UZEMRa5PPalimwsGEoA=;
        b=IJM/6qUFM7f9AS2zVHp3GAiMAcNXKedjamnJDDZuQXnQ6so0BuKch9UQDhbuvZdTNt
         I16Afw2EtNhcPtkmdsU6NK6rFYv0Wz1FfGvdkEFkX9oydqbdIC36FcuUkBechFfo1oPo
         7JAntJHPfjVkFVTCDKkp/NItwRfluqqjTlWtbVYGS7oo2XH+k96i0J90h6OooPHzofAP
         F4Q5Y0DgwIz3SkwV1ByzfbpjyG4XvXwCUy/nnB4g6m2gU9zSgdVLYsULseWwR0YQ00fs
         ooTQsJ64LdiPaO/XkWN59UFRTIlptEEEf+1teAfVWgGU9vBcTN51GEowN6+ok1iIUdfh
         AbFg==
X-Gm-Message-State: APjAAAW9OfcHPq9rDnCFiZIPByv6mSke2pFDYZdThO+KHPjdzHXuqKSp
        y4HL8cUuGKzPbixPXoTaJw4=
X-Google-Smtp-Source: APXvYqy1UuzoFqusgHJGWkcXKF3OoCCWiuc8EE5nKS3nS/6DKMKNDssZYRCVJlzlhtJ8MsPJwHYoew==
X-Received: by 2002:a63:1209:: with SMTP id h9mr5464378pgl.394.1571336522107;
        Thu, 17 Oct 2019 11:22:02 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:01 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 19/33] fix unused parameter warning in tg3_dump_{eeprom,regs}()
Date:   Thu, 17 Oct 2019 11:21:07 -0700
Message-Id: <20191017182121.103569-19-zenczykowski@gmail.com>
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
  external/ethtool/tg3.c:8:41: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  tg3_dump_eeprom(struct ethtool_drvinfo *info, struct ethtool_eeprom *ee)

  external/ethtool/tg3.c:27:39: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  tg3_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I9b357d371095df4b24f2c6ec32fa3d0c99731805
---
 tg3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tg3.c b/tg3.c
index 3232339..8698391 100644
--- a/tg3.c
+++ b/tg3.c
@@ -4,8 +4,8 @@
 
 #define TG3_MAGIC 0x669955aa
 
-int
-tg3_dump_eeprom(struct ethtool_drvinfo *info, struct ethtool_eeprom *ee)
+int tg3_dump_eeprom(struct ethtool_drvinfo *info maybe_unused,
+		    struct ethtool_eeprom *ee)
 {
 	int i;
 
@@ -23,8 +23,8 @@ tg3_dump_eeprom(struct ethtool_drvinfo *info, struct ethtool_eeprom *ee)
 	return 0;
 }
 
-int
-tg3_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int tg3_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	int i;
 	u32 reg;
-- 
2.23.0.866.gb869b98d4c-goog

