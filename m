Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77B04DB048
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 14:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353451AbiCPNEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 09:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiCPNEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 09:04:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3604E26DA;
        Wed, 16 Mar 2022 06:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9F25B81B08;
        Wed, 16 Mar 2022 13:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5225C340EC;
        Wed, 16 Mar 2022 13:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647435770;
        bh=ZixeMbzxdzsZE9YpFw4GHmxKpWmfB1BaLSHZ+JRI9Lk=;
        h=From:Subject:To:Cc:Date:From;
        b=cpal63IHdeVkyRGUajQquzp2W/dzddvbVOsc17ncpxAu9+IA13cWczS86NDooOrt+
         sxENFimA47WLqC05i36Qj1DjpuP3lqY+MnDf4LX1GyZZ8Lx0Ao98VoSqWwcTBFLv5a
         pQ+ly5rWY2Lc9kblTb7nB+VSo9VcPQMIy2I6SsRCyImQMNt21Dco8thDrRCMBtVofq
         IyLYlhGcAHpYof8bEmjqd8bgt6PNJFm+2/5JGFKjBn9/MYHQ2S9JazkcdRG625y3RF
         ezinT6B/k7BiGe489nvaIk7478jZ41AJCtq1J7s2Jzei3hHqviMyBPjQwX0WWmP3Pg
         GpBzyUeMpbanw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-03-16
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220316130249.B5225C340EC@smtp.kernel.org>
Date:   Wed, 16 Mar 2022 13:02:49 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The following changes since commit e6e91ec966db5af4f059cfbac1af06560404b317:

  iwlwifi: mvm: return value for request_ownership (2022-03-02 22:37:25 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-03-16

for you to fetch changes up to 45b4eb7ee6aa1a55a50831b328aa5f46ac3a7187:

  Revert "ath10k: drop beacon and probe response which leak from other channel" (2022-03-16 13:34:52 +0200)

----------------------------------------------------------------
wireless fixes for v5.17

Third set of fixes for v5.17. We have only one revert to fix an ath10k
regression.

----------------------------------------------------------------
Kalle Valo (1):
      Revert "ath10k: drop beacon and probe response which leak from other channel"

 drivers/net/wireless/ath/ath10k/wmi.c | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)
