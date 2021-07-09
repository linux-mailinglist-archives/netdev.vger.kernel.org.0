Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EACA3C2676
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhGIPCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbhGIPCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:02:21 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11BFC0613DD;
        Fri,  9 Jul 2021 07:59:37 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4GLxCC4Pz1zQk2x;
        Fri,  9 Jul 2021 16:59:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 7BNLns0hrjOQ; Fri,  9 Jul 2021 16:59:31 +0200 (CEST)
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
Subject: [PATCH v2 0/2] mwifiex: Add quirks for MS Surface devices
Date:   Fri,  9 Jul 2021 16:58:29 +0200
Message-Id: <20210709145831.6123-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.70 / 15.00 / 15.00
X-Rspamd-Queue-Id: F1F691847
X-Rspamd-UID: 84b67a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is version 2 of the patches proposed earlier here:
https://lore.kernel.org/linux-wireless/20210522131827.67551-1-verdre@v0yd.nl/

Compared to version 1, I left out the last commit, that one had some open
questions and I couldn't test changes to that commit since I don't own a
Surface 3. Other than that, only a few code comments were changed and commit
messages rephrased.

Jonas Dreßler (1):
  mwifiex: pcie: add DMI-based quirk implementation for Surface devices

Tsuchiya Yuto (1):
  mwifiex: pcie: add reset_d3cold quirk for Surface gen4+ devices

 drivers/net/wireless/marvell/mwifiex/Makefile |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  11 ++
 drivers/net/wireless/marvell/mwifiex/pcie.h   |   1 +
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 155 ++++++++++++++++++
 .../wireless/marvell/mwifiex/pcie_quirks.h    |  11 ++
 5 files changed, 179 insertions(+)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h

-- 
2.31.1

