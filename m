Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDAD52379E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244552AbiEKPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiEKPpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDAFE52A8;
        Wed, 11 May 2022 08:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDA5B619FF;
        Wed, 11 May 2022 15:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A12C340EE;
        Wed, 11 May 2022 15:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652283936;
        bh=Wl6m78q9A+1NzTJSqbbz44DDdAKqmmGu2spKYC7SMlo=;
        h=From:Subject:To:Cc:Date:From;
        b=MSnOgAsAUDt70k3zGlv8KQowQTJjMIYLwxaUobdEqfHiskCBcPPOPG9chR88ang19
         3G4NpTZV9EMZTijdxmU79UDuINf6UPAk0KFrFnFdOaplC1gJp7ijjcBXwkLWITw+EX
         POw45TyUcwEM32mipXQW9AM6TMuk17j4qaL1pat41x8PV+WLQwY+i0gyAMWwm2NdKS
         6WpseribzU8eWUjRduHBgf+2FRz0impW0PMkcqdtCAYDHqYjprKD5smW1YWBwRZVKC
         g2JRi1dh7t40gb3rirO/kPoAcJtefd3Gr/Gxg5R8zcwIZ13jmhXkyzTpBLs4ZKYSHn
         TmnUYwSRm4EBw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-05-11
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220511154535.A1A12C340EE@smtp.kernel.org>
Date:   Wed, 11 May 2022 15:45:35 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The following changes since commit ef27324e2cb7bb24542d6cb2571740eefe6b00dc:

  nfc: nci: add flush_workqueue to prevent uaf (2022-04-13 14:44:44 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-05-11

for you to fetch changes up to a36e07dfe6ee71e209383ea9288cd8d1617e14f9:

  rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition (2022-05-09 14:00:07 +0200)

----------------------------------------------------------------
wireless fixes for v5.18

Second set of fixes for v5.18 and hopefully the last one. We have a
new iwlwifi maintainer, a fix to rfkill ioctl interface and important
fixes to both stack and two drivers.

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: fix rx reordering with non explicit / psmp ack policy

Gleb Fotengauer-Malinovskiy (1):
      rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition

Gregory Greenman (1):
      MAINTAINERS: update iwlwifi driver maintainer

Guenter Roeck (1):
      iwlwifi: iwl-dbg: Use del_timer_sync() before freeing

Johannes Berg (3):
      mac80211_hwsim: fix RCU protected chanctx access
      mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection
      nl80211: fix locking in nl80211_set_tx_bitrate_mask()

Kalle Valo (1):
      mailmap: update Kalle Valo's email

Kieran Frewen (2):
      nl80211: validate S1G channel width
      cfg80211: retrieve S1G operating channel number

Manikanta Pubbisetty (1):
      mac80211: Reset MBSSID parameters upon connection

Wen Gong (1):
      ath11k: reduce the wait time of 11d scan and hw scan while add interface

 .mailmap                                         |  1 +
 MAINTAINERS                                      |  2 +-
 drivers/net/wireless/ath/ath11k/core.c           |  1 +
 drivers/net/wireless/ath/ath11k/core.h           | 13 ++++-
 drivers/net/wireless/ath/ath11k/mac.c            | 71 ++++++++++--------------
 drivers/net/wireless/ath/ath11k/mac.h            |  2 +-
 drivers/net/wireless/ath/ath11k/reg.c            | 43 +++++++++-----
 drivers/net/wireless/ath/ath11k/reg.h            |  2 +-
 drivers/net/wireless/ath/ath11k/wmi.c            | 16 +++++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c |  2 +-
 drivers/net/wireless/mac80211_hwsim.c            | 10 +++-
 include/uapi/linux/rfkill.h                      |  2 +-
 net/mac80211/mlme.c                              |  6 ++
 net/mac80211/rx.c                                |  3 +-
 net/wireless/nl80211.c                           | 18 +++++-
 net/wireless/scan.c                              |  2 +-
 16 files changed, 120 insertions(+), 74 deletions(-)
