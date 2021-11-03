Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F544446BC
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhKCRNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhKCRNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:13:48 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08905C061714;
        Wed,  3 Nov 2021 10:11:12 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Hktb01qRSzQk9S;
        Wed,  3 Nov 2021 18:11:08 +0100 (CET)
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
Subject: [PATCH v3 0/2] mwifiex: Add quirk to disable deep sleep with certain hardware revision
Date:   Wed,  3 Nov 2021 18:10:53 +0100
Message-Id: <20211103171055.16911-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F860130A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Third revision of this patch.
v1: https://lore.kernel.org/linux-wireless/20211028073729.24408-1-verdre@v0yd.nl/T/
v2: https://lore.kernel.org/linux-wireless/20211103135529.8537-1-verdre@v0yd.nl/T/

Changes between v2 and v3:
 - Remove redundant sizeof(char) in the second patch

Jonas Dreßler (2):
  mwifiex: Use a define for firmware version string length
  mwifiex: Add quirk to disable deep sleep with certain hardware
    revision

 drivers/net/wireless/marvell/mwifiex/fw.h     |  4 ++-
 drivers/net/wireless/marvell/mwifiex/main.c   | 18 +++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h   |  3 ++-
 .../wireless/marvell/mwifiex/sta_cmdresp.c    | 25 +++++++++++++++++--
 4 files changed, 46 insertions(+), 4 deletions(-)

-- 
2.33.1

