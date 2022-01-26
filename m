Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E36449D363
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiAZU0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:26:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36268 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiAZU0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:26:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E86D617DC
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 20:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC20C340E3;
        Wed, 26 Jan 2022 20:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643228776;
        bh=kSczYsFH8ypM+EAflCdNJJF2mXBKfV+QIRbLnFvi7q4=;
        h=From:To:Cc:Subject:Date:From;
        b=KVY4gNcDxybTa8pGXbnX507htIGZX+1bgEjaVNYBafcyv9f1+Rw72wGcA9/5dzth2
         AReN8Ca0KENNvMOwZ0Bi8/btTJ88Iz0t7/g9HN9Rx6cBSvrAeLEk2b4i5ItZ89kmCc
         1et6jxHVJRHoNssJRZly3i1uLBEBTCiF/PEuRrsSGjakPQwVraSt8PM5KVQmEI3pF3
         r/9K8avLm4icvf5eqIMERhdmngMsifiuHcLSw+miJQWF1kjP78ukw+qxy6rOuwblmY
         AK7k6Gf/sC/H8L2puvFIxYPm64HgZUjn7Jcj2PytFpNoplNOMsCrpZGdrGCrK24QAQ
         fiozDIZfjh8sA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: add missing IPv4/IPv6 header paths
Date:   Wed, 26 Jan 2022 12:26:07 -0800
Message-Id: <20220126202607.2993009-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IP includes under include/linux/ are not explicitly
listed under any entry in MAINTAINERS.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e22999669c4..9c3ec0863e7e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13461,6 +13461,8 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 F:	arch/x86/net/*
+F:	include/linux/ip.h
+F:	include/linux/ipv6*
 F:	include/net/ip*
 F:	net/ipv4/
 F:	net/ipv6/
-- 
2.34.1

