Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E284C3F2A55
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 12:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239103AbhHTKyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 06:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbhHTKyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 06:54:15 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CCAC061756;
        Fri, 20 Aug 2021 03:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=crQ+UKajYqeRHWVOrLPqjerJ5dx5gK1qFrVXZ7KNiZA=; t=1629456817; x=1630666417; 
        b=n63Um6DNEKpZGOUQAG3Cxj6Ic5TVYfQIvhP7Q+Peg4eN6Bw/sG1wKbUGZkxQyoE0YTlsOghMrLf
        m4O+uyl6uxIrs0Rz1FebqsZ1a/t2fZtlM1XipFnYGCqCBcrnwHM/kIxHuOKbGkTa38ZoUYtT1P1Bh
        GkWxuVKtWrybAX4nji4AztRwEsW4+oYS296GfSec+aIqvhUi3Pzvqyc7/MG9HGSBCVQyJKwneQ9JS
        0PBVGrZptSL/YDn/juoNJZKpPyoi3Cpgk0VjjemTE2qadxIvM6tShCWt84UH3OYCCMP/PKh7b5K72
        kY4geNcgXfOLwE9heX9ZK7ism5m/LXuBaWYQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mH29W-00DYph-Lz; Fri, 20 Aug 2021 12:53:34 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2021-08-20
Date:   Fri, 20 Aug 2021 12:53:28 +0200
Message-Id: <20210820105329.48674-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Just a couple of smallish items, in case we get a release.
I expect a few resends of other things, but don't know if
they'll make it, we'll see.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit b769cf44ed55f4b277b89cf53df6092f0c9082d0:

  dt-bindings: net: qcom,ipa: make imem interconnect optional (2021-08-12 14:53:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2021-08-20

for you to fetch changes up to c448f0fd2ce59947b3b8b8d6b56e15036449d1f1:

  cfg80211: fix BSS color notify trace enum confusion (2021-08-18 09:21:52 +0200)

----------------------------------------------------------------
Minor updates:
 * BSS coloring support
 * MEI commands for Intel platforms
 * various fixes/cleanups

----------------------------------------------------------------
Chih-Kang Chang (1):
      mac80211: Fix insufficient headroom issue for AMSDU

Dan Carpenter (1):
      mac80211: remove unnecessary NULL check in ieee80211_register_hw()

Emmanuel Grumbach (1):
      nl80211: vendor-cmd: add Intel vendor commands for iwlmei usage

Johan Almbladh (1):
      mac80211: Fix monitor MTU limit so that A-MSDUs get through

Johannes Berg (2):
      mac80211: include <linux/rbtree.h>
      cfg80211: fix BSS color notify trace enum confusion

John Crispin (2):
      nl80211: add support for BSS coloring
      mac80211: add support for BSS color change

Kees Cook (2):
      mac80211: radiotap: Use BIT() instead of shifts
      mac80211: Use flex-array for radiotap header bitmap

YueHaibing (1):
      mac80211: Reject zero MAC address in sta_info_insert_check()

dingsenjie (1):
      mac80211: Remove unnecessary variable and label

 include/net/cfg80211.h                 |  92 +++++++++++++
 include/net/ieee80211_radiotap.h       |   5 +
 include/net/mac80211.h                 |  29 ++++
 include/uapi/linux/nl80211-vnd-intel.h |  77 +++++++++++
 include/uapi/linux/nl80211.h           |  43 ++++++
 net/mac80211/cfg.c                     | 234 +++++++++++++++++++++++++++++++--
 net/mac80211/ibss.c                    |  15 +--
 net/mac80211/ieee80211_i.h             |  12 ++
 net/mac80211/iface.c                   |  13 +-
 net/mac80211/main.c                    |   2 +-
 net/mac80211/rx.c                      |  29 ++--
 net/mac80211/sta_info.c                |   2 +-
 net/mac80211/status.c                  |  16 +--
 net/mac80211/tx.c                      |  33 +++--
 net/wireless/nl80211.c                 | 157 ++++++++++++++++++++++
 net/wireless/radiotap.c                |   9 +-
 net/wireless/rdev-ops.h                |  13 ++
 net/wireless/trace.h                   |  46 +++++++
 18 files changed, 764 insertions(+), 63 deletions(-)
 create mode 100644 include/uapi/linux/nl80211-vnd-intel.h

