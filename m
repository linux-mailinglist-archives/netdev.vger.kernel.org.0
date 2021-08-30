Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FF53FAF7F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 03:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhH3BUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 21:20:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8797 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbhH3BUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 21:20:18 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GyXX45P8PzYvp9;
        Mon, 30 Aug 2021 09:18:44 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 09:19:24 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 30 Aug 2021 09:19:23 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next 0/2] some optimization for page pool
Date:   Mon, 30 Aug 2021 09:18:08 +0800
Message-ID: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: support non-split page when PP_FLAG_PAGE_FRAG is set.
Patch 1: keep track of pp page when __skb_frag_ref() is called.

Yunshene Lin (2):
  page_pool: support non-split page with PP_FLAG_PAGE_FRAG
  skbuff: keep track of pp page when __skb_frag_ref() is called

 include/linux/skbuff.h  | 13 ++++++++++++-
 include/net/page_pool.h | 23 +++++++++++++++++++++++
 net/core/page_pool.c    | 24 +++++++++---------------
 3 files changed, 44 insertions(+), 16 deletions(-)

-- 
2.7.4

