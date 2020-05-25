Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE60C1E1039
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390898AbgEYOP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgEYOP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 10:15:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997D7C061A0E;
        Mon, 25 May 2020 07:15:58 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jdDtU-002lZQ-97; Mon, 25 May 2020 16:15:56 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-05-25
Date:   Mon, 25 May 2020 16:15:46 +0200
Message-Id: <20200525141547.40538-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

We have a couple more fixes, all of them seem sort of older issues
that surfaced now.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 98790bbac4db1697212ce9462ec35ca09c4a2810:

  Merge tag 'efi-urgent-2020-05-24' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2020-05-24 10:24:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-05-25

for you to fetch changes up to 0bbab5f0301587cad4e923ccc49bb910db86162c:

  cfg80211: fix debugfs rename crash (2020-05-25 13:12:32 +0200)

----------------------------------------------------------------
A few changes:
 * fix a debugfs vs. wiphy rename crash
 * fix an invalid HE spec definition
 * fix a mesh timer crash

----------------------------------------------------------------
Johannes Berg (1):
      cfg80211: fix debugfs rename crash

Linus Lüssing (1):
      mac80211: mesh: fix discovery timer re-arming issue / crash

Pradeep Kumar Chitrapu (1):
      ieee80211: Fix incorrect mask for default PE duration

 include/linux/ieee80211.h | 2 +-
 net/mac80211/mesh_hwmp.c  | 7 +++++++
 net/wireless/core.c       | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

