Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92251E8B1
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 08:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbfEOG64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 02:58:56 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:60125 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfEOG64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 02:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1557903535; x=1589439535;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=XBqMbbFxAAub6tH6XoA+qQzvdl0A07Y1ZU1dj8j3Es4=;
  b=AMayWabNTqBnzTS13OQ0CoGHTBTItj09xgVYB1Tsckp2v4Zia+gJ3Vny
   XtZoDRo9R3uRLuFSuZArIHo0rnjV+PgZHzjxBBdMkz/+5HaoQWbZbRmcS
   YW/cHmpz7C+JwUuc8BTHgjkhLjK2qcT1McjdPj5LvuWH5oRDTreccBJY2
   U=;
X-IronPort-AV: E=Sophos;i="5.60,471,1549929600"; 
   d="scan'208";a="733161644"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 15 May 2019 06:58:54 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4F6wmi6061129
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 15 May 2019 06:58:53 GMT
Received: from EX13D19EUB002.ant.amazon.com (10.43.166.78) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 May 2019 06:58:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D19EUB002.ant.amazon.com (10.43.166.78) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 May 2019 06:58:52 +0000
Received: from galpress-VirtualBox.hfa16.amazon.com (10.218.62.23) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 15 May 2019 06:58:49 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     <netdev@vger.kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH iproute2] rdma: Update node type strings
Date:   Wed, 15 May 2019 09:58:36 +0300
Message-ID: <1557903516-14860-1-git-send-email-galpress@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typo in usnic_udp node type and add a string for the unspecified
node type.

Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 rdma/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rdma/dev.c b/rdma/dev.c
index 339625202200..904836221c1b 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -170,7 +170,8 @@ static const char *node_type_to_str(uint8_t node_type)
 	static const char * const node_type_str[] = { "unknown", "ca",
 						      "switch", "router",
 						      "rnic", "usnic",
-						      "usnic_dp" };
+						      "usnic_udp",
+						      "unspecified" };
 	if (node_type < ARRAY_SIZE(node_type_str))
 		return node_type_str[node_type];
 	return "unknown";
-- 
2.7.4

