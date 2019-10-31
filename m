Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972B0EAD9E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfJaKh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:37:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52308 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfJaKh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:37:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iQ7py-00083L-QP; Thu, 31 Oct 2019 11:37:54 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-10-31
Date:   Thu, 31 Oct 2019 11:37:42 +0100
Message-Id: <20191031103743.24923-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

We have two more fixes, see below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 6f74a55d49004df760381df525f14edf018a640f:

  Merge tag 'mlx5-fixes-2019-10-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2019-10-29 20:59:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2019-10-31

for you to fetch changes up to 1fab1b89e2e8f01204a9c05a39fd0b6411a48593:

  nl80211: fix validation of mesh path nexthop (2019-10-30 10:11:18 +0100)

----------------------------------------------------------------
Just two fixes:
 * HT operation is not allowed on channel 14 (Japan only)
 * netlink policy for nexthop attribute was wrong

----------------------------------------------------------------
Markus Theil (1):
      nl80211: fix validation of mesh path nexthop

Masashi Honma (1):
      nl80211: Disallow setting of HT for channel 14

 net/wireless/chan.c    | 5 +++++
 net/wireless/nl80211.c | 2 +-
 net/wireless/util.c    | 3 ++-
 3 files changed, 8 insertions(+), 2 deletions(-)

