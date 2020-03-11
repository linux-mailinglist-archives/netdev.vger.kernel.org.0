Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5A91814B1
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 10:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgCKJX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 05:23:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45512 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgCKJX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 05:23:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jBx7r-000qTG-Hm; Wed, 11 Mar 2020 09:54:03 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-03-11
Date:   Wed, 11 Mar 2020 09:53:54 +0100
Message-Id: <20200311085355.8235-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

I have a few fixes still; please pull and let me know
if there's any problem.

Thanks,
johannes



The following changes since commit 2165fdf4bc2d323ec73e5995510f163163ce0fa4:

  Merge branch 's390-qeth-fixes' (2020-03-10 16:07:49 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-03-11

for you to fetch changes up to ba32679cac50c38fdf488296f96b1f3175532b8e:

  mac80211: Do not send mesh HWMP PREQ if HWMP is disabled (2020-03-11 09:04:14 +0100)

----------------------------------------------------------------
A couple of fixes:
 * three netlink validation fixes
 * a mesh path selection fix

----------------------------------------------------------------
Jakub Kicinski (3):
      nl80211: add missing attribute validation for critical protocol indication
      nl80211: add missing attribute validation for beacon report scanning
      nl80211: add missing attribute validation for channel switch

Nicolas Cavallari (1):
      mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

 net/mac80211/mesh_hwmp.c | 3 ++-
 net/wireless/nl80211.c   | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

