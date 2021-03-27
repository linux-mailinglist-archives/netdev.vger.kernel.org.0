Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A9434B3C8
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 03:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhC0C0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 22:26:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15324 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhC0C0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 22:26:08 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F6jMP0WWpz9xWL;
        Sat, 27 Mar 2021 10:24:01 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Mar 2021
 10:26:02 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-sctp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgarzare@redhat.com>, <jhansen@vmware.com>,
        <colin.king@canonical.com>, <nslusarek@gmx.net>,
        <andraprs@amazon.com>, <alex.popov@linux.com>,
        <santosh.shilimkar@oracle.com>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>
Subject: [PATCH -next 0/3] Fix some typos
Date:   Sat, 27 Mar 2021 10:27:21 +0800
Message-ID: <20210327022724.241376-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lu Wei (3):
  net: rds: Fix a typo
  net: sctp: Fix some typos
  net: vsock: Fix a typo

 net/rds/send.c           | 2 +-
 net/sctp/sm_make_chunk.c | 2 +-
 net/sctp/socket.c        | 2 +-
 net/vmw_vsock/af_vsock.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.17.1

