Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697CE49D5C4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiAZWzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiAZWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:55:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0341EC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:55:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC68BB8205A
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 22:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E67CC340E3;
        Wed, 26 Jan 2022 22:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643237737;
        bh=pBTXgQaArvjwhTK+bdeW2B0NeYq72JA7mLQsATIvcmo=;
        h=From:To:Cc:Subject:Date:From;
        b=TspPppFaTAjxxQ7W3txtcrDeCZjLtWKR2BXzkZmwnF6bAh2EZpxl5cGugwevXo3ob
         z1Iw/p0QTVzV1fb2oyayDzuGkx2cfCSYVAyyMsezcfFBVqIgeildDTY8MhETHoFve2
         y7kYwqBDYDhyXCrg1s2/mEVRX5+BfRA55MtT5KWvQ1wUrrx8A8Njm/RPUgbJjmml0R
         SagIzTMfCLB3ca6SRM8dGXH9h2l1DJOS4TyOz1pc0z08R6ShZJvIqkaC4iKG7A5nSD
         6E5Isx8EjwXezxGrOIZ7h1FMi0U9tDe2s2ME5OfyZjZGvKpY2i1w+Sqd2YV1k3cVEd
         TTgPritEjFnjA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2] MAINTAINERS: add missing IPv4/IPv6 header paths
Date:   Wed, 26 Jan 2022 14:55:35 -0800
Message-Id: <20220126225535.3328169-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing headers to the IP entry.

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: include/net/fib* and include/net/route.h as well
---
 MAINTAINERS | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e22999669c4..b904348fed0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13461,7 +13461,11 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 F:	arch/x86/net/*
+F:	include/linux/ip.h
+F:	include/linux/ipv6*
+F:	include/net/fib*
 F:	include/net/ip*
+F:	include/net/route.h
 F:	net/ipv4/
 F:	net/ipv6/
 
-- 
2.34.1

