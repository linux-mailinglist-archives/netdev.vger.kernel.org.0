Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9CB4EB998
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242595AbiC3E1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242536AbiC3E1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4276DDFFE;
        Tue, 29 Mar 2022 21:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D188C61552;
        Wed, 30 Mar 2022 04:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485D3C34110;
        Wed, 30 Mar 2022 04:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614318;
        bh=RbzcFqOr0G6u+c1ZbQeSdrw2wYhqK0hXqhtZD8w4ywQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oURXZ/feWZF+COAe5l4bLfI7dio89kk/NwTkI1z5UmT59/odmgNTK+myPa+tMMAyC
         l2o+zVAGDuhd+25OJVHtD/7yLolE359LFIJq7wIsvdD8OiCit7lqSbN/GZzzMHyKns
         3Ux23KQc4LM9DvWOfms6F4RInPnT1c7/jRkybWbgEtOw+zrCGcwsgNwSqiWGjOq/OH
         Z6qQ8bFliYZqI+zYfY95spj0YpGGX/wSA83G1zBouQmWONMp8Jm+bWIk+QP3lyrZGp
         +9KyKERJUp0NwPSXwj2frGXyPhRavBdATQnIZuddh25Tmim1jRkztp9oalmWtz7tRv
         R0AM9qFGnESKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 13/14] docs: netdev: broaden the new vs old code formatting guidelines
Date:   Tue, 29 Mar 2022 21:25:04 -0700
Message-Id: <20220330042505.2902770-14-kuba@kernel.org>
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

Convert the "should I use new or old comment formatting" to cover
all formatting. This makes the question itself shorter.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index a18e4e671e85..c456b5225d66 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -183,10 +183,10 @@ Is the comment style convention different for the networking content?
    * another line of text
    */
 
-I am working in existing code that has the former comment style and not the latter. Should I submit new code in the former style or the latter?
------------------------------------------------------------------------------------------------------------------------------------------------
-Make it the latter style, so that eventually all code in the domain
-of netdev is of this format.
+I am working in existing code which uses non-standard formatting. Which formatting should I use?
+------------------------------------------------------------------------------------------------
+Make your code follow the most recent guidelines, so that eventually all code
+in the domain of netdev is in the preferred format.
 
 I found a bug that might have possible security implications or similar. Should I mail the main netdev maintainer off-list?
 ---------------------------------------------------------------------------------------------------------------------------
-- 
2.34.1

