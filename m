Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072E1EB191
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfJaNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:50:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59554 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727579AbfJaNuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 09:50:22 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1C73B59FE9553B621C98;
        Thu, 31 Oct 2019 21:50:21 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 21:50:12 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH 0/3] wireless: remove unneeded variable and return 0
Date:   Thu, 31 Oct 2019 21:46:17 +0800
Message-ID: <1572529580-26594-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue is detected with help of coccinelle

zhong jiang (3):
  ipw2x00: Remove redundant variable "rc"
  iwlegacy: Remove redundant variable "ret"
  b43legacy: ASoC: ux500: Remove redundant variable "count"

 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 9 +++------
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c    | 4 ++--
 drivers/net/wireless/intel/iwlegacy/4965-mac.c    | 3 +--
 3 files changed, 6 insertions(+), 10 deletions(-)

-- 
1.7.12.4

