Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD60240B878
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 21:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhINUAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 16:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhINUAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 16:00:40 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D31C061574;
        Tue, 14 Sep 2021 12:59:22 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4H8Dh84WKlzQjgH;
        Tue, 14 Sep 2021 21:59:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 0/9] mwifiex: Fixes for wifi p2p and AP mode
Date:   Tue, 14 Sep 2021 21:59:00 +0200
Message-Id: <20210914195909.36035-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DBDF18B4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bunch of bugfixes for running mwifiex in the P2P and AP mode, for some prior
discussions, see https://github.com/linux-surface/kernel/pull/71.

Jonas Dreßler (9):
  mwifiex: Small cleanup for handling virtual interface type changes
  mwifiex: Use function to check whether interface type change is
    allowed
  mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
  mwifiex: Use helper function for counting interface types
  mwifiex: Update virtual interface counters right after setting
    bss_type
  mwifiex: Allow switching interface type from P2P_CLIENT to P2P_GO
  mwifiex: Handle interface type changes from AP to STATION
  mwifiex: Properly initialize private structure on interface type
    changes
  mwifiex: Fix copy-paste mistake when creating virtual interface

 .../net/wireless/marvell/mwifiex/cfg80211.c   | 370 ++++++++++--------
 1 file changed, 197 insertions(+), 173 deletions(-)

-- 
2.31.1

