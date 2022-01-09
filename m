Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99329488834
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 07:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiAIGSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 01:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiAIGSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 01:18:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E986C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 22:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=i70fOHPbeIhP1HNPcBZfJBxHrf/GSIkxpuyaSy3wgwg=; b=q9SDgz+UHWKHkepp1R4D8GgQWA
        cm55B59ECVpoT+Wlj/Ct5C9G6N1YBaiW8DwxdfzYxkdie0MdjNLvhtGhNbyj0aEr6iLkOFPbrV1D9
        ovRExX/WDLTzLYSTf8fbU6LK4tCT5N2kVYr44fUtlu6BhCcRMHQr940o2kiCSrFb7UZzWcjAkDBMJ
        14riQtqG5VgE8p0p5mODW+FTe/VnwnDH5/unWUdF2aXOEbItPKAQGM3CFXte5ogVrX5qUnO3lVQz8
        u/XSEjhu/BVhrBlqFw14XYKmTfjoCEI2kTAXTmPxJLEnMysFvp0UEcrvjaO3UxAeEXfxMe5f2tNRL
        ql2h0Zeg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n6RXS-007Q3e-0n; Sun, 09 Jan 2022 06:18:46 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net/mlx5: fix devlink documentation table warning
Date:   Sat,  8 Jan 2022 22:18:45 -0800
Message-Id: <20220109061845.11635-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a table format warning in networking/devlink/mlx5 by adding
another column data entry:

Documentation/networking/devlink/mlx5.rst:13: WARNING: Error parsing content block for the "list-table" directive: uniform two-level bullet list expected, but row 2 does not contain the same number of items as row 1 (2 vs 3).

Fixes: 0844fa5f7b89 ("net/mlx5: Let user configure io_eq_size param")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Shay Drory <shayd@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/devlink/mlx5.rst |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20220107.orig/Documentation/networking/devlink/mlx5.rst
+++ linux-next-20220107/Documentation/networking/devlink/mlx5.rst
@@ -17,6 +17,7 @@ Parameters
      - Validation
    * - ``enable_roce``
      - driverinit
+     - This is a boolean value (0 or 1, false or true).
    * - ``io_eq_size``
      - driverinit
      - The range is between 64 and 4096.
