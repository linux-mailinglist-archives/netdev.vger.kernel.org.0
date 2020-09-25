Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0397727892D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgIYNQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:16:25 -0400
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:52973 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728814AbgIYNQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:16:25 -0400
IronPort-SDR: lAsdkI1iOSoCmuM1HFCdnPuFg7TJRwX3a9KTEHcvv3zdaRl2DgzapcT6xq2oVoAWc948leSeRQ
 ina3g2yhvB7TE7TQgwcvkTQJPgYlzjS3LYhzHX8uvKz4cHZvy1dJfzOJHO1t7RjFvrRq4Qeo2q
 BOWL3c8iwlPpXm0++t9yeFP5LbzM38RfyO04rKxAOaXSI+ZrEfyMXaOLdO0rzco/cSeJJVkofz
 Zfk3iLDLPWdETU5arxysClA0+JRSHFjSiYg1e2Sb5/rvh+8wX8CuTO9spqAxUQQAYk3ABXEaoS
 Gow=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AnZ/nNBOWH1jaD7Gxbv0l6mtUPXoX/o7sNwtQ0K?=
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
 =?us-ascii?q?4PzOEEIURgUKBNgIBAQEBiCuFGoFBP4RfijQEtz2CcYMThGmSTA8ioRCTCKI?=
 =?us-ascii?q?YgXpNIBiDJFAZDY5WjhJCMDcCBgoBAQMJVwE9AY4fAQE?=
X-IPAS-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQEAQECAQEHAQEcg?=
 =?us-ascii?q?UqBHCACAQGCLV+NPpJikgQLAQEBAQEBAQEBNQECBAEBhEuCMSU4EwIDAQEBA?=
 =?us-ascii?q?wIFAQEGAQEBAQEBBQQBhg9Fgjcig0cLASMjgT8SgyaCWCm4PzOEEIURgUKBN?=
 =?us-ascii?q?gIBAQEBiCuFGoFBP4RfijQEtz2CcYMThGmSTA8ioRCTCKIYgXpNIBiDJFAZD?=
 =?us-ascii?q?Y5WjhJCMDcCBgoBAQMJVwE9AY4fAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 25 Sep 2020 15:16:23 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 1/5 net-next] vxlan: don't collect metadata if remote checksum is wrong
Date:   Fri, 25 Sep 2020 15:16:02 +0200
Message-Id: <20200925131602.56461-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

call vxlan_remcsum() before md filling in vxlan_rcv()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index b9fefe27e3e89..47c762f7f5b11 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1875,6 +1875,10 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 				   !net_eq(vxlan->net, dev_net(vxlan->dev))))
 		goto drop;
 
+	if (vs->flags & VXLAN_F_REMCSUM_RX)
+		if (!vxlan_remcsum(&unparsed, skb, vs->flags))
+			goto drop;
+
 	if (vxlan_collect_metadata(vs)) {
 		struct metadata_dst *tun_dst;
 
@@ -1891,9 +1895,6 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 		memset(md, 0, sizeof(*md));
 	}
 
-	if (vs->flags & VXLAN_F_REMCSUM_RX)
-		if (!vxlan_remcsum(&unparsed, skb, vs->flags))
-			goto drop;
 	if (vs->flags & VXLAN_F_GBP)
 		vxlan_parse_gbp_hdr(&unparsed, skb, vs->flags, md);
 	/* Note that GBP and GPE can never be active together. This is
-- 
2.27.0

