Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAF4393E9E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 10:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhE1ITq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 04:19:46 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2387 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbhE1ITp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 04:19:45 -0400
Received: from dggeml706-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FryC95SNvz65ZC;
        Fri, 28 May 2021 16:14:29 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggeml706-chm.china.huawei.com (10.3.17.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 16:18:08 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 16:18:08 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>, <davem@davemloft.net>
Subject: [PATCH -next 0/2] net: dsa: qca8k: check return value of read  functions correctly
Date:   Fri, 28 May 2021 16:22:38 +0800
Message-ID: <20210528082240.3863991-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch #1 - Change return type and add output parameter to make check
return value of read  functions correctly.

patch #2 - Add missing check return value in qca8k_phylink_mac_config().

Yang Yingliang (2):
  net: dsa: qca8k: check return value of read functions correctly
  net: dsa: qca8k: add missing check return value in
    qca8k_phylink_mac_config()

 drivers/net/dsa/qca8k.c | 135 +++++++++++++++++++---------------------
 1 file changed, 65 insertions(+), 70 deletions(-)

-- 
2.25.1

