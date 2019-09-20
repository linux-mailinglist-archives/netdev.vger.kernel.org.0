Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C285B90AE
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfITNb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 09:31:27 -0400
Received: from antares.kleine-koenig.org ([94.130.110.236]:44580 "EHLO
        antares.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfITNb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 09:31:27 -0400
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
        id 9E1197BD9EF; Fri, 20 Sep 2019 15:31:25 +0200 (CEST)
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] dimlib: make DIMLIB a hidden symbol
Date:   Fri, 20 Sep 2019 15:31:15 +0200
Message-Id: <20190920133115.12802-1-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Tal Gilboa the only benefit from DIM comes from a driver
that uses it. So it doesn't make sense to make this symbol user visible,
instead all drivers that use it should select it (as is already the case
AFAICT).

Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
---
 lib/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index cc04124ed8f7..9fe8a21fd183 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -555,8 +555,7 @@ config SIGNATURE
 	  Implementation is done using GnuPG MPI library
 
 config DIMLIB
-	bool "DIM library"
-	default y
+	bool
 	help
 	  Dynamic Interrupt Moderation library.
 	  Implements an algorithm for dynamically change CQ moderation values
-- 
2.23.0

