Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75066617D17
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 13:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKCMxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 08:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiKCMxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 08:53:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6411114A;
        Thu,  3 Nov 2022 05:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFBDDB82794;
        Thu,  3 Nov 2022 12:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E57C433C1;
        Thu,  3 Nov 2022 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667479995;
        bh=kGkvPP1Oiw9lyfhEG8t/I1qotsbLvKyyALEQlCZqTuk=;
        h=From:Subject:To:Cc:Date:From;
        b=deiNDLE6mvtPNgRIvdy3cOobzhUoOz1UFWgqGsQrJ3QNrrJSTft1Y47QBIkmm9IJI
         4VeowszWxVPuNdpWmX4Wwtnkh9xzw85JrXX+6cyfHdNN6/++YZmTSgjfczi+b26Uj7
         tliMpxRci/MS2q+TERiknenO2nuNu6tEyeyrB4LZmi+JyQfGiyLQ3xLrTjaGcr3uuQ
         AIdryw31XU1nEkFj1sj4iRpXTDNJ4lH/NpMlEg1l+kwdhNzm9wn7zJzTuiNljhQAQR
         nmHraE29vci4JPWHcX5dL6uJpE9JDfC1e14j6FzKtK1fIidKYGYQi6KIfvx8dREeOJ
         Se8WMigitJ/uQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-11-03
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20221103125315.04E57C433C1@smtp.kernel.org>
Date:   Thu,  3 Nov 2022 12:53:14 +0000 (UTC)
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 6d36c728bc2e2d632f4b0dea00df5532e20dfdab:

  Merge tag 'net-6.1-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-10-20 17:24:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-11-03

for you to fetch changes up to f45cb6b29cd36514e13f7519770873d8c0457008:

  wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update() (2022-11-02 19:16:45 +0200)

----------------------------------------------------------------
wireless fixes for v6.1

Second set of fixes for v6.1. Some fixes to char type usage in
drivers, memory leaks in the stack and also functionality fixes. The
rt2x00 char type fix is a larger (but still simple) commit, otherwise
the fixes are small in size.

----------------------------------------------------------------
Arend van Spriel (1):
      wifi: cfg80211: fix memory leak in query_regdb_file()

Dokyung Song (1):
      wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Howard Hsu (1):
      wifi: mac80211: Set TWT Information Frame Disabled bit as 1

Jason A. Donenfeld (2):
      wifi: rt2x00: use explicitly signed or unsigned types
      wifi: airo: do not assign -1 to unsigned char

Johannes Berg (1):
      wifi: cfg80211: silence a sparse RCU warning

Jonas Jelonek (1):
      wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support

Nicolas Cavallari (1):
      wifi: mac80211: Fix ack frame idr leak when mesh has no route

Paul Zhang (1):
      wifi: cfg80211: Fix bitrates overflow issue

Tyler J. Stachecki (1):
      wifi: ath11k: Fix QCN9074 firmware boot on x86

Wen Gong (1):
      wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()

Zhengchao Shao (1):
      wifi: mac80211: fix general-protection-fault in ieee80211_subif_start_xmit()

taozhang (1):
      wifi: mac80211: fix memory free error when registering wiphy fail

 drivers/net/wireless/ath/ath11k/qmi.h              |  2 +-
 drivers/net/wireless/ath/ath11k/reg.c              |  6 +--
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  4 ++
 drivers/net/wireless/cisco/airo.c                  | 18 +++++--
 drivers/net/wireless/mac80211_hwsim.c              |  5 ++
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |  8 +--
 drivers/net/wireless/ralink/rt2x00/rt2400pci.h     |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |  8 +--
 drivers/net/wireless/ralink/rt2x00/rt2500pci.h     |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |  8 +--
 drivers/net/wireless/ralink/rt2x00/rt2500usb.h     |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     | 60 +++++++++++-----------
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |  8 +--
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |  6 +--
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.h       |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.h       |  2 +-
 net/mac80211/main.c                                |  8 ++-
 net/mac80211/mesh_pathtbl.c                        |  2 +-
 net/mac80211/s1g.c                                 |  3 ++
 net/mac80211/tx.c                                  |  5 ++
 net/wireless/reg.c                                 | 12 +++--
 net/wireless/scan.c                                |  4 +-
 net/wireless/util.c                                |  6 ++-
 25 files changed, 114 insertions(+), 77 deletions(-)
