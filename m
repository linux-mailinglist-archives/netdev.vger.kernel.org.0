Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A227563DE4
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiGBDMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBDMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515DC3B3C5
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 20:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5BB461C61
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 03:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B919C341CD;
        Sat,  2 Jul 2022 03:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656731533;
        bh=8qW7/9bymYNMXNeUGiKbK2wLEQjO6vrd2L5oEkUmEtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L76DhhAdR3Gka7TGaWeJQZmGTS+KNGhjUc70egkBH7kxZi+tGUAhOYV/NiVhE57eV
         KBdYUBMW0Cz3wQBo+bGx+11mtvqkvq2a0nAa8IYZ3H7+oIj4rV37/jbj9ysC99Q5Dq
         xJlcvBUa04Ya9dLymcoXu6ieHbrtnh2ddabJa6Et5y3zmVcB2pga/VM6yh0MD7ETSk
         j/4RiNVillgnZK3yp+eHHaVYQUFZ8SRmT0q15uxX6bNAg8oCFVDP7lkMiQs61iWo+n
         xtLOK+7OhFyNpK+Kw3PBmuKq3PnwdNSxIpDo9QfhNttNvRsilOps9H5O7QfPL7HX4n
         /lX+FY9HRqIxg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 3/3] docs: netdev: add a cheat sheet for the rules
Date:   Fri,  1 Jul 2022 20:12:09 -0700
Message-Id: <20220702031209.790535-4-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702031209.790535-1-kuba@kernel.org>
References: <20220702031209.790535-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Summarize the rules we see broken most often and which may
be less familiar to kernel devs who are used to working outside
of netdev.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/process/maintainer-netdev.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index 8a9dae7a0524..d14007081595 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -6,6 +6,15 @@
 netdev FAQ
 ==========
 
+tl;dr
+-----
+
+ - designate your patch to a tree - ``[PATCH net]`` or ``[PATCH net-next]``
+ - for fixes the ``Fixes:`` tag is required, regardless of the tree
+ - don't post large series (> 15 patches), break them up
+ - don't repost your patches within one 24h period
+ - reverse xmas tree
+
 What is netdev?
 ---------------
 It is a mailing list for all network-related Linux stuff.  This
-- 
2.36.1

