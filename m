Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1298E97695
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfHUKAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:00:18 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59000 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfHUKAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 06:00:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i0NPZ-0007iL-QY; Wed, 21 Aug 2019 12:00:13 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-08-21
Date:   Wed, 21 Aug 2019 12:00:03 +0200
Message-Id: <20190821100005.13393-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

I have here for you a few fixes; three, to be specific. Nothing that
warrants real discussion or urgency though.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit a1c4cd67840ef80f6ca5f73326fa9a6719303a95:

  net: fix __ip_mc_inc_group usage (2019-08-20 12:48:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-08-21

for you to fetch changes up to 0d31d4dbf38412f5b8b11b4511d07b840eebe8cb:

  Revert "cfg80211: fix processing world regdomain when non modular" (2019-08-21 10:43:03 +0200)

----------------------------------------------------------------
Just three fixes:
 * extended key ID key installation
 * regulatory processing
 * possible memory leak in an error path

----------------------------------------------------------------
Alexander Wetzel (1):
      cfg80211: Fix Extended Key ID key install checks

Hodaszi, Robert (1):
      Revert "cfg80211: fix processing world regdomain when non modular"

Johannes Berg (1):
      mac80211: fix possible sta leak

 net/mac80211/cfg.c  |  9 +++++----
 net/wireless/reg.c  |  2 +-
 net/wireless/util.c | 23 ++++++++++++++---------
 3 files changed, 20 insertions(+), 14 deletions(-)

