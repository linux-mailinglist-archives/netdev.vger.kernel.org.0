Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824934904DE
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbiAQJ32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 04:29:28 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31097 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbiAQJ32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 04:29:28 -0500
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JcmjM59W0z1FCfC;
        Mon, 17 Jan 2022 17:25:43 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 17:29:26 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 17:29:25 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>, <sgarzare@redhat.com>,
        <stefanha@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>, Longpeng <longpeng2@huawei.com>
Subject: [RFC 0/3] vdpa: add two ioctl commands to support generic vDPA
Date:   Mon, 17 Jan 2022 17:29:18 +0800
Message-ID: <20220117092921.1573-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

To support generic vdpa deivce[1], we need add the following ioctls:
  - GET_CONFIG_SIZE: the size of the virtio config space (Patch 1)
  - GET_VQS_COUNT: the count of virtqueues that exposed (Patch 2)

Patch 3 supports ctrl vq for vdpasim_net, then guys can test the
generic vDPA device on the vdpasim_net/blk.

[1] https://lore.kernel.org/all/20220105005900.860-1-longpeng2@huawei.com/

Longpeng (3):
  vdpa: support exposing the config size to userspace
  vdpa: support exposing the count of vqs to userspace
  vdpasim_net: control virtqueue support

 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 83 +++++++++++++++++++++++++++-
 drivers/vhost/vdpa.c                 | 30 ++++++++++
 include/uapi/linux/vhost.h           |  7 +++
 3 files changed, 118 insertions(+), 2 deletions(-)

-- 
2.23.0

