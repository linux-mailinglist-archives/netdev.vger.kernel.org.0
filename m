Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29C0EC2C2
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfKAMho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:37:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5687 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727806AbfKAMhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 08:37:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 02B56760E61FCB5E63A1;
        Fri,  1 Nov 2019 20:37:41 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Fri, 1 Nov 2019 20:37:33 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>,
        <simon.horman@netronome.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH v2 0/3] wireless: remove unneeded variable and return 0
Date:   Fri, 1 Nov 2019 20:33:38 +0800
Message-ID: <1572611621-13280-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue is detected with help of coccinelle.

v1 -> v2:
   libipw_qos_convert_ac_to_parameters() make it void.


zhong jiang (3):
  ipw2x00: Remove redundant variable "rc"
  iwlegacy: Remove redundant variable "ret"
  b43legacy: ASoC: ux500: Remove redundant variable "count"

 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 9 +++------
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c    | 4 +---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c    | 3 +--
 3 files changed, 5 insertions(+), 11 deletions(-)

-- 
1.7.12.4

