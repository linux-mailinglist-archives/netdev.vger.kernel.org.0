Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4FE5A06BE
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiHYBoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235360AbiHYBni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:43:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC669A6B2;
        Wed, 24 Aug 2022 18:39:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1CBEB824CF;
        Thu, 25 Aug 2022 01:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBA4C433D7;
        Thu, 25 Aug 2022 01:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391564;
        bh=y0vJHQO0zpUcl1JSeX4OcoLoIn2fiTaqE/M75Sa45Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNW2CfNtIACd4LY+gQ3zBqcdccDQOB5wwBLa/TtblGQs+TVST++FR1bCxaed/Q9hj
         7btnN5SAD9RqYoc+leJo7RBkgGmX4CwYjgKCW7DOBlVwGQ1Ulon3HTzlhncwGeZUCJ
         QmYjJyKhtggU5zjceRB6UdKOuAcY5CharAofXsopEcmFcWQ+j9vTXA320xbRZHNabv
         CNP72OZHnxBFKF7/bOcpZ+163Ex4cuoExb+0xVrlC1KN6Hy7BADDacuH0WbfSmqEuc
         BeDsEJImL5RbEb7Vl1/zPow8Vvs1HX1XEtz2pswMpPTeyffBsaY+0av0QJ20XTTtcb
         atCkx2fnFvK1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/11] netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y
Date:   Wed, 24 Aug 2022 21:38:30 -0400
Message-Id: <20220825013836.23205-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013836.23205-1-sashal@kernel.org>
References: <20220825013836.23205-1-sashal@kernel.org>
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
index 6bafd3876aff..8bf70ce03f95 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -118,7 +118,6 @@ config NF_CONNTRACK_ZONES
 
 config NF_CONNTRACK_PROCFS
 	bool "Supply CT list in procfs (OBSOLETE)"
-	default y
 	depends on PROC_FS
 	help
 	This option enables for the list of known conntrack entries
-- 
2.35.1

