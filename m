Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481A9486ED5
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344283AbiAGAaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55088 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344253AbiAGAaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BADE4B822DB
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C412C36AF3;
        Fri,  7 Jan 2022 00:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515417;
        bh=15zZ19ot24H2NAC4cTWKIV+aerLRln1gcNyc2q5DbT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPzGB4b/JxfC5nadZpn52BddEtiPwyRc6t2Uw2WopI9nSwPqmTDJGEEqf7tSoAoex
         BSBCirVXZBlK3OLzbnQnortKqQAe6ToIXE2JSDDmb6buneY4qBSy2vqa9WOoCbr7We
         fi7+v+4GweCfEve0bigNsFfJDGNLCY1sa/Yxvy8olOVkGXRBoT4Ozb+j7NmeukuDWH
         b+lOgd9eoOxJ14Uv7R67R7BufEPDE1sRvvNsJrjqx83cUqGtV4vktofrt6GtE/YZKv
         fm4Ccz2YWqsfrDXBlRrvpLSw5ofO4fNBynoM86AyT4/UPZGN9l2SMWnzFoHDvhh9+O
         wdL29OIcoV8Pw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 15/15] Documentation: devlink: mlx5.rst: Fix htmldoc build warning
Date:   Thu,  6 Jan 2022 16:29:56 -0800
Message-Id: <20220107002956.74849-16-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Fix the following build warning:

Documentation/networking/devlink/mlx5.rst:13: WARNING: Error parsing content block for the "list-table" directive:
+uniform two-level bullet list expected, but row 2 does not contain the same number of items as row 1 (2 vs 3).
...

Add the missing item in the first row.

Fixes: 0844fa5f7b89 ("net/mlx5: Let user configure io_eq_size param")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 38e94ed65936..29ad304e6fba 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -17,6 +17,7 @@ Parameters
      - Validation
    * - ``enable_roce``
      - driverinit
+     - Type: Boolean
    * - ``io_eq_size``
      - driverinit
      - The range is between 64 and 4096.
-- 
2.33.1

