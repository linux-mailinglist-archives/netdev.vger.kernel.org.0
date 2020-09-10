Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891A3264BF2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgIJRyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgIJQPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 12:15:14 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1291C221E3;
        Thu, 10 Sep 2020 16:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599754373;
        bh=LSW0uymH0OeH2QEOskyhHoNpO0V0yrS0w9bNxI5XbcU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=N3A2HH9u3+u9lRw+0UfmuLrQq9cxqa3DlrDeQRcS7m/Y+QeSqTpYwu6Fq3iLvxNCC
         OPmNpNhelk+caKCa9tuFeHJCH8U9nyFe052Z3ZPvpJiOLpH+4vKRvWpwwWRcA615YV
         VC1u+klljK+gGnC2C9UsOtej+1AgHU+hpTHSuJfU=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v3 7/8] MAINTAINERS: Add Krzysztof Kozlowski to Samsung S3FWRN5 and remove Robert
Date:   Thu, 10 Sep 2020 18:12:18 +0200
Message-Id: <20200910161219.6237-8-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161219.6237-1-krzk@kernel.org>
References: <20200910161219.6237-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Bałdyga's email does not work (bounces) since 2016 so remove it.
Additionally there are no review/ack/tested tags from Krzysztof Opasiak
so it looks like the driver is not supported.

As a maintainer of Samsung ARM/ARM64 SoC, I can take care about this
driver and provide some review.  However clearly driver is not in
supported mode as I do not work in Samsung anymore.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/CREDITS b/CREDITS
index 32ee70a7562e..1df63cdf71df 100644
--- a/CREDITS
+++ b/CREDITS
@@ -191,6 +191,10 @@ N: Krishna Balasubramanian
 E: balasub@cis.ohio-state.edu
 D: Wrote SYS V IPC (part of standard kernel since 0.99.10)
 
+B: Robert Baldyga
+E: r.baldyga@hackerion.com
+D: Samsung S3FWRN5 NCI NFC Controller
+
 N: Chris Ball
 E: chris@printf.net
 D: Former maintainer of the MMC/SD/SDIO subsystem.
diff --git a/MAINTAINERS b/MAINTAINERS
index ec4f1d9cb3dc..6888bd851caf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15269,10 +15269,10 @@ F:	drivers/media/platform/s3c-camif/
 F:	include/media/drv-intf/s3c_camif.h
 
 SAMSUNG S3FWRN5 NFC DRIVER
-M:	Robert Baldyga <r.baldyga@samsung.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Krzysztof Opasiak <k.opasiak@samsung.com>
 L:	linux-nfc@lists.01.org (moderated for non-subscribers)
-S:	Supported
+S:	Maintained
 F:	Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
 F:	drivers/nfc/s3fwrn5
 
-- 
2.17.1

