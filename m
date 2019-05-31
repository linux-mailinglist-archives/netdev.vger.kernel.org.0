Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B9314E0
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfEaSoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727057AbfEaSoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 14:44:18 -0400
Received: from dsa-cn-mb.hsd1.co.comcast.net. (unknown [216.129.126.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AABA226E0E;
        Fri, 31 May 2019 18:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559328258;
        bh=3V3R4URWjKJPkv6igd8GRVgbfowWBUox7DUSR62GGFM=;
        h=From:To:Cc:Subject:Date:From;
        b=t47vQn6OmzQirPqxhWyqlOQweV45u0Vr+fOms+SeIvkcj5mNh9NErj4AHaOoPX/0I
         4DtTD/Ew+Q5I5qdn49Ng/RmT6tYDakKC58kHwHzapG1cb8iVx/PzdSFhjBXdAbWe7q
         gXcOLV0soxe7wppxwaEgWMD6T7qzyQIqC7LgULis=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] nexthop: Add entry to MAINTAINERS
Date:   Fri, 31 May 2019 12:44:09 -0600
Message-Id: <20190531184409.40875-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add entry to MAINTAINERS file for new nexthop code.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 429c6c624861..73526f2216d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11065,6 +11065,15 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/qlogic/netxen/
 
+NEXTHOP
+M:	David Ahern <dsahern@kernel.org>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	include/net/nexthop.h
+F:	include/uapi/linux/nexthop.h
+F:	include/net/netns/nexthop.h
+F:	net/ipv4/nexthop.c
+
 NFC SUBSYSTEM
 L:	netdev@vger.kernel.org
 S:	Orphan
-- 
2.17.2 (Apple Git-113)

