Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5825C2B7
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfGASOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGASOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 14:14:33 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5893420B7C;
        Mon,  1 Jul 2019 18:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562004872;
        bh=NMhY/aVjP0dYa3Cdx8BuyUWnyXmQta2sAW4QssgJ8Wg=;
        h=From:To:Cc:Subject:Date:From;
        b=HtBN7jdJpdIj8pJCTxj085KN648JMy9bDCO764Xd7RrGvmbI9mrzu+C+rf6y0Dwu0
         2bqW/mCDrMhv2u+YzpBxSJ5UvGD+ldtRdgQ5SZBAHVBSsyFszHFh32Nwan1c9Udnqc
         N7nf0dK/KudUgcb3qqSmufkSIgC7NucLZvavhaKg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/2] DEVX VHCA tunnel support
Date:   Mon,  1 Jul 2019 21:14:00 +0300
Message-Id: <20190701181402.25286-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

Those two patches introduce VHCA tunnel mechanism to DEVX interface
needed for Bluefield SOC. See extensive commit messages for more
information.

Thanks

Max Gurtovoy (2):
  net/mlx5: Introduce VHCA tunnel device capability
  IB/mlx5: Implement VHCA tunnel mechanism in DEVX

 drivers/infiniband/hw/mlx5/devx.c | 24 ++++++++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h     | 10 ++++++++--
 2 files changed, 28 insertions(+), 6 deletions(-)

--
2.20.1

