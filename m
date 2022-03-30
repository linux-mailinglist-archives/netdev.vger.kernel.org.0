Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1A44EB97A
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242514AbiC3E1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiC3E06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:26:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3DBDF58;
        Tue, 29 Mar 2022 21:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4BB61552;
        Wed, 30 Mar 2022 04:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B58EC34112;
        Wed, 30 Mar 2022 04:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614312;
        bh=ibPzGpYP5ul+5VCwSW0FJEX+gMTvTy87AoOUvx1t1b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gENQQOITiXvTvlLW1paZURN/arNkdkzqbUnpqtvSP4miMNGZeI9Ji9uNEEc8ETnLU
         SSu19DbQ7zKvqMFHsYlChkFnO+mPeTnO2C1dVpxB94VVDigH8aimFdNq7iJo2JYLXI
         sbUqAfsEwy36xI43jHr9lpvGSIV68pFxGCNZn6nlHOoPZvUKriRPtkJMh8YC7iEZBA
         Q9+A0gdHMrXn5Ool+hgrbmy/AKck5MwoTmMsTuWoPCYVryVHa3qortECi+SLuYa1TR
         utbABR+wbBuAgySfH2eWLxM2+4ou046/C+hz8ROi/8vygW15wLyJOMrwovvKE/0mGi
         kZfEd4iUl4W9Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 02/14] docs: netdev: minor reword
Date:   Tue, 29 Mar 2022 21:24:53 -0700
Message-Id: <20220330042505.2902770-3-kuba@kernel.org>
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

that -> those

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

