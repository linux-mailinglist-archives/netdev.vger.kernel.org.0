Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387F6430351
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 17:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbhJPPfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 11:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbhJPPfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 11:35:05 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC98C061570;
        Sat, 16 Oct 2021 08:32:57 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HWnFy1lhqzQjVH;
        Sat, 16 Oct 2021 17:32:54 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
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
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH v3 0/5] A few more cleanups and fixes for mwifiex
Date:   Sat, 16 Oct 2021 17:32:39 +0200
Message-Id: <20211016153244.24353-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EBF03273
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1: https://lore.kernel.org/linux-wireless/20211016101743.15565-1-verdre@v0yd.nl/T/#t
v2: https://lore.kernel.org/linux-wireless/20211016103656.16791-1-verdre@v0yd.nl/T/#t

Changes between v2 and v3:
 - Added "Fixes" tag to commit fixing DELBA requests

Just a few more cleanups and two fixes for mwifiex.

Jonas Dreßler (5):
  mwifiex: Don't log error on suspend if wake-on-wlan is disabled
  mwifiex: Log an error on command failure during key-material upload
  mwifiex: Fix an incorrect comment
  mwifiex: Send DELBA requests according to spec
  mwifiex: Deactive host sleep using HSCFG after it was activated
    manually

 drivers/net/wireless/marvell/mwifiex/11n.c    |  7 ++++---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 12 ++++++++---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 21 +++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.c   | 18 ++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h   |  1 +
 .../net/wireless/marvell/mwifiex/sta_cmd.c    |  4 ++++
 6 files changed, 57 insertions(+), 6 deletions(-)

-- 
2.31.1

