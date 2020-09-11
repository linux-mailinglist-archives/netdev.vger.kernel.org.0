Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB15D266494
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgIKQl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbgIKPKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:10:04 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6FB4222C3;
        Fri, 11 Sep 2020 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599834842;
        bh=aRm/nSH7/SoWVBtD3aaiB7zpszrW2lrJPlUGWAXYJNk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tFh2XMpZBBVQfnwhuAwKDsnDbp8gy95H9eEk9cih8VsCD+4pYXSnH1aClS2/5p6ng
         Yn2X9JpKS8DdRQJCUnyAG7Vwy+US66Q+BeExOoKoIPZrahCZM63lobVJYDuD6zfDNS
         IqN/EI2OKP/0AKav99/1eTM+wqljTi/r2d6TVWxY=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/3] serial: s3c: Update path of Samsung S3C machine file
Date:   Fri, 11 Sep 2020 16:33:42 +0200
Message-Id: <20200911143343.498-2-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200911143343.498-1-krzk@kernel.org>
References: <20200911143343.498-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct the path to Samsung S3C24xx machine file, mentioned in
documentation.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 include/linux/serial_s3c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/serial_s3c.h b/include/linux/serial_s3c.h
index 463ed28d2b27..ca2c5393dc6b 100644
--- a/include/linux/serial_s3c.h
+++ b/include/linux/serial_s3c.h
@@ -254,7 +254,7 @@
  * serial port
  *
  * the pointer is setup by the machine specific initialisation from the
- * arch/arm/mach-s3c2410/ directory.
+ * arch/arm/mach-s3c/ directory.
 */
 
 struct s3c2410_uartcfg {
-- 
2.17.1

