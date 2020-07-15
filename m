Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24910221299
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGOQki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:40:38 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43546 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgGOQkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:40:35 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeVjT021756;
        Wed, 15 Jul 2020 11:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594831231;
        bh=upqGhQJY/Yot7wWvCpEOFZMds6Rur9/qVA2DdzLJA9w=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=PWxOIpbrS7jXaByQ63XsFXJX6T0Le0PuAw3aJFnsSCo2P/qVYXIWrPLWlbYOKfxa7
         PaMqf9QO9KYo847xvmdE+fo9LNmhDyN2qEbtYhPnPGpngMCptICVhUldiFrWiLaaTv
         C4BtlSWi9bgqg/SlUXVYUVjBmhbJ7XIpa7p8uJcA=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeVOp031975;
        Wed, 15 Jul 2020 11:40:31 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 15
 Jul 2020 11:40:31 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 15 Jul 2020 11:40:30 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeCvj081717;
        Wed, 15 Jul 2020 11:40:29 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next iproute2 PATCH v2 2/2] ip: iplink: prp: update man page for new parameter
Date:   Wed, 15 Jul 2020 12:40:12 -0400
Message-ID: <20200715164012.1222-12-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715164012.1222-1-m-karicheri2@ti.com>
References: <20200715164012.1222-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PRP support requires a proto parameter which is 0 for hsr and 1 for
prp. Default is hsr and is backward compatible.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 man/man8/ip-link.8.in | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index e8a25451f7cd..37d77328a5fc 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1360,7 +1360,8 @@ the following additional arguments are supported:
 .BI slave1 " SLAVE1-IF " slave2 " SLAVE2-IF "
 .RB [ " supervision"
 .IR ADDR-BYTE " ] ["
-.BR version " { " 0 " | " 1 " } ]"
+.BR version " { " 0 " | " 1 " } ["
+.BR proto " { " 0 " | " 1 " } ]"
 
 .in +8
 .sp
@@ -1381,6 +1382,12 @@ Default option is "0", possible values 0-255.
 - Selects the protocol version of the interface. Default option is "0", which
 corresponds to the 2010 version of the HSR standard. Option "1" activates the
 2012 version.
+
+.BR proto " { " 0 " | " 1 " }"
+- Selects the protocol at the interface. Default option is "0", which
+corresponds to the HSR standard. Option "1" activates the Parallel
+Redundancy Protocol (PRP).
+.
 .in -8
 
 .TP
-- 
2.17.1

