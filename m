Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9946F09A
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 22:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfGTUZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 16:25:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48198 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfGTUZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 16:25:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hovuh-000771-C3; Sat, 20 Jul 2019 22:25:03 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-07-20
Date:   Sat, 20 Jul 2019 22:24:55 +0200
Message-Id: <20190720202456.8444-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Sorry, this really should've gone out much earlier, in partilar
the vendor command fixes. Not much for now, more -next material
will come later.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1a03bb532934e90c7d662f7c59f4f66ea8451fa4:

  r8169: fix RTL8168g PHY init (2019-07-20 12:17:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-07-20

for you to fetch changes up to d2b3fe42bc629c2d4002f652b3abdfb2e72991c7:

  mac80211: don't warn about CW params when not using them (2019-07-20 21:40:32 +0200)

----------------------------------------------------------------
We have a handful of fixes:
 * ignore bad CW parameters if we aren't using them,
   instead of warning
 * fix operation (and then build) with the new netlink vendor
   command policy requirement
 * fix a memory leak in an error path when setting beacons

----------------------------------------------------------------
Brian Norris (1):
      mac80211: don't warn about CW params when not using them

Johannes Berg (2):
      wireless: fix nl80211 vendor commands
      nl80211: fix VENDOR_CMD_RAW_DATA

John Crispin (1):
      nl80211: fix NL80211_HE_MAX_CAPABILITY_LEN

Lorenzo Bianconi (1):
      mac80211: fix possible memory leak in ieee80211_assign_beacon

 drivers/net/wireless/ath/wil6210/cfg80211.c               |  4 ++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c |  1 +
 drivers/net/wireless/ti/wlcore/vendor_cmd.c               |  3 +++
 include/net/cfg80211.h                                    |  2 +-
 include/uapi/linux/nl80211.h                              |  2 +-
 net/mac80211/cfg.c                                        |  8 ++++++--
 net/mac80211/driver-ops.c                                 | 13 +++++++++----
 7 files changed, 25 insertions(+), 8 deletions(-)

