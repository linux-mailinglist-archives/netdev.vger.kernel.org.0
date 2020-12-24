Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CF52E23A4
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 03:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgLXC0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 21:26:21 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10073 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728707AbgLXC0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 21:26:21 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D1Yn63LDNzM8jm;
        Thu, 24 Dec 2020 10:24:42 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Thu, 24 Dec 2020
 10:25:29 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v4 0/2] fixes for vhost_net
Date:   Thu, 24 Dec 2020 10:25:22 +0800
Message-ID: <1608776722-1576-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

This series include two fixes patches for vhost_net.

---
v4:
   * update patch 2/2 return check and commit log suggested
   * by Willem de Bruijn

v3:
   * update patch 2/2 code styles and commit log suggested
   * by Jason Wang and Willem de Bruijn

v2:
   * update patch 1/2 Fixes tag suggested by Willem de Bruijn
   * update patch 2/2 code styles suggested by Jason Wang

Yunjian Wang (2):
  vhost_net: fix ubuf refcount incorrectly when sendmsg fails
  vhost_net: fix tx queue stuck when sendmsg fails

 drivers/vhost/net.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

-- 
2.23.0

