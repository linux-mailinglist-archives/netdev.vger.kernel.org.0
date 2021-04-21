Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D385366A63
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbhDUMFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbhDUMFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:05:35 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0BDC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:05:01 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 12so66274856lfq.13
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=8N6/NNytP3vCaFcVwG1TesVxRYfAjS3ibaup22OjGQE=;
        b=W2DlYRSImRI24rgrHcRva2xjn7mkykUYXBJEghev3VlQiwhF9b2EclHI4WN/W2sPdZ
         nkCC5/yfWj+2mHFD/ZjuGlbCRW5gW4frx5ZMtHN+WDRHXHpda1Hohl8E/MOf4rXlBt9X
         pXbuGStQFDd2d6JVMepQiLv0zEVzs36yCf1zij9CL528KqSBNq0MqLUIOm3XMt5oMwjK
         mIH+zMnVO7mX9mwGJ34INQUQDQdz+fliMd0HNxHIuEf6QiFyIWDczHFp5GROf5ywgNrW
         V0n3ckbnxrcQFEqPUZ7TV1cDWBFo/l012EXSkCfo1irF7AZVL8afRhCPVLGVfLJb0rKr
         xKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=8N6/NNytP3vCaFcVwG1TesVxRYfAjS3ibaup22OjGQE=;
        b=BwvHPENzCyBQTMDMNTFtcVV0VOeKiUkmnOx5+w8jeVWI+grfNgDBL5txK4IfDH6e83
         GDk98CpNabbDsgflBYGFS/I0QetuD+rmsKWJZbWIv1Urcx0c4ol1d2y27Iv0L8D7Z3+k
         fJgMo6vtvdatD76TxJCIYUse8ccajdYPfu9nCdV6pjuhYrKc3gf6jMhYtTev/JEPFMle
         5WAlQHc608/ibhkbUnYAwYXFVl4edfDcPyiKLeU7i/slvW64QstCj4NeiE+z/mdI6GrB
         ay7FvfEZdOY8YolFi7e/nFXTuPIP8V5cw1CIp3dy1pXbePpvizSJeMfvnhiqt4lzW6bl
         UmzQ==
X-Gm-Message-State: AOAM532iu8BkE8mtphm1cR+OitCPoWvhU/VClgogYmU6qoEXdi1Y0ruj
        5OFmWK3x9IOM7yYXHH5rmTwINKcD07M/5w==
X-Google-Smtp-Source: ABdhPJwDOF3DmvM8jQwRAT4EZkAzVV3CSY1TKuu7erNYnK3j6zsKQNrChj1qOoOrCI4LPBI5H1Zrrg==
X-Received: by 2002:ac2:560b:: with SMTP id v11mr15128960lfd.254.1619006700439;
        Wed, 21 Apr 2021 05:05:00 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r71sm193430lff.12.2021.04.21.05.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 05:05:00 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: dsa: mv88e6xxx: Correct spelling of define "ADRR" -> "ADDR"
Date:   Wed, 21 Apr 2021 14:04:52 +0200
Message-Id: <20210421120454.1541240-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210421120454.1541240-1-tobias@waldekranz.com>
References: <20210421120454.1541240-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because ADRR is not a thing.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 2 +-
 drivers/net/dsa/mv88e6xxx/global2.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9ff1a10993b1..eca285aaf72f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1440,7 +1440,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 			 * the special "LAG device" in the PVT, using
 			 * the LAG ID as the port number.
 			 */
-			dev = MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK;
+			dev = MV88E6XXX_G2_PVT_ADDR_DEV_TRUNK;
 			port = dsa_lag_id(dst, dp->lag_dev);
 		}
 	}
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index c78769cdbb59..8f85c23ec9c7 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -109,7 +109,7 @@
 #define MV88E6XXX_G2_PVT_ADDR_OP_WRITE_PVLAN	0x3000
 #define MV88E6XXX_G2_PVT_ADDR_OP_READ		0x4000
 #define MV88E6XXX_G2_PVT_ADDR_PTR_MASK		0x01ff
-#define MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK		0x1f
+#define MV88E6XXX_G2_PVT_ADDR_DEV_TRUNK		0x1f
 
 /* Offset 0x0C: Cross-chip Port VLAN Data Register */
 #define MV88E6XXX_G2_PVT_DATA		0x0c
-- 
2.25.1

