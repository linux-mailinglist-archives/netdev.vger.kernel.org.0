Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7470548EAC6
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbiANNeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:34:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44384 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241303AbiANNeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 08:34:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2DA860AF5;
        Fri, 14 Jan 2022 13:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1017DC36AEA;
        Fri, 14 Jan 2022 13:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642167260;
        bh=UJ12ZzFrlrSkHp+B0xLmJWpX/izxJhLv+rkiI9O7fkE=;
        h=From:To:Cc:Subject:Date:From;
        b=fb/sf4bQHIT4JPCHnyVyurN8idE3hOWg9RnIlAo89NhoAyXKnX/8WepKcr/5C4wu8
         wfoqY8oZXtFTjQtuG81fgVI5lQaQxR3T1z+O+NwAPoJuudXEabqBRdioncCikv0k9Y
         zFg0YXftB52JLkawldBhkay12p5GeuSSq4JG4dfC6CSpm1KaSywNKh5hp/d94TNALE
         RnVvtkl9VXlwS8uR2P17+k5EKoy4KC/6Hvmgbb6cZ2x6NCIs+puQvGxgCDfH1deMcC
         XIbu147RORUh2ciKVklvG4uw35w5ubDUcnbVnB5HpQqWnca61ur59JbQ00lNJiJ2JQ
         CeeZqE1pPKX2w==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, lkp@intel.com
Subject: [PATCH wireless] MAINTAINERS: add common wireless and wireless-next trees
Date:   Fri, 14 Jan 2022 15:34:15 +0200
Message-Id: <20220114133415.8008-1-kvalo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For easier maintenance we have decided to create common wireless and
wireless-next trees for all wireless patches. Old mac80211 and wireless-drivers
trees will not be used anymore.

While at it, add a wiki link to wireless drivers section and a patchwork link
to 802.11, mac80211 and rfkill sections.

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
---

Stephen, please use these new trees in linux-next from now on.

Intel kernel test robot maintainers, please also update your configuration so
that the new trees are build tested. Reports can be sent to
linux-wireless@vger.kernel.org.

 MAINTAINERS | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 306de106f31b..d8db683d8b47 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -190,8 +190,9 @@ M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 W:	https://wireless.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
+Q:	http://patchwork.kernel.org/project/linux-wireless/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
 F:	Documentation/driver-api/80211/cfg80211.rst
 F:	Documentation/networking/regulatory.rst
 F:	include/linux/ieee80211.h
@@ -11308,8 +11309,9 @@ M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 W:	https://wireless.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
+Q:	http://patchwork.kernel.org/project/linux-wireless/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
 F:	Documentation/networking/mac80211-injection.rst
 F:	Documentation/networking/mac80211_hwsim/mac80211_hwsim.rst
 F:	drivers/net/wireless/mac80211_hwsim.[ch]
@@ -13302,9 +13304,10 @@ NETWORKING DRIVERS (WIRELESS)
 M:	Kalle Valo <kvalo@kernel.org>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+W:	https://wireless.wiki.kernel.org/
 Q:	http://patchwork.kernel.org/project/linux-wireless/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
 F:	Documentation/devicetree/bindings/net/wireless/
 F:	drivers/net/wireless/
 
@@ -16391,8 +16394,9 @@ M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 W:	https://wireless.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
+Q:	http://patchwork.kernel.org/project/linux-wireless/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
 F:	Documentation/ABI/stable/sysfs-class-rfkill
 F:	Documentation/driver-api/rfkill.rst
 F:	include/linux/rfkill.h
-- 
2.20.1

