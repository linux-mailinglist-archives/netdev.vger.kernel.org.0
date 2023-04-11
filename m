Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EBF6DD61A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjDKJB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKJB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:01:28 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C58CED;
        Tue, 11 Apr 2023 02:01:26 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6400B1C0004;
        Tue, 11 Apr 2023 09:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681203684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Autr71rVrAI9fDs2kzDM/24yploQZEPQoKPQVk564z0=;
        b=Fq1H5CTfOqckwZc5UZXALpKVpgmAaOe3t0uTP14PvIRGdeQ7VyAIwRrfUZCxfi/MgvCjb8
        fA2dDBUfMw+MDw2EbvIG5VM6WPC1zOnmyMxqYv/rX0Rm3xG94tfIPXrqAdrAUP2EhnTL0z
        NBrzG1ErdI2ihasHK/Wst3u+Cc7oGY1ebtF7Um7h6J+hzLXjm9NOxtniSaRS4M7YQo8pYz
        W1dbIaQOClCa1EvTXAokCJe9sZMWzbsJtxSyYSc8bjTsepdUfyKwQZG8NvjDFaN3fskJfp
        rofZv+Jl/c4mFCfyGxMRbMWHqu6yRYCXSXLYswRGbp38AoPuLCb2Kqiw1BCM+Q==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 1/2] MAINTAINERS: Update wpan tree
Date:   Tue, 11 Apr 2023 11:01:21 +0200
Message-Id: <20230411090122.419761-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wpan maintainers group is switching from Stefan's tree to a group
tree called 'wpan'. We will now maintain:
* wpan/wpan.git master:
  Fixes targetting the 'net' tree
* wpan/wpan-next.git master:
  Features targetting the 'net-next' tree
* wpan/wpan-next.git staging:
  Same as the wpan-next master branch, but we will push there first,
  expecting robots to parse the tree and report mistakes we would have
  not catch. This branch can be rebased and force pushed, unlike the
  others.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 54a2a8122a97..26d0edc024a7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9889,8 +9889,8 @@ M:	Miquel Raynal <miquel.raynal@bootlin.com>
 L:	linux-wpan@vger.kernel.org
 S:	Maintained
 W:	https://linux-wpan.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan-next.git
 F:	Documentation/networking/ieee802154.rst
 F:	drivers/net/ieee802154/
 F:	include/linux/ieee802154.h
-- 
2.34.1

