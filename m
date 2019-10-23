Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6C4E1821
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404465AbfJWKi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390935AbfJWKi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 06:38:59 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 368222064A;
        Wed, 23 Oct 2019 10:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571827138;
        bh=xVzJBoa+3zxQNYpbubp+oi3MnIvewIBz8bI3zTqPTxc=;
        h=From:To:Cc:Subject:Date:From;
        b=fIO9O2O3zeI0J+u8VX705luv7B8UWDtAlDJUPwk4/cJudi/yRoIstKznnsD4h0V8B
         aPcKBCJsiU2cK7EFoQjdSsgc9hffAJhQe8HHML1Q/b3gmQVpyJgK3E7BNV5Fnp9wUe
         6VNRUhycNs3j2wU4FZuiq0RmiJCpFpgg1DMChtDs=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 0/2] Add MR counters statistics
Date:   Wed, 23 Oct 2019 13:38:52 +0300
Message-Id: <20191023103854.5981-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is supplementary part of "ODP information and statistics"
kernel series.
https://lore.kernel.org/linux-rdma/20191016062308.11886-1-leon@kernel.org

Thanks

Erez Alfasi (2):
  rdma: Add "stat show mr" support
  rdma: Document MR statistics

 man/man8/rdma-statistic.8 | 25 +++++++----
 rdma/Makefile             |  2 +-
 rdma/res.c                |  8 ++++
 rdma/stat-mr.c            | 88 +++++++++++++++++++++++++++++++++++++++
 rdma/stat.c               |  5 ++-
 rdma/stat.h               | 26 ++++++++++++
 6 files changed, 144 insertions(+), 10 deletions(-)
 create mode 100644 rdma/stat-mr.c
 create mode 100644 rdma/stat.h

--
2.20.1

