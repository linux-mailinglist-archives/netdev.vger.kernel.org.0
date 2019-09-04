Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B73A893F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbfIDPHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbfIDPHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:07:03 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE4A22CE3;
        Wed,  4 Sep 2019 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567609622;
        bh=Eo8TsY13tiUGF+H5687TUNsd2U23O1yfbwhuJI3Z1HY=;
        h=From:To:Cc:Subject:Date:From;
        b=MDUhuf1zRjD8cWEwuuUyZiJrOEOu0gJJ7shqKx5+khOLO1pBU1KJptFaj7VlEoFfR
         YGjL5J3UMamr+xnKfC6hTkrA9TaZ+JuqA3ttdN99dCj8B7pfCH6TsrssQsaNC0JnZ9
         WefsEBuxuceePHIE30AUo8iVV2PZvJ81+eGP6TFg=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2] nexthop: Add space after blackhole
Date:   Wed,  4 Sep 2019 08:09:52 -0700
Message-Id: <20190904150952.17274-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a space after 'blackhole' is missing to properly separate the
protocol when it is given.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/ipnexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index f35aab52b775..8356aca296de 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -242,7 +242,7 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	}
 
 	if (tb[NHA_BLACKHOLE])
-		print_null(PRINT_ANY, "blackhole", "blackhole", NULL);
+		print_null(PRINT_ANY, "blackhole", "blackhole ", NULL);
 
 	if (nhm->nh_protocol != RTPROT_UNSPEC || show_details > 0) {
 		print_string(PRINT_ANY, "protocol", "proto %s ",
-- 
2.11.0

