Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9FAE85D1C
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbfHHIoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 04:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbfHHIoD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 04:44:03 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B358D217D7;
        Thu,  8 Aug 2019 08:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565253842;
        bh=kbqEIM+7GxsWTJxchB8fEDZj9Pe0yz77PAypHzu+v5g=;
        h=From:To:Cc:Subject:Date:From;
        b=D0d/ELeb1HM8W1sgjJvA1fS4WfsUoBojpIycrFBYgaZXeQMdGWvTY6IkpxBN2PJr4
         h5/UszestI5Sx3msi0/xc21oiC91MyDa4Dp6dvt8Xe7If9Y7CIZTP3J23G2o8pnQnT
         EOycOGl2e7NoSf3SSEDpQzW0b7juc7iCNTYugGyc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/4] Add XRQ and SRQ support to DEVX interface
Date:   Thu,  8 Aug 2019 11:43:54 +0300
Message-Id: <20190808084358.29517-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This small series extends DEVX interface with SRQ and XRQ legacy commands.

Thanks

Yishai Hadas (4):
  net/mlx5: Use debug message instead of warn
  net/mlx5: Add XRQ legacy commands opcodes
  IB/mlx5: Add legacy events to DEVX list
  IB/mlx5: Expose XRQ legacy commands over the DEVX interface

 drivers/infiniband/hw/mlx5/devx.c             | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  2 +-
 include/linux/mlx5/device.h                   |  9 +++++++++
 include/linux/mlx5/mlx5_ifc.h                 |  2 ++
 5 files changed, 28 insertions(+), 1 deletion(-)

--
2.20.1

