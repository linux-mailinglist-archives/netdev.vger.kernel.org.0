Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E803512FB98
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgACRZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgACRZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 12:25:55 -0500
Received: from localhost.localdomain (unknown [194.230.155.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26DE20848;
        Fri,  3 Jan 2020 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578072354;
        bh=ChkpGRRjn42d8p4wrTVkJcWgbfIfZtCxaUk700S4WsM=;
        h=From:To:Cc:Subject:Date:From;
        b=kTL/tUKXrshG8T2udErByvxPNcrz3L+1Ft475GNgQvEsxFkzkra7J/vMD8nfT4ZlL
         BE/RjN8JMSiNxpc35zAx51V1uIQKxqbFp0umcxcGfQ23bj5yBEtBodFNP2j9ahXzZX
         w9bWMuJYVVAPHSJS6Usylr4BbxjY3d1uzTatseDA=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Byungho An <bh74.an@samsung.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] MAINTAINERS: Drop obsolete entries from Samsung sxgbe ethernet driver
Date:   Fri,  3 Jan 2020 18:25:49 +0100
Message-Id: <20200103172549.11048-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The emails to ks.giri@samsung.com and vipul.pandya@samsung.com bounce
with 550 error code:

    host mailin.samsung.com[203.254.224.12] said: 550
    5.1.1 Recipient address rejected: User unknown (in reply to RCPT TO
    command)"

Drop Girish K S and Vipul Pandya from sxgbe maintainers entry.

Cc: Byungho An <bh74.an@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b626563fb3c..9ea7e6e5b3d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14584,8 +14584,6 @@ F:	include/linux/platform_data/spi-s3c64xx.h
 
 SAMSUNG SXGBE DRIVERS
 M:	Byungho An <bh74.an@samsung.com>
-M:	Girish K S <ks.giri@samsung.com>
-M:	Vipul Pandya <vipul.pandya@samsung.com>
 S:	Supported
 L:	netdev@vger.kernel.org
 F:	drivers/net/ethernet/samsung/sxgbe/
-- 
2.17.1

