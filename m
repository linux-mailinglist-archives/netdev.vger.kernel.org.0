Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22716485597
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbiAEPPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:15:06 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:55782
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241195AbiAEPPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:15:03 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id A0CD740037;
        Wed,  5 Jan 2022 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641395699;
        bh=krm5g8tFpp7LgpQcwpESkXdJo63TQKvHZazL6m/HHi0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Eu/gnRUzGwknoS3eYlS1bO6b/zqTyAs9NXMyHFl9D7/UjGzyk+v/MI5LKqEswOBKq
         zamxYSxusaj42Dc4K4FrVOIGYaTqLJ+oigqPqdoxmw66vHD0s+P3BF8SFTMsbTUKys
         etj2jt4Wn0lyF9HSThyhKEJkB9iAn+kkio/Sth3A1OEpaYxcqMAIgAfhQf+lLvQode
         Qb46fGGwuBq+4wqMFt/do0u9cdwdk7OJNjZ08PaQDJgc0RouFWcxe8l8ailNee017K
         wmXZCt+RaZwAKTw3GcyMn5rxR67gJUiBxE3LxnWxxnYOA3C9FeA4iOE+sBxH9+JjEF
         f2w0A0E8YbPHw==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: [PATCH 3/3] net: usb: r8152: remove unused definition
Date:   Wed,  5 Jan 2022 23:14:27 +0800
Message-Id: <20220105151427.8373-3-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105151427.8373-1-aaron.ma@canonical.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/usb/r8152.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 7cf2faf8d088..7cd3b1db062a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -773,9 +773,6 @@ enum rtl8152_flags {
 	RX_EPROTO,
 };
 
-#define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
-#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
-
 struct tally_counter {
 	__le64	tx_packets;
 	__le64	rx_packets;
-- 
2.30.2

