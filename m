Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFEC434ABA
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhJTMG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:06:59 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26174 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhJTMG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 08:06:57 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HZ8QR2gyfz8tkQ;
        Wed, 20 Oct 2021 20:03:27 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 20 Oct 2021 20:04:41 +0800
Received: from huawei.com (10.175.104.82) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Wed, 20 Oct
 2021 20:04:40 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <kvalo@codeaurora.org>, <briannorris@chromium.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <shenyang39@huawei.com>,
        <marcelo@kvack.org>, <linville@tuxdriver.com>, <luisca@cozybit.com>
CC:     <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 wireless-drivers 0/2] libertas: Fix some memory leak bugs
Date:   Wed, 20 Oct 2021 20:03:43 +0800
Message-ID: <20211020120345.2016045-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes some memory leak bugs by adding the missing kfree().

v1->v2:
	1. Fix the wrong subject.
	2. Splitting the big patch into two separate patches.

Wang Hai (2):
  libertas_tf: Fix possible memory leak in probe and disconnect
  libertas: Fix possible memory leak in probe and disconnect

 drivers/net/wireless/marvell/libertas/if_usb.c    | 2 ++
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 2 ++
 2 files changed, 4 insertions(+)

-- 
2.25.1

