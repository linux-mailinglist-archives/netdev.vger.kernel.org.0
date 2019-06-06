Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C54937266
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfFFLGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfFFLGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 07:06:14 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8246B206E0;
        Thu,  6 Jun 2019 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559819174;
        bh=1DbuJgOqpQEUj50Qkfgh3vo5VutSqi2mdgyP+7YA3/U=;
        h=From:To:Cc:Subject:Date:From;
        b=Rrd+sFViFu4LRxwZKgbERjDyCjmYQgvEGqfCZuxSVLkYG/0irCJmHlIgIyx7++Y1V
         Ta3WbdeiiX/73FdqWszBEgpDTmyxB4/Z3xRPjeiGKijWmEgG1n9jMVaFv4U4b0mmip
         QQ984uggQryTkrdhN5rypoSeQWFT2jkhzdKXY8h0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/3] Expose ENCAP mode to mlx5_ib
Date:   Thu,  6 Jun 2019 14:06:06 +0300
Message-Id: <20190606110609.11588-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is short series from Maor to expose and use enacap mode inside mlx5_ib.

Thanks

Maor Gottlieb (3):
  net/mlx5: Expose eswitch encap mode
  RDMA/mlx5: Consider eswitch encap mode
  RDMA/mlx5: Enable decap and packet reformat on FDB

 drivers/infiniband/hw/mlx5/main.c             | 25 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 10 ++++++++
 include/linux/mlx5/eswitch.h                  | 10 ++++++++
 3 files changed, 39 insertions(+), 6 deletions(-)

--
2.20.1

