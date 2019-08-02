Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7594A7FF60
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391736AbfHBRRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:17:23 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:51104 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391708AbfHBRRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:17:21 -0400
Received: by mail-pf1-f202.google.com with SMTP id h27so48608949pfq.17
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 10:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rxE5Xpol+bSg81z8GVrhZHBv2KTR5njlcPKT7JMdsjY=;
        b=vIgWqGxA5TzbNkCgNJ7AjhvVlQ1OYHAfUboYvrGQIcYN/MnoeCtnopbe5yExBspMr/
         Kddh5faIQApNOWwF4ZHRlXJ3FKuqz42YeHRYH+sO75xqkWQwGCr0Gz7Yr/ocDe52S+Lo
         bgMLtcXiO1qWcZZtO6PL8YZaV0vldl3Ysqn79IkNn/mgICwbLEl2vCYi56LZ/S4E8OsV
         10sujGadRe4z1lcoBwWqfkt3RNY8uZ+5lUzEgU37YtBjtlhfDjzQ/TXtZ9C3hWiJ7d9S
         i97/Kvlp0TZL5/eewvBsbsLpVhr88erLVb+denQH/UZeRtGLYVcrt6xMoV/f3xgib+8m
         pU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rxE5Xpol+bSg81z8GVrhZHBv2KTR5njlcPKT7JMdsjY=;
        b=tBbl1q27n2dbSReiEK23HhtIsWqXOyzlBHgZ6FYkhozxW8iX5Qe5VwGxwQP9eInUSi
         dbPQaxT/kaQsPzLit0mSlVQNknGMnkfdCiIDf2cP7Gi3wkSd6X+bFWWIZn9KGOPWH+fp
         IECY3/gnBLXTFCWiqcRCbJG0HxgYaU+gbhjw+BTXe811hhaKHciABZlVTYKAPIAqJauC
         SV3NDZg+S/gBML+jvziv2fqpq5ddLP9zKwxMGbC9YwvvaaqE78PTkG72ukD9u5PnkhD4
         j8VXMBXUujSPhN9JMbsZSXkWaOKr670D7q1znzXj99Cao2lDrZHc2AgKpqXdQR99Ibgj
         PriQ==
X-Gm-Message-State: APjAAAWxtBdMMPbWT95bru0VqiP2xd5u2iMJj3hPqS2cW7dBsUKMQNKR
        vR4csuoD8/MgTaJWasUBjmmMDIr4xr3MsScJgah4hWMX+l3JfV3zqyBXxYMAab8PuZUUKE4RQLX
        CuMfH/x+Uz8Zbd9xAlqsdEBPhQJ0xZeLFkGlX7YBfrVPqelMwvl26+w==
X-Google-Smtp-Source: APXvYqxO/ZafbbZag2Yj0WDQMyucpwyEnB3HWRsqEL/aPzKBkTFO8+MeDhtc4p+6awaPSXOCxkAstK0=
X-Received: by 2002:a63:20a:: with SMTP id 10mr10632579pgc.226.1564766240192;
 Fri, 02 Aug 2019 10:17:20 -0700 (PDT)
Date:   Fri,  2 Aug 2019 10:17:10 -0700
In-Reply-To: <20190802171710.11456-1-sdf@google.com>
Message-Id: <20190802171710.11456-4-sdf@google.com>
Mime-Version: 1.0
References: <20190802171710.11456-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next 3/3] selftests/bpf: test_progs: drop extra trailing tab
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small (un)related cleanup.

Cc: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_progs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 71c717162ac8..477539d0adeb 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -279,7 +279,7 @@ enum ARG_KEYS {
 	ARG_VERIFIER_STATS = 's',
 	ARG_VERBOSE = 'v',
 };
-	
+
 static const struct argp_option opts[] = {
 	{ "num", ARG_TEST_NUM, "NUM", 0,
 	  "Run test number NUM only " },
-- 
2.22.0.770.g0f2c4a37fd-goog

