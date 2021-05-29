Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18147394A05
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 05:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhE2DBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 23:01:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2456 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhE2DBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 23:01:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FsR6d3Z3wz66ST;
        Sat, 29 May 2021 10:57:13 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 11:00:07 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 29 May
 2021 11:00:07 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next 0/2] net: dsa: qca8k: check return value of read  functions correctly
Date:   Sat, 29 May 2021 11:04:37 +0800
Message-ID: <20210529030439.1723306-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch #1 - Change return type and add output parameter to make check
return value of read  functions correctly.

patch #2 - Add missing check return value in qca8k_phylink_mac_config().

v2:
  move 'int ret' to patch #2.

Yang Yingliang (2):
  net: dsa: qca8k: check return value of read functions correctly
  net: dsa: qca8k: add missing check return value in
    qca8k_phylink_mac_config()

 drivers/net/dsa/qca8k.c | 135 +++++++++++++++++++---------------------
 1 file changed, 65 insertions(+), 70 deletions(-)

-- 
2.25.1

