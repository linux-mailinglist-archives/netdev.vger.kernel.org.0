Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0A268FBB8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjBHX5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjBHX5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:57:30 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B38B1E1E4;
        Wed,  8 Feb 2023 15:57:29 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,281,1669042800"; 
   d="scan'208";a="148941672"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 09 Feb 2023 08:57:28 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id B4BAD40029BF;
        Thu,  9 Feb 2023 08:57:28 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v2 0/4] net: renesas: rswitch: Improve TX timestamp accuracy
Date:   Thu,  9 Feb 2023 08:57:17 +0900
Message-Id: <20230208235721.2336249-1-yoshihiro.shimoda.uh@renesas.com>
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

