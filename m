Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3084EB997
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242536AbiC3E1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242545AbiC3E1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:27:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5B3E0A6;
        Tue, 29 Mar 2022 21:25:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D76FAB81B34;
        Wed, 30 Mar 2022 04:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B54C34112;
        Wed, 30 Mar 2022 04:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614317;
        bh=HuGkOYeCEuEsc3HuodeCEqEow7DthokmDdOaxcQStg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upUEvqpOhTiPhi0lu00Lx2Bc17BPACsqQY00D9GNEUQQzkPNoC8NNGYFR93Q8xg7D
         p4eYwqbP6DkzVQYqHjRKU07ghoc2t39R5cbmtGnoWOo5JETB7FlGhNn+AqJ75q0sV/
         CXtok/DQPf3fLv3pNHgga4yGdRgwaMyeRKII8UxcngKTAJvw/qRgvcZBUx9XkVEsLZ
         BNBxtwrQc+HdGr6NnnT8xjEYfz13xERuQLcPTYHK/VWKOf9bJeXq2FOub97NA1D5FD
         obGgv6VNnvLueaDg+2Zu2I+xSbGagufu/3WCPu2bsRT+pDE6jXWXDVjr+VbipdEU5W
         N+YvvZ3vxsBmw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 11/14] docs: netdev: add missing back ticks
Date:   Tue, 29 Mar 2022 21:25:02 -0700
Message-Id: <20220330042505.2902770-12-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330042505.2902770-1-kuba@kernel.org>
References: <20220330042505.2902770-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think double back ticks are more correct. Add where they are missing.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 1388f78cfbc5..294ad9b0162d 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -218,7 +218,7 @@ or the user space project is not reviewed on netdev include a link
 to a public repo where user space patches can be seen.
 
 In case user space tooling lives in a separate repository but is
-reviewed on netdev  (e.g. patches to `iproute2` tools) kernel and
+reviewed on netdev  (e.g. patches to ``iproute2`` tools) kernel and
 user space patches should form separate series (threads) when posted
 to the mailing list, e.g.::
 
@@ -251,18 +251,18 @@ traffic if we can help it.
 netdevsim is great, can I extend it for my out-of-tree tests?
 -------------------------------------------------------------
 
-No, `netdevsim` is a test vehicle solely for upstream tests.
-(Please add your tests under tools/testing/selftests/.)
+No, ``netdevsim`` is a test vehicle solely for upstream tests.
+(Please add your tests under ``tools/testing/selftests/``.)
 
-We also give no guarantees that `netdevsim` won't change in the future
+We also give no guarantees that ``netdevsim`` won't change in the future
 in a way which would break what would normally be considered uAPI.
 
 Is netdevsim considered a "user" of an API?
 -------------------------------------------
 
 Linux kernel has a long standing rule that no API should be added unless
-it has a real, in-tree user. Mock-ups and tests based on `netdevsim` are
-strongly encouraged when adding new APIs, but `netdevsim` in itself
+it has a real, in-tree user. Mock-ups and tests based on ``netdevsim`` are
+strongly encouraged when adding new APIs, but ``netdevsim`` in itself
 is **not** considered a use case/user.
 
 Any other tips to help ensure my net/net-next patch gets OK'd?
-- 
2.34.1

