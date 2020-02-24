Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097C716AF71
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgBXSlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:41:14 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:42230 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgBXSlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:41:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6IfH-007OIg-Sq; Mon, 24 Feb 2020 19:41:11 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-02-24
Date:   Mon, 24 Feb 2020 19:41:07 +0100
Message-Id: <20200224184108.82737-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

And in addition, I also have a couple of fixes for net.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 36a44bcdd8df092d76c11bc213e81c5817d4e302:

  Merge branch 'bnxt_en-shutdown-and-kexec-kdump-related-fixes' (2020-02-20 16:05:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-02-24

for you to fetch changes up to 253216ffb2a002a682c6f68bd3adff5b98b71de8:

  mac80211: rx: avoid RCU list traversal under mutex (2020-02-24 10:42:38 +0100)

----------------------------------------------------------------
A few fixes:
 * remove a double mutex-unlock
 * fix a leak in an error path
 * NULL pointer check
 * include if_vlan.h where needed
 * avoid RCU list traversal when not under RCU

----------------------------------------------------------------
Andrei Otcheretianski (1):
      mac80211: Remove a redundant mutex unlock

Johannes Berg (3):
      nl80211: fix potential leak in AP start
      cfg80211: check reg_rule for NULL in handle_channel_custom()
      nl80211: explicitly include if_vlan.h

Madhuparna Bhowmik (1):
      mac80211: rx: avoid RCU list traversal under mutex

 net/mac80211/mlme.c    | 6 +-----
 net/mac80211/rx.c      | 2 +-
 net/wireless/nl80211.c | 5 +++--
 net/wireless/reg.c     | 2 +-
 4 files changed, 6 insertions(+), 9 deletions(-)

