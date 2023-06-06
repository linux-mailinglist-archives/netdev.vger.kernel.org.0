Return-Path: <netdev+bounces-8262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B58723551
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 04:32:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B9C11C20D84
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469A9374;
	Tue,  6 Jun 2023 02:32:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B947361
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:32:30 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC74116
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:32:29 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 2FD105C0127;
	Mon,  5 Jun 2023 22:32:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 05 Jun 2023 22:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1686018747; x=1686105147; bh=7N8JmNhEhI
	Ykl2bYN0BGI1aLdAFNAjqWtd3eI4nDWrc=; b=u2yop940IdnNW0HaeQWJPB1w/K
	NJrQwqPFg7Hahoz0Gx49ingIj4uOctJqj/o292aM5LeBBIpSQ+GO4CAHrDDbj8PW
	K7kOOPfmJwUt/OqlzNCptzNCI1+/27CYRGnqh+mWAv2xuc2N4yYYQNCJr/HjwTHO
	LP8A6UUpNWjNuEppLkrMKEdhURdda1MMFV1/uZMjL+0rr6vOGg45PwiDVB/+kJC1
	f4lw+KR/fQ7xTs/ePnySRqgLpTNRMcLLSQ8lnIahgjhqjXb5x+Kx8HcHHjelrybV
	Wgfaeo8GaodKIfbNqGYXe79z2bQFN5dZqbuz9DbEzQlmb0O4QBJNjLFt7hoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686018747; x=1686105147; bh=7N8JmNhEhIYkl
	2bYN0BGI1aLdAFNAjqWtd3eI4nDWrc=; b=iWcbqj+R906UE9K/Zk9ZPh3I/Jgc/
	9gcgEHyskCoBtj8yhHD3pYheptdJge5X4ZgX+gL4nprZxcFqmoyggNVOk3n7BrOA
	TunO8f5PmLaXZbb8QIjzr+4x4tcIQy9Iivm6C2KS3zvoplXAT/DeGkowpuNnv0g+
	L+H0uiQ7cDzmxTyMDdrCpXGqhdRhUodnuYEzJYtP2/I8rRvjChIA/L1BKDZyfeGK
	L2VHPZEUhTZ8pOAzsiu88FMxPNnvfP0mHPV+lNGCA5BvtYMeNo7VkWHPf7R/1VJd
	Lvb793mlgfeY3Zu2BdtWo0kP+GFyLSmDUYuivnL0eK4F9cchRH0wFVqgw==
X-ME-Sender: <xms:upp-ZHrUcCblVxKtN8DX4dgd-PT0QDjGl-_tfERDqJUEu4T89CGWgA>
    <xme:upp-ZBowXrEOrGmAM4Pp8zqVFeaR--ihmjXyHZVCLLls0OcpFSC66_8PW8-krgk0b
    Bi-b86rHKbes0M3Qc4>
X-ME-Received: <xmr:upp-ZEMvqv8sOFTqixQqprT20DLvDNxY3n82n6lLp4uHP7gkEhfdK4TbmM_N4TietbvbJ2YDqnc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedttddgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfedtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddt
    necuhfhrohhmpegglhgrughimhhirhcupfhikhhishhhkhhinhcuoehvlhgrughimhhirh
    esnhhikhhishhhkhhinhdrphifqeenucggtffrrghtthgvrhhnpeevjeetfeeftefhffel
    vefgteelieehveehgeeltdettedvtdekffelgeegiedtveenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhishhh
    khhinhdrphif
X-ME-Proxy: <xmx:upp-ZK69k7LAxxFhw9RJAcJq2tieNvgdDCYWvaTQCfoY8-0MsPyY_A>
    <xmx:upp-ZG7b_cFyz0xE9xn8AduOFyFfTPrMjuCXtwb7pnUIUPYV-Q2qxA>
    <xmx:upp-ZCjeidpKBpRw0VfJjKep5tlyYYep8xfK21eky2pkYHwo8mQWgw>
    <xmx:u5p-ZGxYROV5NOiDriTIfXUHARlzx1mN6B3_QHJ-186-CH0ClsLgiQ>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 22:32:22 -0400 (EDT)
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
	David Ahern <dsahern@gmail.com>,
	Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH iproute2-next v8] ip-link: add support for nolocalbypass in vxlan
Date: Tue,  6 Jun 2023 10:32:02 +0800
Message-Id: <20230606023202.22454-1-vladimir@nikishkin.pw>
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
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
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
v7=>v8: fix indentation. Make sure patch applies in iproute2-next.

ip/iplink_vxlan.c     | 10 ++++++++++
 man/man8/ip-link.8.in | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index 3053cdb8..7781d60b 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -36,6 +36,7 @@ static const struct vxlan_bool_opt {
 	{ "udp_zero_csum6_rx", IFLA_VXLAN_UDP_ZERO_CSUM6_RX, false },
 	{ "remcsum_tx", IFLA_VXLAN_REMCSUM_TX,		false },
 	{ "remcsum_rx", IFLA_VXLAN_REMCSUM_RX,		false },
+	{ "localbypass", IFLA_VXLAN_LOCALBYPASS,	true },
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


