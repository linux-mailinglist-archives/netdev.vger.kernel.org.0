Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980516C6481
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCWKOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCWKOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F0218151;
        Thu, 23 Mar 2023 03:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E96B9625A4;
        Thu, 23 Mar 2023 10:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B17C433D2;
        Thu, 23 Mar 2023 10:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679566438;
        bh=zrgSddTp8IjJIEKsy9w6s1ZGRWxSgC5QVx2esu3Yf6I=;
        h=From:To:Cc:Subject:Date:From;
        b=sAgSrnBwrFRVItl7KRxi7yrS1x2eigTDKQrCdTYZyti/e07OklXqNIBCFiMbvtpFs
         mR39wzH8HAyFOskRpo+jN19Se/eX4/R9sZCmfHWg4mexxvwUY0Kg2GbbFHVVZg7X6r
         CtPUbZTwFyKHdpUhbcGNeW6iBZCYt56GJ3xgwBd5gdBGP/ulSF+Anm/xinCXGZmOX9
         50Rjq6BecfpTnNI8wAtBw5b/NL8bBgslqb7xDk0QjRbV9SqhmgzsvWa3LmsRjneuZ/
         584kHASBDDEMzwU/sTb3Pw2e8m73cjZjRXfwLY2iGlqTb4iPy0Tke5G1BQwPaCtJEW
         jewyVnuIqOeNw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Patrisious Haddad <phaddad@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v1 0/2] Add Q-counters for representors
Date:   Thu, 23 Mar 2023 12:13:50 +0200
Message-Id: <cover.1679566038.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Properly separated between uplink and representors counters
v0: https://lore.kernel.org/all/cover.1678974109.git.leon@kernel.org
----------------------------------------------------------------------

Hi,

The following series from Patrisious exports VF representors counters
to be visible by the host.

Thanks

Patrisious Haddad (2):
  net/mlx5: Introduce other vport query for Q-counters
  RDMA/mlx5: Expand switchdev Q-counters to expose representor
    statistics

 drivers/infiniband/hw/mlx5/counters.c | 171 +++++++++++++++++++++-----
 include/linux/mlx5/mlx5_ifc.h         |  13 +-
 2 files changed, 152 insertions(+), 32 deletions(-)

-- 
2.39.2

