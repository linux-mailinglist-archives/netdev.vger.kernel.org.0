Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF06AE40E
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 08:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406496AbfIJG40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 02:56:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731204AbfIJG4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 02:56:23 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D8911453BED5E90F01BD;
        Tue, 10 Sep 2019 14:56:18 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Tue, 10 Sep 2019 14:56:08 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>
CC:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net 0/2] fix memory leak for sctp_do_bind
Date:   Tue, 10 Sep 2019 15:13:41 +0800
Message-ID: <20190910071343.18808-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch is to do cleanup, remove redundant assignment,
second patch is to fix memory leak for sctp_do_bind if failed
to bind address.

Mao Wenan (2):
  sctp: remove redundant assignment when call sctp_get_port_local
  sctp: destroy bucket if failed to bind addr

 net/sctp/socket.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.20.1

