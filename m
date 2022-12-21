Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21846535DB
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiLUSIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLUSIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:08:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93C252A9;
        Wed, 21 Dec 2022 10:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85ED4B81BFA;
        Wed, 21 Dec 2022 18:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A8AC433EF;
        Wed, 21 Dec 2022 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671646089;
        bh=00bwSwJQjokpOlYiSXJU4FxiqgMm0sqr+wA00SCijUI=;
        h=From:Subject:To:Cc:Date:From;
        b=akG88HtdZhC8o5m7Xe05GUiAW6LK8il0F6WRGkKn7IE62ueFXwizr4YvdJ1GtzbZc
         iMvIR5lg74J83eYG/p7fKko99pKV3EQDpgaHwsEbzIHN7HDLhvhGj4eVCZFfuquV+6
         8+x93BMIyjM4qDGOjeYAoeLfnQcvaQox7qcPUIedZSNYEmevr0M1lGuYAUAUWzr7uw
         XCg6cE6uh2z3jse3sb0dyHth5/bf7S7YLkLaD7F6Op52Hklv8f/e/ZuRnd6V0hE5be
         8OI+V3WodKILG1uAt7dMgIVcmgdtvwvV2gSwMA6xUUq7ySH7LBE1pJveijChC7pB03
         qwyfspyaCJhmA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-12-21
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20221221180808.96A8AC433EF@smtp.kernel.org>
Date:   Wed, 21 Dec 2022 18:08:08 +0000 (UTC)
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

The following changes since commit 7ae9888d6e1ce4062d27367a28e46a26270a3e52:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2022-12-13 19:32:53 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-12-21

for you to fetch changes up to b7dc753fe33a707379e2254317794a4dad6c0fe2:

  wifi: ath9k: use proper statements in conditionals (2022-12-20 15:02:37 +0200)

----------------------------------------------------------------
wireless fixes for v6.2

First set of fixes for v6.2. Fix for a link error in mt76, fix for an
iwlwifi firmware crash and two cleanups.

----------------------------------------------------------------
Arnd Bergmann (2):
      wifi: mt76: mt7996: select CONFIG_RELAY
      wifi: ath9k: use proper statements in conditionals

Johannes Berg (1):
      wifi: iwlwifi: fw: skip PPAG for JF

Lukas Bulwahn (1):
      wifi: ti: remove obsolete lines in the Makefile

 drivers/net/wireless/ath/ath9k/htc.h              | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c      |  5 +++++
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig |  1 +
 drivers/net/wireless/ti/Makefile                  |  3 ---
 4 files changed, 13 insertions(+), 10 deletions(-)
