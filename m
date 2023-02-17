Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA0269B1A4
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBQROd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjBQROc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:14:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E7966046;
        Fri, 17 Feb 2023 09:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A0BE61EBC;
        Fri, 17 Feb 2023 17:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0691DC433D2;
        Fri, 17 Feb 2023 17:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676654070;
        bh=jT8MeMwhG6VwwtZN3LwaCpbMOU44smv1Bhr5ZcREpUQ=;
        h=From:Subject:To:Cc:Date:From;
        b=o5/usVLvbdUzM315ARFl/lTGx8eNmdWxZWqTni3Fq2lQTv88N+0m3Gm/3B+mDTnGZ
         ACxfpoWm25FYj/c3VcFXVQaugF0N0u3PmjYjzCD1F7BvpCuRoXyE76VkuqqJFFz1Xj
         ugz3FmvXdeg9I6OWy7Q+HrdwOfCLGzFU2vE0pHnsFy2p71P9YLoh0/mjW118cVPChn
         VQMaFZJWyNDqpeI4Igzd0xM8HfZ0CGh4ksPJ6I5h4nksDaKAdT0JpmWMSeMLulG57e
         Vubntiw+x0KS5FHwE+4Yo2rx6Bin0eSIbkzhLorCvyheAZtnw/rjja3M6dShxM7R7B
         KXaE0pX+qpO1w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2023-02-17
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20230217171430.0691DC433D2@smtp.kernel.org>
Date:   Fri, 17 Feb 2023 17:14:29 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 84cb1b53cdbad52642571e31a8aee301206d2043:

  Merge branch 'mlx5-next' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux (2023-02-16 11:36:14 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-02-17

for you to fetch changes up to 38ae3192296924181537544e7cfc43ca78eadcda:

  wifi: rtl8xxxu: add LEDS_CLASS dependency (2023-02-17 18:30:44 +0200)

----------------------------------------------------------------
wireless-next patches for v6.3

Third set of patches for v6.3. This time only a set of small fixes
submitted during the last day or two.

----------------------------------------------------------------
Arnd Bergmann (1):
      wifi: rtl8xxxu: add LEDS_CLASS dependency

Johannes Berg (2):
      wifi: iwlwifi: mvm: remove unused iwl_dbgfs_is_match()
      wifi: iwlegacy: avoid fortify warning

Ping-Ke Shih (1):
      wifi: rtw88: use RTW_FLAG_POWERON flag to prevent to power on/off twice

Po-Hao Huang (1):
      wifi: rtw89: fix AP mode authentication transmission failed

 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  7 ----
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |  1 +
 drivers/net/wireless/realtek/rtw88/coex.c          |  2 +-
 drivers/net/wireless/realtek/rtw88/mac.c           | 10 +++++
 drivers/net/wireless/realtek/rtw88/main.h          |  2 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |  4 +-
 drivers/net/wireless/realtek/rtw88/wow.c           |  2 +-
 drivers/net/wireless/realtek/rtw89/core.c          | 47 ++++++++++++----------
 9 files changed, 43 insertions(+), 34 deletions(-)
