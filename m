Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A488A33D324
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbhCPLfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbhCPLfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:35:15 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AC6C06174A;
        Tue, 16 Mar 2021 04:35:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b23so8611206pfo.8;
        Tue, 16 Mar 2021 04:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fvcQ8OAH/TJgsE8NEXu1PwgUImXZqwrU+pigbTYwyiE=;
        b=oeKUc0zS425cU7Fz1wKi/AnPB7XhhXu5NTEYOP36Ub653NpcXZjIAZmVtKyW2Aw9Hd
         Xddg0UwtmGyUiSL1gZBAo5k2nKfKd0wdLGQLCYoZZV1f1m2kJ5gfFpFClc6oG1EQFWZh
         s6sPpUbRx2Zuab/mrR12JWy0Hqr/TMtrY6MiEoSqpWI1ZoUL04QhRYI6F6fP3gE4gem9
         xB+CbdyZgoM2j74ljh8lUcggmiOQZctIsdeLU3WSQeuVpfkcR+HYso1UWmicgaQeziCU
         K/cwbyBei3c6inB08GFDi0OHjl/jeva5q4gvSFZD0QQEjVGS2+CU941pC6tUWPfLvGSi
         Up8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fvcQ8OAH/TJgsE8NEXu1PwgUImXZqwrU+pigbTYwyiE=;
        b=ncsWL4VC0GwLj0bMX7mj+5ZFhe7EOSqRWRhtfoJO/6nIo8uD8+2RpBOwJldSlHXTtl
         S2fZhU3+eLGuRXPuppLs8icx96hKtNu/6ZxasX6n3tL1u7ItGHeV2Nj4mATvvHbrYg4d
         gokYMtZZWDZXvbZR+8Xy1kXRDKcNketUKNgeHc+5xR05hwxuZdcYhimOtPF21At2xLHl
         yFL68o5PLU5vWnEwpCmeS01b7oK8N+FH8fBYr7PLelWYjwy7TWKoYjB1aDbN4QNL4DJs
         V137O8bhw82oj6dmmf/BvG9SzxNUWlL4qLZ0D3/lcqzCLvKwbUbgAU3N3ezi5emeRQN+
         obTw==
X-Gm-Message-State: AOAM531T42nrCsc0DiGZizCCRq8kjTPlnQeZDtkVU9c0BMVKOkDBE25T
        8lkKWolPyXdEI3vn/qyqk1A=
X-Google-Smtp-Source: ABdhPJyvxDO9M16manNvH094gDQUww/AIK6ejJcLNpRrFVw/NqNMD/wIm4EMHtewygBmJ6e4eWDhyw==
X-Received: by 2002:a63:2bc4:: with SMTP id r187mr3663170pgr.131.1615894514838;
        Tue, 16 Mar 2021 04:35:14 -0700 (PDT)
Received: from [192.168.109.128] ([103.16.71.206])
        by smtp.gmail.com with ESMTPSA id b9sm15954989pgn.42.2021.03.16.04.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 04:35:14 -0700 (PDT)
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
From:   Suhas KV <suhas.kv00@gmail.com>
Subject: [PATCH]net: ipv6: ping.c: fixed open brace error
Message-ID: <1c3d8cf6-b87a-590d-a055-cca18e2fe608@gmail.com>
Date:   Tue, 16 Mar 2021 04:35:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fixed the following error shown by checkpatch ERROR: open
brace '{' following function definitions go on the next line

Signed-off-by: Suhas KV <suhas.kv00@gmail.com>
---
  net/ipv6/ping.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 6ac88fe24a8e..c0e5d0c79d6f 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -37,7 +37,9 @@ static int dummy_icmpv6_err_convert(u8 type, u8 code, 
int *err)
         return -EAFNOSUPPORT;
  }
  static void dummy_ipv6_icmp_error(struct sock *sk, struct sk_buff 
*skb, int err,
-                                 __be16 port, u32 info, u8 *payload) {}
+                                 __be16 port, u32 info, u8 *payload)
+{
+}
  static int dummy_ipv6_chk_addr(struct net *net, const struct in6_addr 
*addr,
                                const struct net_device *dev, int strict)
  {
-- 
2.25.1

