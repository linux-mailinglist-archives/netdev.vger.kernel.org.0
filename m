Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1ED5A064C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiHYBkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiHYBjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DD59AF8F;
        Wed, 24 Aug 2022 18:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5238CB826E2;
        Thu, 25 Aug 2022 01:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB87C4347C;
        Thu, 25 Aug 2022 01:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391418;
        bh=8LySNvavf0C4AvLzk48MTafbWk1bIvW/zo6ROrDL8Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFmQyr9nMyMn433JS2XDXsqRLJVbE5kjP5KcQiAvpkudRaTyYvL8ItRo20kLWyVOs
         01a8NdCuKQSMa7nofLe4Y7lZ+hnM9C2pTWyKJyBGhqX1E7vQk1jlJAY6UBxzLHDjW8
         6YoILHy0Fyk9FS3SElJB2SADkp1lKE/rt71n7TXbPkkSPO53Vk/+RfJ5DYe3LDUDEd
         Rk/2JkWci8PZaAsB8uDNkq49ZkTm4ecXRgq2VHiZ9vs5m5Vf+B54OhHNdTOh60L1KC
         4qBiU9sA7EiQSDFxLtdCQj+6DB6082PSEhGWUymsvyQl5xil8DLrTuhIhMUDpk3azW
         eZlrCAU+pArkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 31/38] netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y
Date:   Wed, 24 Aug 2022 21:33:54 -0400
Message-Id: <20220825013401.22096-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit aa5762c34213aba7a72dc58e70601370805fa794 ]

NF_CONNTRACK_PROCFS was marked obsolete in commit 54b07dca68557b09
("netfilter: provide config option to disable ancient procfs parts") in
v3.3.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ddc54b6d18ee..8c0fea1bdc8d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -144,7 +144,6 @@ config NF_CONNTRACK_ZONES
 
 config NF_CONNTRACK_PROCFS
 	bool "Supply CT list in procfs (OBSOLETE)"
-	default y
 	depends on PROC_FS
 	help
 	This option enables for the list of known conntrack entries
-- 
2.35.1

