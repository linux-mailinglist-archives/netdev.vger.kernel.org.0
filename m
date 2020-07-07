Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A35217840
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgGGTuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:50:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26205 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726951AbgGGTuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594151402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gm86AYRiuLFDuEYT+4BTX4K72xOOs3FxTl9CrJ15LQA=;
        b=FsLo2JGyI6id1t+GCzBsjWQXGsto3m6RvZRhdDpxi/0CRSz3cnwd9XGjqLghapt4jSpc/K
        WOVBFGKXjkDZkrbyNQZe5RBeEVraAP35icatM4JytXEhGn7EMpYHl9b+Z4rtR3LkdEOUMW
        la2ROYYuSCLjnvwGa7lDqWstU6roynE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-Ct0AAVDMOBG3PCrZH0h79w-1; Tue, 07 Jul 2020 15:50:00 -0400
X-MC-Unique: Ct0AAVDMOBG3PCrZH0h79w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59E9118A8222;
        Tue,  7 Jul 2020 19:49:59 +0000 (UTC)
Received: from renaissance-vector.redhat.com (ovpn-112-3.ams2.redhat.com [10.36.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18F9273FDD;
        Tue,  7 Jul 2020 19:49:57 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2-next] ip address: remove useless include
Date:   Tue,  7 Jul 2020 21:49:47 +0200
Message-Id: <7b7bc10473ab2b539b0100f6db3d849cc3922364.1594145961.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

utils.h is included two times in ipaddress.c, there is no need for that.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipaddress.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 3b53933f41673..a6acd8acca4a2 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -30,7 +30,6 @@
 #include <linux/sockios.h>
 #include <linux/net_namespace.h>
 
-#include "utils.h"
 #include "rt_names.h"
 #include "utils.h"
 #include "ll_map.h"
-- 
2.26.2

