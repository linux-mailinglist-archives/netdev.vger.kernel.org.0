Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7F32F306F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404814AbhALM6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404604AbhALM6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD66C2311F;
        Tue, 12 Jan 2021 12:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456231;
        bh=2en8818mCPobvH+Dx1pkm6mBNp03J0/We1+gCiq/EE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPcUZA/qCWqpffYeBQit8tt8hEPOhAeFeQ2hi+MmfcJlcxr+3qQBC1WZ0TMDgsDb2
         cJbZBCQ3oqCGOFeZIsdAE+ao/xQQMIT8/VLxz2UNhOvr+d1PaspkSjiPd12bdMnuu9
         TbH6yk7V75DtrHq6qiC25Ja9skLyJwbi3iqvrzW/rEYVTma0Z3X66iW3y1+w1RpVAD
         0M7kLKc9UrXRBNkLyoRJQwbJtLfYfMe2Gv5fnRrBcjE+vGarzVe9n8wIEkSWLKblOh
         Ni2YEJ5tMUROD8cofWdL1vqu8MX5m6OhL5kN5bALxEe0vzF9M27OaGulte/mbPREEk
         kJal445mbBlqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/28] misdn: dsp: select CONFIG_BITREVERSE
Date:   Tue, 12 Jan 2021 07:56:35 -0500
Message-Id: <20210112125645.70739-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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

