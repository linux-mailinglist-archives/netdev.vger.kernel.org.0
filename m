Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E80CD344
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfJFQAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfJFQAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Oct 2019 12:00:02 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 827612084B;
        Sun,  6 Oct 2019 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570377601;
        bh=oZiSiRSEbjLypwmX4KdWcgliuBwF3Xfc/O5gZrtjC1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=TLEEm2Qad/5dGRXoWpKOF9giR0oToew28lvvsPLDYAacP1084Ssgs9vVebvWyVg2s
         dY9w5bV/nFTIgkpE9M76QUqYXHhs+GdBCl8RSofb3wN9E4luG+cZnUO62G85NbnGXA
         rUpwyL6GTJa+2QFa3ohRKYbrvDSung9IzQ0cwEas=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/3] Optimize SGL registration
Date:   Sun,  6 Oct 2019 18:59:52 +0300
Message-Id: <20191006155955.31445-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series from Yamin implements long standing "TODO" existed in rw.c.

Thanks

Yamin Friedman (3):
  net/mlx5: Expose optimal performance scatter entries capability
  RDMA/mlx5: Add capability for max sge to get optimized performance
  RDMA/rw: Support threshold for registration vs scattering to local
    pages

 drivers/infiniband/core/rw.c      | 12 ++++++------
 drivers/infiniband/hw/mlx5/main.c |  2 ++
 include/linux/mlx5/mlx5_ifc.h     |  2 +-
 include/rdma/ib_verbs.h           |  2 ++
 4 files changed, 11 insertions(+), 7 deletions(-)

--
2.20.1

