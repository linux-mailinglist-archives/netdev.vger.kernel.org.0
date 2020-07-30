Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFD523350E
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 17:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgG3PIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 11:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729684AbgG3PIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 11:08:51 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CDEC061575;
        Thu, 30 Jul 2020 08:08:51 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k1AAr-00Db7Y-7k; Thu, 30 Jul 2020 17:08:49 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-07-30
Date:   Thu, 30 Jul 2020 17:08:35 +0200
Message-Id: <20200730150836.66554-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

It's been a while, sorry. I have a few more fix that'd be nice
to get in, though I don't think they affect a majority of users.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 27a2145d6f826d1fad9de06ac541b1016ced3427:

  ibmvnic: Fix IRQ mapping disposal in error path (2020-07-29 15:35:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2020-07-30

for you to fetch changes up to 04e35caa32ec9aae6b306d07f07dc2ee6d69166c:

  mac80211: remove STA txq pending airtime underflow warning (2020-07-30 10:26:04 +0200)

----------------------------------------------------------------
A couple of more changes:
 * remove a warning that can trigger in certain races
 * check a function pointer before using it
 * check before adding 6 GHz to avoid a warning in mesh
 * fix two memory leaks in mesh
 * fix a TX status bug leading to a memory leak

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: remove STA txq pending airtime underflow warning

Julian Squires (1):
      cfg80211: check vendor command doit pointer before use

Rajkumar Manoharan (1):
      mac80211: fix warning in 6 GHz IE addition in mesh mode

Remi Pommarel (2):
      mac80211: mesh: Free ie data when leaving mesh
      mac80211: mesh: Free pending skb when destroying a mpath

Vasanthakumar Thiagarajan (1):
      mac80211: Fix bug in Tx ack status reporting in 802.3 xmit path

 net/mac80211/cfg.c          |  1 +
 net/mac80211/mesh.c         | 13 +++++++++++++
 net/mac80211/mesh_pathtbl.c |  1 +
 net/mac80211/sta_info.c     |  4 +---
 net/mac80211/tx.c           |  7 ++++---
 net/mac80211/util.c         |  4 ++++
 net/wireless/nl80211.c      |  6 +++---
 7 files changed, 27 insertions(+), 9 deletions(-)

