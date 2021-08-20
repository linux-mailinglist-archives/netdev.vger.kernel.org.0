Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DECF3F2DE8
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 16:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240831AbhHTOWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 10:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbhHTOWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 10:22:16 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2B9C061575;
        Fri, 20 Aug 2021 07:21:38 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4GrkMy5GVjzQk1w;
        Fri, 20 Aug 2021 16:21:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id oQdTRAHGdyxc; Fri, 20 Aug 2021 16:21:30 +0200 (CEST)
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH v3 0/2] mwifiex: Add quirks for MS Surface devices
Date:   Fri, 20 Aug 2021 16:20:48 +0200
Message-Id: <20210820142050.35741-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF4421887
X-Rspamd-UID: 39dc6b
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Third revision of this patch, here's version 1 and 2:
version 1: https://lore.kernel.org/linux-wireless/20210522131827.67551-1-verdre@v0yd.nl/
version 2: https://lore.kernel.org/linux-wireless/20210709145831.6123-1-verdre@v0yd.nl/

Changes between v2 and v3:
 - Removed a small comment about the choice of dev_dbg() over mwifiex_dbg()
 - Switched to same licence boilerplate for pcie_quirks.* as the rest of mwifiex

Jonas Dreßler (1):
  mwifiex: pcie: add DMI-based quirk implementation for Surface devices

Tsuchiya Yuto (1):
  mwifiex: pcie: add reset_d3cold quirk for Surface gen4+ devices

 drivers/net/wireless/marvell/mwifiex/Makefile |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  11 ++
 drivers/net/wireless/marvell/mwifiex/pcie.h   |   1 +
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 161 ++++++++++++++++++
 .../wireless/marvell/mwifiex/pcie_quirks.h    |  23 +++
 5 files changed, 197 insertions(+)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h

-- 
2.31.1

