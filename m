Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CCF2DBC8B
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 09:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgLPIVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 03:21:10 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9449 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPIVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 03:21:09 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cwp2V6xDwzhs6s;
        Wed, 16 Dec 2020 16:19:46 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.498.0; Wed, 16 Dec 2020
 16:20:07 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v2 0/2] fixes for vhost_net
Date:   Wed, 16 Dec 2020 16:20:04 +0800
Message-ID: <cover.1608065644.git.wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
In-Reply-To: <cover.1608024547.git.wangyunjian@huawei.com>
References: <cover.1608024547.git.wangyunjian@huawei.com>
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
v2:
   * update patch 1/2 Fixes tag suggested by Willem de Bruijn
   * update patch 2/2 code styles suggested by Jason Wang


Yunjian Wang (2):
  vhost_net: fix ubuf refcount incorrectly when sendmsg fails
  vhost_net: fix high cpu load when sendmsg fails

 drivers/vhost/net.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

-- 
2.23.0

