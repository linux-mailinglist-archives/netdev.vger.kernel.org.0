Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91B1189823
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgCRJn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:43:58 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51580 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727585AbgCRJn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:56 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9hpBA012925;
        Wed, 18 Mar 2020 11:43:51 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 31D2F360F45; Wed, 18 Mar 2020 11:43:51 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 28/28] tcp: AccECN sysctl documentation
Date:   Wed, 18 Mar 2020 11:43:32 +0200
Message-Id: <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 Documentation/networking/ip-sysctl.txt | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 5f53faff4e25..ecca6e1d6bea 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -301,15 +301,21 @@ tcp_ecn - INTEGER
 		0 Disable ECN.  Neither initiate nor accept ECN.
 		1 Enable ECN when requested by incoming connections and
 		  also request ECN on outgoing connection attempts.
-		2 Enable ECN when requested by incoming connections
+		2 Enable ECN or AccECN when requested by incoming connections
 		  but do not request ECN on outgoing connections.
+		3 Enable AccECN when requested by incoming connections and
+		  also request AccECN on outgoing connection attempts.
+	    0x102 Enable AccECN in optionless mode for incoming connections.
+	    0x103 Enable AccECN in optionless mode for incoming and outgoing
+		  connections.
 	Default: 2
 
 tcp_ecn_fallback - BOOLEAN
 	If the kernel detects that ECN connection misbehaves, enable fall
 	back to non-ECN. Currently, this knob implements the fallback
-	from RFC3168, section 6.1.1.1., but we reserve that in future,
-	additional detection mechanisms could be implemented under this
+	from RFC3168, section 6.1.1.1., as well as the ECT codepoint mangling
+	detection during the Accurate ECN handshake, but we reserve that in
+	future, additional detection mechanisms could be implemented under this
 	knob. The value	is not used, if tcp_ecn or per route (or congestion
 	control) ECN settings are disabled.
 	Default: 1 (fallback enabled)
-- 
2.20.1

