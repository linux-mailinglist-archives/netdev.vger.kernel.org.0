Return-Path: <netdev+bounces-7781-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A623172178F
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16AA91C20A3A
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 14:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964B3DDA5;
	Sun,  4 Jun 2023 14:01:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B38C23C6
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 14:01:14 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17804C4
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:01:12 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 7A3095C0117;
	Sun,  4 Jun 2023 10:01:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 04 Jun 2023 10:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1685887270; x=1685973670; bh=wAz3bShVJq
	rySuHlwxRJ60Y+zqdkGivTWsod+JR14lI=; b=tskHjDb9zSa+rWwawi7Fre6S3l
	PyQxXNKG+QJpGx+hXflchsFVzQDHDR1VF2mmhTXcXDHCqva1fC5WF2mtr4UOKWWS
	4KLZ4JzsFvk+iK7Fw42MqvBI6EPGYpY6cQJ82V4K0gW0pirWLvfDWfDN05GQodVF
	a1cCmmRH+8LV4hkm8+Zue+sI6Xv9Q6usfWL731pMLoRc71rdbao0xq6mpFuVOhjH
	Up9KWE/o5tU7AllLcBCz3ptmb23/u8JMwgVE3xVjK/OVz5NASYHin1ihtaGyaLPQ
	ubv+CCFOT+7wZINbJ+zd4CUVGvtvqMvj6zJOro/XFqxtWglp8frY3j591vlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685887270; x=1685973670; bh=wAz3bShVJqryS
	uHlwxRJ60Y+zqdkGivTWsod+JR14lI=; b=wu7B6EAp3g6FlCZcNHaXsdeZi8ZUe
	qkmyv5YYNrwN4TGCIPsMXprDyTRDFq5zjVH7T+kozrMvymGSEBo+uo6I1NbAJXRt
	pBbGaiN1bT3Hp7zaJiFcaosoW9jKKUvsKRNYxKViG9WebBx2KXv7nn0a0ClXC1Ef
	MsoV4mzoveEQiCl0Ok+57JUPOCEq3EyHoxPrQt17h617QFJvK1L3sfnWeblJkjE8
	m1gV9mXELCg0Adb+pF/BWAuroiEEIS7/XauYW/uopg/H94kbor7eIqfDz80EM+Yh
	EB+7JgZkgOIZKAw8sOlbvPWtpKT0gYzArwx0zoOyElV6/NE6EqVLuKQjA==
X-ME-Sender: <xms:JZl8ZLaP7E1Vo7gvxnix7xctbPrNgwZFCFpq5Gw-cgJ_-_-Se36k8w>
    <xme:JZl8ZKbQlE41mO7chJhLB9ttWYOus4DKRQmt_8alWd_lqBCexfwXZnuifOTvBXUJL
    EOwGDpOK7S-z65Sdws>
X-ME-Received: <xmr:JZl8ZN9SOm2jszSw-aWG8KTMmxvdzycc5vcKLcZ9XZro0p3RS2mHndlVt7Fa6L9gBZhYFQXHX4Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeljedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:JZl8ZBoPwfRuHMQ3HDH637iTExE4u2hlkXDns_DylIfKX_V8TcuuaA>
    <xmx:JZl8ZGqOAF6WMtP5ohu0NzIrGdEy7CjH6L5fcfVxJRgXz3LArAINYA>
    <xmx:JZl8ZHR7zjyLq0ElIJ2iyvDOFGXfrxgSYIvACHXqwhzZw6C9b2Y35w>
    <xmx:Jpl8ZDRTirxFSjeXbiXkC4M1ozBWxviXFgpFi4RMEp6IoiCUg5iqEw>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 4 Jun 2023 10:01:04 -0400 (EDT)
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	liuhangbin@gmail.com,
	eyal.birger@gmail.com,
	jtoppins@redhat.com,
	Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH iproute2-next v7] ip-link: add support for nolocalbypass in vxlan
Date: Sun,  4 Jun 2023 22:00:51 +0800
Message-Id: <20230604140051.4523-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add userspace support for the [no]localbypass vxlan netlink
attribute. With localbypass on (default), the vxlan driver processes
the packets destined to the local machine by itself, bypassing the
userspace nework stack. With nolocalbypass the packets are always
forwarded to the userspace network stack, so userspace programs,
such as tcpdump have a chance to process them.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
v6=>v7:
Use the new vxlan_opts data structure. Rely on the printing loop
in vxlan_print_opt when printing the value of [no] localbypass.

ip/iplink_vxlan.c     | 10 ++++++++++
 man/man8/ip-link.8.in | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index 3053cdb8..70f38a86 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -36,6 +36,7 @@ static const struct vxlan_bool_opt {
 	{ "udp_zero_csum6_rx", IFLA_VXLAN_UDP_ZERO_CSUM6_RX, false },
 	{ "remcsum_tx", IFLA_VXLAN_REMCSUM_TX,		false },
 	{ "remcsum_rx", IFLA_VXLAN_REMCSUM_RX,		false },
+	{ "localbypass", IFLA_VXLAN_LOCALBYPASS,		true },
 };
 
 static void print_explain(FILE *f)
@@ -62,6 +63,7 @@ static void print_explain(FILE *f)
 		"		[ [no]udp6zerocsumtx ]\n"
 		"		[ [no]udp6zerocsumrx ]\n"
 		"		[ [no]remcsumtx ] [ [no]remcsumrx ]\n"
+		"		[ [no]localbypass ]\n"
 		"		[ [no]external ] [ gbp ] [ gpe ]\n"
 		"		[ [no]vnifilter ]\n"
 		"\n"
@@ -327,6 +329,14 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 			check_duparg(&attrs, IFLA_VXLAN_REMCSUM_RX,
 				     *argv, *argv);
 			addattr8(n, 1024, IFLA_VXLAN_REMCSUM_RX, 0);
+		} else if (strcmp(*argv, "localbypass") == 0) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS,
+				     *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
+		} else if (strcmp(*argv, "nolocalbypass") == 0) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS,
+				     *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
 		} else if (!matches(*argv, "external")) {
 			check_duparg(&attrs, IFLA_VXLAN_COLLECT_METADATA,
 				     *argv, *argv);
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index bf3605a9..6a82ddc4 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -634,6 +634,8 @@ the following additional arguments are supported:
 ] [
 .RB [ no ] udp6zerocsumrx
 ] [
+.RB [ no ] localbypass
+] [
 .BI ageing " SECONDS "
 ] [
 .BI maxaddress " NUMBER "
@@ -742,6 +744,14 @@ are entered into the VXLAN device forwarding database.
 .RB [ no ] udp6zerocsumrx
 - allow incoming UDP packets over IPv6 with zero checksum field.
 
+.sp
+.RB [ no ] localbypass
+- if FDB destination is local, with nolocalbypass set, forward encapsulated
+packets to the userspace network stack. If there is a userspace process
+listening for these packets, it will have a chance to process them. If
+localbypass is active (default), bypass the kernel network stack and
+inject the packets into the target VXLAN device, assuming one exists.
+
 .sp
 .BI ageing " SECONDS"
 - specifies the lifetime in seconds of FDB entries learnt by the kernel.
-- 
2.35.8

--
Fastmail.


