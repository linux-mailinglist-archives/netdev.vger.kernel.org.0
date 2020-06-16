Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678941FA98D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgFPHIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPHIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 03:08:19 -0400
X-Greylist: delayed 587 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Jun 2020 00:08:19 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE9FC05BD43
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 00:08:19 -0700 (PDT)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d71c61de2d263da9f29fb60d.dip0.t-ipconnect.de [IPv6:2003:e9:d71c:61de:2d26:3da9:f29f:b60d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 7A93AC0D4F;
        Tue, 16 Jun 2020 08:58:28 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 1/2] docs: net: ieee802154: change link to new project URL
Date:   Tue, 16 Jun 2020 08:58:13 +0200
Message-Id: <20200616065814.816248-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We finally came around to setup a new project website.
Update the reference here.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
---
 Documentation/networking/ieee802154.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ieee802154.rst b/Documentation/networking/ieee802154.rst
index 36ca823a1122..6f4bf8447a21 100644
--- a/Documentation/networking/ieee802154.rst
+++ b/Documentation/networking/ieee802154.rst
@@ -30,8 +30,8 @@ Socket API
 
 The address family, socket addresses etc. are defined in the
 include/net/af_ieee802154.h header or in the special header
-in the userspace package (see either http://wpan.cakelab.org/ or the
-git tree at https://github.com/linux-wpan/wpan-tools).
+in the userspace package (see either https://linux-wpan.org/wpan-tools.html
+or the git tree at https://github.com/linux-wpan/wpan-tools).
 
 6LoWPAN Linux implementation
 ============================
-- 
2.25.4

