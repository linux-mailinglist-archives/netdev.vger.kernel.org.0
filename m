Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6844FEFF4
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiDMGlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiDMGlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5884650075;
        Tue, 12 Apr 2022 23:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E887F61CFC;
        Wed, 13 Apr 2022 06:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EE4C385A3;
        Wed, 13 Apr 2022 06:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649831930;
        bh=G7/WJoWD9FfHoh4X7HlXVQoamqq7l9XUV19pw+KNsSI=;
        h=From:Subject:To:Cc:Date:From;
        b=f3GbY+whWmrOYbP5T8ldGzwehXMkDFlvnddBCmNoSye1yqi5n5tFkWvyYdE3j4oqh
         J9e7v8wRXfd+uPBo/CYSXZHaMNQW19bD9+/pZO/xRBeaOIeqbwAbja7I6UyF3qrG2o
         A4Ytn8lNzMQEX0vV6Ghw3ajcDP6Kc5cgT8YPigqGkeO4Pzcz08DeRRa++V3eBPCMAq
         E3mRSBj0ueiLgcM6YsiDnMiSh/GYSKK+wWXgO/n0IyHGbGiJuy+yDJ90pJ3hJ8Msxh
         L/IhLfLKo+Zz6A8eS6sn2YbJgsk2BnOhSJo0HzR6NqvPGtHuzQAvn+uZCC9zQuKFUQ
         fSc8k8ZU6ONfQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-04-13
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220413063849.C1EE4C385A3@smtp.kernel.org>
Date:   Wed, 13 Apr 2022 06:38:49 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit a81687886ca9a64c0aeefefcbc6e7a64ce083ab0:

  Merge branch 'vsock-virtio-enable-vqs-early-on-probe-and-finish-the-setup-before-using-them' (2022-03-24 18:36:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-04-13

for you to fetch changes up to fb4bccd863ccccd36ad000601856609e259a1859:

  mac80211: fix ht_capa printout in debugfs (2022-04-11 11:57:27 +0200)

----------------------------------------------------------------
wireless fixes for v5.18

First set of fixes for v5.18. Maintainers file updates, two
compilation warning fixes, one revert for ath11k and smaller fixes to
drivers and stack. All the usual stuff.

----------------------------------------------------------------
Anilkumar Kolli (1):
      Revert "ath11k: mesh: add support for 256 bitmap in blockack frames in 11ax"

Ben Greear (1):
      mac80211: fix ht_capa printout in debugfs

Borislav Petkov (2):
      mt76: Fix undefined behavior due to shift overflowing the constant
      brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

Johannes Berg (2):
      MAINTAINERS: claim include/uapi/linux/wireless.h
      nl80211: correctly check NL80211_ATTR_REG_ALPHA2 size

Kalle Valo (1):
      MAINTAINERS: mark wil6210 as orphan

Lorenzo Bianconi (1):
      MAINTAINERS: update Lorenzo's email address

Rameshkumar Sundaram (1):
      cfg80211: hold bss_lock while updating nontrans_list

Toke Høiland-Jørgensen (2):
      ath9k: Properly clear TX status area before reporting to mac80211
      ath9k: Fix usage of driver-private space in tx_info

 MAINTAINERS                                        |  7 ++---
 drivers/net/wireless/ath/ath11k/mac.c              | 22 +++++++++------
 drivers/net/wireless/ath/ath9k/main.c              |  2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              | 33 ++++++++++++++--------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |  2 +-
 net/mac80211/debugfs_sta.c                         |  2 +-
 net/wireless/nl80211.c                             |  3 +-
 net/wireless/scan.c                                |  2 ++
 9 files changed, 46 insertions(+), 29 deletions(-)
