Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543F44809FA
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 15:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhL1O02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 09:26:28 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:49879 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbhL1O0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 09:26:22 -0500
Received: from mwalle01.kontron.local. (unknown [IPv6:2a02:810b:4340:43bf:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 98B4222438;
        Tue, 28 Dec 2021 15:26:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1640701581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z7Jp/9TSBr/YXtTUKHXXv5W5V0V0BzH9Fdgy4wsGzuM=;
        b=i27Za8Xxp66QNN2GAetc5+ufS54wRS8I3TG4LOZ7r/64y4vaq4SuALrGDc7+bWJ8W6dGPa
        i6A/Vk+pnzFBMXYfh4c5bF4tGI4oE1zimVTC50EJDE0smC+5+DK/fmeYOJ+Nshn1NVBf9o
        o4lFfflbRswrsrd9bTZbhl1ZC7KTep0=
From:   Michael Walle <michael@walle.cc>
To:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH 8/8] arm64: defconfig: enable NVMEM transformations
Date:   Tue, 28 Dec 2021 15:25:49 +0100
Message-Id: <20211228142549.1275412-9-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211228142549.1275412-1-michael@walle.cc>
References: <20211228142549.1275412-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Kontron sl28 needs the transformation to get the correct ethernet
addresses for its onboard NICs.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index ee4bd7710a0d..117423e81d15 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1178,6 +1178,7 @@ CONFIG_FSL_IMX8_DDR_PMU=m
 CONFIG_HISI_PMU=y
 CONFIG_QCOM_L2_PMU=y
 CONFIG_QCOM_L3_PMU=y
+CONFIG_NVMEM_TRANSFORMATIONS=y
 CONFIG_NVMEM_IMX_OCOTP=y
 CONFIG_NVMEM_IMX_OCOTP_SCU=y
 CONFIG_QCOM_QFPROM=y
-- 
2.30.2

