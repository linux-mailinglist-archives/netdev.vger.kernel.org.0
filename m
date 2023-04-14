Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12966E213D
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjDNKta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjDNKt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:49:29 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D548A41
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 03:49:07 -0700 (PDT)
X-QQ-mid: bizesmtp74t1681469323tcd6fl2x
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 14 Apr 2023 18:48:35 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: PS/N6jJLnDbDOeqaEHka8Xtyzrx1TXgoleI0w1ECQpNJ+RmZF9U/CpA2kZW2o
        wGKlOZclLRtmUB04V8PBO7MPKFzybvCGh38UpQziIwVv8e7En/sRdMCJfojKYHO8AX/XJ8z
        9KGLRP6VehM7ijzeh6mYKhfkU9VnHuxw/z0FysdI81EmT2TpoL31WWwmXyPwPS/xIDFUFxH
        //MQivsXRVY9UwcWkJm5JZpyJ1oL3H2zgz3HVTdpzm5WFH7FiMc3tbYusIuIrEBqwkAJwVD
        Mtyzwze7hn+NVG/gotNw9yYNsaQBs1gATgkWzrwEror3FD+Vd3RWRVElooAWvVbmuBE6E6g
        9UAXAtQrS8mPw64so2PWrLAeXVCO2GxtODAbSg+pPQJtinQvq/AzRgcsCOJqP/O32ApEfR1
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 15691204273217725154
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 0/5] Wangxun netdev features support
Date:   Fri, 14 Apr 2023 18:48:28 +0800
Message-Id: <20230414104833.42989-1-mengyuanlou@net-swift.com>
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

Mengyuan Lou (4):
  net: wangxun: libwx add rx offload functions
  net: wangxun: Implement vlan add and kill functions
  net: wangxun: ngbe add netdev features support
  net: wangxun: txgbe add netdev features support

mengyuanlou (1):
  net: wangxun: libwx add tx offload functions

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 279 ++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 995 +++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 695 ++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  19 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  24 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 8 files changed, 2000 insertions(+), 17 deletions(-)

-- 
2.40.0

