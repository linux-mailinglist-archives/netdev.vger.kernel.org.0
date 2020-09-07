Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E40625FE63
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgIGQPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:15:31 -0400
Received: from mailrelay114.isp.belgacom.be ([195.238.20.141]:59666 "EHLO
        mailrelay114.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729988AbgIGQPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:15:06 -0400
IronPort-SDR: dieaFj0XuBLbwCPcmuyfJKb5DtO63lgh5Jm3f9xhzLV65F+d0LNRmi+wTnUz7HlW2dx15N4dab
 vLpKI7M1DxRR2oU05vWbwlJNIpG8rRUP8l7rWfV4fRDddqKWtL3CcgPr5U5NJxpaUw9a5HpHXK
 CgBkn+Vdl0sz9VKE5prbvNxzPFfAFEGW0DO3F04yTFGdJjbGdHYsOmHBYizMvSWZVuqyd7mTU4
 NexPajjuRjEBq5D/ph0IqKlmOFYBQM7WgkB0UOj+Ty7MRzsAl/LyogcYs+WJ0ViDoni5YBU/zA
 aOE=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AARXcVhIRgrXdQaJlF9mcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgXKv7/rarrMEGX3/hxlliBBdydt6sazbOL6+u+CSQp2tWoiDg6aptCVh?=
 =?us-ascii?q?sI2409vjcLJ4q7M3D9N+PgdCcgHc5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFR?=
 =?us-ascii?q?rhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTagYL5+Ngi6oAXNusUZgIZvKbs6xw?=
 =?us-ascii?q?fUrHdPZ+lY335jK0iJnxb76Mew/Zpj/DpVtvk86cNOUrj0crohQ7BAAzsoL2?=
 =?us-ascii?q?465MvwtRneVgSP/WcTUn8XkhVTHQfI6gzxU4rrvSv7sup93zSaPdHzQLspVz?=
 =?us-ascii?q?mu87tnRRn1gyoBKjU38nzYitZogaxbvhyvuhJxzY3Tbo6aO/RzZb/RcNAASG?=
 =?us-ascii?q?ZdRMtdSzBND4WhZIUPFeoBOuNYopH9qVQUthS+BBOjBOXywTFInH/5w7A13P?=
 =?us-ascii?q?o7EQHHwAMgHM8FvXParNrvL6gSX/u4zLLLzTTDafNZxyv95JLTfR8/uPyBW6?=
 =?us-ascii?q?97fsXNx0c1DQzFkkmQppL/PzOTzukDvWuW4u5gW++ui2MrtQ98rDiyy8swl4?=
 =?us-ascii?q?XFmoMYxF/L+yhkzos4O8C1RU55bNO6H5Vcqy+UOYRyT80iQ29kpiI3x7sbsp?=
 =?us-ascii?q?C4ZCgH0JAqywPFZ/CacIWE/AjvWPuQLDp4nn5pZbOyihCv+ka60OL8TNO70F?=
 =?us-ascii?q?NSoypAldnDq24C2gTI6siCVvt95kCh2SuT1wzL6uFLP0Q0la3DJpE6w74wmZ?=
 =?us-ascii?q?UTsVnYHi/tn0X2iLKWdl4+9uio7OTnZ6vpqoedN49ylA7+Lrwjl8iiDegiLw?=
 =?us-ascii?q?QDXHaX9f6h2LDi/UD1WqhGg/wunqncqp/aJMAbpqCjAw9S14Yu8xi/AC2939?=
 =?us-ascii?q?QWhnQHN1FFeRKBj4f3J1HCOuv3Aumnj1S2jDhr3+zGPqHmApjVM3fMiqnhcq?=
 =?us-ascii?q?h460NH1QU8185f6IxRCrEFJ/LzVFPxuMbeDhAnLwy+2/znB8ll1oMCRWKPBb?=
 =?us-ascii?q?eUMKDPsVCT/O0iOOqMa5EPuDb7Nfcl4+TijXgjmV8SZaOpx4cYaGikHvR6JE?=
 =?us-ascii?q?WUeXTsg9kaHGcRogo+Vujqh0OEUTJJenm9Qbo25isnB4K+EYfDWoetjaSH3C?=
 =?us-ascii?q?ilAp1Ze35JCk6XHHf2eIWLRe0MZDiRIsB/iDwEU6auS4s72RGprg/6xKJtLv?=
 =?us-ascii?q?DI9S0AqZLjyN916vXdlR4o7jN0Ad+Q03qOT2B0mGMHWSM20LpkrkNjmR+/1v?=
 =?us-ascii?q?10iuJVEPRf7u1EVwM9O4KayeFmT5jxRwjIVtSEUlCrRpOhGz51Btwu68QSeU?=
 =?us-ascii?q?JwHZOug1SL2Se2D7ILv6KECYZy8a/G2XX1YcFnxCXozq4k2ncvSMpGMyWInK?=
 =?us-ascii?q?Nz+hLSDI2Bx0uQnaiCbqcN2iPRsm2Omznd9HpEWRJ9BP2WFUsUYVHb+Iz0?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AFBQBTXFZf/xCltltfH3GFN1+NOoY?=
 =?us-ascii?q?kjC2SAgsBAQEBAQEBAQE0AQIEAQGES4I9JTgTAgMBAQEDAgUBAQYBAQEBAQE?=
 =?us-ascii?q?FBAGGD0WCNyKDUgEjI09wEoMmglgptA2FU4MzgUKBOIgshRmBQT+EX4o0BLZ?=
 =?us-ascii?q?qgm+DDZcWDyGgVi2SJKFqgXpNIBiDJFAZDZxoQjA3AgYKAQEDCVcBIgGPCwE?=
 =?us-ascii?q?B?=
X-IPAS-Result: =?us-ascii?q?A2AFBQBTXFZf/xCltltfH3GFN1+NOoYkjC2SAgsBAQEBA?=
 =?us-ascii?q?QEBAQE0AQIEAQGES4I9JTgTAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDU?=
 =?us-ascii?q?gEjI09wEoMmglgptA2FU4MzgUKBOIgshRmBQT+EX4o0BLZqgm+DDZcWDyGgV?=
 =?us-ascii?q?i2SJKFqgXpNIBiDJFAZDZxoQjA3AgYKAQEDCVcBIgGPCwEB?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO biggussolus.home) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 07 Sep 2020 18:14:48 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, fw@strlen.de,
        netdev@vger.kernel.org
Cc:     Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 net-next] selftests/net: replace obsolete NFT_CHAIN configuration
Date:   Mon,  7 Sep 2020 18:14:28 +0200
Message-Id: <20200907161428.16847-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace old parameters with global NFT_NAT from commit db8ab38880e0
("netfilter: nf_tables: merge ipv4 and ipv6 nat chain types")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/net/config | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 3b42c06b59858..5a57ea02802df 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -24,8 +24,7 @@ CONFIG_IP_NF_NAT=m
 CONFIG_NF_TABLES=m
 CONFIG_NF_TABLES_IPV6=y
 CONFIG_NF_TABLES_IPV4=y
-CONFIG_NFT_CHAIN_NAT_IPV6=m
-CONFIG_NFT_CHAIN_NAT_IPV4=m
+CONFIG_NFT_NAT=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
-- 
2.27.0

