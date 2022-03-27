Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D248E4E851C
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiC0Cz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiC0Czu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C96DFD8;
        Sat, 26 Mar 2022 19:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D883B80BE6;
        Sun, 27 Mar 2022 02:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EFAC34110;
        Sun, 27 Mar 2022 02:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349649;
        bh=+Vb/d+QtzOBqo/ycx6OvL5BZXjJUpw7EnMkEx/Q0eC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWEjMvEwlgDqwkunKwGC3zlUD5jTH7ForzlkncatY3oGKdCutI0EG6ibVLjE/DQLr
         okHqNHHdA2bfGp9Wk0zzzsEmct+gwi5gxINO+PhIEt+AOzHCMk8+5O3177VPXRtHHv
         ixjoIGP+7leuG0BmZx+EnV3oheyTp8S2/QvtiAAgnHnh6akrRg5sLGUUBxY878Tv2I
         krS0KW35OMhoN8hqkcY61MYg5TQJ9R6eIi6ppwJsHyW4O1TR5FnApX99wNnFrsBP+q
         5eRxiONmHO6Q47K4MDDMuJoWczJJcp2BnTkRRqthHsgN5FRts/3shdqBMdih2nDjR3
         rwBPbjxJM0wUw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 02/13] docs: netdev: minor reword
Date:   Sat, 26 Mar 2022 19:53:49 -0700
Message-Id: <20220327025400.2481365-3-kuba@kernel.org>
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

that -> those

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 25b8a7de737c..f7e5755e013e 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -19,7 +19,7 @@ The netdev list is managed (like many other Linux mailing lists) through
 VGER (http://vger.kernel.org/) with archives available at
 https://lore.kernel.org/netdev/
 
-Aside from subsystems like that mentioned above, all network-related
+Aside from subsystems like those mentioned above, all network-related
 Linux development (i.e. RFC, review, comments, etc.) takes place on
 netdev.
 
-- 
2.34.1

