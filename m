Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C87303E18
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391290AbhAZNGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390642AbhAZNGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:06:20 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C91C0611C2;
        Tue, 26 Jan 2021 05:05:38 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l4O2K-00Bud6-Bx; Tue, 26 Jan 2021 14:05:36 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-01-26
Date:   Tue, 26 Jan 2021 14:05:28 +0100
Message-Id: <20210126130529.75225-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

We have a few fixes - note one is for a staging driver, but acked by
Greg and fixing the driver for a change that came through my tree.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1c45ba93d34cd6af75228f34d0675200c81738b5:

  net: dsa: microchip: Adjust reset release timing to match reference reset circuit (2021-01-20 20:52:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-01-26

for you to fetch changes up to 81f153faacd04c049e5482d6ff33daddc30ed44e:

  staging: rtl8723bs: fix wireless regulatory API misuse (2021-01-26 12:21:42 +0100)

----------------------------------------------------------------
A couple of fixes:
 * fix 160 MHz channel switch in mac80211
 * fix a staging driver to not deadlock due to some
   recent cfg80211 changes
 * fix NULL-ptr deref if cfg80211 returns -EINPROGRESS
   to wext (syzbot)
 * pause TX in mac80211 in type change to prevent crashes
   (syzbot)

----------------------------------------------------------------
Johannes Berg (3):
      wext: fix NULL-ptr-dereference with cfg80211's lack of commit()
      mac80211: pause TX while changing interface type
      staging: rtl8723bs: fix wireless regulatory API misuse

Shay Bar (1):
      mac80211: 160MHz with extended NSS BW in CSA

 drivers/staging/rtl8723bs/include/rtw_wifi_regd.h |  6 +++---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |  6 +++---
 drivers/staging/rtl8723bs/os_dep/wifi_regd.c      | 10 +++-------
 net/mac80211/ieee80211_i.h                        |  1 +
 net/mac80211/iface.c                              |  6 ++++++
 net/mac80211/spectmgmt.c                          | 10 +++++++---
 net/wireless/wext-core.c                          |  5 +++--
 7 files changed, 26 insertions(+), 18 deletions(-)

