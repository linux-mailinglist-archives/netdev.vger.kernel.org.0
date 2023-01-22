Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F06B677217
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 20:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjAVTmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 14:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjAVTmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 14:42:21 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42A41CF60;
        Sun, 22 Jan 2023 11:42:19 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 71ED8FF804;
        Sun, 22 Jan 2023 19:42:15 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Cc:     Diederik de Haas <didi.debian@cknow.org>
Subject: [PATCH] bonding: Fix full name of the GPL
Date:   Sun, 22 Jan 2023 20:42:01 +0100
Message-Id: <20230122194201.61105-1-didi.debian@cknow.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
---
 include/net/bonding.h           | 2 +-
 include/uapi/linux/if_bonding.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/bonding.h b/include/net/bonding.h
index ea36ab7f9e72..5dacb7e9a034 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -8,7 +8,7 @@
  * (c) Copyright 1999, Thomas Davis, tadavis@lbl.gov
  *
  *	This software may be used and distributed according to the terms
- *	of the GNU Public License, incorporated herein by reference.
+ *	of the GNU General Public License, incorporated herein by reference.
  *
  */
 
diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
index d174914a837d..3338c7c6da45 100644
--- a/include/uapi/linux/if_bonding.h
+++ b/include/uapi/linux/if_bonding.h
@@ -10,7 +10,7 @@
  * (c) Copyright 1999, Thomas Davis, tadavis@lbl.gov
  *
  *	This software may be used and distributed according to the terms
- *	of the GNU Public License, incorporated herein by reference.
+ *	of the GNU General Public License, incorporated herein by reference.
  *
  * 2003/03/18 - Amir Noam <amir.noam at intel dot com>
  *	- Added support for getting slave's speed and duplex via ethtool.
-- 
2.39.0

