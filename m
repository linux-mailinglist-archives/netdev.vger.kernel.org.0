Return-Path: <netdev+bounces-10603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFB972F4C8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DAE41C2096A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 06:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D17220E0;
	Wed, 14 Jun 2023 06:29:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502531C04
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 06:29:35 +0000 (UTC)
Received: from mail.208.org (unknown [183.242.55.162])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179E81FDE
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:29:27 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
	by mail.208.org (Postfix) with ESMTP id 4QgwW86dfDzBR5Fg
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:29:24 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
	content-transfer-encoding:content-type:message-id:user-agent
	:references:in-reply-to:subject:to:from:date:mime-version; s=
	dkim; t=1686724164; x=1689316165; bh=klrFd4m/LXdoMGxRTnZu0esLRgA
	FT+1tJ+pjxp3tsB0=; b=NbQNkOjN3Hq7r4uDFUsqSI0dVzvCb0dk9hFctJvCWeI
	VXqOfnKaqGYIGG9xNCXNZ79dQ42LreK1K+PhVYD3u/hvME+RJ7yd0P0FzlzA+xPt
	fzn39gnuhe+hXIaF+/usVbkaT1WIDc1Bi9XDZLyg7pVvn0BLayxd2cw1IWmVZsEj
	crIhkkzGgSMonolTPg9qxR4+7zMTsRSdKhqL32i/9xI4Gwz/reWxWzk4W/cHK4uq
	izPgoW6ICqgL+P6uA+dpIGaIUpLhFahe72fCB/nKxtTsmZWu/VF8K8p8wb1+EDVf
	NMK6eAgG7BzeXQTSRnM4yxGvup86iKecCEmY7KU5ZhA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
	by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id buzV07OUgM3r for <netdev@vger.kernel.org>;
	Wed, 14 Jun 2023 14:29:24 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
	by mail.208.org (Postfix) with ESMTPSA id 4QgwW83Nz8zBQgpC;
	Wed, 14 Jun 2023 14:29:24 +0800 (CST)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 14 Jun 2023 14:29:24 +0800
From: xuanzhenggang001@208suo.com
To: davem@davemloft.net, dsahern@kernel.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, bpf@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: Remove unneeded variable
In-Reply-To: <e980bbb2536d4c35ce90a4666b3e8bf6@208suo.com>
References: <20230610124403.36396-1-denghuilong@cdjrlc.com>
 <e980bbb2536d4c35ce90a4666b3e8bf6@208suo.com>
User-Agent: Roundcube Webmail
Message-ID: <f65f9d0caf6a315f21eb09e7a29a8189@208suo.com>
X-Sender: xuanzhenggang001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fix the following coccicheck warning:

arch/x86/net/bpf_jit_comp32.c:1274:5-8: Unneeded variable: "cnt".

Signed-off-by: Zhenggang Xuan <xuanzhenggang001@208suo.com>
---
  arch/x86/net/bpf_jit_comp32.c | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c 
b/arch/x86/net/bpf_jit_comp32.c
index 429a89c5468b..bc71329ac5ed 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1271,7 +1271,6 @@ static void emit_epilogue(u8 **pprog, u32 
stack_depth)
  static int emit_jmp_edx(u8 **pprog, u8 *ip)
  {
      u8 *prog = *pprog;
-    int cnt = 0;

  #ifdef CONFIG_RETPOLINE
      EMIT1_off32(0xE9, (u8 *)__x86_indirect_thunk_edx - (ip + 5));
@@ -1280,7 +1279,7 @@ static int emit_jmp_edx(u8 **pprog, u8 *ip)
  #endif
      *pprog = prog;

-    return cnt;
+    return 0;
  }

  /*

