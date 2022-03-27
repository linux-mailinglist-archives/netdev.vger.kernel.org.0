Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AED4E851B
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiC0Cz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiC0Czt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD3F245A2;
        Sat, 26 Mar 2022 19:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B705B80BA9;
        Sun, 27 Mar 2022 02:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806CDC34100;
        Sun, 27 Mar 2022 02:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349648;
        bh=SQPfqsNvIbtB/mPXmku6u4/+/U4nHoOxy19MUhP3/U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzVIXpVKjdjcVtemyBz3wm6wjT0mINQ5aZyPHCN/i8zyBypJysYt+C9MK+cFUOAYN
         CQ1ETy4kowb2taKzzwZa3MZnDeqB4CtJ5KMrZmuxfosOy1qlTz9O++D3d9V1+DqU53
         /7ZLat9w5WH3rNMlh24vx8/lhZMw4c+uRenl21jG8TeH5RNSyqKcFZ2WutaTQa42UP
         zx+PVzpHM6ZcAJ0k8Sxs20QjWuM6DVkzeETSvj883kxQ6xcim3y7SuNfdJHDD3dyH+
         y9rKOp+ZgD3EGt655nSjat/CRifxEqB/VndOsceKhbAtk/+dKj00cyYvmiYbTUF/2M
         gduzhxC8d26OA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 01/13] docs: netdev: replace references to old archives
Date:   Sat, 26 Mar 2022 19:53:48 -0700
Message-Id: <20220327025400.2481365-2-kuba@kernel.org>
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

Most people use (or should use) lore at this point.
Replace the pointers to older archiving systems.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index e26532f49760..25b8a7de737c 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -16,10 +16,8 @@ Note that some subsystems (e.g. wireless drivers) which have a high
 volume of traffic have their own specific mailing lists.
 
 The netdev list is managed (like many other Linux mailing lists) through
-VGER (http://vger.kernel.org/) and archives can be found below:
-
--  http://marc.info/?l=linux-netdev
--  http://www.spinics.net/lists/netdev/
+VGER (http://vger.kernel.org/) with archives available at
+https://lore.kernel.org/netdev/
 
 Aside from subsystems like that mentioned above, all network-related
 Linux development (i.e. RFC, review, comments, etc.) takes place on
-- 
2.34.1

