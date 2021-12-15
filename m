Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD3C475A8A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhLOOSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:18:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50136 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbhLOOSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:18:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B937EB81F2A;
        Wed, 15 Dec 2021 14:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040D3C34604;
        Wed, 15 Dec 2021 14:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639577932;
        bh=frgeiBv6eu/KdNqtU+zCsKIIyZPfVonzlLQXT5ztlHI=;
        h=From:Subject:To:Cc:Date:From;
        b=GNA5Wnmq3PqzPsIMW1MZiBz9gl1kvuXTPojBgvYs9jSWZdOY4oOdYma6W6fBt0ZS9
         QZOVCwaKFyVjBJGd3w8SZBicYj2nGFlHvcyzSB/A4zpvY/cdEmgWPU9rR+kyZxyiZN
         Y9XBvDB1gDu6tBNUJX03M2Uyik/TcjDuueSNhCg7IPfvezZhK6011R9ljJL+6WLdJ6
         g5J86dmMhn41eG+Jb9bVPl7sHEMhTv0F+IxdW0lkAWYcEyM+sL3vtWBBpxmjfMg5jz
         /mr6Zt49yYdH3J8PytCZoew96OV5H5F0mGnwtnGJHBk0yE9VlHiAI+xXQ/iTn1lrJp
         Eem1F9w8gBYUQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-drivers-2021-12-15
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211215141852.040D3C34604@smtp.kernel.org>
Date:   Wed, 15 Dec 2021 14:18:51 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 191587cd1a5f36852a0fc32cff2d5bc7680551db:

  mt76: fix key pointer overwrite in mt7921s_write_txwi/mt7663_usb_sdio_write_txwi (2021-11-29 19:33:33 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-12-15

for you to fetch changes up to f7d55d2e439fa4430755d69a5d7ad16d43a5ebe6:

  mt76: mt7921: fix build regression (2021-12-08 20:17:07 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.16

Second set of fixes for v5.16, hopefully also the last one. I changed
my email in MAINTAINERS, one crash fix in iwlwifi and some build
problems fixed.

iwlwifi

* fix crash caused by a warning

* fix LED linking problem

brcmsmac

* rework LED dependencies for being consistent with other drivers

mt76

* mt7921: fix build regression

----------------------------------------------------------------
Arnd Bergmann (3):
      iwlwifi: fix LED dependencies
      brcmsmac: rework LED dependencies
      mt76: mt7921: fix build regression

Johannes Berg (1):
      iwlwifi: mvm: don't crash on invalid rate w/o STA

Kalle Valo (1):
      MAINTAINERS: update Kalle Valo's email

 MAINTAINERS                                               | 12 ++++++------
 drivers/net/wireless/broadcom/brcm80211/Kconfig           | 14 +++++++++-----
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile |  2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/led.h    |  2 +-
 drivers/net/wireless/intel/iwlegacy/Kconfig               |  4 ++--
 drivers/net/wireless/intel/iwlwifi/Kconfig                |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c               |  5 +++--
 drivers/net/wireless/mediatek/mt76/Makefile               |  2 +-
 8 files changed, 24 insertions(+), 19 deletions(-)
