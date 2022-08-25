Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585995A06CE
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiHYBqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbiHYBpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AA49926A;
        Wed, 24 Aug 2022 18:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 186AE61B0B;
        Thu, 25 Aug 2022 01:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A9BC43144;
        Thu, 25 Aug 2022 01:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391616;
        bh=Cq2yZuYDa6ap8K06RCcjboWiugL8Z5wJsyGICmyPpvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTZ8CaDUs5Q6pHbj3s8oN8uhTrXD0wmQn5f0vYWvEggEMOMCjyvGmP2UiE/m9ky1v
         xG++dzl3SfSYD+3XcFtRei78dpIpBDEGY2BGtWePTvWxSf6wEBjmR/nDda8e9jDzdw
         o3AaP+93JSOjfCF9UgXTlowc17MGp9RSNp4Qn/vhnoKf325ypb7ncQmi7cHfRVSLYN
         rsQpP3NhiRqL/O9ibaj/1I1aCrAXzU5BuJNlV2z2nCZw0TvIwhnee6amJo/kMUqag7
         l+EvCJt8uciBD1fbWHWCa3LU/Pg/Qpq5kT9slN1Xi/fVyXg588zrUEN3qg4Bj7A8t6
         hqMi3M45KrFcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/5] netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y
Date:   Wed, 24 Aug 2022 21:39:58 -0400
Message-Id: <20220825014001.24008-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825014001.24008-1-sashal@kernel.org>
References: <20220825014001.24008-1-sashal@kernel.org>
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
index 56cddadb65d0..92e0514f624f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -117,7 +117,6 @@ config NF_CONNTRACK_ZONES
 
 config NF_CONNTRACK_PROCFS
 	bool "Supply CT list in procfs (OBSOLETE)"
-	default y
 	depends on PROC_FS
 	---help---
 	This option enables for the list of known conntrack entries
-- 
2.35.1

