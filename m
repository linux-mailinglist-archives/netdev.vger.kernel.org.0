Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1716D5FD795
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 12:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJMKFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 06:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJMKFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 06:05:30 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA28B40EA;
        Thu, 13 Oct 2022 03:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=MIv4m4vQ4qvNV4Hb3bgm4q2zBlksVMHOhzFO9UdQ9rs=; t=1665655529; x=1666865129; 
        b=Blf1jDnD5T1ApDR6KT5Ke4X3wQ0RGyXTMlCxM/bblXMFYc/soTyx885ypsH8ppk7/VlxkR7FNnY
        UmAgaR6cDm1Irq5W5N90Cu0zM8FPqNCjGA69m9EoBT6W/UZbGmo1arYywLDmFS9M5BVNeBOam7qdZ
        n/TvDmQXSs/R9E6W5JLeXGS/sfPY/u+SeXeXOU6iRxUWBtIL7uL2oHqoPU9BZ14I7Olis5Nz4kuF0
        llAY8WbTMirDekTQGicynvqtObcCgQ8uwQkdzlK/9sjLJhqvBNMrZJgkxCjG7Guv0Nh+u3+g48Cg2
        ziba9wl69oclZmUD+9YVT1LaVRu4uCmfBGlA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oiv5i-005e80-1q;
        Thu, 13 Oct 2022 12:05:26 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2022-10-13
Date:   Thu, 13 Oct 2022 12:04:51 +0200
Message-Id: <20221013100522.46346-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
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

So as discussed previously, here are the fixes for the
scan parsing issues. I had to create a merge commit to
keep the stable commit IDs that we'd already used for
communication.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit abf93f369419249ca482a8911039fe1c75a94227:

  wifi: ath11k: mac: fix reading 16 bytes from a region of size 0 warning (2022-10-11 11:46:31 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-10-13

for you to fetch changes up to e7ad651c31c5e1289323e6c680be6e582a593b26:

  Merge branch 'cve-fixes-2022-10-13' (2022-10-13 11:59:56 +0200)

----------------------------------------------------------------
More wireless fixes for 6.1

This has only the fixes for the scan parsing issues.

----------------------------------------------------------------
Johannes Berg (10):
      wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
      wifi: cfg80211/mac80211: reject bad MBSSID elements
      wifi: mac80211: fix MBSSID parsing use-after-free
      wifi: cfg80211: ensure length byte is present before access
      wifi: cfg80211: fix BSS refcounting bugs
      wifi: cfg80211: avoid nontransmitted BSS list corruption
      wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
      wifi: mac80211: fix crash in beacon protection for P2P-device
      wifi: cfg80211: update hidden BSSes to avoid WARN_ON
      Merge branch 'cve-fixes-2022-10-13'

 Documentation/networking/phy.rst                   |  2 +-
 MAINTAINERS                                        |  1 +
 drivers/isdn/hardware/mISDN/hfcpci.c               |  3 +-
 drivers/net/ethernet/adi/adin1110.c                | 13 ++--
 drivers/net/ethernet/broadcom/Makefile             |  5 --
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  1 -
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |  4 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |  7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  4 +-
 .../ethernet/marvell/prestera/prestera_matchall.c  |  2 +
 drivers/net/ethernet/mediatek/Makefile             |  5 --
 drivers/net/hyperv/hyperv_net.h                    |  3 +-
 drivers/net/hyperv/netvsc.c                        |  4 ++
 drivers/net/hyperv/netvsc_drv.c                    | 19 ++++++
 drivers/net/macvlan.c                              |  2 +-
 drivers/net/pse-pd/Kconfig                         |  1 +
 drivers/net/wireless/mac80211_hwsim.c              |  2 +
 drivers/ptp/ptp_ocp.c                              |  1 +
 include/net/ieee802154_netdev.h                    | 12 +++-
 net/dsa/port.c                                     |  2 +-
 net/ieee802154/socket.c                            |  7 +-
 net/ipv4/fib_semantics.c                           |  8 +--
 net/mac80211/ieee80211_i.h                         |  8 +++
 net/mac80211/rx.c                                  | 12 ++--
 net/mac80211/util.c                                | 30 +++++----
 net/sched/sch_taprio.c                             |  8 +--
 net/wireless/scan.c                                | 77 ++++++++++++++--------
 tools/testing/selftests/net/fib_nexthops.sh        |  5 ++
 28 files changed, 160 insertions(+), 88 deletions(-)

