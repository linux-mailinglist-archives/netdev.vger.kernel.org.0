Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627404EA6FE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiC2FK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiC2FKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FA7BC92;
        Mon, 28 Mar 2022 22:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EF53B8128F;
        Tue, 29 Mar 2022 05:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DC5C34116;
        Tue, 29 Mar 2022 05:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530531;
        bh=hi1FoOl5SFC8RxD/oG8PLi6b4942NDmvCh7csz/0tD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1k9yPcikxXQ/62q87WBP4r1MghH9UjyPYGQSsi5uvNfHG249QkoIrK+JK9BCZA3v
         EkddNFmK/Dg4xkpEejG8OYa44dnmOhyVo87XUH8dE9P0h9AXWUL712QJThHkYisI83
         axkuq2Z+BbCZVxlaujhJHHQPM3U3qpTq+ylikfZUGZkppRTwN/2uhuTV/eDqEWQwND
         1p5M+ARswUjnu0NukCQ4bTSjz8UFFfUoMKTMkq6akvSCg15i1vUsZqnR/W1oSfa9nM
         9mkhgaBaWsR0R+TCg+el+xiT+Ycg33iYjdvOtlshukK8GA8RQCkn6KJRdbswRp0zLX
         r7GrXQV3pf69A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 13/14] docs: netdev: broaden the new vs old code formatting guidelines
Date:   Mon, 28 Mar 2022 22:08:29 -0700
Message-Id: <20220329050830.2755213-14-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329050830.2755213-1-kuba@kernel.org>
References: <20220329050830.2755213-1-kuba@kernel.org>
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

