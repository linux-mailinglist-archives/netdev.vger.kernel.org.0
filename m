Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153FD177590
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 13:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgCCMAL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Mar 2020 07:00:11 -0500
Received: from mail1.windriver.com ([147.11.146.13]:51090 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbgCCMAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 07:00:11 -0500
X-Greylist: delayed 5586 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Mar 2020 07:00:06 EST
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id 023AQilA015177
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 3 Mar 2020 02:26:44 -0800 (PST)
Received: from ALA-MBD.corp.ad.wrs.com ([169.254.3.75]) by
 ALA-HCA.corp.ad.wrs.com ([147.11.189.40]) with mapi id 14.03.0487.000; Tue, 3
 Mar 2020 02:26:43 -0800
From:   "Xue, Ying" <Ying.Xue@windriver.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        GhantaKrishnamurthy MohanKrishna 
        <mohan.krishna.ghanta.krishnamurthy@ericsson.com>
Subject: RE: [PATCH net 13/16] tipc: add missing attribute validation for
 MTU property
Thread-Topic: [PATCH net 13/16] tipc: add missing attribute validation for
 MTU property
Thread-Index: AQHV8RlqlBEplGReekm6oUwLIp4tGKg2qb+g
Date:   Tue, 3 Mar 2020 10:26:43 +0000
Message-ID: <25A14D9CFAB7B34FB9440F90AFD35233013CBFA713@ALA-MBD.corp.ad.wrs.com>
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-14-kuba@kernel.org>
In-Reply-To: <20200303050526.4088735-14-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.224.16.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks! The patch looks good to me.

-----Original Message-----
From: Jakub Kicinski [mailto:kuba@kernel.org] 
Sent: Tuesday, March 3, 2020 1:05 PM
To: davem@davemloft.net
Cc: netdev@vger.kernel.org; Jakub Kicinski; Jon Maloy; Xue, Ying; GhantaKrishnamurthy MohanKrishna
Subject: [PATCH net 13/16] tipc: add missing attribute validation for MTU property

Add missing attribute validation for TIPC_NLA_PROP_MTU
to the netlink policy.

Fixes: 901271e0403a ("tipc: implement configuration of UDP media MTU")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Jon Maloy <jmaloy@redhat.com>
CC: Ying Xue <ying.xue@windriver.com>
CC: GhantaKrishnamurthy MohanKrishna <mohan.krishna.ghanta.krishnamurthy@ericsson.com>
---
 net/tipc/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index 7c35094c20b8..bb9862410e68 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -116,6 +116,7 @@ const struct nla_policy tipc_nl_prop_policy[TIPC_NLA_PROP_MAX + 1] = {
 	[TIPC_NLA_PROP_PRIO]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_TOL]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_WIN]		= { .type = NLA_U32 },
+	[TIPC_NLA_PROP_MTU]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_BROADCAST]	= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_BROADCAST_RATIO]	= { .type = NLA_U32 }
 };
-- 
2.24.1

