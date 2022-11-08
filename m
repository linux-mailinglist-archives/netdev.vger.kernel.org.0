Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F59620B0D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiKHIYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbiKHIXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:53 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A839E27B12
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:52 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 3FEE384FB5;
        Tue,  8 Nov 2022 09:23:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895830;
        bh=DBYzCogn/9wiUq7uYmdB4Lu0Fygut93Crnr7cr8sh/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSSqAs18dMI5jvpo5UdsoCXuh1WOw+K5heyOX9VFGwXFTEYKYLLcB7j41eBwr4RXz
         LBlveKMeoQR1MD/6/nHic1ZETCjMxNusAkWa6CIH5/uesPsvi3Jr1Pe7h8fOu7g7Kh
         VkD5TMbazuTUMFOxH/yzO9gF3MYmepl9fLofHIB0+NqTWZ2dtEMPYRs4JaWl7ruvnL
         gcC/SdpzGfaA6Y1SRnBSSG1tf2rTgZXFL6XOqIQwa3MH3Qz/1CTltUDTGdKBFKcPHR
         TeyT3gRzaGryGidInhNGwT26jZEGAXA0cc3N1vzrElyokMhuNSM11drYTVjejlVSsH
         wYa2RCFgy8WNg==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 7/9] net: dsa: mv88e6071: Define max frame size (2048 bytes)
Date:   Tue,  8 Nov 2022 09:23:28 +0100
Message-Id: <20221108082330.2086671-8-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108082330.2086671-1-lukma@denx.de>
References: <20221108082330.2086671-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Accroding to the documentation - the mv88e6071 can support
frame size up to 2048 bytes.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d90835b4c606..e0224fc92ddf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5563,6 +5563,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
-- 
2.37.2

