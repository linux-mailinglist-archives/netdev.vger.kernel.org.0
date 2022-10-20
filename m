Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FEE605BDE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiJTKKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiJTKKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:10:12 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 938684621C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:09:58 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 65F0460077;
        Thu, 20 Oct 2022 12:09:57 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1olSUv-0003b4-Ag; Thu, 20 Oct 2022 12:09:57 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Julian Anastasov <ja@ssi.bg>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH net 0/3] ip: rework the fix for dflt addr selection for connected nexthop"
Date:   Thu, 20 Oct 2022 12:09:49 +0200
Message-Id: <20221020100952.8748-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series reworks the fix that is reverted in the second commit.
As Julian explained, nhc_scope is related to nhc_gw, it's not the scope of
the route.

 net/ipv4/fib_frontend.c  | 4 ++--
 net/ipv4/fib_semantics.c | 2 +-
 net/ipv4/nexthop.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Comments are welcome.

Regards,
Nicolas

