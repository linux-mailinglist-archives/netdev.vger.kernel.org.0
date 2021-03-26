Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F079F34B295
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhCZXQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhCZXQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:22 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7261DC0613AA;
        Fri, 26 Mar 2021 16:16:22 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c4so6979994qkg.3;
        Fri, 26 Mar 2021 16:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FPvMyeVOV2OmDimqW8ZadEQxGmmzRTtlAwCkJN5MerE=;
        b=FoekZ6qIQ73LmnF/RFD/TO2N/077rtYj6zW4Aru0/X3JYdeFjRi6QJGX5ej0bKzVl4
         Ore2agQNlB+k471obE3h+M8Mc9M94dtp1dGAa+1Z1PLc9HJtIxL63qvRe6MEIJRmS/jW
         fXnDxlU8b7IEntloWiF1ZbliieWLzPwfD2hAH7yX3LCLc/Q2Qc9YbC0dO64nwO2OoQea
         Szh6oFsDOAP5N0kDt0fVcg9JeX2oj5rzTz4C6uDamKwEw34w8OaE/yNQIq9wFS2oGAQi
         663OQpqIIhIqZEJ4WcZ55CW5AwYJna+waEJgYVNRrCHy5TtN131WI0t4VKuXgl6DDgnR
         9GHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FPvMyeVOV2OmDimqW8ZadEQxGmmzRTtlAwCkJN5MerE=;
        b=lxir50S8NY8L1Km1Ha9Oycu/KSTnoGQcok64ZOoH0NSmXj9+WcN74/Pw7jkl6Viz6R
         NcriPrPsbTNmTEndI9hPue+e5+zejjWFtSRZFnYcg8AQ2x2lL9CU/4Uqc6BtjebHFPWj
         WYQRsuUihf+7PDqsZU83BL/S8v/KMmfBs4ibSAUxQMInBK7ofwKINPQa6P6LPqC/3hAy
         XQ/sY/9hlZUo+blMUw20VJ4wExMisD3b6XplS31ONxH1VxDysXHmmkbkyap3qQ53dBdN
         AnwfBT7PqCzHCEX3Rg7+YM19kbiapQhSf+ABX9MIfy8vTEFc9suGks6BRaBH10sD7/pJ
         axfg==
X-Gm-Message-State: AOAM5305/NBvNyOFC1LGFg8ajTSKKHy5Q9zIV3PWa8Xc/mEhZobRPy9/
        fv5QVqJBcnsEX+bI/VYcKf8=
X-Google-Smtp-Source: ABdhPJyEG3HdyXz/tHzqW3gxh5HRSqC6qskz90XmFh6bTaL1sumOUGx4IgAvc1/rLpy4f4HBSvr+yw==
X-Received: by 2002:a05:620a:1477:: with SMTP id j23mr14817772qkl.416.1616800581787;
        Fri, 26 Mar 2021 16:16:21 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:21 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] ipv4: ip_output.c: Couple of typo fixes
Date:   Sat, 27 Mar 2021 04:42:38 +0530
Message-Id: <20210326231608.24407-3-unixbhaskar@gmail.com>
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

