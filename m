Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA2E15D48F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 10:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgBNJTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 04:19:25 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39394 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgBNJTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 04:19:25 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j2X87-00BExV-Bj; Fri, 14 Feb 2020 10:19:23 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-02-14
Date:   Fri, 14 Feb 2020 10:19:10 +0100
Message-Id: <20200214091911.9516-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's a new pull request, long delayed unfortunately, but it
wasn't that many fixes and some are pretty recent too. See the
description below, it's really various things all over that we
discovered.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit df373702bc0f8f2d83980ea441e71639fc1efcf8:

  net: dsa: b53: Always use dev->vlan_enabled in b53_configure_vlan() (2020-02-07 11:25:09 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-02-14

for you to fetch changes up to 33181ea7f5a62a17fbe55f0f73428ecb5e686be8:

  mac80211: fix wrong 160/80+80 MHz setting (2020-02-14 09:54:12 +0100)

----------------------------------------------------------------
Just a few fixes:
 * avoid running out of tracking space for frames that need
   to be reported to userspace by using more bits
 * fix beacon handling suppression by adding some relevant
   elements to the CRC calculation
 * fix quiet mode in action frames
 * fix crash in ethtool for virt_wifi and similar
 * add a missing policy entry
 * fix 160 & 80+80 bandwidth to take local capabilities into
   account

----------------------------------------------------------------
Johannes Berg (2):
      mac80211: use more bits for ack_frame_id
      mac80211: consider more elements in parsing CRC

Sara Sharon (1):
      mac80211: fix quiet mode activation in action frames

Sergey Matyukevich (2):
      cfg80211: check wiphy driver existence for drvinfo report
      cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Shay Bar (1):
      mac80211: fix wrong 160/80+80 MHz setting

 include/net/mac80211.h | 11 +++++------
 net/mac80211/cfg.c     |  2 +-
 net/mac80211/mlme.c    |  8 ++++----
 net/mac80211/tx.c      |  2 +-
 net/mac80211/util.c    | 34 ++++++++++++++++++++++++++--------
 net/wireless/ethtool.c |  8 ++++++--
 net/wireless/nl80211.c |  1 +
 7 files changed, 44 insertions(+), 22 deletions(-)

