Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3065B34B2A1
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhCZXRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhCZXQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:44 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F335C0613AA;
        Fri, 26 Mar 2021 16:16:44 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id dc12so3802542qvb.4;
        Fri, 26 Mar 2021 16:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JFREJ/UC00k0j/cD9Pm0GUdJuuLMBEc30OeK7dTZRxU=;
        b=VaQ8NYX+dDX9hwDInbtQgvr+5svl3BZreNvvebq5SXVu0OhXQmum0HanMZXa2POn/8
         Ffk1elrq7CWIuA6vROmyVYiQuB+ynwbpnWnScrM8gxMPX3tQTi5KV4o1sufQksolMTMn
         XYT+M9xaJFZj0HNSPF5Gm1GIikgJD7WYoLgNqsCR1lCNGto8jRClQ1Hm7kpboWsqx9IW
         S9pmC/5FvIHbNJRMdyClhKphAmy1FgcHUPJte+o25E0THIfhf4s0ufkVLWlBXZ+1QJki
         xz/GMuBBLVZxaUT3xNLdOZWtyPNobLJvGmlPRprpMJIhv60Ssz34s+WhlsykDJMLt5oc
         aYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JFREJ/UC00k0j/cD9Pm0GUdJuuLMBEc30OeK7dTZRxU=;
        b=gcT4n8qKfuf7b0DPCdWIeUHX6na78Pmj5H8pHSGnjRe6CQkFyZy5RYfZifbeNnO4do
         qlquo5k6AjByxnMzMIKaEat/Cw3PlZNiG4luJ5yik2sxjM52B5Okx+AUTbBt7OTAgRCE
         +GpGLQZKsd9S4VAuzgCE4BE3xl/VqFJhrcLZqVwbX5L+FDYMdwObDZatr7cwhp18rCG2
         beA3qstADWqq/BuNGPpdITl2i3r6L4nwrOtaZmMsB0EPYiFW2fFpp0pZY7y5re9tXmg6
         riuPThd839AJhp9dyZYscIbb1boanNxKzzt0idIfSBZQl0CirvrwiSjGXb2KhpDAXIMg
         /E7Q==
X-Gm-Message-State: AOAM531H8/kHjsOPWErSkkuu1C4BDIundizkh9bJiRgQfi4osdb3dTL/
        8fauivzQYLiSR4GMCFVJpCQ=
X-Google-Smtp-Source: ABdhPJwxu2cnqyCmW+k/GVIBvQf6Cy1VBqY3M38emoMoMNtuAA3qEik/MiwSt6mTlICsEEVl9ojBgg==
X-Received: by 2002:a0c:8d44:: with SMTP id s4mr15453594qvb.53.1616800603982;
        Fri, 26 Mar 2021 16:16:43 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:43 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] llc: llc_core.c: COuple of typo fixes
Date:   Sat, 27 Mar 2021 04:42:44 +0530
Message-Id: <20210326231608.24407-9-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/searchs/searches/   ....two different places.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/llc/llc_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/llc/llc_core.c b/net/llc/llc_core.c
index 64d4bef04e73..6e387aadffce 100644
--- a/net/llc/llc_core.c
+++ b/net/llc/llc_core.c
@@ -59,10 +59,10 @@ static struct llc_sap *__llc_sap_find(unsigned char sap_value)
 }

 /**
- *	llc_sap_find - searchs a SAP in station
+ *	llc_sap_find - searches a SAP in station
  *	@sap_value: sap to be found
  *
- *	Searchs for a sap in the sap list of the LLC's station upon the sap ID.
+ *	Searches for a sap in the sap list of the LLC's station upon the sap ID.
  *	If the sap is found it will be refcounted and the user will have to do
  *	a llc_sap_put after use.
  *	Returns the sap or %NULL if not found.
--
2.26.2

