Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE48CD94A5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 17:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391148AbfJPPBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 11:01:00 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:49488 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389055AbfJPPA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 11:00:59 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id C9B213303C7;
        Wed, 16 Oct 2019 17:00:57 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1iKknJ-00080O-O9; Wed, 16 Oct 2019 17:00:57 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2 1/2] ip-netns.8: document the 'auto' keyword of 'ip netns set'
Date:   Wed, 16 Oct 2019 17:00:51 +0200
Message-Id: <20191016150052.30695-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up of the commit ebe3ce2fcc5f ("ipnetns: parse nsid as a
signed integer").

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 man/man8/ip-netns.8 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/man/man8/ip-netns.8 b/man/man8/ip-netns.8
index 39a10e765083..961bcf03f609 100644
--- a/man/man8/ip-netns.8
+++ b/man/man8/ip-netns.8
@@ -31,6 +31,9 @@ ip-netns \- process network namespace management
 .B ip netns set
 .I NETNSNAME NETNSID
 
+.ti -8
+.IR NETNSID " := " auto " | " POSITIVE-INT
+
 .ti -8
 .BR "ip netns identify"
 .RI "[ " PID " ]"
-- 
2.23.0

