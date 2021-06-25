Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874D33B3B1B
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 05:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhFYDVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 23:21:46 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5074 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhFYDVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 23:21:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GB2Cl35tNzXkk9;
        Fri, 25 Jun 2021 11:14:11 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 11:19:24 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 11:19:23 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [PATCH net-next v2 0/2] add benchmark selftest and optimization for ptr_ring
Date:   Fri, 25 Jun 2021 11:18:54 +0800
Message-ID: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: add a selftest app to benchmark the performance
         of ptr_ring.
Patch 2: make __ptr_ring_empty() checking more reliable
         and use the just added selftest to benchmark the
         performance impact.

V2: add patch 1 and add performance data for patch 2.

Yunsheng Lin (2):
  selftests/ptr_ring: add benchmark application for ptr_ring
  ptr_ring: make __ptr_ring_empty() checking more reliable

 MAINTAINERS                                      |   5 +
 include/linux/ptr_ring.h                         |  25 ++-
 tools/testing/selftests/ptr_ring/Makefile        |   6 +
 tools/testing/selftests/ptr_ring/ptr_ring_test.c | 249 +++++++++++++++++++++++
 tools/testing/selftests/ptr_ring/ptr_ring_test.h | 150 ++++++++++++++
 5 files changed, 426 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/ptr_ring/Makefile
 create mode 100644 tools/testing/selftests/ptr_ring/ptr_ring_test.c
 create mode 100644 tools/testing/selftests/ptr_ring/ptr_ring_test.h

-- 
2.7.4

