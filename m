Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5D1223F6D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGQPWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:22:16 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55300 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGQPWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 11:22:16 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06HFM7to083326;
        Fri, 17 Jul 2020 10:22:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594999327;
        bh=nWmi1N267mykLXBFK8hhRu1dzohcmL3IImqJTPPwDqQ=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=b6/KEktigmbyOrBsYAT+Ym9uD23cUrq1bqXLF7/OyrXnLlSfA+0dvRchAA/CeorL6
         49J1uhi465tUnbHO9YWYw4a0l/tLeqfFRipVfgrG193pigQqMPm/DQsxekhAxt5bv9
         f6xBl8+xitGyZ0JL7PWXsMy+yFpGmmh56kZvEgXY=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HFM757106522;
        Fri, 17 Jul 2020 10:22:07 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 17
 Jul 2020 10:22:06 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 17 Jul 2020 10:22:06 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HFM51Q022443;
        Fri, 17 Jul 2020 10:22:06 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next iproute2 PATCH v3 2/2] ip: iplink: prp: update man page for new parameter
Date:   Fri, 17 Jul 2020 11:22:05 -0400
Message-ID: <20200717152205.826-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200717152205.826-1-m-karicheri2@ti.com>
References: <20200717152205.826-1-m-karicheri2@ti.com>
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
 dependent on the series "[net-next PATCH v3 0/7] Add PRP driver"
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

