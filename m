Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFB942567
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438784AbfFLMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389885AbfFLMUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 08:20:20 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FAC820866;
        Wed, 12 Jun 2019 12:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560342020;
        bh=I9EXwroHKLafl5yX9WVLSGQDf4LTbArTsdUTlRaDB4E=;
        h=From:To:Cc:Subject:Date:From;
        b=SlpNpS/Yo/D/1qFCQ2oVc0Gb/ucBf5cbyDphwJYrgrmKIGQ5f5uEPOguOhCZownuT
         C/1csS4fom2knKTz6hKDIrAa3CRlElMmNGscflma5iZCVEPIgAMtExNTmHKPcFsARM
         /U5GtqIVhdLYXOyrWNill25wkis1jLeNMtXA1XgE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH rdma-next v1 0/4] Expose ENCAP mode to mlx5_ib
Date:   Wed, 12 Jun 2019 15:20:10 +0300
Message-Id: <20190612122014.22359-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog v0->v1:
 * Added patch to devlink to use declared enum for encap mode instead of u8
 * Constify input argumetn to encap mode function
 * fix encap variable type to be boolean

---------------------------------------------------------------------
Hi,

This is short series from Maor to expose and use enacap mode inside mlx5_ib.

Thanks

Leon Romanovsky (1):
  net/mlx5: Declare more strictly devlink encap mode

Maor Gottlieb (3):
  net/mlx5: Expose eswitch encap mode
  RDMA/mlx5: Consider eswitch encap mode
  RDMA/mlx5: Enable decap and packet reformat on FDB

 drivers/infiniband/hw/mlx5/main.c             | 25 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 ++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +++---
 .../mellanox/mlx5/core/eswitch_offloads.c     |  6 +++--
 include/linux/mlx5/eswitch.h                  | 12 +++++++++
 include/net/devlink.h                         |  6 +++--
 net/core/devlink.c                            |  6 +++--
 7 files changed, 59 insertions(+), 15 deletions(-)

--
2.20.1

