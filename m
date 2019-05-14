Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456401C7ED
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 13:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfENLoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 07:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfENLoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 07:44:20 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C09620818;
        Tue, 14 May 2019 11:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557834259;
        bh=75oaqgPFRpMBkkXlg3jRciCVdOZTavNN6rpWHtYHW6c=;
        h=From:To:Cc:Subject:Date:From;
        b=lW4m7w6eBDc4bmTnQ7swBVA3FSmuynKfRlk4MwTlhT+wxvtxhFZW/Gnh44vLt6TCm
         Yt3HYtslt7tKb1pdqIP+EmvP/ZNDVYCRJQnJcOYN8TV2RO/8a+I6dumbLyjNiEngoI
         GSAKzXYaWmLOB2h/w0CO+dTjRMvn5YG+mJ8Wuupo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/2] DevX fixes
Date:   Tue, 14 May 2019 14:44:10 +0300
Message-Id: <20190514114412.30604-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

There are two very short but important fixes to DevX flows.

Thanks

Yishai Hadas (2):
  IB/mlx5: Verify DEVX general object type correctly
  net/mlx5: Set completion EQs as shared resources

 drivers/infiniband/hw/mlx5/devx.c            | 13 ++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  3 +++
 include/linux/mlx5/mlx5_ifc.h                |  2 +-
 3 files changed, 14 insertions(+), 4 deletions(-)

--
2.20.1

