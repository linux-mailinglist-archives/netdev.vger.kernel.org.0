Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC3E267C0B
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgILThG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgILTg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 15:36:59 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC74C0613ED
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 12:36:58 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4BpjYY3dqnzQlK8;
        Sat, 12 Sep 2020 21:36:49 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id YwgyIcJMVzSN; Sat, 12 Sep 2020 21:36:46 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com, eric.dumazet@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 0/4] net: lantiq: Fix bugs in NAPI handling
Date:   Sat, 12 Sep 2020 21:36:25 +0200
Message-Id: <20200912193629.1586-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 2.58 / 15.00 / 15.00
X-Rspamd-Queue-Id: 782C114E4
X-Rspamd-UID: 4984f9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes multiple bugs in the NAPI handling.

Changes since:
v1:
 - removed stable tag from "net: lantiq: use netif_tx_napi_add() for TX NAPI"
 - Check the NAPI budged in "net: lantiq: Use napi_complete_done()"
 - Add extra fix "net: lantiq: Disable IRQs only if NAPI gets scheduled"

Hauke Mehrtens (4):
  net: lantiq: Wake TX queue again
  net: lantiq: use netif_tx_napi_add() for TX NAPI
  net: lantiq: Use napi_complete_done()
  net: lantiq: Disable IRQs only if NAPI gets scheduled

 drivers/net/ethernet/lantiq_xrx200.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

-- 
2.20.1

