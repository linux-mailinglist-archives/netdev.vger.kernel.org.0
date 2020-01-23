Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B93146C57
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgAWPLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:11:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34420 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbgAWPLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:11:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579792261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=yA9tNGlpJ3HnOW0r8Z/WI/AlcNMmjJ27y0CGUg9/O9M=;
        b=U0xqr2UTd1SbrzwuBfkOwNMDWP09mfVrP8NtinNzrhGOPP4wq264kxrkT8yKeldelV3PrQ
        WzgLLlov6vAkyWCpJgus2Ms4X91h5Nfke/fL3r7xkl34/2HSRLI/w3YsIKMtomzNwp1c9U
        3f76KKP5lrl0Oa8hmXYvr2ZQmS0qTig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-JpJg1dIyPl6ZoUBLel8XlQ-1; Thu, 23 Jan 2020 10:10:56 -0500
X-MC-Unique: JpJg1dIyPl6ZoUBLel8XlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B8A10054E3;
        Thu, 23 Jan 2020 15:10:54 +0000 (UTC)
Received: from dhcp16-201-135.khw1.lab.eng.bos.redhat.com (dhcp16-201-135.khw1.lab.eng.bos.redhat.com [10.16.201.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 650D886E00;
        Thu, 23 Jan 2020 15:10:51 +0000 (UTC)
From:   Jon Maloy <jmaloy@redhat.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     john.rutherford@dektech.com.au, tung.q.nguyen@dektech.com.au,
        hoang.h.le@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net,
        Jon Maloy <jmaloy@redhat.com>
Subject: [net-next 1/1] tipc: change maintainer email address
Date:   Thu, 23 Jan 2020 10:09:39 -0500
Message-Id: <1579792179-3632-1-git-send-email-jmaloy@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reflecting new realities.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f9e9049..6e11ffa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16607,7 +16607,7 @@ F:	kernel/time/ntp.c
 F:	tools/testing/selftests/timers/
 
 TIPC NETWORK LAYER
-M:	Jon Maloy <jon.maloy@ericsson.com>
+M:	Jon Maloy <jmaloy@redhat.com>
 M:	Ying Xue <ying.xue@windriver.com>
 L:	netdev@vger.kernel.org (core kernel code)
 L:	tipc-discussion@lists.sourceforge.net (user apps, general discussion)
-- 
1.8.3.1

