Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DED71DD566
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgEUR7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728885AbgEUR7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:59:24 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E9BB207D3;
        Thu, 21 May 2020 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590083963;
        bh=1KZ2pZiNqLML18DpPvbIuMuyJqfRzyjikxLwQeSaNUw=;
        h=From:To:Cc:Subject:Date:From;
        b=XRNuPT2XXHvOeq6UCDKA641DUnJOUe5bXeTmhoRsU3GT+amfTm6ovXwt6dbc2jkAf
         zWD3Cm2ltDdoqD96+/lPJNRu3R+rOkOqsnW7rzkeKCxTUeXkNxvmFLSnYbGTQmsnQP
         wFsOmwnDPXt9b8dwoFETHCHle9YB+mqhR4UXwWU8=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 0/4] RAW format dumps through RDMAtool
Date:   Wed, 20 May 2020 13:25:35 +0300
Message-Id: <20200520102539.458983-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

The following series adds support to get the RDMA resource data in RAW
format. The main motivation for doing this is to enable vendors to
return the entire QP/CQ/MR data without a need from the vendor to set
each field separately.

User-space part of the kernel series [1].

Thanks

[1] https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org

Maor Gottlieb (4):
  rdma: Refactor res_qp_line
  rdma: Add support to get QP in raw format
  rdma: Add support to get CQ in raw format
  rdma: Add support to get MR in raw format

 man/man8/rdma-resource.8 |   5 ++
 man/man8/rdma.8          |   4 ++
 rdma/rdma.c              |   8 ++-
 rdma/rdma.h              |   7 +-
 rdma/res-cq.c            |  16 ++++-
 rdma/res-mr.c            |  13 +++-
 rdma/res-qp.c            | 139 ++++++++++++++++++++++++++-------------
 rdma/res.c               |   1 +
 rdma/utils.c             |  20 ++++++
 9 files changed, 163 insertions(+), 50 deletions(-)

--
2.26.2

