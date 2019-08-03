Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB7228054E
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 10:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387727AbfHCIhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 04:37:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387688AbfHCIhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 04:37:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 303D630860DA;
        Sat,  3 Aug 2019 08:37:43 +0000 (UTC)
Received: from ocho.redhat.com (ovpn-116-24.ams2.redhat.com [10.36.116.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62BCC5D6A9;
        Sat,  3 Aug 2019 08:37:42 +0000 (UTC)
From:   Patrick Talbert <ptalbert@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Subject: [PATCH iproute2-next] ss: sctp: fix typo for nodelay
Date:   Sat,  3 Aug 2019 10:37:41 +0200
Message-Id: <20190803083741.24122-1-ptalbert@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sat, 03 Aug 2019 08:37:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nodealy should be nodelay.

Signed-off-by: Patrick Talbert <ptalbert@redhat.com>
---
 misc/ss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/ss.c b/misc/ss.c
index 0927b192..01b47fed 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2414,7 +2414,7 @@ static void sctp_stats_print(struct sctp_info *s)
 	if (s->sctpi_s_pd_point)
 		out(" pdpoint:%d", s->sctpi_s_pd_point);
 	if (s->sctpi_s_nodelay)
-		out(" nodealy:%d", s->sctpi_s_nodelay);
+		out(" nodelay:%d", s->sctpi_s_nodelay);
 	if (s->sctpi_s_disable_fragments)
 		out(" nofrag:%d", s->sctpi_s_disable_fragments);
 	if (s->sctpi_s_v4mapped)
-- 
2.18.1

