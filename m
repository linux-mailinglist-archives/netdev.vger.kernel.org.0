Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC1269BC04
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 22:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBRVOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 16:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBRVOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 16:14:01 -0500
X-Greylist: delayed 14014 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Feb 2023 13:14:00 PST
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CFE10A9F;
        Sat, 18 Feb 2023 13:13:59 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d720e7fa38aeb66ad4157793.dip0.t-ipconnect.de [IPv6:2003:e9:d720:e7fa:38ae:b66a:d415:7793])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DF33CC04A2;
        Sat, 18 Feb 2023 22:13:55 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        linux-kernel@vger.kernel.org, alan@signal11.us,
        liuxuenetmail@gmail.com, varkabhadram@gmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH net 1/4] MAINTAINERS: Switch maintenance for cc2520 driver over
Date:   Sat, 18 Feb 2023 22:13:14 +0100
Message-Id: <20230218211317.284889-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Varka Bhadram has not been actively working on the driver or reviewing
patches for several years. I have been taking odd fixes in through the
wpan/ieee802154 tree. Update the MAINTAINERS file to reflect this
reality. I wanted to thank Varka for his work on the driver.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6a47510d1592..b3862b03c99b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4807,9 +4807,9 @@ F:	net/sched/sch_etf.c
 F:	net/sched/sch_taprio.c
 
 CC2520 IEEE-802.15.4 RADIO DRIVER
-M:	Varka Bhadram <varkabhadram@gmail.com>
+M:	Stefan Schmidt <stefan@datenfreihafen.org>
 L:	linux-wpan@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 F:	drivers/net/ieee802154/cc2520.c
 F:	include/linux/spi/cc2520.h
-- 
2.39.1

