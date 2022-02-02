Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202094A72F5
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344911AbiBBO0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:26:10 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:57160 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344907AbiBBO0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:26:09 -0500
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 91B71200F82E;
        Wed,  2 Feb 2022 15:26:07 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 91B71200F82E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643811967;
        bh=LSjutnclx8bl8zi9N2/zUTZ9BGMAOKDBc0sO7vmFshw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIj1TPt1WvrarKhMU04SpZQDNKTAQAJjWEFZgisnVnlgR9p43MJZMpCl+WiKdU2mS
         t2Qer8WDbd1+dnVhE0y4M0NyYXq+PjV0Q4Fbp3HQ9LYcbIOhot37ST4bUBfLl85wwD
         xCNtLV/LGy+zkmmDehN04IDfC5i9s7PcUDyrcgUYHtR+mC4UJQdfx2AczSpxgylGXI
         5q/qpf5w03vx8JANqLHW8/oPkcXVX84edjFh9J5ca2wJgO86/cLbaFWktZ3bmsvniC
         /j1XwhjSiHVun650EMm6v0ycuBNgdY7QaGqs2T0eA7ylDfLTR2GO8o0TT5InhwAtl0
         d+tcuttqDS6vA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next v2 1/2] uapi: ioam: Insertion frequency
Date:   Wed,  2 Feb 2022 15:25:53 +0100
Message-Id: <20220202142554.9691-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220202142554.9691-1-justin.iurman@uliege.be>
References: <20220202142554.9691-1-justin.iurman@uliege.be>
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
index 829ffdfcacca..38f6a8fdfd34 100644
--- a/include/uapi/linux/ioam6_iptunnel.h
+++ b/include/uapi/linux/ioam6_iptunnel.h
@@ -41,6 +41,15 @@ enum {
 	/* IOAM Trace Header */
 	IOAM6_IPTUNNEL_TRACE,		/* struct ioam6_trace_hdr */
 
+	/* Insertion frequency:
+	 * "k over n" packets (0 < k <= n)
+	 * [0.0001% ... 100%]
+	 */
+#define IOAM6_IPTUNNEL_FREQ_MIN 1
+#define IOAM6_IPTUNNEL_FREQ_MAX 1000000
+	IOAM6_IPTUNNEL_FREQ_K,		/* u32 */
+	IOAM6_IPTUNNEL_FREQ_N,		/* u32 */
+
 	__IOAM6_IPTUNNEL_MAX,
 };
 
-- 
2.25.1

