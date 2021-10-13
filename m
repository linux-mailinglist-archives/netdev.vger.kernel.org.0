Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6254042B98F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbhJMHw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:52:58 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13732 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238626AbhJMHwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:52:53 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HTl6J0c8hzWl7w;
        Wed, 13 Oct 2021 15:49:12 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 13 Oct 2021 15:50:48 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <krzysztof.kozlowski@canonical.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/2] fix two possible memory leak problems in NFC digital module
Date:   Wed, 13 Oct 2021 15:49:53 +0800
Message-ID: <cover.1634111083.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two possible memory leak problems in NFC digital module.

Ziyang Xuan (2):
  NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
  NFC: digital: fix possible memory leak in digital_in_send_sdd_req()

 net/nfc/digital_core.c       | 9 +++++++--
 net/nfc/digital_technology.c | 8 ++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

-- 
2.25.1

