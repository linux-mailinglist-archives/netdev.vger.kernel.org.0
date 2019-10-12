Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05817D4C30
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 04:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfJLCnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 22:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbfJLCnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 22:43:06 -0400
Received: from localhost.localdomain (c-73-169-115-106.hsd1.co.comcast.net [73.169.115.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F878206CD;
        Sat, 12 Oct 2019 02:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570848185;
        bh=zP8A8eVe9WgIVXdfNeGYH8ZmGdK/6tbv6TiWBtOp2/0=;
        h=From:To:Cc:Subject:Date:From;
        b=mQkI+hch2cwnN5eSZT6chzbtxkH272uXetKR0/J5KgzGnBQyR2GohapyMl7Xqie7Q
         P8MR58xTneu+tKDimIP9VtPFTN6POIwGZ3WIOqq/hQWDk3dYm+Mrux3s0Mh/oM3NqE
         wjv07YP7p3V2wFS6iV6gTQ1ZFlHpvsNxe4JZ5uDA=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] net: Update address for vrf and l3mdev in MAINTAINERS
Date:   Fri, 11 Oct 2019 20:43:03 -0600
Message-Id: <20191012024303.86494-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Use my kernel.org address for all entries in MAINTAINERS.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8824f61cd2c0..b431e6d5f43f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9126,7 +9126,7 @@ F:	drivers/auxdisplay/ks0108.c
 F:	include/linux/ks0108.h
 
 L3MDEV
-M:	David Ahern <dsa@cumulusnetworks.com>
+M:	David Ahern <dsahern@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	net/l3mdev
@@ -17439,7 +17439,7 @@ F:	include/linux/regulator/
 K:	regulator_get_optional
 
 VRF
-M:	David Ahern <dsa@cumulusnetworks.com>
+M:	David Ahern <dsahern@kernel.org>
 M:	Shrijeet Mukherjee <shrijeet@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.20.1 (Apple Git-117)

