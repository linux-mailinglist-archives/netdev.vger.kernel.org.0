Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADA349D200
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244189AbiAZSrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:47:04 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:45388 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244169AbiAZSrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 13:47:04 -0500
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 497C0200BE7E;
        Wed, 26 Jan 2022 19:47:00 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 497C0200BE7E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643222820;
        bh=okhvnbZHP6LPau5LZZ4uoPQdP1yX58fTbe0BC7m3Qps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZzaLK8pU8UheCloLq51A9eRjb0wXjiSG7Ie6bNxJxMfh6lJkWPhaNRGuX2clyrJg
         5VlYXsOrpojnBImXDhbAkohx012NPlBDp8TyvTxtqSzMLL2KzET2Zptpfx7tfuWV0g
         7ieNg3cuTC6ze5hGjW5uQMtEKB1LcUdUIMaEcjg5ulRdfqtuiFf6AsfbnXY5tsQIIX
         34g4ORVSYN2EDUa+mwPMnneDwnogvAWrEifu+lTl/iOxCM3p3GleM8JLDAHQWDBm07
         gWamtaZQbg7nHKJ6lrUc3xmATkzPgDY3CHGUPms3gKtiCVoi1db1MhrkKI8jc+Qd4E
         B0zN99UvMjxHw==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next 1/2] uapi: ioam: Insertion frequency
Date:   Wed, 26 Jan 2022 19:46:27 +0100
Message-Id: <20220126184628.26013-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126184628.26013-1-justin.iurman@uliege.be>
References: <20220126184628.26013-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the insertion frequency uapi for IOAM lwtunnels.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/uapi/linux/ioam6_iptunnel.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/ioam6_iptunnel.h b/include/uapi/linux/ioam6_iptunnel.h
index 829ffdfcacca..462758cdba14 100644
--- a/include/uapi/linux/ioam6_iptunnel.h
+++ b/include/uapi/linux/ioam6_iptunnel.h
@@ -30,6 +30,15 @@ enum {
 enum {
 	IOAM6_IPTUNNEL_UNSPEC,
 
+	/* Insertion frequency:
+	 * "k over n" packets (0 < k <= n)
+	 * [0.0001% ... 100%]
+	 */
+#define IOAM6_IPTUNNEL_FREQ_MIN 1
+#define IOAM6_IPTUNNEL_FREQ_MAX 1000000
+	IOAM6_IPTUNNEL_FREQ_K,		/* s32 */
+	IOAM6_IPTUNNEL_FREQ_N,		/* s32 */
+
 	/* Encap mode */
 	IOAM6_IPTUNNEL_MODE,		/* u8 */
 
-- 
2.25.1

