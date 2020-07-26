Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EF822DE6F
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 13:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGZLUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 07:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgGZLUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 07:20:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F17A220663;
        Sun, 26 Jul 2020 11:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595762417;
        bh=SpK+RWnuX1BgtAT8pog5D+UaCp/NbMNuFQruSCBTcIQ=;
        h=From:To:Cc:Subject:Date:From;
        b=zTQ3v2sPAs5z1h8+W2y+vauFuLkVT7HZuJdWF7dbJEtrKUVxPgaozVS3Vpu3u+j3g
         tnvzXYcjxvePAHltrxTUD3B8x6ztRMv6z/CObXTuGGQoRn0TNsAka77W756B7y3bRm
         kxqwDMDvwbJvdhXafcSx7tR+DM9jR3JAttf87Xgg=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Ido Kalir <idok@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [RFC PATCH iproute2-next 0/3] Global per-type support for QP counters
Date:   Sun, 26 Jul 2020 14:20:08 +0300
Message-Id: <20200726112011.75905-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

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
 rdma/include/uapi/rdma/rdma_netlink.h |  2 +-
 rdma/res-cmid.c                       |  6 --
 rdma/res.c                            |  6 ++
 rdma/res.h                            |  2 +-
 rdma/stat.c                           | 95 ++++++++++++++++++++-------
 6 files changed, 98 insertions(+), 36 deletions(-)

--
2.26.2

