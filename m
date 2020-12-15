Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ADC2DA952
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 09:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgLOIjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 03:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgLOIj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 03:39:27 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86182C06179C;
        Tue, 15 Dec 2020 00:38:47 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id qw4so26415723ejb.12;
        Tue, 15 Dec 2020 00:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E5HMvyuTTnIDatg6r6w86mEYHeRbT17Cy9WXQA6H7Fc=;
        b=TnDpdqbGSYdMFqpOKq74ztUq4/vZ/IxYBtcfPLDH0KTA0ZelKhKOXbC9yCu/apCV5j
         MAQFPKRhCazjj9kDnYBnVzSXKEvQF2u9cGcPPF8GFpmqz28tUVF1SFOgntLgFL15qDOi
         fB3DSAlxYhj82/xykqwzwaZrUdJIe5z7/8195Z9XyeCUlhwU64TIqKfRp7Vxn5GHsdx6
         WIZg/bKw2EVteWVFnN+2aTKYGimwGijobOpfbozgj5gwahWUL01ejlORGIQRgZSTiA2o
         f15uU28zVP4Ni4/adLJDOnziUiW6daag/BuHVa6Xs/wQ4QsiZP0QIZiLJw3gQ2l+xtkw
         WRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E5HMvyuTTnIDatg6r6w86mEYHeRbT17Cy9WXQA6H7Fc=;
        b=isuUVsXcBBg9EM436TopiX5C8ZfF5Y3TVCu5VaWneDkrnQSBwQrMESeOiUUDnGjF43
         uSfgvOmUQTlvR1wEJ4VDMUQ0Dx7nY2EJ0Ung/ItK++AFsh48vUcGOsAVAcut2pY6uV/q
         +xcnH/2FoModQSEfLy6W+s7ycUtD4XcYpUP2Q/HyD5F1103Di2rM+uNhibMPNsNuB/Va
         0laCt6Bl9LF3neKkHWIfWCPYehqlG6jmfvbI4AVxc0v43cp0xscHgag52pgTgHQyDZKl
         +a/cKYm6V39r0blQi7GBzWKZxilMo47q4GunSQ2MQXV0YWB8briEwKu63HgKkMHL7rPV
         ULuw==
X-Gm-Message-State: AOAM530KKWXZIJSzoFkOdnCnVOTLsxKal6B7yEGssQ/ecUW4MuMsi+NM
        DaSyfIVzT1LwBpwEPVmUqd8l2DInaL4=
X-Google-Smtp-Source: ABdhPJzYlAYm4Ypohm7RA74c06EBNOVyf3N+zIXJL8sAmL76w2bbiCHZ6mMuLJOu3NqjBvHNZNOhbw==
X-Received: by 2002:a17:906:8587:: with SMTP id v7mr25295267ejx.381.1608021526255;
        Tue, 15 Dec 2020 00:38:46 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id r1sm827909eje.51.2020.12.15.00.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 00:38:45 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH] net: phy: fix kernel-doc for .config_intr()
Date:   Tue, 15 Dec 2020 10:37:51 +0200
Message-Id: <20201215083751.628794-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Fix the kernel-doc for .config_intr() so that we do not trigger a
warning like below.

include/linux/phy.h:869: warning: Function parameter or member 'config_intr' not described in 'phy_driver'

Fixes: 6527b938426f ("net: phy: remove the .did_interrupt() and .ack_interrupt() callback")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 include/linux/phy.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 381a95732b6a..9effb511acde 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -743,7 +743,8 @@ struct phy_driver {
 	/** @read_status: Determines the negotiated speed and duplex */
 	int (*read_status)(struct phy_device *phydev);
 
-	/** @config_intr: Enables or disables interrupts.
+	/**
+	 * @config_intr: Enables or disables interrupts.
 	 * It should also clear any pending interrupts prior to enabling the
 	 * IRQs and after disabling them.
 	 */
-- 
2.28.0

