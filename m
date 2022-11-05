Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A84E61D897
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 09:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKEIHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 04:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEIHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 04:07:41 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFDC2AE39;
        Sat,  5 Nov 2022 01:07:39 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N498L665hz15MLl;
        Sat,  5 Nov 2022 16:07:30 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 5 Nov
 2022 16:07:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jiawenwu@trustnetic.com>, <mengyuanlou@net-swift.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next 0/2] net: txgbe: Fix two bugs in txgbe_calc_eeprom_checksum
Date:   Sat, 5 Nov 2022 16:07:20 +0800
Message-ID: <20221105080722.20292-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix memleak and unsigned comparison bugs in txgbe_calc_eeprom_checksum

YueHaibing (2):
  net: txgbe: Fix memleak in txgbe_calc_eeprom_checksum()
  net: txgbe: Fix unsigned comparison to zero in
    txgbe_calc_eeprom_checksum()

 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.17.1

