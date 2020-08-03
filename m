Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A508D23A3E3
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgHCMQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 08:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgHCMQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 08:16:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0958C06174A;
        Mon,  3 Aug 2020 05:16:12 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k2ZNv-00FfDv-Se; Mon, 03 Aug 2020 14:16:08 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-08-03
Date:   Mon,  3 Aug 2020 14:15:55 +0200
Message-Id: <20200803121556.29405-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Not sure you'll still take a few stragglers, but if you're
going to make a last pass then having a few more things in
would be nice. One (the while -> if) is something I'd even
send as a bugfix later, the rest are just nice to have. :)

Please pull (if you still want) and let me know if there's
any problem.

Thanks,
johannes



The following changes since commit bd0b33b24897ba9ddad221e8ac5b6f0e38a2e004:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-08-02 01:02:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2020-08-03

for you to fetch changes up to 0b91111fb1a164fedbb68a9263afafd10ffa6ec3:

  mac80211: Do not report beacon loss if beacon filtering enabled (2020-08-03 13:02:06 +0200)

----------------------------------------------------------------
A few more changes, notably:
 * handle new SAE (WPA3 authentication) status codes in the correct way
 * fix a while that should be an if instead, avoiding infinite loops
 * handle beacon filtering changing better

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: fix misplaced while instead of if

John Crispin (1):
      mac8211: fix struct initialisation

Jouni Malinen (1):
      mac80211: Handle special status codes in SAE commit

Loic Poulain (1):
      mac80211: Do not report beacon loss if beacon filtering enabled

Miaohe Lin (2):
      mac80211: use eth_zero_addr() to clear mac address
      nl80211: use eth_zero_addr() to clear mac address

 include/linux/ieee80211.h | 2 ++
 net/mac80211/agg-rx.c     | 2 +-
 net/mac80211/mlme.c       | 8 +++++++-
 net/mac80211/sta_info.c   | 2 +-
 net/mac80211/trace.h      | 3 ++-
 net/wireless/nl80211.c    | 3 +--
 6 files changed, 14 insertions(+), 6 deletions(-)

