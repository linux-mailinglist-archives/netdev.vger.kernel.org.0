Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A936F7491
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKKNMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:12:18 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6187 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbfKKNMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 08:12:17 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BBD124C60CECA1C89D5E;
        Mon, 11 Nov 2019 21:12:03 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 11 Nov 2019
 21:11:53 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <irusskikh@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 0/2] net: atlantic: make some symbol & function static
Date:   Mon, 11 Nov 2019 21:19:15 +0800
Message-ID: <1573478357-71751-1-git-send-email-zhengbin13@huawei.com>
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
  net: atlantic: make symbol 'aq_pm_ops' static
  net: atlantic: make function
    'aq_ethtool_get_priv_flags','aq_ethtool_set_priv_flags' static

 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c  | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--
2.7.4

