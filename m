Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80392A1E2C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfH2PAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:00:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37892 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfH2PAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 11:00:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i3LuO-0002s2-4f; Thu, 29 Aug 2019 17:00:20 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-08-29
Date:   Thu, 29 Aug 2019 17:00:10 +0200
Message-Id: <20190829150011.10512-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

We have just three more fixes now, and one of those is a driver fix
because Kalle is on vacation and I'm covering for him in the meantime.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 189308d5823a089b56e2299cd96589507dac7319:

  sky2: Disable MSI on yet another ASUS boards (P6Xxxx) (2019-08-28 16:09:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-08-29

for you to fetch changes up to f8b43c5cf4b62a19f2210a0f5367b84e1eff1ab9:

  mac80211: Correctly set noencrypt for PAE frames (2019-08-29 16:40:00 +0200)

----------------------------------------------------------------
We have
 * one fix for a driver as I'm covering for Kalle while he's on vacation
 * two fixes for eapol-over-nl80211 work

----------------------------------------------------------------
Denis Kenzior (2):
      mac80211: Don't memset RXCB prior to PAE intercept
      mac80211: Correctly set noencrypt for PAE frames

Luca Coelho (1):
      iwlwifi: pcie: handle switching killer Qu B0 NICs to C0

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  | 24 ++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  4 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  7 +------
 net/mac80211/rx.c                               |  6 +++---
 5 files changed, 34 insertions(+), 9 deletions(-)

