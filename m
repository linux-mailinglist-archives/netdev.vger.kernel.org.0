Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B0D58DC69
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244934AbiHIQsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244667AbiHIQr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA1122B1D;
        Tue,  9 Aug 2022 09:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFC0460BC2;
        Tue,  9 Aug 2022 16:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DAEC433D6;
        Tue,  9 Aug 2022 16:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660063677;
        bh=c+XSJnYZA1fHMjlcjE0Mxg1cES3z+ecaRGAsvCxauxY=;
        h=From:Subject:To:Cc:Date:From;
        b=jTNjdpH8+KkWe+/+rOSosPRehxdoYEDTuTYA14bmKlnccnA8uhietqVR6ig/FAxu0
         0Xy/UAZg1K8TrdA1eLZQKKccf49H12u9PHP+ehs2eVIJ1U9eI9bPSFEKw4pnkNCAkH
         e8XSPGTXxxkODhQsqdViQx8hDfQUE7XxwpdpNDF4q9198UNzViTQ1euZae5KQzi+d6
         ZhJW0x1Ig9WRq64op6a1O7lwN8h9z8MgppFTLZ9dY7FIbbkAUuj8OsILQPtSiyIDvv
         wszE4vgwqQZ/AgPgaD7SdZ6BCv5xIJNs0XYRhxJLJPFg6BGxhSdRtmxD4+nA6xFYC8
         sDCzPRiMougQQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-08-09
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220809164756.B1DAEC433D6@smtp.kernel.org>
Date:   Tue,  9 Aug 2022 16:47:56 +0000 (UTC)
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

The following changes since commit ac0dbed9ba4c38ed9b5fd3a43ee4bc1f48901a34:

  net: seg6: initialize induction variable to first valid array index (2022-08-05 19:34:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-08-09

for you to fetch changes up to f01272ee3856e62e8a0f8211e8edf1876a6f5e38:

  wifi: wilc1000: fix spurious inline in wilc_handle_disconnect() (2022-08-08 11:11:04 +0300)

----------------------------------------------------------------
wireless fixes for v6.0

First set of fixes for v6.0. Small one this time, fix a cfg80211
warning seen with brcmfmac and remove an unncessary inline keyword
from wilc1000.

----------------------------------------------------------------
Kalle Valo (1):
      wifi: wilc1000: fix spurious inline in wilc_handle_disconnect()

Veerendranath Jakkam (1):
      wifi: cfg80211: Fix validating BSS pointers in __cfg80211_connect_result

 drivers/net/wireless/microchip/wilc1000/hif.c | 2 +-
 drivers/net/wireless/microchip/wilc1000/hif.h | 3 ++-
 net/wireless/sme.c                            | 8 +++++---
 3 files changed, 8 insertions(+), 5 deletions(-)
