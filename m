Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF23245C1
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhBXV0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:26:46 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53825 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234354AbhBXV0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:26:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9365A5C0183;
        Wed, 24 Feb 2021 16:25:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 24 Feb 2021 16:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        message-id:in-reply-to:references:from:date:subject:to; s=fm2;
         bh=jTVg3G4cu/UsP/usEY8GDOyu2foXdL73CsN7V9uXu7U=; b=g3eGJxbZGB5k
        PAC9HmqtMDv2zy0QseRDpt2ZXY9UpeDyPIGFiTyhSsInnRiO/+cPP9NSVNDCK8E7
        1jXsLYdz4505S5+cQh8DHvm+mOLUCRJrI9PNV2882JvJv/YBWUnFcaIVkzDl6e+j
        MX1nMTTkC27bdoVyx/DAgfFV+Su6ugZsKzKz6eVHBIki0MlTZKgsbRhMYRdbV8lJ
        BcQTUgRKQxETQMOkg7tbMmhP7BWCvPF+9AlaNKBbk1Ul09SW8nzdK5EYzfeApiMA
        BwS4WNfiQRQzPmtt8Trk8ylrP1QmOlEbm0PAy7LzzAh05IGa7VbMflkukGOdjDnb
        20nz8FO7Vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=date:from:in-reply-to:message-id
        :references:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=jTVg3G4cu/UsP/usEY8GDOyu2foXd
        L73CsN7V9uXu7U=; b=P0wY4hrNNUxLhORlzpolsDeU4C3pkb/1mCt35lTmCnL9v
        wt74huLdaOj/WuGB7AtaI1jHeozLU7pe6oYg3+m1bv8aSusehTv33X0yuJVlaHgv
        20qipK9Br1yV+w2Pie0BhkBVBXWQSG4SPZxUHcM1wV9PznoA0/fMND/5gwtPV925
        5h7MqxurYoCFxouR8OyCpgN6D3ZzHVjmSzYH/F++5WfJHfar0EXhhAD/7MuwB5xY
        d2wX06UyV14ShXopYyt+QjUWl6phM52zgSQYLYxw1xucMUzBtyTQhASmzO8fROMw
        qbNUIfKPqIApDsgtqRq+4/TwMCjTrCCoE5ZkZQAbg==
X-ME-Sender: <xms:T8Q2YBcCdHUBhY3S587MzkxgZN__4DSRVRK1JGGoxbWFYQGW_JS67Q>
    <xme:T8Q2YPOpb2OgEvB9W8Yp3KREoY8WG7diWhtWQt3fWiDewemDD4oUw6bYMzR36cYWO
    TXJnUIgSGmTXZr5qeo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeejgddugeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkjghfhfffuffvsedttdertddttd
    dtnecuhfhrohhmpefkrghnucffvghnhhgrrhguthcuoehirghnseiivghnhhgrtghkrdhn
    vghtqeenucggtffrrghtthgvrhhnpeelleeggffguedvgfelgeffleduudeltdetgfegie
    dvkeegfeefieffuddvjeejffenucfkphepuddttddrtddrfeejrddvvddunecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihgrnhesiigvnhhhrg
    gtkhdrnhgvth
X-ME-Proxy: <xmx:T8Q2YKgGoAa1htxFCAB8uyiGamo-8bJcFqr0S3QBbisJBRGFhuNR_A>
    <xmx:T8Q2YK8x4a81vRuEUkMVuZ1QnfLUMeuK-8ZA-hSklq3-hGYLD3ydMQ>
    <xmx:T8Q2YNslHQGL9Jui-AuI5BzrUG8LkI9WWxLDnMtOVne6lFV4zXIlOw>
    <xmx:T8Q2YOUjhYTQbHW0PqE-4hsU8n75kHWlA-AYWbg8mleT39Sb8wh4JA>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D69124005B;
        Wed, 24 Feb 2021 16:25:35 -0500 (EST)
X-Mailbox-Line: From b0bea780bc292f29e7b389dd062f20adc2a2d634 Mon Sep 17 00:00:00 2001
Message-Id: <b0bea780bc292f29e7b389dd062f20adc2a2d634.1614201868.git.ian@zenhack.net>
In-Reply-To: <cover.1614201868.git.ian@zenhack.net>
References: <cover.1614201868.git.ian@zenhack.net>
From:   Ian Denhardt <ian@zenhack.net>
Date:   Tue, 23 Feb 2021 21:24:00 -0500
Subject: [PATCH 2/2] tools, bpf_asm: exit non-zero on errors.
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...so callers can correctly detect failure.

Signed-off-by: Ian Denhardt <ian@zenhack.net>
---
 tools/bpf/bpf_exp.y | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpf_exp.y b/tools/bpf/bpf_exp.y
index 8d03e5245da5..dfb7254a24e8 100644
--- a/tools/bpf/bpf_exp.y
+++ b/tools/bpf/bpf_exp.y
@@ -185,13 +185,13 @@ ldx
 	| OP_LDXB number '*' '(' '[' number ']' '&' number ')' {
 		if ($2 != 4 || $9 != 0xf) {
 			fprintf(stderr, "ldxb offset not supported!\n");
-			exit(0);
+			exit(1);
 		} else {
 			bpf_set_curr_instr(BPF_LDX | BPF_MSH | BPF_B, 0, 0, $6); } }
 	| OP_LDX number '*' '(' '[' number ']' '&' number ')' {
 		if ($2 != 4 || $9 != 0xf) {
 			fprintf(stderr, "ldxb offset not supported!\n");
-			exit(0);
+			exit(1);
 		} else {
 			bpf_set_curr_instr(BPF_LDX | BPF_MSH | BPF_B, 0, 0, $6); } }
 	;
@@ -472,7 +472,7 @@ static void bpf_assert_max(void)
 {
 	if (curr_instr >= BPF_MAXINSNS) {
 		fprintf(stderr, "only max %u insns allowed!\n", BPF_MAXINSNS);
-		exit(0);
+		exit(1);
 	}
 }
 
@@ -522,7 +522,7 @@ static int bpf_find_insns_offset(const char *label)
 
 	if (ret == -ENOENT) {
 		fprintf(stderr, "no such label \'%s\'!\n", label);
-		exit(0);
+		exit(1);
 	}
 
 	return ret;
-- 
2.30.1

