Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDA32CEDFD
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgLDMVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbgLDMVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:21:04 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D764C0613D1;
        Fri,  4 Dec 2020 04:20:24 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1klA4U-002NvD-KX; Fri, 04 Dec 2020 13:20:22 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-12-04
Date:   Fri,  4 Dec 2020 13:20:16 +0100
Message-Id: <20201204122017.118099-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

We've got a few more fixes for the current cycle, everything
else I have pending right now seems likely to go to 5.11 instead.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit bbe2ba04c5a92a49db8a42c850a5a2f6481e47eb:

  Merge tag 'net-5.10-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-12-03 13:10:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-12-04

for you to fetch changes up to bdeca45a0cc58f864f1eb2e919304203ff5c5f39:

  mac80211: set SDATA_STATE_RUNNING for monitor interfaces (2020-12-04 12:45:25 +0100)

----------------------------------------------------------------
Three small fixes:
 * initialize some data to avoid using stack garbage
 * fix 6 GHz channel selection in mac80211
 * correctly restart monitor mode interfaces in mac80211

----------------------------------------------------------------
Borwankar, Antara (1):
      mac80211: set SDATA_STATE_RUNNING for monitor interfaces

Sara Sharon (1):
      cfg80211: initialize rekey_data

Wen Gong (1):
      mac80211: fix return value of ieee80211_chandef_he_6ghz_oper

 net/mac80211/iface.c   | 2 ++
 net/mac80211/util.c    | 2 +-
 net/wireless/nl80211.c | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

