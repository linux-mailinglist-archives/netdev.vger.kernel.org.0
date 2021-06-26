Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D1F3B4CA7
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 06:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFZEnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 00:43:22 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12030 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhFZEnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 00:43:21 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBh1v4SPrzZjcP;
        Sat, 26 Jun 2021 12:37:55 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 12:40:58 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 26 Jun
 2021 12:40:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>
Subject: [PATCH net-next 0/3] fix some bugs for sparx5
Date:   Sat, 26 Jun 2021 12:44:17 +0800
Message-ID: <20210626044420.390517-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Yang Yingliang (3):
  net: sparx5: check return value after calling platform_get_resource()
  net: sparx5: fix return value check in sparx5_create_targets()
  net: sparx5: fix error return code in
    sparx5_register_notifier_blocks()

 drivers/net/ethernet/microchip/sparx5/sparx5_main.c      | 8 ++++++--
 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c | 4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
2.25.1

