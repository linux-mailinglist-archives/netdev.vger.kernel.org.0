Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F32A6E45F9
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjDQLDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjDQLDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:03:21 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4AD3A80
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:02:37 -0700 (PDT)
X-QQ-mid: bizesmtp75t1681728908t0dqma53
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 17 Apr 2023 18:54:59 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: xQoAiglG4R7nGnH2mgrK2BTsKIc58zx1BBn6T/FylFhJEmuJLZUy8No7ta/uB
        4LDIS/aLfJKKq7tlUlgT/D3kdGbzbmR0GyPvI98n4lTK4XFORREt7HCbSf8UarXBtvbLyqg
        gcIWw5r5uydmFSkU5SQ1fkA2j92dPDFA8KRfeB/wDCQ6AG2AGOI4qmZx/Q2mA0gUyaREnqf
        vC61F/P2PNJ1JhM8lrfn0uSyXzvKC33ooLm6mzbi1jKiuJ5lFXXV6WaM/9/l7bj496DeTXl
        xSbUxqAyAQP1HFJIWQH1fxbq1kk/oKOS8vK2BRh/df4dAKbM/V2St19LYnyH9wXRPZ0hP5L
        FPLGkpAiCX4VsBQAPGOIcM2LteA/+M+DbhRy0AHdeRSUlceJ5lBnv/3rWQBjw==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 14519736068612147149
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 0/5] Wangxun netdev features support
Date:   Mon, 17 Apr 2023 18:54:52 +0800
Message-Id: <20230417105457.82127-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement tx_csum and rx_csum to support hardware checksum offload.
Implement ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
Enable macros in netdev features which wangxun can support.

changes v2:
- Andrew Lunn:
  Add ETH_P_CNM Congestion Notification Message to if_ether.h.
  Remove lro support.
- Yunsheng Lin:
  https://lore.kernel.org/netdev/eb75ae23-8c19-bbc5-e99a-9b853511affa@huawei.com/

Mengyuan Lou (4):
  net: wangxun: libwx add rx offload functions
  net: wangxun: Implement vlan add and kill functions
  net: wangxun: ngbe add netdev features support
  net: wangxun: txgbe add netdev features support

mengyuanlou (1):
  net: wangxun: libwx add tx offload functions

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 279 +++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 650 +++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 514 +++++++++++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  19 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  24 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 include/uapi/linux/if_ether.h                 |   1 +
 9 files changed, 1473 insertions(+), 19 deletions(-)

-- 
2.40.0

