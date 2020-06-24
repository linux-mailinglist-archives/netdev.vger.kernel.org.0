Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BFB207155
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390245AbgFXKkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388197AbgFXKkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 06:40:18 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F91320644;
        Wed, 24 Jun 2020 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592995217;
        bh=JR4w9lMroJCisomCBo1jVhVtTAWE41zBeWxrGD2kQFk=;
        h=From:To:Cc:Subject:Date:From;
        b=CeJf+g/QqOqV/j8ettBOL9NLOFP1g3fkHC+g7m7OzmnuQ77qlx9FwpkgTsrI/WLS2
         HRpOx2s6fANQdWzYhnDnw2Srn9wSV1nVPY/7uIY178LSqlG5WELweQWzC50H9S2UgT
         FhggclOd6CfG/MUA5jAu1hXfsisOB6mZjs5YBW6E=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next v1 0/4] RAW format dumps through RDMAtool
Date:   Wed, 24 Jun 2020 13:40:08 +0300
Message-Id: <20200624104012.1450880-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v1:
 * Kernel part was accepted, so this series has correct SHA for the
   kernel header update patch.
 * Aligned implementation to the final kernel solution of query
   interface.
v0:
https://lore.kernel.org/linux-rdma/20200520102539.458983-1-leon@kernel.org

-----------------------------------------------------------------------------

Hi,

The following series adds support to get the RDMA resource data in RAW
format. The main motivation for doing this is to enable vendors to
return the entire QP/CQ/MR data without a need from the vendor to set
each field separately.

Thanks

Maor Gottlieb (4):
  rdma: update uapi headers
  rdma: Add support to get QP in raw format
  rdma: Add support to get CQ in raw format
  rdma: Add support to get MR in raw format

 man/man8/rdma-resource.8              |  5 +++++
 man/man8/rdma.8                       |  4 ++++
 rdma/include/uapi/rdma/rdma_netlink.h |  8 +++++++
 rdma/rdma.c                           | 10 +++++++--
 rdma/rdma.h                           |  7 +++++--
 rdma/res-cq.c                         | 20 ++++++++++++++++--
 rdma/res-mr.c                         | 21 +++++++++++++++++--
 rdma/res-qp.c                         | 20 ++++++++++++++++--
 rdma/res.h                            | 30 ++++++++++++++++++++++-----
 rdma/utils.c                          | 20 ++++++++++++++++++
 10 files changed, 130 insertions(+), 15 deletions(-)

--
2.26.2

