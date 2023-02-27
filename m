Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3E6A424D
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjB0NK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjB0NK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:10:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51649E04D;
        Mon, 27 Feb 2023 05:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E78FA60DFF;
        Mon, 27 Feb 2023 13:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD779C433D2;
        Mon, 27 Feb 2023 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677503454;
        bh=n157J+FX9Vk7oC3RGoXa72XZGmKXav1KHQAzqkqB9s4=;
        h=From:Subject:To:Cc:Date:From;
        b=GLV07VtPtN8aSBffaWUbusPqV52Uw2/Lms1Qj/Hw07W5ihdr4h8WcytpAea1auHzB
         GGltYFcyuKRpebh6dVejmTDsFQD8QhQTj9JIcLEm/e5W2yXWqXlzEHi68JPoImEhj7
         pqlnMSDDCqUbglPbV9G7gkHvCQxIMDpXfpilts079nZyYLGdwMe/oFCsk86J0p6J61
         LubI+BLJvaRpmsCjQaAq9bpVORXQiVWFZQ/0pPs0sn434rUC4nwc3ahjwRg72SqUVh
         hxQBjC2FSAHdFKUGxfA+o9zOawA/nI/m9IiexOEtsUpgF54XnBB811RseuJA1rD2XI
         EcK7rnXHUxlZQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2023-02-27
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20230227131053.BD779C433D2@smtp.kernel.org>
Date:   Mon, 27 Feb 2023 13:10:53 +0000 (UTC)
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

The following changes since commit 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2:

  Merge tag 'net-next-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2023-02-21 18:24:12 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-02-27

for you to fetch changes up to 52fd90638a7269be2a6f6cf1e4dea6724f8e13b6:

  wifi: wext: warn about usage only once (2023-02-26 19:53:35 +0200)

----------------------------------------------------------------
wireless fixes for v6.3

First set of fixes for v6.3. We have only three oneliners. The most
important one is the patch reducing warnings about the Wireless
Extensions usage, reported by Linus.

----------------------------------------------------------------
Johannes Berg (1):
      wifi: wext: warn about usage only once

Len Brown (1):
      wifi: ath11k: allow system suspend to survive ath11k

Lorenzo Bianconi (1):
      wifi: mt76: usb: fix use-after-free in mt76u_free_rx_queue

 drivers/net/wireless/ath/ath11k/pci.c    | 2 +-
 drivers/net/wireless/mediatek/mt76/usb.c | 1 +
 net/wireless/wext-core.c                 | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)
