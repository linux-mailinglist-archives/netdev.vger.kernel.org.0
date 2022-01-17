Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF9E49102C
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 19:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242223AbiAQSUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 13:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiAQSUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 13:20:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E71BC061574;
        Mon, 17 Jan 2022 10:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C6D06100E;
        Mon, 17 Jan 2022 18:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5F9C36AE3;
        Mon, 17 Jan 2022 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642443604;
        bh=zLGeYHy6RxeDRs/7PXGDuFwinvTJa8TuCQCs9UarAA4=;
        h=From:To:Cc:Subject:Date:From;
        b=p9zXwaAL4xy9J7O61LYb/yOVEzDGdJIEey7bSgXyAzmaNLB0VeO1+5qpqDlbGqltL
         6TAefnD6rPJCR5kjbJP7GzyMsjchB+p4Vkf38+l8SBiuWu/gwQnm9EWiolQ+gZ446z
         7fSIHFTLKFwru9qV7WUS3nY4Jb34g7II62HgZhfIZMKbtFfdCLg3lvvDOEUbAeItFb
         Pxj1J7M/Cf+HKTjXB1JaHfSVTi30U90dtgliQORx7UXYuqa14t4CbHGenBCPNeWWgr
         TBsolNtD1YzzKGmBNxVeDUaglIdd8N+JTICVTzmil99857k25aVnkeRE7iOEkjQVLI
         fR5C5dok9rs+Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, lkp@intel.com
Subject: [PATCH wireless v2 1/2] MAINTAINERS: add common wireless and wireless-next trees
Date:   Mon, 17 Jan 2022 20:19:57 +0200
Message-Id: <20220117181958.3509-1-kvalo@kernel.org>
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
to 802.11, mac80211 and rfkill sections. Also use https in patchwork links.

Signed-off-by: Kalle Valo <kvalo@kernel.org>
---

Intel kernel test robot maintainers, please update your configuration so
that the new trees are build tested. Reports can be sent to
linux-wireless@vger.kernel.org.

v2:

* use https on patchwork links

 MAINTAINERS | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 306de106f31b..f67e7dae2c55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -190,8 +190,9 @@ M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 W:	https://wireless.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
+Q:	https://patchwork.kernel.org/project/linux-wireless/list/
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
+Q:	https://patchwork.kernel.org/project/linux-wireless/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
 F:	Documentation/networking/mac80211-injection.rst
 F:	Documentation/networking/mac80211_hwsim/mac80211_hwsim.rst
 F:	drivers/net/wireless/mac80211_hwsim.[ch]
@@ -13302,9 +13304,10 @@ NETWORKING DRIVERS (WIRELESS)
 M:	Kalle Valo <kvalo@kernel.org>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-Q:	http://patchwork.kernel.org/project/linux-wireless/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
+W:	https://wireless.wiki.kernel.org/
+Q:	https://patchwork.kernel.org/project/linux-wireless/list/
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
+Q:	https://patchwork.kernel.org/project/linux-wireless/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
 F:	Documentation/ABI/stable/sysfs-class-rfkill
 F:	Documentation/driver-api/rfkill.rst
 F:	include/linux/rfkill.h
-- 
2.20.1

