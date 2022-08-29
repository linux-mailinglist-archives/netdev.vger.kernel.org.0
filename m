Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACC05A45A1
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiH2JCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiH2JCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F005D5005A;
        Mon, 29 Aug 2022 02:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C46160F49;
        Mon, 29 Aug 2022 09:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D750C433C1;
        Mon, 29 Aug 2022 09:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661763755;
        bh=pJqU8moap50VhgN5I8OUHi3noAjFjzchZMbdZ6AZBxI=;
        h=From:To:Cc:Subject:Date:From;
        b=ncIJET2VlPI1ixT88vCbELbxgx7X/lg6d63h7f+tI8F/Ghr4KOGPMuQibaJxQkgQt
         HIFH09KMElS0RqSRTpM/LmcDhnvdDFhwxZ6Uq1I1U3GiXm5WPoNdDixFrzP15CRO9U
         BPOwJD/iDq3nVMIIZrL9j2odJY2lft++FKOheZtw5KQvWH5XiOVCCGxB3LQ0bzJB8g
         izlJlGqXxqAT7BaCgPsYy+eKY17B7NxFs1++yUmt400LCZc3FSinDtrtHEjrDpgvHM
         Xu7jxLaYtJGkrJY30xU3O5ecVC+fEsKJw75OqgNjY8kQz3C8vaJs/doUhbSL4rgjFs
         fbSuBq8id5Qdw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-rc 0/3] Batch of fixes to mlx5_ib
Date:   Mon, 29 Aug 2022 12:02:26 +0300
Message-Id: <cover.1661763459.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is batch of independent fixes related to mlx5_ib driver.

Thanks

Chris Mi (1):
  RDMA/mlx5: Set local port to one when accessing counters

Maher Sanalla (1):
  RDMA/mlx5: Rely on RoCE fw cap instead of devlink when setting profile

Maor Gottlieb (1):
  RDMA/mlx5: Fix UMR cleanup on error flow of driver init

 drivers/infiniband/hw/mlx5/mad.c              |  6 +++++
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  1 +
 drivers/infiniband/hw/mlx5/umr.c              |  3 +++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 23 +++++++++++++++++--
 include/linux/mlx5/driver.h                   | 19 +++++++--------
 6 files changed, 42 insertions(+), 12 deletions(-)

-- 
2.37.2

