Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BFEECDCD
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 09:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfKBI7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 04:59:30 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbfKBI7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 04:59:30 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7C1F2DBEDB2D07A25113;
        Sat,  2 Nov 2019 16:59:27 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 2 Nov 2019 16:59:17 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>,
        <simon.horman@netronome.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH v3 0/2] wireless: remove unneeded variable and return 0
Date:   Sat, 2 Nov 2019 16:55:20 +0800
Message-ID: <1572684922-61805-1-git-send-email-zhongjiang@huawei.com>
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

v2 -> v3:
    Remove [PATCH 3/3] of series. Because fappend will use the
    local variable.  

v1 -> v2:
    libipw_qos_convert_ac_to_parameters() make it void.

zhong jiang (2):
  ipw2x00: Remove redundant variable "rc"
  iwlegacy: Remove redundant variable "ret"

 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 +---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

-- 
1.7.12.4

