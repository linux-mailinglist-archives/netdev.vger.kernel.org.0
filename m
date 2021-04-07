Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8129C3575E4
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356189AbhDGUZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356143AbhDGUYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 818546100A;
        Wed,  7 Apr 2021 20:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827039;
        bh=jOgLdvDFW2zfR7Otnfjh5CaRO0BlvQ1igdZOgpzUOvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoNKMd5pqosAh26a9az5XYXNqrSMPaTJnwMuVxs73FSWPf8ZX+gV7lV/cNXlUT6wB
         eevwLCFLrYco+yxtrSmteFJtUf7MtSci7wVOpkRIkREvmjEdp9A04VC0bTXtn56Ppv
         BybDv+c3ci8zSiUGxzX2Fo77Ui1BYdCNdcubQKWf4+zt6aSNLPvhzaBWy2ze1yXsRY
         jeGkRcL7yLB4Okle5LtQ4uMmjKCQl31HH1DfvYDQiPR6heD1cZEhQBKWXFnDStsV5O
         am5gTrwx+BkLti6xORvzgQ3gSzZt3YdHQ1Hwm9vyRRSaDapgnNqnhl9TMEeC4jLAd0
         mX8xwTJVIX/mQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 16/16] MAINTAINERS: add myself as maintainer of marvell10g driver
Date:   Wed,  7 Apr 2021 22:22:54 +0200
Message-Id: <20210407202254.29417-17-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add myself as maintainer of the marvell10g ethernet PHY driver, in
addition to Russell King.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 217c7470bfa9..3ea9539821b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10695,6 +10695,7 @@ F:	include/linux/mv643xx.h
 
 MARVELL MV88X3310 PHY DRIVER
 M:	Russell King <linux@armlinux.org.uk>
+M:	Marek Behun <marek.behun@nic.cz>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/marvell10g.c
-- 
2.26.2

