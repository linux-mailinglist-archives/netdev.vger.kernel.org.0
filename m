Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48B9485452
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240701AbiAEOYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:24:40 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:38730
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240665AbiAEOYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:24:30 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id A345A3F130;
        Wed,  5 Jan 2022 14:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641392668;
        bh=quJFW/G6Pk/dF+baBRmWRZZ5XMkT3idjESzLbFJlnNk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=AyK/9W79ic4JMKbe/3cJgQHb9uplm15cXkTVw3U/JA6Gu/C05l4O6Gsd6T7L53iR4
         BL8wfqW0k+Vc0nzra8q/ovlD9JtCdWM/1LXlme7zwNlXwUADk6x5aW05ra01PZR+rq
         5s9cuBQsRZhGYwIUWl+iJqzFY74dYcc6Kj3QC5P80ZXSaZKTw3ac+ojLoj7dRpeEtq
         WWw0hktDWalICQOWzZvzFNmfFC7ldfKvyj4r8tgK5TpvPptqpe8Kpp7f0OOe696Bfw
         Jp3+yWBvEXHbpeZ/3w+PifC32HpCBLJaUUi1H/tPgVu5CDvFhu8V+sb2vRg3VyXS9/
         ACl0RWujdVexQ==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: [PATCH 3/3] net: usb: r8152: remove unused definition
Date:   Wed,  5 Jan 2022 22:23:51 +0800
Message-Id: <20220105142351.8026-3-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105142351.8026-1-aaron.ma@canonical.com>
References: <20220105142351.8026-1-aaron.ma@canonical.com>
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
index 3fbce3dbc04d..be2a6a2c2445 100644
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

