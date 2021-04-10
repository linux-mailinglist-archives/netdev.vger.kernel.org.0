Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB8D35AF60
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 19:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhDJRrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 13:47:11 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:58895 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234392AbhDJRrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Apr 2021 13:47:10 -0400
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 13AHkYij031595
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 10 Apr 2021 19:46:34 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [PATCH net] net: seg6: trivial fix of a spelling mistake in comment
Date:   Sat, 10 Apr 2021 19:46:14 +0200
Message-Id: <20210410174614.13359-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a comment spelling mistake "interfarence" -> "interference" in
function parse_nla_action(). Fix it.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 8936f48570fc..bd7140885e60 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1475,7 +1475,7 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	/* Forcing the desc->optattrs *set* and the desc->attrs *set* to be
 	 * disjoined, this allow us to release acquired resources by optional
 	 * attributes and by required attributes independently from each other
-	 * without any interfarence.
+	 * without any interference.
 	 * In other terms, we are sure that we do not release some the acquired
 	 * resources twice.
 	 *
-- 
2.20.1

