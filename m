Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009D341870B
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 09:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhIZHUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 03:20:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:19373 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhIZHUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 03:20:21 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HHH8510l3zRS1h;
        Sun, 26 Sep 2021 15:14:29 +0800 (CST)
Received: from dggpeml500002.china.huawei.com (7.185.36.158) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sun, 26 Sep 2021 15:18:43 +0800
Received: from huawei.com (10.136.117.208) by dggpeml500002.china.huawei.com
 (7.185.36.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sun, 26 Sep
 2021 15:18:43 +0800
From:   Qiumiao Zhang <zhangqiumiao1@huawei.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <yanan@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH stable 4.19 0/4] tcp: fix the timeout value calculated by tcp_model_timeout() is not accurate
Date:   Sun, 26 Sep 2021 15:18:38 +0800
Message-ID: <20210926071842.1429-1-zhangqiumiao1@huawei.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.117.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500002.china.huawei.com (7.185.36.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is present in v5.15 and fixes the problem that the
timeout value calculated by tcp_model_timeout() is not accurate.

Pseudo-Shortlog of commits:

Eric Dumazet <edumazet@google.com>
    tcp: address problems caused by EDT misshaps

Yuchung Cheng <ycheng@google.com>
    tcp: always set retrans_stamp on recovery

Yuchung Cheng <ycheng@google.com>
    tcp: create a helper to model exponential backoff

Eric Dumazet <edumazet@google.com>
    tcp: adjust rto_base in retransmits_timed_out()

 net/ipv4/tcp_input.c  | 16 ++++++-----
 net/ipv4/tcp_output.c |  9 +++----
 net/ipv4/tcp_timer.c  | 63 ++++++++++++++++++++-----------------------
 3 files changed, 43 insertions(+), 45 deletions(-)

-- 
2.19.1

