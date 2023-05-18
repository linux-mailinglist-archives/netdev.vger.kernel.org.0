Return-Path: <netdev+bounces-3489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2237078B5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAD3728179D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16F939B;
	Thu, 18 May 2023 04:00:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E247394
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:00:53 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3CD30EC
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:00:51 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id D715A5C0151;
	Thu, 18 May 2023 00:00:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 18 May 2023 00:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1684382447; x=1684468847; bh=9XDY3qIL5Y
	mh793iWgz/KuPvoObDkpG3i2bNN78lDoI=; b=FmPodWtfk6WnSLpyhAzzoi7TVb
	DJrO5h400PlLt1sn5wGUv5zKGKAcMqkILEGK8LWUhKdm5x2uNolV4XUPSw8kbk1n
	QqbxE3r55tZgeQmrU0wn4kZnTHRB4G6en1WSBua7FkoWjzLPosnxAaTf4rIYgJLr
	oYMkgMl2Nk6zVTEPYcdJ/Yl29K8WgE1EFksZiUrDkRutkrFZj4eyY1PMBje+6hwf
	NqCHS6hta7FrOCanVesLa7dptCIkU3d6VWcIWZCTtgtmywlPB6Glp+/slnId5nQ4
	SobIto1eK+z+JPJ9LaEuEqbzyRgxLeuULMr96RbAGQUoaq+cZVbfFUqlsOsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684382447; x=1684468847; bh=9XDY3qIL5Ymh7
	93iWgz/KuPvoObDkpG3i2bNN78lDoI=; b=dHwRP2xTKe6AdJJe1W/hUgjt/hLxn
	qS3H1ERa1lYCmkB3ImDh9nb5xgv4rWsjwx31mU2fZbP1A4mKkPwr/moXcZMnPUtR
	mcnfv7P0sinaZ400q8hlvTPhumPjoiWPe5JnYJL04gV1RfPOSsEOaE7yS0LssZX/
	ol0fjNQYjXwIf/gbo/RRsYPPKk3NJZEw1GSHnCfT41kYydb9u+7lJ/Gfht/SWmIx
	NSApH8xVZ1zpbs5E4JXwoOGcVjtLvgwLVHMt0jTKDDwVmh/gjsMz4Ja5GDyYIS+Z
	i4jwDH8fPgkU8MCUaOsbpabYfgXOINDB6EYn1/Fer/5IGqImJQXhgdl9A==
X-ME-Sender: <xms:76JlZLuqi3OAiNauhdJ8ZgG8lXQPe8tDLF-M9GBBhIy31feLHB2n2A>
    <xme:76JlZMfPNYSpo0Mvpll87bKiVPHjBJWqBpaaLpuv9q4TidbxZWuy-OTrpHdRtiQHz
    RjPecKHmYN1RPb0s-A>
X-ME-Received: <xmr:76JlZOyZargppy-pJ3Dpm7LqDAILiTEJz5K6zdms68TacL8ro9mffe6VASE4l0KxJXo8h4ViEYc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeivddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:76JlZKP9IB7t5aZAg0e6_jak99IYNxokPFTTCS3RKjeshvCxFIJzjQ>
    <xmx:76JlZL80dOAMDOazVULBu50hFrsTi6kpY3LcP-3SulGRPP-SK6KRUQ>
    <xmx:76JlZKWr2LtAlKm2sHHaiymXmZGEAaefOeLrvPGnMjEls19eKsYhTg>
    <xmx:76JlZKXxtEi64rorrbvUyuEifksZ1P6Ww0DqF76ZbVHjRNCpf7N8iw>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 May 2023 00:00:43 -0400 (EDT)
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
Subject: [PATCH iproute2-next v3] ip-link: add support for nolocalbypass in vxlan
Date: Thu, 18 May 2023 12:00:30 +0800
Message-Id: <20230518040030.5935-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
v2=>v3: 1. replace fputs with print_string                                                                                                     2. fix 77 char line length                                                                                                             3. fix typos and improve man page                                                                                                      4. reformat strcmp usage                                                                                                        this patch matches commit 69474a8a5837be63f13c6f60a7d622b98ed5c539                                                                     in the main tree.                                                                                                                      
ip/iplink_vxlan.c     | 20 ++++++++++++++++++++
 man/man8/ip-link.8.in | 10 ++++++++++
 2 files changed, 30 insertions(+)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index c7e0e1c4..966b0daf 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -45,6 +45,7 @@ static void print_explain(FILE *f)
 		"		[ [no]remcsumtx ] [ [no]remcsumrx ]\n"
 		"		[ [no]external ] [ gbp ] [ gpe ]\n"
 		"		[ [no]vnifilter ]\n"
+		"		[ [no]localbypass ]\n"
 		"\n"
 		"Where:	VNI	:= 0-16777215\n"
 		"	ADDR	:= { IP_ADDRESS | any }\n"
@@ -276,6 +277,14 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else if (!matches(*argv, "noudpcsum")) {
 			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
 			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
+		} else if (strcmp(*argv, "localbypass") == 0) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS,
+				     *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
+		} else if (strcmp(*argv, "nolocalbypass") == 0) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS,
+				     *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
 		} else if (!matches(*argv, "udp6zerocsumtx")) {
 			check_duparg(&attrs, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
 				     *argv, *argv);
@@ -613,6 +622,17 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		}
 	}
 
+	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
+		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
+
+		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
+		if (localbypass) {
+			print_string(PRINT_FP, NULL, "localbypass ", NULL);
+		} else {
+			print_string(PRINT_FP, NULL, "nolocalbypass ", NULL);
+		}
+	}
+
 	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
 		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index bf3605a9..ef6a800d 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -630,6 +630,8 @@ the following additional arguments are supported:
 ] [
 .RB [ no ] udpcsum
 ] [
+.RB [ no ] localbypass
+] [
 .RB [ no ] udp6zerocsumtx
 ] [
 .RB [ no ] udp6zerocsumrx
@@ -734,6 +736,14 @@ are entered into the VXLAN device forwarding database.
 .RB [ no ] udpcsum
 - specifies if UDP checksum is calculated for transmitted packets over IPv4.
 
+.sp
+.RB [ no ] localbypass
+- if FDB destination is local, with nolocalbypass set, forward encapsulated
+packets to the userspace network stack. If there is a userspace process
+listening for these packets, it will have a chance to process them. If
+localbypass is active (default), bypass the userspace network stack and
+inject the packets ingit to the target VXLAN device, assuming one exists.
+
 .sp
 .RB [ no ] udp6zerocsumtx
 - skip UDP checksum calculation for transmitted packets over IPv6.
-- 
2.35.8

--
Fastmail.


