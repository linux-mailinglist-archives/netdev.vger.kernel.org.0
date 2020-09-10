Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873F5264F92
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgIJTqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:46:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57266 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731257AbgIJP3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:29:34 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2773398BEAE6FDF66E8E;
        Thu, 10 Sep 2020 23:12:18 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 23:12:17 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/3] Fix some kernel-doc warnings for i40e
Date:   Thu, 10 Sep 2020 23:09:31 +0800
Message-ID: <20200910150934.34605-1-wanghai38@huawei.com>
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
  i40e: Fix some kernel-doc warnings in i40e_client.c
  i40e: Fix some kernel-doc warnings in i40e_common.c
  i40e: Fix a kernel-doc warning in i40e_ptp.c

 drivers/net/ethernet/intel/i40e/i40e_client.c | 2 --
 drivers/net/ethernet/intel/i40e/i40e_common.c | 2 --
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    | 1 -
 3 files changed, 5 deletions(-)

-- 
2.17.1

