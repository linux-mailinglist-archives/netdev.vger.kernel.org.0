Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33173235DE
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 03:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhBXCnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 21:43:31 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49033 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232698AbhBXCnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 21:43:25 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A97B65C0113;
        Tue, 23 Feb 2021 21:42:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Feb 2021 21:42:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        message-id:in-reply-to:references:from:date:subject:to; s=fm2;
         bh=zX7JBPLIHAV2HMYc9beglbBAlWe9br7l4Md06RPvYow=; b=efjJ6OteR33d
        tzsN4LRW/Gl14AmksIb2CKhYpIcWlNIBPY+EVDZ4KFlXbANHmHSy5jwcTdKuxQLe
        n1AKAdU0ZaFwzRv6GnwjwlSo9FVzcGPupf2GgY/jxqP8m0kfp/hBZPmkdoehjnIj
        xFK+FGtDgb1KUBORjj42uCbrD9btDQgMnBG44Po9WJqGYfsHOluHitb0wAhSXgXy
        H3/h5NO7x3mrIxZHx4wv27Y2GZ+epSRLa92YeCVCvfl4r/PwrQY+6vPdxo/hAH8J
        IoAKvxu2TknB/vZer6tOtpxT6di7/v9hc4HZAWT2BsmZ/zDsqBEuydDBnpr/LdkJ
        NI4wds898A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=date:from:in-reply-to:message-id
        :references:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=zX7JBPLIHAV2HMYc9beglbBAlWe9b
        r7l4Md06RPvYow=; b=V8OErlgmH/t6PqBteEXF7aORvUnsedYPmHyTSDUx90vHj
        +AWzAoaV3iH1g1+ZYL1QMDE29vwQ7VBd6Bwd5Fzoe2jdchvZJX9rYfgbxj8iAvjx
        yKsGeq7fM/RprfNudqSKhw2xo95L7GBu2L+j64nU8453xfEN6N0QOK39P5I1YyrT
        UbFf7RuFv7D6QvL6Lpxh9iO4ARbvzX6oUvdVKNk9rdLoyzT3LuIhijCUsvRgonjL
        bBxGbDoN9aqV1i+9YMEw+5K+NZJPFPBq6KycOebGqbu0JDUabv+6881PDk/e24Rl
        ZJ7yFW4WPIxpV1Ei9d0Ycjvpo3IunrksuvwdMxPJw==
X-ME-Sender: <xms:Cr01YFiqmcbwbkGPBmPnop4-V6vlnoamveYzEggASm8VHOrSqrZW5A>
    <xme:Cr01YKCzjj-9i1h8MLUR_l5IommmDcSQhI5zReTbNixQf5wpLjmpbziS-CCI2S--d
    miNbMEXKmT5O-Qbvjs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeeigdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepkfgjfhfhfffuvfestddtredttddttd
    enucfhrhhomhepkfgrnhcuffgvnhhhrghrughtuceoihgrnhesiigvnhhhrggtkhdrnhgv
    theqnecuggftrfgrthhtvghrnhepleelgefggfeuvdfgleegffeludduledttefggeeivd
    ekgeeffeeiffduvdejjeffnecukfhppedutddtrddtrdefjedrvddvudenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehirghnseiivghnhhgrtg
    hkrdhnvght
X-ME-Proxy: <xmx:Cr01YFGTBJSvJ58Ux9ZiR4ysRWIVTRPX_OyKZmjcIb-NGDGZoYWx5g>
    <xmx:Cr01YKTr3HN97f87HIH2VqYiwh5HTbTG_I9TEDUJUOpsWZB01kThHQ>
    <xmx:Cr01YCxxOYCDOp7Vvw0D6r4VPs-ektURdo8Iz-vGPGTzF3pYlO3yJg>
    <xmx:Cr01YHpH4CsoU6Ky4OPj5vppc2bhuo58MaB6qYyqPqBTpq7RJ2OhaQ>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6938824005D;
        Tue, 23 Feb 2021 21:42:18 -0500 (EST)
X-Mailbox-Line: From edb7c1985e446f6dd4ad875f39605bb2968d9920 Mon Sep 17 00:00:00 2001
Message-Id: <edb7c1985e446f6dd4ad875f39605bb2968d9920.1614134213.git.ian@zenhack.net>
In-Reply-To: <cover.1614134213.git.ian@zenhack.net>
References: <cover.1614134213.git.ian@zenhack.net>
From:   Ian Denhardt <ian@zenhack.net>
Date:   Tue, 23 Feb 2021 21:24:00 -0500
Subject: [PATCH 2/2] tools, bpf_asm: exit non-zero on errors.
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...so callers can correctly detect failure.
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

