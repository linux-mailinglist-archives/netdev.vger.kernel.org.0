Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE782F2FFF
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391090AbhALNBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405513AbhALM6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF60523132;
        Tue, 12 Jan 2021 12:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456311;
        bh=K5UVOAFSVMpxnx58cB+TImbkULMojURm5Eon9UXNVrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRkFbKJMn/qyxU3n4j29Sq6ecWiQQyRPJ/lUSB2iZkRJS5h44F9IevFdEdLsMdggk
         hgE0+rbvOnQArkUwEM/P5YLrnpfQcduAPBKp0LFbHZAnisJOufxx/sYvg9wwwIINtm
         YRQIFy5VZZfmGj9WYnSj4FqFjXuzVQqh1S7ke4Xcxon6v0M64rDHvHJxxy+bimKchG
         rtqJVOoP/A8aW87XXmeEjxKWjcenPzjLd5nidz8h/w80ICQ5jGe0ZgIqWcSvQnKylu
         wFrcq9awaQcAeDHTdsYP+NG6sR2WqAEwWseR/d5a4jQhPDNTCOT84COjP9tTpNvUB3
         5TOrTGh/qVGVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/8] misdn: dsp: select CONFIG_BITREVERSE
Date:   Tue, 12 Jan 2021 07:58:20 -0500
Message-Id: <20210112125823.71463-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125823.71463-1-sashal@kernel.org>
References: <20210112125823.71463-1-sashal@kernel.org>
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

