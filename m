Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E268620C60
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiKHJgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiKHJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:36:10 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4880020F57;
        Tue,  8 Nov 2022 01:36:08 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N62tz1W2HzpWFG;
        Tue,  8 Nov 2022 17:32:27 +0800 (CST)
Received: from localhost.localdomain (10.175.103.91) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 17:36:06 +0800
From:   Wei Li <liwei391@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <huawei.libin@huawei.com>
Subject: [PATCH v1 0/3] rtlwifi: Correct inconsistent header guard
Date:   Tue, 8 Nov 2022 17:34:44 +0800
Message-ID: <20221108093447.3588889-1-liwei391@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes some inconsistent header guards in module
rtl8188ee/rtl8723ae/rtl8192de, that may be copied but missing update.

Wei Li (3):
  rtlwifi: rtl8188ee: Correct the header guard of rtl8188ee/*.h
  rtlwifi: rtl8723ae: Correct the header guard of
    rtl8723ae/{fw,led,phy}.h
  rtlwifi: rtl8192de: Correct the header guard of rtl8192de/{dm,led}.h

 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h  | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h    | 4 ++--
 16 files changed, 32 insertions(+), 32 deletions(-)

-- 
2.25.1

