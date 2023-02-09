Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5566901F8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBIIRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIIRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:17:44 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7172367E4;
        Thu,  9 Feb 2023 00:17:43 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,283,1669042800"; 
   d="scan'208";a="152222914"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 09 Feb 2023 17:17:43 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 2F17640134F8;
        Thu,  9 Feb 2023 17:17:43 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v3 0/4] net: renesas: rswitch: Improve TX timestamp accuracy
Date:   Thu,  9 Feb 2023 17:17:37 +0900
Message-Id: <20230209081741.2536034-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is based on next-20230206.

The patch [[123]/4] are minor refacoring for readability.
The patch [4/4] is for improving TX timestamp accuracy.
To improve the accuracy, it requires refactoring so that this is not
a fixed patch.

Changes from v2:
https://lore.kernel.org/all/20230208235721.2336249-1-yoshihiro.shimoda.uh@renesas.com/
 - Fix sparse warnings in the patch [4/4].

Changes from v1:
https://lore.kernel.org/all/20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com/
 - Revise the patch description in the patch [3/4].

Yoshihiro Shimoda (4):
  net: renesas: rswitch: Rename rings in struct rswitch_gwca_queue
  net: renesas: rswitch: Move linkfix variables to rswitch_gwca
  net: renesas: rswitch: Remove gptp flag from rswitch_gwca_queue
  net: renesas: rswitch: Improve TX timestamp accuracy

 drivers/net/ethernet/renesas/rswitch.c | 295 ++++++++++++++++++-------
 drivers/net/ethernet/renesas/rswitch.h |  46 +++-
 2 files changed, 248 insertions(+), 93 deletions(-)

-- 
2.25.1

