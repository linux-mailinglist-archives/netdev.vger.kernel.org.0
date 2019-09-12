Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E9B0740
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 05:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfILDpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 23:45:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2216 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727873AbfILDpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 23:45:01 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D197F765668A76E5E634;
        Thu, 12 Sep 2019 11:44:58 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 12 Sep 2019 11:44:51 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>
CC:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH v2 net 0/3] fix memory leak for sctp_do_bind
Date:   Thu, 12 Sep 2019 12:02:16 +0800
Message-ID: <20190912040219.67517-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First two patches are to do cleanup, remove redundant assignment,
and change return type of sctp_get_port_local.
Third patch is to fix memory leak for sctp_do_bind if failed
to bind address.

---
 v2: add one patch to change return type of sctp_get_port_local.
---
Mao Wenan (3):
  sctp: change return type of sctp_get_port_local
  sctp: remove redundant assignment when call sctp_get_port_local
  sctp: destroy bucket if failed to bind addr

 net/sctp/socket.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

-- 
2.20.1

