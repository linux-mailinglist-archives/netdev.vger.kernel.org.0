Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC4D103C2E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731372AbfKTNlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730323AbfKTNlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:41:24 -0500
Received: from localhost.localdomain (unknown [118.189.143.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F9EF22506;
        Wed, 20 Nov 2019 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574257284;
        bh=Ix16peC/bFPfpJNFYk2KffAYTt/5+CNdwzHxME0+VSI=;
        h=From:To:Cc:Subject:Date:From;
        b=a2YBRWrp4Se06WzbQKybM7JcJJ+MTbd2BDX5UT9dTCIQC7nVlFse3CHJnlxoV82ch
         wMGKCM8rO3JY6+N7OGs2jC6gNJuQIP/QWraW2VcqebvlLrhI+DcZ6KZl1BNR6APvRv
         P5iOc6pmhLEWpcHs4cgGB4I+lVXFdjlt3IdOE8Fc=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH] isdn: Fix Kconfig indentation
Date:   Wed, 20 Nov 2019 21:41:20 +0800
Message-Id: <20191120134120.15009-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/isdn/hardware/mISDN/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index 304f50c08da2..078eeadf707a 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -10,7 +10,7 @@ config MISDN_HFCPCI
 	depends on PCI
 	help
 	  Enable support for cards with Cologne Chip AG's
-          HFC PCI chip.
+	  HFC PCI chip.
 
 config MISDN_HFCMULTI
 	tristate "Support for HFC multiport cards (HFC-4S/8S/E1)"
-- 
2.17.1

