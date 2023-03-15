Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBE16BA8A8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjCOHE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCOHEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:04:41 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08206213F;
        Wed, 15 Mar 2023 00:04:39 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,262,1673881200"; 
   d="scan'208";a="156005157"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 15 Mar 2023 16:04:39 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 61790418A02B;
        Wed, 15 Mar 2023 16:04:39 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net 0/2] net: renesas: rswitch: Fix rx and timestamp
Date:   Wed, 15 Mar 2023 16:04:22 +0900
Message-Id: <20230315070424.1088877-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got reports locally about issues on the rswitch driver.
So, fix the issues.

Yoshihiro Shimoda (2):
  net: renesas: rswitch: Fix the output value of quote from rswitch_rx()
  net: renesas: rswitch: Fix GWTSDIE register handling

 drivers/net/ethernet/renesas/rswitch.c | 19 ++++++++++++++-----
 drivers/net/ethernet/renesas/rswitch.h |  1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

-- 
2.25.1

