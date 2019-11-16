Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BDCFEB23
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 08:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfKPHeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 02:34:20 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6683 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbfKPHeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 02:34:20 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9836EEBD5AF8DA211DA2;
        Sat, 16 Nov 2019 15:34:06 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 16 Nov 2019
 15:33:59 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <stas.yakovlev@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next 0/2] ipw2x00: remove some set but not used variables
Date:   Sat, 16 Nov 2019 15:41:21 +0800
Message-ID: <1573890083-33761-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin (2):
  ipw2x00: remove set but not used variable 'reason'
  ipw2x00: remove set but not used variable 'force_update'

 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 3 +--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 3 ---
 2 files changed, 1 insertion(+), 5 deletions(-)

--
2.7.4

