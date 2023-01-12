Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808B76670E3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjALL26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjALL1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:27:55 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520E42FF;
        Thu, 12 Jan 2023 03:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=r52aUji9bItkN+vBqhAtLLpbNeb98LoqNR+2KBUOzO8=; t=1673522388; x=1674731988; 
        b=jZ8bnbIMJ4W7ulGYOvPyvSME1q/MO+4zlsEVTQ7WPOalC0GFLODmuq4MqaHvS2ky9IGgXp/YpqY
        NgOduU2cBuWjtux6IKeRmsdQ7SBPgTZvLN9zicebjYyPMg6ftAP2iPhgZ9eNYA8ILyAN70ViULCQy
        jtQr+BZ9Rtt+b+Zf3pcQgSSFLv7MVdIIXaFYxbotAqNwSk6Ryo1+/WLUpvW2RTPIrgJJ3GEs9lEcv
        ophzitOZ/y0DXcyTi0ajVKJW2VbwnqvS1qgCkAancfKYK7PxIQM7MrnOkp7DaUCZc5pKHk5XMj/V6
        zuiNAZf35Lv+Hgm8dr5jekNaDsa6ozChrdyA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pFvcX-00H55D-1w;
        Thu, 12 Jan 2023 12:19:45 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2023-01-12
Date:   Thu, 12 Jan 2023 12:19:40 +0100
Message-Id: <20230112111941.82408-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here are some first (stack only) changes in wireless; given
holidays etc. things are a bit delayed, but it's not that
much here.

Note that I have a new signing subkey on my GPG key, you can
get the key info from keyservers or
https://johannes.sipsolutions.net/key.txt

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 7d6ceeb1875cc08dc3d1e558e191434d94840cd5:

  af_unix: selftest: Fix the size of the parameter to connect() (2023-01-09 08:16:13 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-01-12

for you to fetch changes up to f216033d770f7ca0eda491fe01a9f02e7af59576:

  wifi: mac80211: fix MLO + AP_VLAN check (2023-01-10 13:24:30 +0100)

----------------------------------------------------------------
Some fixes, stack only for now:
 * iTXQ conversion fixes, various bugs reported
 * properly reset multiple BSSID settings
 * fix for a link_sta crash
 * fix for AP VLAN checks
 * fix for MLO address translation

----------------------------------------------------------------
Alexander Wetzel (3):
      wifi: mac80211: Proper mark iTXQs for resumption
      wifi: mac80211: sdata can be NULL during AMPDU start
      wifi: mac80211: Fix iTXQ AMPDU fragmentation handling

Aloka Dixit (1):
      wifi: mac80211: reset multiple BSSID options in stop_ap()

Felix Fietkau (2):
      wifi: mac80211: fix initialization of rx->link and rx->link_sta
      wifi: mac80211: fix MLO + AP_VLAN check

Sriram R (1):
      mac80211: Fix MLO address translation for multiple bss case

 include/net/mac80211.h     |   4 -
 net/mac80211/agg-tx.c      |   8 +-
 net/mac80211/cfg.c         |   7 ++
 net/mac80211/debugfs_sta.c |   5 +-
 net/mac80211/driver-ops.c  |   3 +
 net/mac80211/driver-ops.h  |   2 +-
 net/mac80211/ht.c          |  31 ++++++
 net/mac80211/ieee80211_i.h |   2 +-
 net/mac80211/iface.c       |   4 +-
 net/mac80211/rx.c          | 229 ++++++++++++++++++++-------------------------
 net/mac80211/tx.c          |  34 +++----
 net/mac80211/util.c        |  42 +--------
 12 files changed, 178 insertions(+), 193 deletions(-)

