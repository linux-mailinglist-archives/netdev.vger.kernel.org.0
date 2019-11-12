Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5998F8907
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfKLGwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:52:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6201 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727387AbfKLGwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 01:52:34 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0EE70C2892068A850084;
        Tue, 12 Nov 2019 14:52:27 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 12 Nov 2019
 14:52:18 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <irusskikh@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH net-next v2 0/2] net: atlantic: make some symbol & function static
Date:   Tue, 12 Nov 2019 14:59:40 +0800
Message-ID: <1573541982-100413-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2: add Fixes tag

zhengbin (2):
  net: atlantic: make symbol 'aq_pm_ops' static
  net: atlantic: make function
    'aq_ethtool_get_priv_flags','aq_ethtool_set_priv_flags' static

 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c  | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--
2.7.4

