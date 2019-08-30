Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA05A30F4
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfH3H1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:27:41 -0400
Received: from packetmixer.de ([79.140.42.25]:52142 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfH3H1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:27:40 -0400
Received: from kero.packetmixer.de (p200300C5970B8500250C6283C70837BA.dip0.t-ipconnect.de [IPv6:2003:c5:970b:8500:250c:6283:c708:37ba])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id CCE5362075;
        Fri, 30 Aug 2019 09:27:38 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 1/1] batman-adv: Add Sven to MAINTAINERS file
Date:   Fri, 30 Aug 2019 09:27:36 +0200
Message-Id: <20190830072736.18535-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190830072736.18535-1-sw@simonwunderlich.de>
References: <20190830072736.18535-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sven is taking care of tracking our patches and merging most of them in
our tree. Let's add him to the MAINTAINERS file so he will get all
patch e-mails.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Acked-by: Antonio Quartulli <a@unstable.cc>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 783569e3c4b4..ce8316cbe3b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2911,6 +2911,7 @@ BATMAN ADVANCED
 M:	Marek Lindner <mareklindner@neomailbox.ch>
 M:	Simon Wunderlich <sw@simonwunderlich.de>
 M:	Antonio Quartulli <a@unstable.cc>
+M:	Sven Eckelmann <sven@narfation.org>
 L:	b.a.t.m.a.n@lists.open-mesh.org (moderated for non-subscribers)
 W:	https://www.open-mesh.org/
 B:	https://www.open-mesh.org/projects/batman-adv/issues
-- 
2.20.1

