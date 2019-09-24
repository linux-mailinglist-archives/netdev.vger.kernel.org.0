Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC77BCC06
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 18:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391571AbfIXQDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 12:03:05 -0400
Received: from antares.kleine-koenig.org ([94.130.110.236]:52290 "EHLO
        antares.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389811AbfIXQDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 12:03:05 -0400
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
        id A44CF7C76AC; Tue, 24 Sep 2019 18:03:03 +0200 (CEST)
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] dimlib: make DIMLIB a hidden symbol
Date:   Tue, 24 Sep 2019 18:02:59 +0200
Message-Id: <20190924160259.10987-1-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190924.164528.724219923520816886.davem@davemloft.net>
References: <20190924.164528.724219923520816886.davem@davemloft.net>
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
Hello David,

On Tue, Sep 24, 2019 at 04:45:28PM +0200, David Miller wrote:
> Since this doesn't apply due to the moderation typo being elsewhere, I'd
> really like you to fix up this submission to properly be against 'net'.

I thought it would be possible to git-apply my patch with the -3 option.
I even tested that, but obviously it only applies to my tree that has
the git object with the typo fixed. Sorry for the extra effort I'm
forcing on you. This patch applies to your public tree from just now.

Best regads
Uwe

 lib/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 4e6b1c3e4c98..d7fc9eb33b9b 100644
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
 	  Implements an algorithm for dynamically change CQ modertion values
-- 
2.23.0

