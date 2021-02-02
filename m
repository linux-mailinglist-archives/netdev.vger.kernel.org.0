Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6030C218
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhBBOkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbhBBOi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:38:29 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8DCC0617AB;
        Tue,  2 Feb 2021 06:35:12 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l6wlq-00EuEw-9q; Tue, 02 Feb 2021 15:35:10 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-02-02
Date:   Tue,  2 Feb 2021 15:35:04 +0100
Message-Id: <20210202143505.37610-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

So, getting late, but we have two more fixes - the staging
one (acked by Greg) is for a recent regression I had through
my tree, and the rate tables one is kind of important for
(some) drivers to get proper rate scaling going.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit eb4e8fac00d1e01ada5e57c05d24739156086677:

  neighbour: Prevent a dead entry from updating gc_list (2021-01-30 11:09:07 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-02-02

for you to fetch changes up to 50af06d43eab6b09afc37aa7c8bbf69b14a3b2f7:

  staging: rtl8723bs: Move wiphy setup to after reading the regulatory settings from the chip (2021-02-01 19:26:10 +0100)

----------------------------------------------------------------
Two fixes:
 - station rate tables were not updated correctly
   after association, leading to bad configuration
 - rtl8723bs (staging) was initializing data incorrectly
   after the previous fix and needed to move the init
   later

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: fix station rate table updates on assoc

Hans de Goede (1):
      staging: rtl8723bs: Move wiphy setup to after reading the regulatory settings from the chip

 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 4 ++--
 net/mac80211/driver-ops.c                    | 5 ++++-
 net/mac80211/rate.c                          | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

