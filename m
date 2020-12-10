Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047242D6B87
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389489AbgLJXEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388747AbgLJXEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:04:00 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225A0C061793
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:03:20 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CsTwF15d8zQlWV;
        Fri, 11 Dec 2020 00:02:53 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LjKw49ni0doIlCJQJAg+TzhueGJhlo/vtu7hbO6Vims=;
        b=dsWrKuCe4HxxFd0TqzF/C2F/B5s0+zUnrvQHh0rv5wDXUwgkoNYb3Q+kK0/TPP3P040/Dl
        bdBVtbIL8P8G1eIDVbldtOU2o6d9KPAQ8xe6Yx0bbZ9Oxf05KegdVBbJ6b/hE/oZ0/Ipwj
        8CmvkNYe6ZchDoomGdjKvIoS7ca688PNWOMJrQQrvTWWSIJ02n4Elf8TMGWEtLanGu9LTl
        ZgHGzyH0Vk9zR15fVWRIrNuM+nQzK0sP47Jo/y3vKfIaMHdwt/XQzYi1BOiLCW5AQKdUEo
        Eiqd+vExNOuqthtVbxkYX+mE03jFjDwhV9xbu0fxhqT2qQtXxz5YFrECyinZmw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id uOJf831hSQGD; Fri, 11 Dec 2020 00:02:50 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 03/10] dcb: ets: Change the way show parameters are given in synopsis
Date:   Fri, 11 Dec 2020 00:02:17 +0100
Message-Id: <9db3b144d02446d8c5613266c276b0552923434d.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.16 / 15.00 / 15.00
X-Rspamd-Queue-Id: 2A1531778
X-Rspamd-UID: 234217
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

None, one, or many parameters can be given on the command line, but
the current synopsis allows only none or one. Fix it.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb_ets.c      |  6 +++---
 man/man8/dcb-ets.8 | 13 ++++++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/dcb/dcb_ets.c b/dcb/dcb_ets.c
index 94c6019e8095..c20881051ffe 100644
--- a/dcb/dcb_ets.c
+++ b/dcb/dcb_ets.c
@@ -32,9 +32,9 @@ static void dcb_ets_help_show(void)
 {
 	fprintf(stderr,
 		"Usage: dcb ets show dev STRING\n"
-		"           [ willing | ets-cap | cbs | tc-tsa | reco-tc-tsa |\n"
-		"             pg-bw | tc-bw | reco-tc-bw | prio-tc |\n"
-		"             reco-prio-tc ]\n"
+		"           [ willing ] [ ets-cap ] [ cbs ] [ tc-tsa ]\n"
+		"           [ reco-tc-tsa ] [ pg-bw ] [ tc-bw ] [ reco-tc-bw ]\n"
+		"           [ prio-tc ] [ reco-prio-tc ]\n"
 		"\n"
 	);
 }
diff --git a/man/man8/dcb-ets.8 b/man/man8/dcb-ets.8
index 0ae3587cb66a..1ef0948fb062 100644
--- a/man/man8/dcb-ets.8
+++ b/man/man8/dcb-ets.8
@@ -17,9 +17,16 @@ the DCB (Data Center Bridging) subsystem
 .ti -8
 .B dcb ets show dev
 .RI DEV
-.RB "[ { " willing " | " ets-cap " | " cbs " | " tc-tsa " | " reco-tc-tsa
-.RB " | " pg-bw " | " tc-bw " | " reco-tc-bw " | " prio-tc
-.RB " | " reco-prio-tc " } ]"
+.RB "[ " willing " ]"
+.RB "[ " ets-cap " ]"
+.RB "[ " cbs " ]"
+.RB "[ " tc-tsa " ]"
+.RB "[ " reco-tc-tsa " ]"
+.RB "[ " pg-bw " ]"
+.RB "[ " tc-bw " ]"
+.RB "[ " reco-tc-bw " ]"
+.RB "[ " prio-tc " ]"
+.RB "[ " reco-prio-tc " ]"
 
 .ti -8
 .B dcb ets set dev
-- 
2.25.1

