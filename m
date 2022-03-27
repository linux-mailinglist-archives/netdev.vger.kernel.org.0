Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72DE4E8516
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiC0Czz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbiC0Czs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0A32182D;
        Sat, 26 Mar 2022 19:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D797960EEA;
        Sun, 27 Mar 2022 02:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F442C34113;
        Sun, 27 Mar 2022 02:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349650;
        bh=SPdSfbhLQSOfNpuHBGoThbTO8srfvb+o/1lcDd4PLbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qezV1lKzXPTv8NldJ6ah700q2J6NTkrvYGFpbf2V9rvJ3QetMmrqAfiZfLqWpXnc2
         Ni0d8X2ZE8sfa1mUa/KGXsxQS5pty92bNWiFMnDUzP8dJfnAb8Jf5erTWW/tP5FV+A
         7ixmUO2Hug3GSyj2Rf66C1XXzVLLTelyLSTYSgMhzWSTVEZoKYzE0RUjzO9DtWhnh6
         Tz6z0NoAor8jI7YWXKCyJXzH4VIerZU9ubVshe55WuyifrfiSztqTluA6+5fo6Alsi
         AQS97HLSK+XslGu1x5UV4vKzX1B33XcPV8UFJcnYPw4PE1cooXt30Uzy7LiaGoRvuc
         abSPw1sqLCJWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 05/13] docs: netdev: shorten the name and mention msgid for patch status
Date:   Sat, 26 Mar 2022 19:53:52 -0700
Message-Id: <20220327025400.2481365-6-kuba@kernel.org>
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

Cut down the length of the question so it renders better in docs.
Mention that Message-ID can be used to search patchwork.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index c1683ed1faca..f0d452846d84 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -105,14 +105,16 @@ and note the top of the "tags" section.  If it is rc1, it is early in
 the dev cycle.  If it was tagged rc7 a week ago, then a release is
 probably imminent.
 
-I sent a patch and I'm wondering what happened to it - how can I tell whether it got merged?
---------------------------------------------------------------------------------------------
+How can I tell the status of a patch I've sent?
+-----------------------------------------------
 Start by looking at the main patchworks queue for netdev:
 
   https://patchwork.kernel.org/project/netdevbpf/list/
 
 The "State" field will tell you exactly where things are at with your
-patch.
+patch. Patches are indexed by the ``Message-ID`` header of the emails
+which carried them so if you have trouble finding your patch append
+the value of ``Message-ID`` to the URL above.
 
 The above only says "Under Review".  How can I find out more?
 -------------------------------------------------------------
-- 
2.34.1

