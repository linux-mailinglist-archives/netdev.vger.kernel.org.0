Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20B740BC12
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbhINXMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235116AbhINXMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 19:12:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0471461165;
        Tue, 14 Sep 2021 23:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631661088;
        bh=XuegkM+ZMo3/PTwYhIMnNIlxH5Nhu9CSqElmdyEKcQ0=;
        h=From:To:Cc:Subject:Date:From;
        b=L6I0y6htOiHrQd6+bb5G12K4AZYs37rtxlV+NWgIx8bdEaLkfXQtbNX4/1gHipNRp
         lxG5xPZhJHNhqlHI7U/iXinJHlM9SfgNy259xxu3qH0Ad/QBIQ82E2nRCDpBA0coJ1
         NFxdLVaVkbqRD/1FmGFtOem9h5WVjeYYQ5zZWrxvnp6uk7mK/wb88YvPSwd2iOEZhS
         qZMsf3JKagTLfY0RBjsOw6pOYa0XPyJFz/fyIwr72N4b/Z1gpk8ylR2LoEqn+jMGJ0
         FvwMh9JoOWgQ6wgjhSzkMZmQyIpXxgHIB532ZCunsV9aWPsf2QW99UjwAGcd/siiR3
         xTuM8500nHcvw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 0/2] Extend UAR to have DevX UID
Date:   Wed, 15 Sep 2021 02:11:21 +0300
Message-Id: <cover.1631660943.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is short series from Meir that adds DevX UID to the UAR.

Thanks

Meir Lichtinger (2):
  net/mlx5: Add uid field to UAR allocation structures
  IB/mlx5: Enable UAR to have DevX UID

 drivers/infiniband/hw/mlx5/cmd.c  | 24 ++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h  |  2 ++
 drivers/infiniband/hw/mlx5/main.c | 55 +++++++++++++++++--------------
 include/linux/mlx5/mlx5_ifc.h     |  4 +--
 4 files changed, 59 insertions(+), 26 deletions(-)

-- 
2.31.1

