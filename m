Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322952245FB
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgGQVvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:51:35 -0400
Received: from alln-iport-6.cisco.com ([173.37.142.93]:35265 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgGQVvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 17:51:35 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jul 2020 17:51:35 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1572; q=dns/txt; s=iport;
  t=1595022695; x=1596232295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PrH8U/oQUIkCoHJHzRknCPq0jpBVR7VNdgM3MarDuRs=;
  b=OtFx7NKXg2f8yCzQOJlscbOXlp6HJzHR0C4haLoElk+lGXJktszLp5iC
   N1Oit8Jz/q3XC6k7UXdQAz9+CU15E21ynQQ4r+lW98XKCfa92Gtkj39mb
   y7UeddBvFztFtldqPjQs/IOJp+1KjMAWzrfVE3CbvlzVDiGxUBViqAm/o
   w=;
X-IronPort-AV: E=Sophos;i="5.75,364,1589241600"; 
   d="scan'208";a="545085576"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 Jul 2020 21:48:31 +0000
Received: from 240m5avmarch.cisco.com (240m5avmarch.cisco.com [10.193.164.12])
        (authenticated bits=0)
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPSA id 06HLmKnW030142
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Fri, 17 Jul 2020 21:48:30 GMT
From:   Govindarajulu Varadarajan <gvaradar@cisco.com>
To:     netdev@vger.kernel.org, edumazet@google.com,
        linville@tuxdriver.com, mkubecek@suse.cz
Cc:     govind.varadar@gmail.com, benve@cisco.com,
        Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: [PATCH ethtool v2 2/2] man: add man page for ETHTOOL_GTUNABLE and ETHTOOL_STUNABLE
Date:   Fri, 17 Jul 2020 07:59:50 -0700
Message-Id: <20200717145950.327680-2-gvaradar@cisco.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717145950.327680-1-gvaradar@cisco.com>
References: <20200717145950.327680-1-gvaradar@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: gvaradar@cisco.com
X-Outbound-SMTP-Client: 10.193.164.12, 240m5avmarch.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
---
v2:
Add description

 ethtool.8.in | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 689822e..9a3e9a7 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -398,6 +398,18 @@ ethtool \- query or control network driver and hardware settings
 .RB [ fast-link-down ]
 .RB [ energy-detect-power-down ]
 .HP
+.B ethtool \-\-get\-tunable
+.I devname
+.RB [ rx-copybreak ]
+.RB [ tx-copybreak ]
+.RB [ pfc-prevention-tout ]
+.HP
+.B ethtool \-\-set\-tunable
+.I devname
+.BN rx\-copybreak
+.BN tx\-copybreak
+.BN pfc\-prevention\-tout
+.HP
 .B ethtool \-\-reset
 .I devname
 .BN flags
@@ -1211,6 +1223,34 @@ Gets the PHY Fast Link Down status / period.
 .B energy\-detect\-power\-down
 Gets the current configured setting for Energy Detect Power Down (if supported).
 
+.RE
+.TP
+.B \-\-get\-tunable
+Get the tunable parameters.
+.RS 4
+.TP
+.B rx\-copybreak
+Get the current rx copybreak value in bytes.
+.TP
+.B tx\-copybreak
+Get the current tx copybreak value in bytes.
+.TP
+.B pfc\-prevention\-tout
+Get the current pfc prevention timeout value in msecs.
+.RE
+.TP
+.B \-\-set\-tunable
+Set driver's tunable parameters.
+.RS 4
+.TP
+.BI rx\-copybreak \ N
+Set the rx copybreak value in bytes.
+.TP
+.BI tx\-copybreak \ N
+Set the tx copybreak value in bytes.
+.TP
+.BI pfc\-prevention\-tout \ N
+Set pfc prevention timeout in msecs.
 .RE
 .TP
 .B \-\-reset
-- 
2.27.0

