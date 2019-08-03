Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60880556
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 10:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387778AbfHCIrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 04:47:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387692AbfHCIrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 04:47:10 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E7BD83F3E;
        Sat,  3 Aug 2019 08:47:10 +0000 (UTC)
Received: from ocho.redhat.com (ovpn-116-24.ams2.redhat.com [10.36.116.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A96355C22B;
        Sat,  3 Aug 2019 08:47:09 +0000 (UTC)
From:   Patrick Talbert <ptalbert@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Subject: [PATCH iproute2-next] ss: sctp: Formatting tweak in sctp_show_info for locals
Date:   Sat,  3 Aug 2019 10:47:08 +0200
Message-Id: <20190803084708.24753-1-ptalbert@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Sat, 03 Aug 2019 08:47:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'locals' output does not include a leading space so it runs up against
skmem:() output. Add a leading space to fix it.

Signed-off-by: Patrick Talbert <ptalbert@redhat.com>
---
 misc/ss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/ss.c b/misc/ss.c
index 0927b192..5e70709d 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2937,7 +2937,7 @@ static void sctp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
 		len = RTA_PAYLOAD(tb[INET_DIAG_LOCALS]);
 		sa = RTA_DATA(tb[INET_DIAG_LOCALS]);
 
-		out("locals:%s", format_host_sa(sa));
+		out(" locals:%s", format_host_sa(sa));
 		for (sa++, len -= sizeof(*sa); len > 0; sa++, len -= sizeof(*sa))
 			out(",%s", format_host_sa(sa));
 
-- 
2.18.1

