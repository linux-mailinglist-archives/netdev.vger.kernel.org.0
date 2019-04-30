Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8FEFFA
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfD3FbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:31:03 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46870 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfD3Faw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:30:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E6C982027A;
        Tue, 30 Apr 2019 07:30:50 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cC4VHKxPDS3n; Tue, 30 Apr 2019 07:30:49 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 098BC20278;
        Tue, 30 Apr 2019 07:30:48 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1D2603180630;
 Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 12/12] xfrm: update doc about xfrm[46]_gc_thresh
Date:   Tue, 30 Apr 2019 07:30:30 +0200
Message-ID: <20190430053030.27009-13-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430053030.27009-1-steffen.klassert@secunet.com>
References: <20190430053030.27009-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: AFC299BE-8E87-4D1E-8045-1A0ACFDFF215
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Those entries are not used anymore.

CC: Florian Westphal <fw@strlen.de>
Fixes: 09c7570480f7 ("xfrm: remove flow cache")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 Documentation/networking/ip-sysctl.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index acdfb5d2bcaa..f1843b132453 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1336,6 +1336,7 @@ tag - INTEGER
 	Default value is 0.
 
 xfrm4_gc_thresh - INTEGER
+	(Obsolete since linux-4.14)
 	The threshold at which we will start garbage collecting for IPv4
 	destination cache entries.  At twice this value the system will
 	refuse new allocations.
@@ -1919,6 +1920,7 @@ echo_ignore_all - BOOLEAN
 	Default: 0
 
 xfrm6_gc_thresh - INTEGER
+	(Obsolete since linux-4.14)
 	The threshold at which we will start garbage collecting for IPv6
 	destination cache entries.  At twice this value the system will
 	refuse new allocations.
-- 
2.17.1

