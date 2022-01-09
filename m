Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B2A488BB2
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 19:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiAISlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 13:41:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35544 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAISlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 13:41:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C444A60F67
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 18:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C200C36AE5;
        Sun,  9 Jan 2022 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641753705;
        bh=/LU/WNPMI4jw6B1xPsw1Ty/Q21BKhKZrBlqEv6EQUyk=;
        h=From:To:Cc:Subject:Date:From;
        b=NUcXLm+DTtzqNMJZRmDYD4pZS5dk3kHA+vbNX2l80HOI7ZIm1mMixF1f3MWJOTs3K
         xQe7gNYR+FGUr8/nn6OjzWfz7ZnYIuEm+VspOODsaTaLaiqkzDwwda9t9jABrK3UHY
         xxoGepwH1d35jb4sEiELpd1FRIUqHFuCCU/7gDv3b2bMrqEI9argYIKwITFp5iRoPt
         fUTKlVPwA1GG0rb+IWFoBzPQWfjOA9k/s5qGKDp9nglZ7Jn3OYzeY4y90IlR3SE7+i
         GlMkm55FRfYOvqStvk0ak+LSxJRqFCOcurDv/6aaKYDoVcIWlZu5PcUdnYQZf9SWWI
         maZiZA2WVsCrg==
From:   Leon Romanovsky <leon@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH iproute2-next 0/2] RDMA clang warning fixes
Date:   Sun,  9 Jan 2022 20:41:37 +0200
Message-Id: <cover.1641753491.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This is followup to Stephen's series [1].

Thanks

[1] https://lore.kernel.org/all/20220108204650.36185-1-sthemmin@microsoft.com

Leon Romanovsky (2):
  rdma: Limit copy data by the destination size
  rdma: Don't allocate sparse array

 rdma/res-srq.c | 14 +++++---------
 rdma/res.c     |  6 +++---
 2 files changed, 8 insertions(+), 12 deletions(-)

-- 
2.33.1

