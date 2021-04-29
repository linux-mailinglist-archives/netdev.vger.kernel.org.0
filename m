Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5B836E52F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 08:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbhD2G4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 02:56:19 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:22279 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237146AbhD2G4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 02:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619679333; x=1651215333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=76XTOd1vl8Um82kU9b9uNSfrIRZPi/Si+ad1IrDBPgM=;
  b=d/jkrU1BToPojkJ0nFuyqRGulRA86O9gyIxROGAap+MygqlwgGh3LyiX
   xyeuql4DPDAx1Ym76uDE9IyhlR9k8Jd9jda3NiD6tsh2Yn+6MwPWSAzfU
   P2QFjRSOMIVab5/VzSk44U6Sne7PWIEeHHjq9pLHsFs5G+Tddd90iukz/
   s=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="104668397"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 29 Apr 2021 06:48:23 +0000
Received: from EX13D19EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id BE06C240ACA;
        Thu, 29 Apr 2021 06:48:21 +0000 (UTC)
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D19EUA003.ant.amazon.com (10.43.165.175) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 06:48:20 +0000
Received: from 8c85908914bf.ant.amazon.com.com (10.85.98.110) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 06:48:17 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     David Ahern <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH iproute2-next v2 1/2] rdma: update uapi headers
Date:   Thu, 29 Apr 2021 09:48:02 +0300
Message-ID: <20210429064803.58458-2-galpress@amazon.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210429064803.58458-1-galpress@amazon.com>
References: <20210429064803.58458-1-galpress@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update rdma_netlink.h file upto kernel commit
6cc9e215eb27 ("RDMA/nldev: Add copy-on-fork attribute to get sys command")

Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index e161c245bf71..37f583ee58fc 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -546,6 +546,9 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_ATTR_MIN_RANGE,		/* u32 */
 	RDMA_NLDEV_ATTR_MAX_RANGE,		/* u32 */
+
+	RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK,	/* u8 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.31.1

