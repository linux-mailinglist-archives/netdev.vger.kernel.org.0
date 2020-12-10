Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3DC2D6B86
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389558AbgLJXEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730702AbgLJXD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:03:59 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0350BC0613D6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:03:19 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CsTwC5znRzQlWs;
        Fri, 11 Dec 2020 00:02:51 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=54o6mJF3flX67UFtU962Ave9S/F1oGSWfDTnTjA0oF8=;
        b=C9Gn4bUqJ9YIXNsV/baWXIlZkNjWFQewZbCg+/8zhHPUq8MPG1Mcj+BhdZ5gDwuEcywwCd
        IbWL+EwoupSuNrwpT2CZlSYVrjl/DM1Zhn1cIm8OD0Bh5/eQnZ2pJtPAOsjU/aMa1PSLqx
        UGMhvVXV0qyGiprfOY40p/IMhsrg0zCwh1I4FYl/FojBeW24II2bBeyC08rTiztm07lz+v
        ip/sip6B6PNEAUePe7unCEXC48cQQt0XTuXyjNdE4TsuN+cFD5qFIFJ12UHonc/WIZas5b
        XkTqER+divMorlvFFayuXCykrIq21C8DuHUyOvk++n86qtrmhqhy90EaDG6Nfw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id J1j9PwyiTM18; Fri, 11 Dec 2020 00:02:48 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 01/10] dcb: Remove unsupported command line arguments from getopt_long()
Date:   Fri, 11 Dec 2020 00:02:15 +0100
Message-Id: <8e5515689baf3c3df8c7e014d139e9de9cb31cf9.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.14 / 15.00 / 15.00
X-Rspamd-Queue-Id: D8A6917BF
X-Rspamd-UID: aa3755
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

getopt_long() currently includes "c" and "n" in the short option string.
These probably slipped in as a cut'n'paste, and are not actually accepted.
Remove them.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index dc1e9fe04e22..217dd640d7e5 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -349,7 +349,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "b:c::fhjnpvN:V",
+	while ((opt = getopt_long(argc, argv, "b:fhjpvN:V",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
-- 
2.25.1

