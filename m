Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3587C3F287B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 10:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhHTId4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 04:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhHTIdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 04:33:46 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B73BC061756
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 01:33:08 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c5970e73c0a32126881010a2d4.dip0.t-ipconnect.de [IPv6:2003:c5:970e:73c0:a321:2688:1010:a2d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 5E7BA174021;
        Fri, 20 Aug 2021 10:33:05 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/6] batman-adv: Move IRC channel to hackint.org
Date:   Fri, 20 Aug 2021 10:32:56 +0200
Message-Id: <20210820083300.32289-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210820083300.32289-1-sw@simonwunderlich.de>
References: <20210820083300.32289-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

Due to recent developments around the Freenode.org IRC network, the
opinions about the usage of this service shifted dramatically. The majority
of the still active users of the #batman channel prefers a move to the
hackint.org network.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 Documentation/networking/batman-adv.rst | 2 +-
 MAINTAINERS                             | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/batman-adv.rst b/Documentation/networking/batman-adv.rst
index 74821d29a22f..b85563ea3682 100644
--- a/Documentation/networking/batman-adv.rst
+++ b/Documentation/networking/batman-adv.rst
@@ -157,7 +157,7 @@ Contact
 Please send us comments, experiences, questions, anything :)
 
 IRC:
-  #batman on irc.freenode.org
+  #batadv on ircs://irc.hackint.org/
 Mailing-list:
   b.a.t.m.a.n@open-mesh.org (optional subscription at
   https://lists.open-mesh.org/mailman3/postorius/lists/b.a.t.m.a.n.lists.open-mesh.org/)
diff --git a/MAINTAINERS b/MAINTAINERS
index 41fcfdb24a81..b8971a2f5a7e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3197,7 +3197,7 @@ S:	Maintained
 W:	https://www.open-mesh.org/
 Q:	https://patchwork.open-mesh.org/project/batman/list/
 B:	https://www.open-mesh.org/projects/batman-adv/issues
-C:	irc://chat.freenode.net/batman
+C:	ircs://irc.hackint.org/batadv
 T:	git https://git.open-mesh.org/linux-merge.git
 F:	Documentation/networking/batman-adv.rst
 F:	include/uapi/linux/batadv_packet.h
-- 
2.20.1

