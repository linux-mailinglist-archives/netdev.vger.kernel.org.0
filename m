Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B989DB608
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441383AbfJQSW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43996 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503220AbfJQSVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id a2so2158624pfo.10
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4mn951ojWG6H1WfltkvCD5uGwbE1/LT5rlc1glMoqkI=;
        b=jh5ul5yKHL1LloRNnj+/N9HT22tFETnoRFG/yCx3lfJ5Rkk/bYrQ4Nk0P/UXkJuhD5
         W1E9RUH2ULguGdeB9pEytv+pBDvtbtxXTGu5yPIubMw4ulh6Fh+pcKOKvcLOeWMMRmQW
         DDCpwJgB8K+GLwV8Uy7MWKQ/XtC2PUnsTWI7W7RsKohrKQvGwgbPvM2fkMTqdxvu0eJK
         d5+Bo1ZqXOQRuDvMbe0qSLL1KlwyCHyXr1GCBoCwEdxqyiDUQA67EK+gT3MzHVkQdLvo
         czY2QgymUAmbd2wXOrBB5qF17ceXvDeX55EpvIEOUIXUs3fklRroxua0XRABufYJHRyi
         bvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4mn951ojWG6H1WfltkvCD5uGwbE1/LT5rlc1glMoqkI=;
        b=NvJM+ivUjP73fAyDT3YD3rTJGLAQutquoE8TqGCqF0ydbjUwGEI/nrtNXqbSkpA3E3
         8psTckRLRHM34Yd7hyooMZ+NS0Zmul6ZdH/fs9wpt+Q2is/lTJ9QXNI/oe4mcvXmd0Su
         oWixuhv3utoojTAIjsY7N6pRIXDttsI5EO4xlG7Gd2YH47GRyWQKHoAQERQCl440wMwK
         QrhCLxFCr9iwVU6QNw94d1l8PB5Ef5k/mIB6QUXfSRUhsGh5YneHJkROu8fiQKcNgfnq
         DKZiVkhdBVfwU1Brd5Wak6j03xqLvO2NAeogWoTfAeHX79hmMsMbnlUIvNkN9JXXa3eF
         OaAg==
X-Gm-Message-State: APjAAAU8mExV3I+z6T3yqWZWuv5mzvcyOpDkpD5Xkb4TlGUMNUTy55yy
        M6SKjJytLhEJ5smq4F7PuEE=
X-Google-Smtp-Source: APXvYqwnv8H43EMnkVaoZMvzmmKwiZtejmTb+xmiviwCW8L+hoc82z6QNN4M9HF0yE7iItj9vYw/3w==
X-Received: by 2002:a63:8f41:: with SMTP id r1mr5241181pgn.83.1571336508559;
        Thu, 17 Oct 2019 11:21:48 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:47 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 09/33] fix unused parameter warning in netsemi_dump_eeprom()
Date:   Thu, 17 Oct 2019 11:20:57 -0700
Message-Id: <20191017182121.103569-9-zenczykowski@gmail.com>
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
  external/ethtool/natsemi.c:967:45: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  natsemi_dump_eeprom(struct ethtool_drvinfo *info, struct ethtool_eeprom *ee)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I40d66f887d18ac6e69e1f365767a19f580a44f69
---
 natsemi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/natsemi.c b/natsemi.c
index e6e94b0..ce82c42 100644
--- a/natsemi.c
+++ b/natsemi.c
@@ -964,7 +964,8 @@ natsemi_dump_regs(struct ethtool_drvinfo *info maybe_unused,
 }
 
 int
-natsemi_dump_eeprom(struct ethtool_drvinfo *info, struct ethtool_eeprom *ee)
+natsemi_dump_eeprom(struct ethtool_drvinfo *info maybe_unused,
+		    struct ethtool_eeprom *ee)
 {
 	int i;
 	u16 *eebuf = (u16 *)ee->data;
-- 
2.23.0.866.gb869b98d4c-goog

