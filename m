Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1F824843A
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgHRLxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgHRLw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 07:52:59 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A31D206B5;
        Tue, 18 Aug 2020 11:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597751579;
        bh=hANew3lRlBCN+pRllKo5f7mc/OeBZssc4CyRVHHuOq4=;
        h=From:To:Cc:Subject:Date:From;
        b=LvgrdwSKWJ8MSb5+i4e1qt1WVPcsEPc8gkmdpmXtAGtA9loEcxMmujDEJA1Dax7N6
         4jupRe5bB/VhAYEkvIj9qabmM8XRpLDkt92/1geNZKIn0Ml0bxfUbENb7VigytByni
         9+MniP/GlKrVcgUAyEW84GgUn/jBMlMVynpJiyVM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 0/2] Add DC RoCE LAG support
Date:   Tue, 18 Aug 2020 14:52:43 +0300
Message-Id: <20200818115245.700581-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

Two extremely short patches to enable DC RoCE LAG support.

Thanks

Mark Zhang (2):
  IB/mlx5: Add tx_affinity support for DCI QP
  IB/mlx5: Add DCT RoCE LAG support

 drivers/infiniband/hw/mlx5/qp.c | 23 ++++++++++++++---------
 include/linux/mlx5/mlx5_ifc.h   |  3 ++-
 2 files changed, 16 insertions(+), 10 deletions(-)

--
2.26.2

