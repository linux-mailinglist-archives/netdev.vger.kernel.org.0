Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636853A2FB8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 17:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhFJPrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 11:47:53 -0400
Received: from mail.satchell.net ([99.65.194.97]:47394 "EHLO mail.satchell.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231837AbhFJPre (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 11:47:34 -0400
Received: from c7-i5.satchell.net (unknown [10.1.1.36])
        by mail.satchell.net (Postfix) with ESMTP id 9CD21601EF;
        Thu, 10 Jun 2021 08:45:37 -0700 (PDT)
Reply-To: list@satchell.net
To:     linux-doc@vger.kernel.org, netdev@vger.kernel.org
From:   Stephen Satchell <list@satchell.net>
Subject: [PATCH docs-next] sysctl -- rp_format completed description with
 filter criteria
Message-ID: <b143fc72-afda-1570-7ac1-1e90461a9859@satchell.net>
Date:   Thu, 10 Jun 2021 08:45:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
  Documentation/networking/ip-sysctl.rst | 7 +++++++
  1 file changed, 7 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst 
b/Documentation/networking/ip-sysctl.rst
index c2ecc98..0ab017b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1443,6 +1443,13 @@ rp_filter - INTEGER
  	  and if the source address is not reachable via any interface
  	  the packet check will fail.

+	rp_filter will examine the source address of an incoming IP
+	packet by performing an FIB lookup.  In loose mode (value 2),
+	the packet is rejected if the source address is neither
+	UNICAST nor LOCAL(when interface allows) nor IPSEC.  For
+	strict mode (value 1) the interface indicated by the FIB table
+	entry must also match the interface on which the packet arrived.
+
  	Current recommended practice in RFC3704 is to enable strict mode
  	to prevent IP spoofing from DDos attacks. If using asymmetric routing
  	or other complicated routing, then loose mode is recommended.
-- 
1.8.3.1
