Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0E76E9075
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbjDTKkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbjDTKjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:39:48 -0400
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AAA5FFC
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:38:02 -0700 (PDT)
X-QQ-mid: bizesmtp63t1681987073tsr65b2n
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 20 Apr 2023 18:37:44 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: j86OQQvu8eQnMYKEo+CmHvC17OuqV7fJ7MsFC5LFhJeIW4KSq9K0EgNnmFjfk
        CVJZ5tg1N15UXFWgzjIegIz1CaPF6pR1m+LY+UJ3uczl/AxsMkzBG8Wjihi8wMCM5Y+qDRW
        AOowtJtrue+wzsT1ooW/d8tWG0o+saUZw4SYLp7iVpVrE8UFe+5lq101BJgCzC03uTts0sW
        KNMWIA0kYCjcL9XRwKf1mYu4n6DoUKlU3+O3831QAcNiNab0+jli3kkk4DMBtW2b+e28AH5
        Qniyuu72pIZPLRBLFq/EsLq6JdbTugDsxOq2cQVoQ8FmklgspROQ8fSp5AX8kxq0oQHW0H7
        WiC0r+omOu37LG8d50GOkd5HnLChYeU2AuXdTd5FxM9/ZhPkIZU98nWWxA6tjMWT0200N96
        900gGP+jxi4=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 10783789380104572420
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, linyunsheng@huawei.com,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v3 0/5] Wangxun netdev features support
Date:   Thu, 20 Apr 2023 18:37:37 +0800
Message-Id: <20230420103742.43168-1-mengyuanlou@net-swift.com>
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

changes v3:
- Yunsheng Lin: Tidy up logic for wx_encode_tx_desc_ptype.
changes v2:
- Andrew Lunn:
 Add ETH_P_CNM Congestion Notification Message to if_ether.h.
 Remove lro support.
- Yunsheng Lin:
 https://lore.kernel.org/netdev/eb75ae23-8c19-bbc5-e99a-9b853511affa@huawei.com/

Mengyuan Lou (5):
  net: wangxun: libwx add tx offload functions
  net: wangxun: libwx add rx offload functions
  net: wangxun: Implement vlan add and kill functions
  net: wangxun: ngbe add netdev features support
  net: wangxun: txgbe add netdev features support

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 279 +++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 624 +++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 421 +++++++++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  19 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  24 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 8 files changed, 1352 insertions(+), 20 deletions(-)

-- 
2.40.0

