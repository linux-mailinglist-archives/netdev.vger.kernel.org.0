Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4ACC712B7
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732643AbfGWHWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbfGWHWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 03:22:55 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F1121911;
        Tue, 23 Jul 2019 07:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563866574;
        bh=/OVdnP8BCY2PyC4zUBDAebPr7jyb6Jreu6rUjrTh9xs=;
        h=From:To:Cc:Subject:Date:From;
        b=gfDLsN+brPXq3QMaKOm+Ts19HPGJRwQkQW6eer9SIzRc48aj9Jx2LizWtVAqhW3j9
         q//MBsienqBUr30znsXX6ike8s2Fl9shEkwp5o9hncpKbAsEDyotx46GE1zY0+Y5NS
         3uo0SXf7GmmZvmN7dAWn5pkvlMt7tpb/lZy84zkU=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net 0/2] DIM fixes for 5.3
Date:   Tue, 23 Jul 2019 10:22:46 +0300
Message-Id: <20190723072248.6844-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

Those two fixes for recently merged DIM patches, both exposed through
RDMa DIM usage.

Thanks

Leon Romanovsky (1):
  lib/dim: Fix -Wunused-const-variable warnings

Yamin Friedman (1):
  linux/dim: Fix overflow in dim calculation

 drivers/net/ethernet/broadcom/bcmsysport.c    |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  4 +-
 include/linux/dim.h                           | 56 -------------------
 lib/dim/dim.c                                 |  4 +-
 lib/dim/net_dim.c                             | 56 +++++++++++++++++++
 7 files changed, 63 insertions(+), 63 deletions(-)

--
2.20.1

