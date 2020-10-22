Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E5F295A7E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509361AbgJVIhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 04:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508193AbgJVIhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:37:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF155C0613CE;
        Thu, 22 Oct 2020 01:37:20 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l24so917792edj.8;
        Thu, 22 Oct 2020 01:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EoBlqRFhkkSNn7Y09jombg3gcIxThC7vA4TcMP8jIBE=;
        b=cCND1jmC7kpdG17HFYH5UjDzYpADfsDedLEwz8zngOgu5VTefsEcxWzD6PDRouDwJ8
         m48WOMMfuKzOgeuSy9yu9YolddoG84LdH4C62Mg7g1SbdykXQsaD8kmge6JMmP+Kd/3i
         vpLwfnY+knBC9TodN9YT0JaxjrCz5+7pmjfXGTGMpKiwVxLjqbUrY9bT1Fn2aibiQp1S
         KI2ht9Eb/8gvVrx2bfXyaK/cPUdoolKY/vIpRsvGPUO6CJPBkupFUZ/AkW7PcArz/xXG
         oC39uQxgvdqtGoxM1GbFFuWjvpuC0D7oI2htwnQl1PhA0aFS2AC71aVBCdXgw48ImXUK
         V07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EoBlqRFhkkSNn7Y09jombg3gcIxThC7vA4TcMP8jIBE=;
        b=V4VJLtmSHd2KjgkGxOpYU+OM1yeCXivEpNedItWpKLWiGbQdBDYgZIzLFGyz2D5qgz
         qxpB7u/0vUhc2DP4YgxqcmwRuqaHCsAyd8eGXxlwJUjTLPyaa87MX9F2ra+FtwJy9xWr
         muRRtFcgxcAHvvbEqWSl+6VGLAAS5UExXVQkBHUJgL/9w9QPi3s+pPKDzqkH3zzH59FH
         vC4Gq4fnL0xagEZ/IyS1ERy6rBEQj/A+CSgACYPK5/mriZ2jXQoa/vC9/IPLMRSU+buP
         mmDmB+hPR2wnh90MqCG0AwnsryygW5kNzag1gJcUIMq8tM2wanu3xmEvp0KdTAuTLWCy
         y9tg==
X-Gm-Message-State: AOAM5327jSmov5jA1UEk94i67de1C4wepDeJzhLi4GjYqjqJWEcOEGl8
        jro17zeEZW5fCn9oaBb/5vrO5LCK2Ok=
X-Google-Smtp-Source: ABdhPJzKG6JTJY+I7vRS0mK6M79cTjoH7sQa5Q0a9/riod4tpZJUOq+GUdn3g/YkJbgtj6T8Imu6zg==
X-Received: by 2002:a05:6402:128c:: with SMTP id w12mr1198063edv.242.1603355839265;
        Thu, 22 Oct 2020 01:37:19 -0700 (PDT)
Received: from development1.visionsystems.de (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id op24sm436295ejb.56.2020.10.22.01.37.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 01:37:18 -0700 (PDT)
From:   yegorslists@googlemail.com
To:     linux-can@vger.kernel.org
Cc:     mkl@pengutronix.de, netdev@vger.kernel.org,
        Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] can: j1939: swap addr and pgn in the send example
Date:   Thu, 22 Oct 2020 10:37:08 +0200
Message-Id: <20201022083708.8755-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

The address was wrongly assigned to the PGN field and vice versa.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Documentation/networking/j1939.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index be59fcece3bf..faf2eb5c5052 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -414,8 +414,8 @@ Send:
 		.can_family = AF_CAN,
 		.can_addr.j1939 = {
 			.name = J1939_NO_NAME;
-			.pgn = 0x30,
-			.addr = 0x12300,
+			.addr = 0x30,
+			.pgn = 0x12300,
 		},
 	};
 
-- 
2.17.0

