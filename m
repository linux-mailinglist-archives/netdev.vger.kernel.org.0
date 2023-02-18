Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5648669BC0D
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 22:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjBRVOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 16:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjBRVOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 16:14:07 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B677412070;
        Sat, 18 Feb 2023 13:14:05 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d720e7fa38aeb66ad4157793.dip0.t-ipconnect.de [IPv6:2003:e9:d720:e7fa:38ae:b66a:d415:7793])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 6F4F9C0E7A;
        Sat, 18 Feb 2023 22:14:03 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        linux-kernel@vger.kernel.org, alan@signal11.us,
        liuxuenetmail@gmail.com, varkabhadram@gmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH net 4/4] MAINTAINERS: Add Miquel Raynal as additional maintainer for ieee802154
Date:   Sat, 18 Feb 2023 22:13:17 +0100
Message-Id: <20230218211317.284889-4-stefan@datenfreihafen.org>
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

We are growing the maintainer team for ieee802154 to spread the load for
review and general maintenance. Miquel has been driving the subsystem
forward over the last year and we would like to welcome him as a
maintainer.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5f77559f3f4..1ba493cb777f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10007,6 +10007,7 @@ F:	drivers/clk/clk-versaclock5.c
 IEEE 802.15.4 SUBSYSTEM
 M:	Alexander Aring <alex.aring@gmail.com>
 M:	Stefan Schmidt <stefan@datenfreihafen.org>
+M:	Miquel Raynal <miquel.raynal@bootlin.com>
 L:	linux-wpan@vger.kernel.org
 S:	Maintained
 W:	https://linux-wpan.org/
-- 
2.39.1

