Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE40B26491E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 17:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbgIJPxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 11:53:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11805 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731468AbgIJPxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:53:22 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 29F16B96951B54FD42BC;
        Thu, 10 Sep 2020 23:07:11 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 23:07:10 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/3] Fix some kernel-doc warnings for e1000/e1000e
Date:   Thu, 10 Sep 2020 23:04:26 +0800
Message-ID: <20200910150429.31912-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai (3):
  e1000e: Fix some kernel-doc warnings in ich8lan.c
  e1000e: Fix some kernel-doc warnings in netdev.c
  e1000: Fix a bunch of kerneldoc parameter issues in e1000_hw.c

 drivers/net/ethernet/intel/e1000/e1000_hw.c | 7 +------
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c  | 6 ++----
 3 files changed, 5 insertions(+), 12 deletions(-)

-- 
2.17.1

