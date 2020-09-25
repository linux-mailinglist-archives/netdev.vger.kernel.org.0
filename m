Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166B0278115
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgIYHFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:05:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727135AbgIYHFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 03:05:34 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601017534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cXiPntWmZ8U5pOfeuPcqsPVgWvTJduclrOMDODyzCA=;
        b=e3WDBWj8grb7ijUX1lP0LADeCRPFHhPVnD/f+uvHk+rU+grK2NeNGfOmNSLDYjsTXglk6Z
        4fit24pAlUf1afMeFT7xHj68UB3Je3nz7X+CbRdbzsjttvP30x8JKCUQdSMTPD2kCMfaBt
        uKPNfTWyfcCpXP6lo77DnKIXDc/rodA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-qjz-2WqDPuiXDiEe_TllPg-1; Fri, 25 Sep 2020 03:05:31 -0400
X-MC-Unique: qjz-2WqDPuiXDiEe_TllPg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4B0518B9F40;
        Fri, 25 Sep 2020 07:05:30 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.195.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D708C3C89;
        Fri, 25 Sep 2020 07:05:29 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 2/2] netlink: fix copy-paste error in rtm_link_summary()
Date:   Fri, 25 Sep 2020 09:05:27 +0200
Message-Id: <20200925070527.1001190-2-ivecera@redhat.com>
In-Reply-To: <20200925070527.1001190-1-ivecera@redhat.com>
References: <20200925070527.1001190-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: bdfffab54933 ("netlink: message format descriptions for rtnetlink")

Cc: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 netlink/prettymsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/prettymsg.c b/netlink/prettymsg.c
index 9e62bebe615e..f992dcaf071f 100644
--- a/netlink/prettymsg.c
+++ b/netlink/prettymsg.c
@@ -202,7 +202,7 @@ static void rtm_link_summary(const struct ifinfomsg *ifinfo)
 		printf(" ifindex=%d", ifinfo->ifi_index);
 	if (ifinfo->ifi_flags)
 		printf(" flags=0x%x", ifinfo->ifi_flags);
-	if (ifinfo->ifi_flags)
+	if (ifinfo->ifi_change)
 		printf(" change=0x%x", ifinfo->ifi_change);
 }
 
-- 
2.26.2

