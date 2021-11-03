Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F534442DF
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhKCN6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:58:33 -0400
Received: from mout-p-102.mailbox.org ([80.241.56.152]:61308 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbhKCN62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:58:28 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HkpFZ313czQk3X;
        Wed,  3 Nov 2021 14:55:46 +0100 (CET)
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
Subject: [PATCH v2 0/2] mwifiex: Add quirk to disable deep sleep with certain hardware revision
Date:   Wed,  3 Nov 2021 14:55:27 +0100
Message-Id: <20211103135529.8537-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27FA0130B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Second revision of this patch, the first one is here:
https://lore.kernel.org/linux-wireless/20211028073729.24408-1-verdre@v0yd.nl/T/

Changes between v1 and v2:
 - Add patch to move fixed version string length (128) into a define
 - Added handling for errors in mwifiex_send_cmd()
 - Switched to test_and_set_bit() to avoid reentry in maybe_quirk_fw_disable_ds()
 - Improve commit message a bit

Jonas Dreßler (2):
  mwifiex: Use a define for firmware version string length
  mwifiex: Add quirk to disable deep sleep with certain hardware
    revision

 drivers/net/wireless/marvell/mwifiex/fw.h     |  4 +++-
 drivers/net/wireless/marvell/mwifiex/main.c   | 18 ++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h   |  3 ++-
 .../wireless/marvell/mwifiex/sta_cmdresp.c    | 24 +++++++++++++++++--
 4 files changed, 45 insertions(+), 4 deletions(-)

-- 
2.33.1

