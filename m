Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B444F36EE8
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfFFIks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:40:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46913 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfFFIks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 04:40:48 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hYnwu-00080J-5v; Thu, 06 Jun 2019 08:40:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ipv6: fix spelling mistake: "wtih" -> "with"
Date:   Thu,  6 Jun 2019 09:40:39 +0100
Message-Id: <20190606084039.6265-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a NL_SET_ERR_MSG message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fbaa7e9e0d9c..641a31d42ef9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3342,7 +3342,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 			goto out;
 		}
 		if (rt->fib6_src.plen) {
-			NL_SET_ERR_MSG(extack, "Nexthops can not be used wtih source routing");
+			NL_SET_ERR_MSG(extack, "Nexthops can not be used with source routing");
 			goto out;
 		}
 		rt->nh = nh;
-- 
2.20.1

