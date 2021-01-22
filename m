Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735D9300A0F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbhAVRnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbhAVRdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 12:33:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C0FB23433;
        Fri, 22 Jan 2021 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611336742;
        bh=LXlMOcQ8Kla0NYZqRJ+t12w+Wz8N6AvuYTODqotKTjI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ss0U6sHAGRidEWS7Qb46FPn9Pj6Cq+IQ7YenMskdK8HCipqEq+HAP4pQMGrusSd6x
         UAGP4Uw6qUN91MQqvbTu0KbOuQr6NHyujxrJ/rlYY64c7HVZQRxKFRtjsfmq9FQag4
         OKNYH/6VuEfR+FRCfqo0kJusxOewQE9GykR8cMgc7WItFlLprsrl/e1/z8EdH0NPDx
         6qExoQzsnmrR/ykhxuiveJtxbyJQAC5Co/go0eNCJJ6uIJIkOT40tuVb6icT9SRqcO
         2T+X4qLPPFgPxPXETUgbL5h0xXqPpYvXF3DxLUKfHGCoGP9sCJq1HIp/bVdfcdCtlu
         qs71cxRYAXG4g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: add David Ahern to IPv4/IPv6 maintainers
Date:   Fri, 22 Jan 2021 09:32:20 -0800
Message-Id: <20210122173220.3579491-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David has been the de-facto maintainer for much of the IP code
for the last couple of years, let's make it official.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1df56a32d2df..8f68b591be57 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12428,6 +12428,7 @@ F:	tools/testing/selftests/net/ipsec.c
 NETWORKING [IPv4/IPv6]
 M:	"David S. Miller" <davem@davemloft.net>
 M:	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
+M:	David Ahern <dsahern@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
-- 
2.26.2

