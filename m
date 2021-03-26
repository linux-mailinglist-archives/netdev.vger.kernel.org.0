Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B560634B2DB
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhCZXUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbhCZXS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:18:27 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8976CC061221;
        Fri, 26 Mar 2021 16:18:26 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id 1so4794969qtb.0;
        Fri, 26 Mar 2021 16:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FPvMyeVOV2OmDimqW8ZadEQxGmmzRTtlAwCkJN5MerE=;
        b=gNbcgRGzW0lbEuIRTLVruRCPL8Xa7gTCrJrEuPJONp4fAhxUdzeuvuVQMUPJAkLXni
         HqZZVUhALZKCXDJxCe+q0tY2ECEyJOYO181Ixo1mG9e7fpcqtvmV/TUv+my2GnIAkXRd
         cntE6k8Akybe0rtZUPEoAu//hjapJV5eGwgKKXlu4PU7H50sfoLzxozFPJkPf8MDNLfg
         2niNY5IG/bPtITSaBCNnx+he/LpVhmjklhMOed4vNba+b2GR7Ah3dcVabmy9Z0DB7lJy
         o+asj/S08U8caOx1G79csPCpxHzvKjjdTEX/cWUzU1D9p+S5cOsCjGzkrBR78k0qxC8V
         yBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FPvMyeVOV2OmDimqW8ZadEQxGmmzRTtlAwCkJN5MerE=;
        b=DLyU6Y372WNUpft/ZuzXplXco7uNpYKlOkXm8VmnRZlOw+nbv1da41RoaAQYsDCAuo
         eNR1DKHcWG3XOWM7e1Shj5rBAS99xh1ouDuL3j0PX1fVuyiHt4BNcnC+urKGkWVcZDxl
         ftJMMdlch19idwfNSRK8eGiEgukgYWdHs4XnoUW5xhQT3HCEH1EjjiF99QpbePINGEah
         mgRh2TRGx4gRjDoP7VYh3XkKO31GqUTKFQH1Fk2YOW76fhQcSan0SEtzOtyminfUkkN0
         50hC5g806sESVITpHaH+qTjyC++4xhZ7LhDce+harlXheaRMzdhmp5y4HVbK0q625kUC
         Ow4g==
X-Gm-Message-State: AOAM5315obiI5MttxmJjtLdFF4AggmlHbWXSUnIxefEfOGLIwIKfVAJ8
        P+4bwaLkJbwl3FQVpPX+yRI=
X-Google-Smtp-Source: ABdhPJwk8x9rcW6TJjfiZj7A42WpP7f1o82X9Zo4Ml8aBTMFJME9uKk8RmiC/l47nkkUaWaHRBJ1Kw==
X-Received: by 2002:a05:622a:549:: with SMTP id m9mr8050540qtx.359.1616800705841;
        Fri, 26 Mar 2021 16:18:25 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:18:25 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 18/19] ipv4: ip_output.c: Couple of typo fixes
Date:   Sat, 27 Mar 2021 04:43:11 +0530
Message-Id: <7a3dd639aa13f3351e790e4e3c6277f871738f87.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/readibility/readability/
s/insufficent/insufficient/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/ipv4/ip_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3aab53beb4ea..c3efc7d658f6 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -34,7 +34,7 @@
  *		Andi Kleen	: 	Replace ip_reply with ip_send_reply.
  *		Andi Kleen	:	Split fast and slow ip_build_xmit path
  *					for decreased register pressure on x86
- *					and more readibility.
+ *					and more readability.
  *		Marc Boucher	:	When call_out_firewall returns FW_QUEUE,
  *					silently drop skb instead of failing with -EPERM.
  *		Detlev Wengorz	:	Copy protocol for fragments.
@@ -262,7 +262,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 *    interface with a smaller MTU.
 	 *  - Arriving GRO skb (or GSO skb in a virtualized environment) that is
 	 *    bridged to a NETIF_F_TSO tunnel stacked over an interface with an
-	 *    insufficent MTU.
+	 *    insufficient MTU.
 	 */
 	features = netif_skb_features(skb);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
--
2.26.2

