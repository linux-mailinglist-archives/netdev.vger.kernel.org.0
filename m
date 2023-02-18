Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FDA69BC08
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 22:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBRVOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 16:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBRVOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 16:14:05 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F9311156;
        Sat, 18 Feb 2023 13:14:03 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d720e7fa38aeb66ad4157793.dip0.t-ipconnect.de [IPv6:2003:e9:d720:e7fa:38ae:b66a:d415:7793])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 33B95C0831;
        Sat, 18 Feb 2023 22:14:02 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        linux-kernel@vger.kernel.org, alan@signal11.us,
        liuxuenetmail@gmail.com, varkabhadram@gmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH net 2/4] MAINTAINERS: Switch maintenance for mcr20a driver over
Date:   Sat, 18 Feb 2023 22:13:15 +0100
Message-Id: <20230218211317.284889-2-stefan@datenfreihafen.org>
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

Xue Liu has not been actively working on the driver or reviewing
patches for several years. I have been taking odd fixes in through the
wpan/ieee802154 tree. Update the MAINTAINERS file to reflect this
reality. I wanted to thank Xue Liu for his work on the driver.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3862b03c99b..0313cee5121a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12822,9 +12822,9 @@ F:	drivers/iio/potentiometer/mcp4018.c
 F:	drivers/iio/potentiometer/mcp4531.c
 
 MCR20A IEEE-802.15.4 RADIO DRIVER
-M:	Xue Liu <liuxuenetmail@gmail.com>
+M:	Stefan Schmidt <stefan@datenfreihafen.org>
 L:	linux-wpan@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 W:	https://github.com/xueliu/mcr20a-linux
 F:	Documentation/devicetree/bindings/net/ieee802154/mcr20a.txt
 F:	drivers/net/ieee802154/mcr20a.c
-- 
2.39.1

