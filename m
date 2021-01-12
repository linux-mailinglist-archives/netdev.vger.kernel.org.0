Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8732F3030
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbhALNEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405324AbhALM6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2615623122;
        Tue, 12 Jan 2021 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456284;
        bh=K5UVOAFSVMpxnx58cB+TImbkULMojURm5Eon9UXNVrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nB9vMrG/PHK5S610fXqQr8XtsmV+gcJHrZ/Hg00r8JS6yAWWpUu5WwTGr8F9G2OEK
         0yCODOibmP1bHmUaXRnfq7vunOCzfcogyiLBxE+eIhuuaP1eCzfuuY2kJDgIv99h03
         mYhi9dOKrb7r5+a08L1Ga41v2CGbybDyqKiLojgNyoHu5OoQbONUc9YtbLQvC657jU
         8bAF2hbsCyz0wmGAA3uNEtl/XU5WxeYNzXbyT0oE9ssM1vTCW8znrk9svzuxXkfivb
         GFadpMJY/uAUg6Xt+93g+0l4mwHFQeUK4Y53mUx2rw5wou55ynmpSYp89qpNv9QCBC
         DB+937V9Jq5ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/13] misdn: dsp: select CONFIG_BITREVERSE
Date:   Tue, 12 Jan 2021 07:57:46 -0500
Message-Id: <20210112125749.71193-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125749.71193-1-sashal@kernel.org>
References: <20210112125749.71193-1-sashal@kernel.org>
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
index c0730d5c734d6..fb61181a5c4f7 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -12,6 +12,7 @@ if MISDN != n
 config MISDN_DSP
 	tristate "Digital Audio Processing of transparent data"
 	depends on MISDN
+	select BITREVERSE
 	help
 	  Enable support for digital audio processing capability.
 
-- 
2.27.0

