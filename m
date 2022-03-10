Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E764D41AA
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 08:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbiCJHV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 02:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiCJHV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 02:21:58 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC80131118;
        Wed,  9 Mar 2022 23:20:57 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KDgMn4xR1z1GCMf;
        Thu, 10 Mar 2022 15:16:05 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 15:20:55 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 15:20:55 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <mst@redhat.com>, <sgarzare@redhat.com>, <stefanha@redhat.com>,
        <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>, <gdawar@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH v2 0/2] vdpa: add two ioctl commands to support generic vDPA
Date:   Thu, 10 Mar 2022 15:20:49 +0800
Message-ID: <20220310072051.2175-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

To support generic vdpa deivce[1], we need add the following ioctls:
  - GET_CONFIG_SIZE: the size of the virtio config space (Patch 1)
  - GET_VQS_COUNT: the count of virtqueues that exposed (Patch 2)

Changes v1(RFC) -> v2:
  Patch 1:
    - be more verbose in commit message and the comment for get_config_size
      [Jason]
  Patch 2:
    - change the type of nvqs to u32 [Jason]
  Patch 3:
    - drop from this series because Gautam sent another proposal[2]

[1] https://lore.kernel.org/all/20220105005900.860-1-longpeng2@huawei.com/
[2] https://patchwork.kernel.org/project/kvm/patch/20220224212314.1326-20-gdawar@xilinx.com/

Longpeng (2):
  vdpa: support exposing the config size to userspace
  vdpa: support exposing the count of vqs to userspace

 drivers/vdpa/vdpa.c        |  6 +++---
 drivers/vhost/vdpa.c       | 40 ++++++++++++++++++++++++++++++++++++----
 include/linux/vdpa.h       |  9 +++++----
 include/uapi/linux/vhost.h |  7 +++++++
 4 files changed, 51 insertions(+), 11 deletions(-)

-- 
1.8.3.1

