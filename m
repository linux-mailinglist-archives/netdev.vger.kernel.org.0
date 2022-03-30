Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6E54EB974
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbiC3E07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbiC3E06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:26:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C44CDF12;
        Tue, 29 Mar 2022 21:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F4161550;
        Wed, 30 Mar 2022 04:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968FEC340F0;
        Wed, 30 Mar 2022 04:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614312;
        bh=U+RoGeVHl41hvHJbe4CNBvquzt03zw4gxBoZIfdKUws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9YRWp6Id4s99rqTmtqXl/okNYYgNqOWMFLMEtMML3+mmnQ05N+pvwPh+8QVS0WEE
         Qukzw5mrEt3GznuZFM3vVNGidCGKMb/1cxP9teDQ1ngR62vgnFnxL84gMZL+blf2O5
         QWzzPeVwGEWuyWDOlso9+YRw94fZoxezNEg6OZKk/L57i07X/9v1PKGDVcZg1pN6sq
         gieJPtxd6SBxfcLD6BgRanv95Yr8dlM6PWBQfhEQVrpbAWMFRe7II0m+bsSMLgoP4n
         vp0NW7u9qHaho9yB4D4unsIElNNKb9Ept7cOU6JBb/USciFwHvA3TKJ/aaReL828YF
         xaIkJZJNn1nWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 01/14] docs: netdev: replace references to old archives
Date:   Tue, 29 Mar 2022 21:24:52 -0700
Message-Id: <20220330042505.2902770-2-kuba@kernel.org>
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

Most people use (or should use) lore at this point.
Replace the pointers to older archiving systems.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

