Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78C22C5C22
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 19:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404790AbgKZSsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 13:48:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404018AbgKZSsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 13:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606416492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xmLlNcLeEa4ofpa4FsZipn5WCuVLzCvibyZ4YGEFyz8=;
        b=IWUP0qWFPgRYS4uH4ys1/UzRGV3NitxE5gIxgF3UdKRKfNU1wbpmF5/Z6C/pLs2r6hX78i
        ok3B4jAvBTp3Bc0to5qtVw0oW0JF/m95fYFoqmchuWph574MX0eHoaRanK6WqSILZC0e1h
        OGgwCAT8NTQDCzE+JvyRWYnQHEL3LoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-hqGZlQxwMHa514FVBA60Pw-1; Thu, 26 Nov 2020 13:48:09 -0500
X-MC-Unique: hqGZlQxwMHa514FVBA60Pw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71D978042AA;
        Thu, 26 Nov 2020 18:48:08 +0000 (UTC)
Received: from new-host-6.station (unknown [10.40.194.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFB5D1A4D0;
        Thu, 26 Nov 2020 18:48:06 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Roman Mashak <mrv@mojatatu.com>,
        Briana Oursler <briana.oursler@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Marcelo Leitner <mleitner@redhat.com>
Subject: [PATCH net-next] selftests: tc-testing: enable CONFIG_NET_SCH_RED as a module
Date:   Thu, 26 Nov 2020 19:47:47 +0100
Message-Id: <cfa23f2d4f672401e6cebca3a321dd1901a9ff07.1606416464.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a proper kernel configuration for running kselftest can be obtained with:

 $ yes | make kselftest-merge

enable compile support for the 'red' qdisc: otherwise, tdc kselftest fail
when trying to run tdc test items contained in red.json.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 tools/testing/selftests/tc-testing/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index c33a7aac27ff..b71828df5a6d 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -59,6 +59,7 @@ CONFIG_NET_IFE_SKBPRIO=m
 CONFIG_NET_IFE_SKBTCINDEX=m
 CONFIG_NET_SCH_FIFO=y
 CONFIG_NET_SCH_ETS=m
+CONFIG_NET_SCH_RED=m
 
 #
 ## Network testing
-- 
2.28.0

