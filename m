Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366572F30F3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbhALNNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404172AbhALM5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F6172311B;
        Tue, 12 Jan 2021 12:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456181;
        bh=2en8818mCPobvH+Dx1pkm6mBNp03J0/We1+gCiq/EE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJRYjjyG46KpVaf7h+XrUE/aXWkeQYcYlZBXf9Gsh5juK+xkdaKsjnJJjSOhedEtG
         poMrKfoiJZlynNlyuJ14I/xddjG9Eha/mhwuF1y8ZrMrO8IWuGR+cJ4dRxVpJjQlr4
         WRnaBHFtlovmsAHNlbt/PgmPeihlnpRYAfcO12hVo+OHGy132h+OlQcbdZBOwampwL
         mc4odt/kTjNrvwuA3JpqqmnpnGg/stqJ8JS31Enqn+nY//IRYyyvNJkWfAceNMEqss
         YjstuOq8rZxsUT1F1W/oTdU5P0Tp9lueu74kA/FKSuQPcbxo9ojK0jG6L3Gb2cMOh+
         9lQRFLmdcWHPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 35/51] misdn: dsp: select CONFIG_BITREVERSE
Date:   Tue, 12 Jan 2021 07:55:17 -0500
Message-Id: <20210112125534.70280-35-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 51049bd903a81307f751babe15a1df8d197884e8 ]

Without this, we run into a link error

arm-linux-gnueabi-ld: drivers/isdn/mISDN/dsp_audio.o: in function `dsp_audio_generate_law_tables':
(.text+0x30c): undefined reference to `byte_rev_table'
arm-linux-gnueabi-ld: drivers/isdn/mISDN/dsp_audio.o:(.text+0x5e4): more undefined references to `byte_rev_table' follow

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index 26cf0ac9c4ad0..c9a53c2224728 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -13,6 +13,7 @@ if MISDN != n
 config MISDN_DSP
 	tristate "Digital Audio Processing of transparent data"
 	depends on MISDN
+	select BITREVERSE
 	help
 	  Enable support for digital audio processing capability.
 
-- 
2.27.0

