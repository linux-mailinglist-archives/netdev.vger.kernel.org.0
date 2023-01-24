Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9744F678C6E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 01:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjAXACR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 19:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbjAXACP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 19:02:15 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D096F23C4C;
        Mon, 23 Jan 2023 16:02:14 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,240,1669042800"; 
   d="scan'208";a="147236827"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 24 Jan 2023 09:02:14 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id D6D664008C7E;
        Tue, 24 Jan 2023 09:02:13 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net v3 0/2] net: ravb: Fix potential issues
Date:   Tue, 24 Jan 2023 09:02:09 +0900
Message-Id: <20230124000211.1426624-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix potentiall issues on the ravb driver.

Changes from v2:
https://lore.kernel.org/all/20230123131331.1425648-1-yoshihiro.shimoda.uh@renesas.com/
 - Add Reviewed-by in the patch [2/2].
 - Add a commit description in the patch [2/2].

Changes from v1:
https://lore.kernel.org/all/20230119043920.875280-1-yoshihiro.shimoda.uh@renesas.com/
 - Fix typo in the patch [1/2].
 - Add Reviewed-by in the patch [1/2].
 - Fix "Fixed" tag in the patch [2/2].
 - Fix a comment indentation of the code in the patch [2/2].

Yoshihiro Shimoda (2):
  net: ravb: Fix lack of register setting after system resumed for Gen3
  net: ravb: Fix possible hang if RIS2_QFF1 happen

 drivers/net/ethernet/renesas/ravb_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.25.1

