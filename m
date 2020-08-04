Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D40923B702
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgHDItR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 04:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgHDItR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 04:49:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 208752075D;
        Tue,  4 Aug 2020 08:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596530956;
        bh=vsKlW0xoSbpwgH/w/zl/SzUCT8BvsYv1Tv061mlqouU=;
        h=From:To:Cc:Subject:Date:From;
        b=sSzKhGDJRk/Zs1dOrl2ENlpvhOMKExJo3QncCADAE9FQ9SwXaDJ8yS0tx1dopA81I
         PUTBbij6ZZ4VhOqWyML0d7d3ZS5J+h7B8ErDzTG3LZ27hivaqSRXQ4v6M+/1zMCWNN
         d7xdqYMuTS3IWnySrSODVZAy8GNLrR0pLNm9HSRA=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Ido Kalir <idok@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next 0/3] Global per-type support for QP counters
Date:   Tue,  4 Aug 2020 11:49:06 +0300
Message-Id: <20200804084909.604846-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 * Update first patch to latest rdma_netlink.h file.
 * Drop RFC, the kernel part was accepted.
https://lore.kernel.org/linux-rdma/20200726112011.75905-1-leon@kernel.org

---------------------------------------------------

Hi,

This is complimentary part of kernel series [1] that extends netlink
interface to allow automatic binding of QP counters based on their type,
in very similar manner to already existing per-PID ability.

Thanks

[1] https://lore.kernel.org/lkml/20200702082933.424537-1-leon@kernel.org

Mark Zhang (3):
  rdma: update uapi headers
  rdma: Add "PID" criteria support for statistic counter auto mode
  rdma: Document the new "pid" criteria for auto mode

 man/man8/rdma-statistic.8             | 23 +++++--
 rdma/include/uapi/rdma/rdma_netlink.h |  9 +--
 rdma/res-cmid.c                       |  6 --
 rdma/res.c                            |  6 ++
 rdma/res.h                            |  2 +-
 rdma/stat.c                           | 95 ++++++++++++++++++++-------
 6 files changed, 102 insertions(+), 39 deletions(-)

--
2.26.2

