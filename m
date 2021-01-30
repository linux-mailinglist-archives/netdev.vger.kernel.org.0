Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42B1309505
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 12:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhA3L4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 06:56:06 -0500
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:54102 "EHLO
        bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhA3L4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 06:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1031; q=dns/txt; s=iport;
  t=1612007764; x=1613217364;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SjQny2U0SmNslQRFB24Sf6IeYW9zw4iqoArd6ysixCo=;
  b=PB2oOHNvIrbDXYE9NtmFp+FI8gzfCltEeFQXT7uJeorcUfzDoa7w+QWO
   5GcsyXSyTicby6PWCKr/ecASHQLNjqo+MvSHz6QAorTWb0IcXqsFKtK5M
   T/6MceMnIQVn1O2s5VsGHLiAEcLx/gmCwxDD7CiFvL7U29z9oy8bSWzqM
   A=;
X-IronPort-AV: E=Sophos;i="5.79,388,1602547200"; 
   d="scan'208";a="136659721"
Received: from vla196-nat.cisco.com (HELO bgl-core-3.cisco.com) ([72.163.197.24])
  by bgl-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 30 Jan 2021 11:55:21 +0000
Received: from bgl-ads-1848.cisco.com (bgl-ads-1848.cisco.com [173.39.51.250])
        by bgl-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 10UBtLIB019333
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 30 Jan 2021 11:55:21 GMT
Received: by bgl-ads-1848.cisco.com (Postfix, from userid 838444)
        id 1E221CC1251; Sat, 30 Jan 2021 17:25:21 +0530 (IST)
From:   Aviraj CJ <acj@cisco.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, xe-linux-external@cisco.com,
        acj@cisco.com
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH stable v5.4 1/2] ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
Date:   Sat, 30 Jan 2021 17:24:51 +0530
Message-Id: <20210130115452.19192-1-acj@cisco.com>
X-Mailer: git-send-email 2.26.2.Cisco
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 173.39.51.250, bgl-ads-1848.cisco.com
X-Outbound-Node: bgl-core-3.cisco.com
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

