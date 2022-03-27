Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A24E852E
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiC0C4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiC0Czy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D5EDFD8;
        Sat, 26 Mar 2022 19:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B8E8B80BEB;
        Sun, 27 Mar 2022 02:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99354C3410F;
        Sun, 27 Mar 2022 02:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349653;
        bh=fZ0EYz2DjIW4qH93e1IVyGOAJ3sfRxIRBbhQEX5FPEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkC4ixd/Nsp/FD5THosq2yAT10UtmpmfRMssyPee9Si60MWm5LnKcYlHFneYJnp/o
         a/RemIgalRxZovCAaIx6h3ahLGnJpatIo/5V4oXTxN1fOaUWm8kQS0U54CgrcHq3gP
         HsXx0nyM9L6tT9e6hlEu+8BAc2yz+HuhV/sdHGrPRlz+Xwj9VOcJYCsOdbfJoI7O/p
         ee0xjPr9tnLh/wir3jJGdjvtcW76S85xUSF3hJnyKBuPX7FpyWStIh7xNY5R1R7Ks5
         YgtCBR8vnWSL2ps0edD3YRUOciqy9k10decn32YXpb+rnlJF6IAATMwud5DfVKY86R
         vVJqpRglz2VPQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 12/13] docs: netdev: broaden the new vs old code formatting guidelines
Date:   Sat, 26 Mar 2022 19:53:59 -0700
Message-Id: <20220327025400.2481365-13-kuba@kernel.org>
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

Convert the "should I use new or old comment formatting" to cover
all formatting. This makes the question itself shorter.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index a7367a757a4b..47ea5d052c0b 100644
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

