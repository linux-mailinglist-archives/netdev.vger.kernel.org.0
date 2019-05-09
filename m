Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14F618401
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 05:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfEIDN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 23:13:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46891 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfEIDN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 23:13:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id y11so490074pfm.13;
        Wed, 08 May 2019 20:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+Tj8r8hdckRUUnpA/M/03E2Lbxyok4vK09Grgvy9XQg=;
        b=nBOy6dLQbs4k4FDnOf6MVbGJxl0Fa+IIx1mBzgshVBaOmYYXcvl4A2YP8Lk95a1kLs
         gMqOVIPHEKXS+DWzQ1oNyDw97fPBR9AG5sMoo/SLd0p+RaTjZStZn2E7t2OQPBhgxRlL
         JWiBqZUGZpGaWD4lzVpXVtLAVTD8rnMDfVhSQH2UBZJcmyHawXrG41RMNbyCknMjzMKd
         oTX+fv9wwrxKSqgjMC+XQkMga7qlk7P94nRc2O2ESU/sG2R5n6lQztOZMHUO8rJFy4Iw
         S5CBa7UwLQ3BYZWfwruXekJwx9a5hwQsb0caHMZkS1+IrtWQeG//NMshxHqQPJpaXx3a
         v5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+Tj8r8hdckRUUnpA/M/03E2Lbxyok4vK09Grgvy9XQg=;
        b=suL8u5Ql84e/qal5U1aXKXSZaizE2JXXYjd46KUci76zCf+/aGBL3OpWmSju74RMw7
         YaoRexetsxFL9XvlXYOXqSKEpHyUpXpUD28OSORJJeEuVe5SinXuTAl26gO7Y+8NoRdG
         PuXCeFdqXm74DPiLpE1NSE/ouYCKLqOmizE1TY/tx/AEGxVKzB0CYRnWCAbaPMpuF6Ew
         +KEV64PvXyTn7jHxmQ4hTkC043x7AzOiIT4AsZ2xfPX5NUSme+yjnKBwpi1AbtTwEDMf
         C79m0LfTxqSDge+8C2NAgo7OoxdhTlJ16fO3RL9PUIxzKsyZZMsQLr63hXhZfYdmOnPr
         d4zQ==
X-Gm-Message-State: APjAAAX0URXTY6IWH/86ttyvja/0CN3kR01Nr2jB5VctcJw9z4QOsJFc
        pOU82Yti2JOw03+DSQvqpSk=
X-Google-Smtp-Source: APXvYqzBupoEzG5ZWlfgCphT1eceBcdy9snaTxgFBB6p1NVSwutf/WIAU3wwGs6Sfl9HUODYjOWHVQ==
X-Received: by 2002:a63:8dc8:: with SMTP id z191mr2523315pgd.9.1557371637730;
        Wed, 08 May 2019 20:13:57 -0700 (PDT)
Received: from localhost.localdomain (ec2-52-192-173-191.ap-northeast-1.compute.amazonaws.com. [52.192.173.191])
        by smtp.gmail.com with ESMTPSA id f20sm815630pff.176.2019.05.08.20.13.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 20:13:57 -0700 (PDT)
From:   Cheng Han <hancheng2009@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cheng Han <hancheng2009@gmail.com>
Subject: [PATCH] dwmac4_prog_mtl_tx_algorithms() missing write operation
Date:   Thu,  9 May 2019 11:13:41 +0800
Message-Id: <20190509031341.31428-1-hancheng2009@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net: ethernet: stmmac: dwmac4_prog_mtl_tx_algorithms() missing write operation

The value of MTL_OPERATION_MODE is not written back

Signed-off-by: Cheng Han <hancheng2009@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 7e5d5db..b4bb562 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -192,6 +192,8 @@ static void dwmac4_prog_mtl_tx_algorithms(struct mac_device_info *hw,
 	default:
 		break;
 	}
+
+	writel(value, ioaddr + MTL_OPERATION_MODE);
 }
 
 static void dwmac4_set_mtl_tx_queue_weight(struct mac_device_info *hw,
-- 
1.9.1

