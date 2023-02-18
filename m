Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D607269BC0A
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 22:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjBRVOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 16:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjBRVOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 16:14:07 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2CE11E89;
        Sat, 18 Feb 2023 13:14:05 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d720e7fa38aeb66ad4157793.dip0.t-ipconnect.de [IPv6:2003:e9:d720:e7fa:38ae:b66a:d415:7793])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C1F04C0AE2;
        Sat, 18 Feb 2023 22:14:02 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        linux-kernel@vger.kernel.org, alan@signal11.us,
        liuxuenetmail@gmail.com, varkabhadram@gmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH net 3/4] MAINTAINERS: Switch maintenance for mrf24j40 driver over
Date:   Sat, 18 Feb 2023 22:13:16 +0100
Message-Id: <20230218211317.284889-3-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230218211317.284889-1-stefan@datenfreihafen.org>
References: <20230218211317.284889-1-stefan@datenfreihafen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Ott has not been actively working on the driver or reviewing
patches for several years. I have been taking odd fixes in through the
wpan/ieee802154 tree. Update the MAINTAINERS file to reflect this
reality. I wanted to thank Alan for his work on the driver.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0313cee5121a..d5f77559f3f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14185,9 +14185,9 @@ T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/radio/radio-mr800.c
 
 MRF24J40 IEEE 802.15.4 RADIO DRIVER
-M:	Alan Ott <alan@signal11.us>
+M:	Stefan Schmidt <stefan@datenfreihafen.org>
 L:	linux-wpan@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 F:	Documentation/devicetree/bindings/net/ieee802154/mrf24j40.txt
 F:	drivers/net/ieee802154/mrf24j40.c
 
-- 
2.39.1

