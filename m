Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3BB572EDF
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiGMHNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiGMHNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:13:42 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B711163;
        Wed, 13 Jul 2022 00:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=9pIcFcBJ2kqaxG/2C64Os3L7Qwb6VJENhcuLxSwGJQE=; t=1657696422; x=1658906022; 
        b=FLx3lu1ULPMQRfiu4PAjK0j7nOdG5y5MHoOr38plvbUaN8gaQesQ3ZkuCZlVq1BOVhY5L2q7ZsM
        8TZ6gxgGXKawdouRZLSy9FW+/Fy3da93QB8OhFL3ms6ngIW4IJFzPsV/kJC7g1zqT/+k1f/egm+ZO
        2/wNwuKMnAbH+vOUO74TenYKrVFu34ymtl9LdYdAaNKdMBc6xH4WFlYF35Lw0xbHgIvb//bu/83EF
        dtjFu4T6zyaa+VQ5wTKu7ZDr330VhUrFK/NcNjBmDBhuluZC5vSnTTw3MwiXKKUfVoZ6FgNaSYTqR
        2Q+yv1cHdQGWrc6rr/gW2F8kBW3lPPWxzo/w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBWZ2-00EbSx-6r;
        Wed, 13 Jul 2022 09:13:40 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2022-07-13
Date:   Wed, 13 Jul 2022 09:13:32 +0200
Message-Id: <20220713071333.19713-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's a small set of fixes for the current cycle, see the
description in the tag below.

No known conflicts.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit bf56a0917fd329d5adecfd405e681ff7ba1abb52:

  Merge tag 'mlx5-fixes-2022-06-08' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2022-06-09 22:05:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-07-13

for you to fetch changes up to 50e2ab39291947b6c6c7025cf01707c270fcde59:

  wifi: mac80211: fix queue selection for mesh/OCB interfaces (2022-07-11 10:36:55 +0200)

----------------------------------------------------------------
A small set of fixes for
 * queue selection in mesh/ocb
 * queue handling on interface stop
 * hwsim virtio device vs. some other virtio changes
 * dt-bindings email addresses
 * color collision memory allocation
 * a const variable in rtw88
 * shared SKB transmit in the ethernet format path
 * P2P client port authorization

----------------------------------------------------------------
Felix Fietkau (2):
      wifi: mac80211: do not wake queues on a vif that is being stopped
      wifi: mac80211: fix queue selection for mesh/OCB interfaces

Johannes Berg (1):
      wifi: mac80211_hwsim: set virtio device ready in probe()

Kalle Valo (2):
      dt-bindings: net: wireless: ath9k: Change Toke as maintainer
      dt-bindings: net: wireless: ath11k: change Kalle's email

Lorenzo Bianconi (1):
      wifi: mac80211: add gfp_t parameter to ieeee80211_obss_color_collision_notify

Ping-Ke Shih (1):
      rtw88: 8821c: fix access const table of channel parameters

Ryder Lee (1):
      wifi: mac80211: check skb_shared in ieee80211_8023_xmit()

Vinayak Yadawad (1):
      wifi: cfg80211: Allow P2P client interface to indicate port authorization

 .../bindings/net/wireless/qca,ath9k.yaml           |  2 +-
 .../bindings/net/wireless/qcom,ath11k.yaml         |  2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  2 ++
 drivers/net/wireless/realtek/rtw88/main.h          |  6 ++--
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      | 14 +++++----
 include/net/cfg80211.h                             |  5 +--
 include/net/mac80211.h                             |  3 +-
 net/mac80211/cfg.c                                 |  4 +--
 net/mac80211/iface.c                               |  2 ++
 net/mac80211/rx.c                                  |  3 +-
 net/mac80211/tx.c                                  | 36 ++++++++--------------
 net/mac80211/util.c                                |  3 ++
 net/mac80211/wme.c                                 |  4 +--
 net/wireless/sme.c                                 |  3 +-
 15 files changed, 48 insertions(+), 44 deletions(-)

