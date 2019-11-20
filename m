Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FCC103C21
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbfKTNkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730034AbfKTNku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:40:50 -0500
Received: from localhost.localdomain (unknown [118.189.143.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E66224FC;
        Wed, 20 Nov 2019 13:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574257249;
        bh=6nRls0at4U1WUxZ2o/HXmg8n98PkTMsiMPhnQf/J+ms=;
        h=From:To:Cc:Subject:Date:From;
        b=hn+NwVAh9OXf13mgOiwkrpmV688mR+Squ0/2A9Af4YNhCzqlFJIcjas94xXQvAmh8
         u5n/h4OyO3BAaUsmJ+24uF9IFTwHcMCSNOlYoHde0eKPQsnuFSb/RyGaL/lGKug0QK
         XqVZKMrL6A5r1CYaOExix5dzHdpWFDetaWrvI2JM=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] nfc: Fix Kconfig indentation
Date:   Wed, 20 Nov 2019 21:40:44 +0800
Message-Id: <20191120134044.14558-1-krzk@kernel.org>
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
 drivers/nfc/nfcmrvl/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/Kconfig b/drivers/nfc/nfcmrvl/Kconfig
index 06f34fb4e0b0..ded0d03c0015 100644
--- a/drivers/nfc/nfcmrvl/Kconfig
+++ b/drivers/nfc/nfcmrvl/Kconfig
@@ -15,7 +15,7 @@ config NFC_MRVL_USB
 	  Marvell NFC-over-USB driver.
 
 	  This driver provides support for Marvell NFC-over-USB devices:
-          8897.
+	  8897.
 
 	  Say Y here to compile support for Marvell NFC-over-USB driver
 	  into the kernel or say M to compile it as module.
-- 
2.17.1

