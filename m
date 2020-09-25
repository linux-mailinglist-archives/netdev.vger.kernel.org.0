Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E9F278932
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgIYNQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:16:42 -0400
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:53006 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbgIYNQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:16:41 -0400
IronPort-SDR: pvB6/BqLSD6nCV6jzNQwttKSF6G2Cfouh+/UZue2RMLukfsYpc+4BX4hl+AhZF/BUMWj91w21+
 Yd753wYr0m5ERCRZLY1BYwpZoN5sbPVFltK+7V+WbEEHWlaGn+H1Naf195fZHHztoHxQLN4Z5a
 pAu2HCZajpdpsmi/o5m3admjrioVrME0n+ZIFL6f+CnHv2ZIxM7FOAiID7R4aWrISwvFr+u425
 O3LRKuSfaLWJ6jgjWoUOXCDEiFNO9EnRRGATCtmNNVN+HKZBlm9wneL+k3dNB8EQi4rQX0iLif
 RVQ=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3ADpaXJBMzJh/VqhcVQtQl6mtUPXoX/o7sNwtQ0K?=
 =?us-ascii?q?IMzox0K/z8pMbcNUDSrc9gkEXOFd2Cra4d1KyM6+u9CCQp2tWoiDg6aptCVh?=
 =?us-ascii?q?sI2409vjcLJ4q7M3D9N+PgdCcgHc5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFR?=
 =?us-ascii?q?rhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTagY75+Ngu6oRneusQWhYZpN7o8xA?=
 =?us-ascii?q?bOrnZUYepd2HlmJUiUnxby58ew+IBs/iFNsP8/9MBOTLv3cb0gQbNXEDopPW?=
 =?us-ascii?q?Y15Nb2tRbYVguA+mEcUmQNnRVWBQXO8Qz3UY3wsiv+sep9xTWaMMjrRr06RT?=
 =?us-ascii?q?iu86FmQwLuhSwaNTA27XvXh9RwgqxFvRyvqR9xzYnbb4+aL/dyYqDQcMkGSW?=
 =?us-ascii?q?dbQspdSypMCZ68YYsVCOoBOP5VoYnnqFQVrBuxHw+sD/7vxD9SmHD5wLM10/?=
 =?us-ascii?q?4gEQ7a3wwrAtUDsHrOo9ruOqcfSvu1zKrIzDXFcfxWxS3x55PWfR04p/yHQL?=
 =?us-ascii?q?1/f9bLx0Y1CwPFkkufqZbjPz6N2OoAsGyW4ephWO+vlWIqpQF/ryWzyssxlo?=
 =?us-ascii?q?XEh40bxF/Z+Ch33os4ON21RUxlbNCrDJdeuS6UOo92TM0iXW1lvCA3waAFt5?=
 =?us-ascii?q?6jZCUHzIkrywTCZ/GEbYSE+A/vWeeRLDtimX5oebSyjAuo/0e60O3zTMy03U?=
 =?us-ascii?q?5PripCj9bDqGgA1wfW6sibUvt9+Vqh2SqX2wDT9O5EJUc0mLLfK54m3rE/jJ?=
 =?us-ascii?q?4TsUTEHi/thEX6lquWdkI49eey7+Tof7LmppqGOI91jAHyKqUumsqhDuQkKg?=
 =?us-ascii?q?UDW3WX9f6h2LDg40H1WqhGg/w2n6XDrZzXJNwXpqujDA9U1oYj5Qy/DzCj0N?=
 =?us-ascii?q?kAk3kINklKeBycgojyOFHPIPb4Aumjg1i2izhk2ejKPqf9DZXVMnjDjLDhcK?=
 =?us-ascii?q?5g5EFG1go809Vf6olJBb4bPvL8RErxtNjfDh83Lwy42eDnB8th1okGQ2KAHr?=
 =?us-ascii?q?eZML/OsV+P/u8vIPSMa5QPtzvmKPgq+eTujXknll8ZZ6Wp2oEXaH+gFPR8P0?=
 =?us-ascii?q?qZeWbsgssGEWoSuwo+T/Hqh0acXjFPeXmyXLkx5iomCIK9E4jPXJyigb2Z1i?=
 =?us-ascii?q?ehApJWfnxGCkyLEXrwcYWLResMZz+MLc9/iTEES7ehRJE71R20tw/11aBnLu?=
 =?us-ascii?q?zK9S0cr57j08J15+LLnxEo6TN0F9id032KT2xsmmMIRjk23L1woEBkyVeMz7?=
 =?us-ascii?q?J4g/pGGtxX/P5JTAg6OoDGz+BgCND9RBjBftGXR1aiWNmmBisxTt0pyd8Uf0?=
 =?us-ascii?q?l9A8mijgzE3yeyDb8ajaeEBJIv/6LH3HjwJ8B9xGja1KU7lFYpXJgHCWrziq?=
 =?us-ascii?q?dh+g37C4fXnkCdkKi2M6IRwGqF93qJxEKNsVteXQo2Vr/KDl4FYU6Dg93z50?=
 =?us-ascii?q?rEB5G0BLgqKApKyobWJKJAZPXyjkRASeulMtmIMDH5oHu5GRvdnuDEV4HtYW?=
 =?us-ascii?q?hIhCg=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQ?=
 =?us-ascii?q?EAQECAQEHAQEcgUqBHCACAQGCLV+NPpJikgQLAQEBAQEBAQEBNQECBAEBhEu?=
 =?us-ascii?q?CMSU4EwIDAQEBAwIFAQEGAQEBAQEBBQQBhg9Fgjcig0cLASMjgT8SgyaCWCm?=
 =?us-ascii?q?4PzOEEIURgUKBNgIBAQEBiCuFGoFBP4RfhASGMAS3PYJxgxOEaZJMDyKhEC2?=
 =?us-ascii?q?SW6IYgXpNIBiDJFAZDZxoQjA3AgYKAQEDCVcBPQGLWYJGAQE?=
X-IPAS-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQEAQECAQEHAQEcg?=
 =?us-ascii?q?UqBHCACAQGCLV+NPpJikgQLAQEBAQEBAQEBNQECBAEBhEuCMSU4EwIDAQEBA?=
 =?us-ascii?q?wIFAQEGAQEBAQEBBQQBhg9Fgjcig0cLASMjgT8SgyaCWCm4PzOEEIURgUKBN?=
 =?us-ascii?q?gIBAQEBiCuFGoFBP4RfhASGMAS3PYJxgxOEaZJMDyKhEC2SW6IYgXpNIBiDJ?=
 =?us-ascii?q?FAZDZxoQjA3AgYKAQEDCVcBPQGLWYJGAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 25 Sep 2020 15:16:39 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 2/5 net-next] vxlan: add unlikely to vxlan_remcsum check
Date:   Fri, 25 Sep 2020 15:16:18 +0200
Message-Id: <20200925131618.56512-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

small optimization around checking as it's being done in all
receptions

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 47c762f7f5b11..cc904f003f158 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1876,7 +1876,7 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	if (vs->flags & VXLAN_F_REMCSUM_RX)
-		if (!vxlan_remcsum(&unparsed, skb, vs->flags))
+		if (unlikely(!vxlan_remcsum(&unparsed, skb, vs->flags)))
 			goto drop;
 
 	if (vxlan_collect_metadata(vs)) {
-- 
2.27.0

