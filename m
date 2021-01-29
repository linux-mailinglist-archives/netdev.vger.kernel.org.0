Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9773D308D81
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhA2TiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:38:13 -0500
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:7400 "EHLO
        bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhA2TiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:38:11 -0500
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2021 14:38:09 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1031; q=dns/txt; s=iport;
  t=1611949089; x=1613158689;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SjQny2U0SmNslQRFB24Sf6IeYW9zw4iqoArd6ysixCo=;
  b=ZJ+9QKqQahydzqzdN07ivYBjfqRA+c4VTerNNYd6XQOGw0S/1zeDKLIE
   ptVLTfGx6YE+eLrjcfD15qopbh+1u6qM1EO0A98wBpK/w8TvCL5jXMVQc
   WA8V4T1ddLZa28HvYOFa9CXAmFO6tUB5zmivowqz0waCJCw79COYCdA8s
   A=;
X-IronPort-AV: E=Sophos;i="5.79,386,1602547200"; 
   d="scan'208";a="175655159"
Received: from vla196-nat.cisco.com (HELO bgl-core-2.cisco.com) ([72.163.197.24])
  by bgl-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 29 Jan 2021 19:28:10 +0000
Received: from bgl-ads-1848.cisco.com (bgl-ads-1848.cisco.com [173.39.51.250])
        by bgl-core-2.cisco.com (8.15.2/8.15.2) with ESMTPS id 10TJSAZg027920
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 29 Jan 2021 19:28:10 GMT
Received: by bgl-ads-1848.cisco.com (Postfix, from userid 838444)
        id AB7FECC1251; Sat, 30 Jan 2021 00:58:09 +0530 (IST)
From:   Aviraj CJ <acj@cisco.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, xe-linux-external@cisco.com,
        acj@cisco.com
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [Internal review][PATCH stable v5.4 1/2] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Sat, 30 Jan 2021 00:57:40 +0530
Message-Id: <20210129192741.117693-1-acj@cisco.com>
X-Mailer: git-send-email 2.26.2.Cisco
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 173.39.51.250, bgl-ads-1848.cisco.com
X-Outbound-Node: bgl-core-2.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit b59e286be280fa3c2e94a0716ddcee6ba02bc8ba upstream.

Based on RFC7112, Section 6:

   IANA has added the following "Type 4 - Parameter Problem" message to
   the "Internet Control Message Protocol version 6 (ICMPv6) Parameters"
   registry:

      CODE     NAME/DESCRIPTION
       3       IPv6 First Fragment has incomplete IPv6 Header Chain

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Aviraj CJ <acj@cisco.com>
---
 include/uapi/linux/icmpv6.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index 2622b5a3e616..9a31ea2ad1cf 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -137,6 +137,7 @@ struct icmp6hdr {
 #define ICMPV6_HDR_FIELD		0
 #define ICMPV6_UNK_NEXTHDR		1
 #define ICMPV6_UNK_OPTION		2
+#define ICMPV6_HDR_INCOMP		3
 
 /*
  *	constants for (set|get)sockopt
-- 
2.26.2.Cisco

