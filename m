Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059AA2872A4
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgJHKju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729469AbgJHKjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 06:39:49 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF42C061755;
        Thu,  8 Oct 2020 03:39:49 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQTKs-001Xgb-MG; Thu, 08 Oct 2020 12:39:46 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-10-08
Date:   Thu,  8 Oct 2020 12:39:34 +0200
Message-Id: <20201008103935.43636-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Not sure you were still planning to send anything to Linus,
but even if not this single fix seemed appropriate for net.
Seems to be a long-standing issue.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit d91dc434f2baa592e9793597421231174d57bbbf:

  Merge tag 'rxrpc-fixes-20201005' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs (2020-10-06 06:18:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-10-08

for you to fetch changes up to 3dc289f8f139997f4e9d3cfccf8738f20d23e47b:

  net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key() (2020-10-08 12:37:25 +0200)

----------------------------------------------------------------
A single fix for missing input validation in nl80211.

----------------------------------------------------------------
Anant Thazhemadam (1):
      net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()

 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

