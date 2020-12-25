Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B722E2A26
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 08:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgLYHYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 02:24:06 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9925 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgLYHYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 02:24:05 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D2JLS5h1yzhXlW;
        Fri, 25 Dec 2020 15:22:40 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 25 Dec 2020
 15:23:05 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v5 0/2] fixes for vhost_net
Date:   Fri, 25 Dec 2020 15:22:50 +0800
Message-ID: <1608880970-7156-1-git-send-email-wangyunjian@huawei.com>
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
v5:
   * update patch 2/2 add -ENOBUFS check

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

