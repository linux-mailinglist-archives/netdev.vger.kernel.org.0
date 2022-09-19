Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1BB5BCA0B
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 12:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiISKys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 06:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiISKxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 06:53:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E586C62C2;
        Mon, 19 Sep 2022 03:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E804BB818FD;
        Mon, 19 Sep 2022 10:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAE7C433B5;
        Mon, 19 Sep 2022 10:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663584603;
        bh=we/uqACxvlSuH1F+o5KROZOH8HmfvuQkcL72+hdQo0g=;
        h=From:Subject:To:Cc:Date:From;
        b=ZNil+2UAKtRGWrmMlcJOwD33EMYCpQHLwNPQ5hEJqRXOtYYtSa1USXKhj+HJCxHcI
         Ei8BzqIT30y50K5mreJcO8vl0GY3jVV2sQITp8pDgi6zaR7uhE0L/bqQiBudSTJqe3
         A25tXvPnQGK9OqJ1L1776J7GjQCAkpfALaorL8jPG+yidqdjYIDuh2IKMBZ5GLSH6G
         6SMtGE+Pr8ncnUDTps2auD05YycdywFu3liaxJlpmkVlohgfhJchSzLFaXvWFUilKe
         mBKzoWLm39MgmQQUjcXm7xaXUkcpwZ916cGKgK0kOVhZ8QsrAUZoVgajqCe1cXRxSF
         rgwRCIqhvYobQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-09-19
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220919105003.1EAE7C433B5@smtp.kernel.org>
Date:   Mon, 19 Sep 2022 10:50:02 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The following changes since commit 2aec909912da55a6e469fd6ee8412080a5433ed2:

  wifi: use struct_group to copy addresses (2022-09-03 16:40:06 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-09-19

for you to fetch changes up to 781b80f452fcc1cfc16ee41f12556626a9ced049:

  wifi: mt76: fix 5 GHz connection regression on mt76x0/mt76x2 (2022-09-12 14:26:02 +0300)

----------------------------------------------------------------
wireless fixes for v6.0

Late stage fixes for v6.0. Temporarily mark iwlwifi's mei code broken
as it breaks suspend for iwd users and also don't spam nss trimming
messages. mt76 has fixes for aggregation sequence numbers and a
regression related to the VHT extended NSS BW feature.

----------------------------------------------------------------
Felix Fietkau (2):
      wifi: mt76: fix reading current per-tid starting sequence number for aggregation
      wifi: mt76: fix 5 GHz connection regression on mt76x0/mt76x2

Jason A. Donenfeld (1):
      wifi: iwlwifi: don't spam logs with NSS>2 messages

Toke Høiland-Jørgensen (1):
      wifi: iwlwifi: Mark IWLMEI as broken

 drivers/net/wireless/intel/iwlwifi/Kconfig        | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 drivers/net/wireless/mediatek/mt76/mac80211.c     | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c   | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)
