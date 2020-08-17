Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6AD2478B3
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgHQVTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:19:53 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:50676 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgHQVTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:19:52 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07HLJmou047117;
        Mon, 17 Aug 2020 16:19:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597699188;
        bh=uxcnSjzUiqDws5N5tXOlhzvsMy7/95fMwMASURHhnmA=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=mjy71Ci9c1b2OBxmLhmcMhCR+jMbGAHHNyx3IeXAB8M9uB0BTm84sn3sHcnJ3Ao9y
         oO/IyPRaY9xRnIlbeNV0lnm+KNFhZB3e5U2/Jt6sGhHiJODmreCKy/ZAxOE/6ayTDp
         yEtt1NslisbHA/IXV8EGQkJwBd0Pzx/o57t/SFx4=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07HLJmBr018833
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 16:19:48 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 17
 Aug 2020 16:17:42 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 17 Aug 2020 16:17:43 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07HLHb8T073931;
        Mon, 17 Aug 2020 16:17:41 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>
Subject: [PATCH iproute2 v5 2/2] ip: iplink: prp: update man page for new parameter
Date:   Mon, 17 Aug 2020 17:17:37 -0400
Message-ID: <20200817211737.576-3-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817211737.576-1-m-karicheri2@ti.com>
References: <20200817211737.576-1-m-karicheri2@ti.com>
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
index c6bd2c530547..367105b72f44 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1404,7 +1404,8 @@ the following additional arguments are supported:
 .BI slave1 " SLAVE1-IF " slave2 " SLAVE2-IF "
 .RB [ " supervision"
 .IR ADDR-BYTE " ] ["
-.BR version " { " 0 " | " 1 " } ]"
+.BR version " { " 0 " | " 1 " } ["
+.BR proto " { " 0 " | " 1 " } ]"
 
 .in +8
 .sp
@@ -1425,6 +1426,12 @@ Default option is "0", possible values 0-255.
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

