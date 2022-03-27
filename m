Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B374E8512
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiC0Czw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiC0Czs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E811FA73;
        Sat, 26 Mar 2022 19:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64C660EC7;
        Sun, 27 Mar 2022 02:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1962C3410F;
        Sun, 27 Mar 2022 02:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349650;
        bh=xem/WDbeiv1jg1Gf2N6sgo6Hsoixhq7r6N5ZpgXa7M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZ2DeQHuZQys1gawz8tOK+zMfHENie3DuEjAFDZKFVhdoOztlcs2tkmK+3t0eW6Mq
         nGGAkWWxqmKRuM1Rd+6tyvZwaPz9fYLY7JBM0vvt35Q2NQCyZqt6AbOfZIZSooXH2n
         gU28dhUn0H9sWcVDPxWqvLSQZiuZqm32IXKHNF3+Y626bNTJO0djjheFX1qxC3jCsN
         XgIRk2RntVAp/AqNkNoc4MUlaxSj+3zX0KQU1kJZqSnxGcr/M+pK9qlP9rvH15H8pb
         ZHn/3FZ9kVVNVpwQeG42/XUs2L4ReSOWJq/87GcllqFWlpk5h496hFPUDivt+aX6Px
         PZJVbNE30ZICw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 04/13] docs: netdev: turn the net-next closed into a Warning
Date:   Sat, 26 Mar 2022 19:53:51 -0700
Message-Id: <20220327025400.2481365-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220327025400.2481365-1-kuba@kernel.org>
References: <20220327025400.2481365-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the sphinx Warning box to make the net-next being closed
stand out more.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 0bff899f286f..c1683ed1faca 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -73,8 +73,9 @@ relating to vX.Y
 An announcement indicating when ``net-next`` has been closed is usually
 sent to netdev, but knowing the above, you can predict that in advance.
 
-IMPORTANT: Do not send new ``net-next`` content to netdev during the
-period during which ``net-next`` tree is closed.
+.. warning::
+  Do not send new ``net-next`` content to netdev during the
+  period during which ``net-next`` tree is closed.
 
 Shortly after the two weeks have passed (and vX.Y-rc1 is released), the
 tree for ``net-next`` reopens to collect content for the next (vX.Y+1)
-- 
2.34.1

