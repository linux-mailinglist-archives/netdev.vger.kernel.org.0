Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E9A6730CE
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjASE55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjASE5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:57:38 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CEAA2C647;
        Wed, 18 Jan 2023 20:49:37 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,226,1669042800"; 
   d="scan'208";a="146811644"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 19 Jan 2023 13:39:23 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 8F3684188CFF;
        Thu, 19 Jan 2023 13:39:23 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net 0/2] net: ravb: Fix potential issues
Date:   Thu, 19 Jan 2023 13:39:18 +0900
Message-Id: <20230119043920.875280-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix potentiall issues on the ravb driver.

Yoshihiro Shimoda (2):
  net: ravb: Fix lack of register setting after system resumed for Gen3
  net: ravb: Fix possible hang if RIS2_QFF1 happen

 drivers/net/ethernet/renesas/ravb_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.25.1

