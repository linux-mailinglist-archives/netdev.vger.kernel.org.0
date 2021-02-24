Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C8F3245B9
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbhBXVXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:23:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53347 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233922AbhBXVXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:23:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C2C815C015C;
        Wed, 24 Feb 2021 16:22:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 24 Feb 2021 16:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        message-id:in-reply-to:references:from:date:subject:to; s=fm2;
         bh=jTVg3G4cu/UsP/usEY8GDOyu2foXdL73CsN7V9uXu7U=; b=OGrSWRqlu/x5
        Kv/ki+/9g+a6eKKLGVfsEu8P1DPC6OS/BVmAav/rWVgf0vrxhXTDZ5q2r25gCgZ7
        k0C+0UzKVFbh8qZjyxRInIISTdzPT436QLJS+cW5YNkj+yTzmF96+5G8mNBn7dvH
        Gbmm1G+GCdaUwGM/V8/HMsilw1BERaTnMGLFWTKs/RDAelyHCf1myS418993YeAf
        6pChlIE2T5nHXI4QqCT1IFKCgN4DqXwb3g1JPepsMWhiCF6AG5nFe/+ypEMFf9Ff
        813pST9ZUp1J147zGuvGtbT+iS2xXHYcE6zma3Ijl7no+C1hrm7cWweGX/vyg4/j
        hK2gPjsDYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=date:from:in-reply-to:message-id
        :references:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=jTVg3G4cu/UsP/usEY8GDOyu2foXd
        L73CsN7V9uXu7U=; b=sWbBltcpW+9fC6wUpXK6eE/Di9RaB50Mz3Us0P2iFoZgf
        /udmeHv/6eT/LDZcR8nbZlsFLz3Ip0NmU+0/pyKavPODENwt4KgXcYvSt9tpeT+h
        uXVSDkcJLLP42rYrSSMkMjIkojsO/6y9dkyelQ5bRwo2jq4axMlnu0jxCDE1YWoW
        UqAU74f0cNy5jQ8SBlEpcEgFh2ewAivQ/ZyjXYb2ERdEGc6tRhfSp8uC6+NwpwMI
        rq6QxmnpWniEw3wixn2wjljU9m3DmbG0EPSSzHf0fThH+u9EB2YyjeDebvZACZhs
        9KnWBV38vmf7QBOiHKZpJkqIDB5m5SwxVd1apIPwA==
X-ME-Sender: <xms:p8M2YKeQ1qnEkAyd9Kt1hd7XF_hfbAyhzcIeLsLn-YUVKhmrBqtgZw>
    <xme:p8M2YEO9O4oRD6wYrVNxyxTQlnv4RKizZLWSqKe16wstVBPjCCjJR28u5xrAn0Dqp
    9QH4H1G5WhHwNy2jds>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeejgddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkjghfhfffuffvsedttdertddttd
    dtnecuhfhrohhmpefkrghnucffvghnhhgrrhguthcuoehirghnseiivghnhhgrtghkrdhn
    vghtqeenucggtffrrghtthgvrhhnpeelleeggffguedvgfelgeffleduudeltdetgfegie
    dvkeegfeefieffuddvjeejffenucfkphepuddttddrtddrfeejrddvvddunecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihgrnhesiigvnhhhrg
    gtkhdrnhgvth
X-ME-Proxy: <xmx:p8M2YLgfnhLkNaDY-U7DbkjQzdIR8w3zrGf41uLd6CjPX-jw6EEcjw>
    <xmx:p8M2YH89VhAUPL40Fq6PbwppIflrkarE0s92MnxmQ7WJ7yMc1oqBXw>
    <xmx:p8M2YGsNUH8qrstzj9iejw911SFAze73P9fSM46GekbHktgwe2ZC0w>
    <xmx:p8M2YLXZAYtJ_N1LwXwmDgiyx7uS64pNMySAMRVzuGqyJFfsIN51NQ>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CA361080057;
        Wed, 24 Feb 2021 16:22:47 -0500 (EST)
X-Mailbox-Line: From b36c61004609b6499992ec08c8b69a255ab9a55d Mon Sep 17 00:00:00 2001
Message-Id: <b36c61004609b6499992ec08c8b69a255ab9a55d.1614201304.git.ian@zenhack.net>
In-Reply-To: <cover.1614201303.git.ian@zenhack.net>
References: <cover.1614201303.git.ian@zenhack.net>
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

