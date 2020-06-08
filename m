Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287931F1427
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 10:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgFHIIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 04:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgFHIIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 04:08:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CA1C08C5C3;
        Mon,  8 Jun 2020 01:08:44 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jiCpn-00HVPk-2v; Mon, 08 Jun 2020 10:08:43 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-06-08
Date:   Mon,  8 Jun 2020 10:08:32 +0200
Message-Id: <20200608080834.11576-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

We have a couple of updates - most importantly the fix
for the deadlock issue that came up.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 98749b7188affbf2900c2aab704a8853901d1139:

  yam: fix possible memory leak in yam_init_driver (2020-06-04 15:58:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2020-06-08

for you to fetch changes up to 59d4bfc1e2c09435d91c980b03f7b72ce6e9f24e:

  net: fix wiki website url mac80211 and wireless files (2020-06-08 10:06:05 +0200)

----------------------------------------------------------------
Just a small update:
 * fix the deadlock on rfkill/wireless removal that a few
   people reported
 * fix an uninitialized variable
 * update wiki URLs

----------------------------------------------------------------
Flavio Suligoi (3):
      doc: networking: wireless: fix wiki website url
      include: fix wiki website url in netlink interface header
      net: fix wiki website url mac80211 and wireless files

Johannes Berg (2):
      cfg80211: fix management registrations deadlock
      mac80211: initialize return flags in HE 6 GHz operation parsing

 Documentation/networking/mac80211-injection.rst |  2 +-
 Documentation/networking/regulatory.rst         |  6 +++---
 include/net/cfg80211.h                          |  5 +++--
 include/uapi/linux/nl80211.h                    |  2 +-
 net/mac80211/mlme.c                             |  2 ++
 net/mac80211/rx.c                               |  2 +-
 net/wireless/Kconfig                            |  2 +-
 net/wireless/core.c                             |  6 +++---
 net/wireless/core.h                             |  2 ++
 net/wireless/mlme.c                             | 26 ++++++++++++++++++++-----
 10 files changed, 38 insertions(+), 17 deletions(-)

