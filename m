Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1A723E342
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgHFUiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 16:38:06 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:38918 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFUiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 16:38:05 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 076KbENl090321;
        Thu, 6 Aug 2020 15:37:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596746234;
        bh=uxcnSjzUiqDws5N5tXOlhzvsMy7/95fMwMASURHhnmA=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=ojUIqog82tXzTX2Y5cbf8TzZpkgOQ0L56q5x6uNwIIs/mP6RZnppSbDFVIOnEeXUM
         QMwRF7FZobhYZ5JjMccQvDRQqtfWOezl6u10Sc6GyX627K6Il5b7yrUG9KwdJ8S6B5
         gBHhRTu3pKWwIJ+UIE9W9Bg5cJ7D3gKgxum9lAW8=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 076KbEHZ128745;
        Thu, 6 Aug 2020 15:37:14 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 6 Aug
 2020 15:37:14 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 6 Aug 2020 15:37:14 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 076KbCej075449;
        Thu, 6 Aug 2020 15:37:14 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <kuznet@ms2.inr.ac.ru>
Subject: [net-next iproute2 PATCH v4 2/2] ip: iplink: prp: update man page for new parameter
Date:   Thu, 6 Aug 2020 16:37:12 -0400
Message-ID: <20200806203712.2712-3-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806203712.2712-1-m-karicheri2@ti.com>
References: <20200806203712.2712-1-m-karicheri2@ti.com>
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

