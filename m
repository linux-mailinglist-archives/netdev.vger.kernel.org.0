Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FF6490A4D
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238744AbiAQOaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238653AbiAQOaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 09:30:25 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A13C061574;
        Mon, 17 Jan 2022 06:30:24 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 19C1341AC8;
        Mon, 17 Jan 2022 14:30:14 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v3 0/9] misc brcmfmac fixes (M1/T2 series spin-off)
Date:   Mon, 17 Jan 2022 23:29:10 +0900
Message-Id: <20220117142919.207370-1-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

This series contains just the fixes / misc improvements from the
previously submitted series:

brcmfmac: Support Apple T2 and M1 platforms

Patches 8-9 aren't strictly bugfixes but rather just general
improvements; they can be safely skipped, although patch 8 will be a
dependency of the subsequent series to avoid a compile warning.

Hector Martin (9):
  brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
  brcmfmac: firmware: Allocate space for default boardrev in nvram
  brcmfmac: firmware: Do not crash on a NULL board_type
  brcmfmac: pcie: Declare missing firmware files in pcie.c
  brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
  brcmfmac: pcie: Fix crashes due to early IRQs
  brcmfmac: of: Use devm_kstrdup for board_type & check for errors
  brcmfmac: fwil: Constify iovar name arguments
  brcmfmac: pcie: Read the console on init and shutdown

 .../broadcom/brcm80211/brcmfmac/firmware.c    |  5 ++
 .../broadcom/brcm80211/brcmfmac/fwil.c        | 34 ++++----
 .../broadcom/brcm80211/brcmfmac/fwil.h        | 28 +++----
 .../wireless/broadcom/brcm80211/brcmfmac/of.c |  8 +-
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 77 ++++++++-----------
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  1 -
 6 files changed, 72 insertions(+), 81 deletions(-)

-- 
2.33.0

