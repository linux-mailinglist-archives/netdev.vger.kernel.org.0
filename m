Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C502E1D95
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgLWOsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:48:07 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9682 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgLWOsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 09:48:07 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D1GHT191bzkvRm;
        Wed, 23 Dec 2020 22:46:29 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.498.0; Wed, 23 Dec 2020
 22:47:15 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v3 0/2] fixes for vhost_net
Date:   Wed, 23 Dec 2020 22:46:54 +0800
Message-ID: <1608734814-10560-1-git-send-email-wangyunjian@huawei.com>
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
v3:
   * update patch 2/2 code styles and commit log suggested
   * by Jason Wang and Willem de Bruijn

v2:
   * update patch 1/2 Fixes tag suggested by Willem de Bruijn
   * update patch 2/2 code styles suggested by Jason Wang

Yunjian Wang (2):
  vhost_net: fix ubuf refcount incorrectly when sendmsg fails
  vhost_net: fix tx queue stuck when sendmsg fails

 drivers/vhost/net.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

-- 
2.23.0

