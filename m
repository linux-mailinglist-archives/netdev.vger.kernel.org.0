Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB6837A9
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387933AbfHFRJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:09:13 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:56820 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733201AbfHFRJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:09:12 -0400
Received: by mail-qt1-f201.google.com with SMTP id x11so74975399qto.23
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=e4SLScTqtI1V1lopKxDYlItZzmDFwVySiqM/qjPmZNY=;
        b=mlpugaoSL+UvdG+aMZebOWrryZZ4vP+9G7OKamn2nyVtPFpgbbmpjXF03u3V1uCHIO
         PI0Q/JHlk2hIhpim/6VC3cEZqw3MkdEvb29YNaGO+XU/BGKcIeXPmsPSd+SBw0lcQdwG
         YSHtJuOiQ4INcZeqIKHp6b2/OOuYoqaXSSDYzp+AFLhSq2rzbqyI7gC/o9ynidI5IuiE
         Zs/5dhRnxghmJxzIlDcwEz3zM5gJoPVH2j1VL62Ktn1WejSVlSie/+nILEStU7ocRLKa
         1v8dFIZ6rzNQ/8uGie6MYpI7ZQeVEjIc6wV8p2LfCsznb/D795+bR6OL2jUGeOg0iKZm
         MIPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e4SLScTqtI1V1lopKxDYlItZzmDFwVySiqM/qjPmZNY=;
        b=cMBPQ1fkf5yXTyY8b3ztzctfv6gUbUs1G+kMhDLBJqqVSGgxRp98PAAUT7brGV5hPr
         KtZLR+zesQIA1JwyMG/FQ0VHkzmY/9FT4rE6q1BbqsLJgJdqF2Z9Wt2SFYyoev8WAVla
         PIxMyPzx8PAkNkd3L7G9wRthBump/hjevbjpqB1OQxH3Ngig4qH5kGIfcAwGah2g/tTo
         YJptVxGOBCIKYIAizArYVqaouql23rr/MaZG7O2ByyETz3m1Q/VSFUrvBjBS/wEtonsX
         VJu3sxiUYbr6lovk8S0eFX5A0KcG0i20ZKaCMieZzm7+O5v+vXolI67BZ/lbPSX7ldpx
         iYyg==
X-Gm-Message-State: APjAAAVKR3IlYINbYRS9XOoESLu8xJJCFOlVaDOx73bRbQk6oNu5mnZh
        YoYK3zDy0JA3dbQjGgJ/HZVPnNWw9PqzCIhHaludmuI/IpqIGkWt++6JqaUM7+EnNBZjMfmr15u
        ciVIAV56/yfmdx6/0WlW2qHexnhLR8vJYRt5gUmFbt45UheOqeuW6Zg==
X-Google-Smtp-Source: APXvYqzsyBAb4TAh/nfup7MPTSQyaNb4sM7dMyz1UzIr4ifdwswvER3+hBKpqdLs49aF5mh/sDO+Fv4=
X-Received: by 2002:ac8:2763:: with SMTP id h32mr4225202qth.350.1565111351512;
 Tue, 06 Aug 2019 10:09:11 -0700 (PDT)
Date:   Tue,  6 Aug 2019 10:09:01 -0700
In-Reply-To: <20190806170901.142264-1-sdf@google.com>
Message-Id: <20190806170901.142264-4-sdf@google.com>
Mime-Version: 1.0
References: <20190806170901.142264-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next v4 3/3] selftests/bpf: test_progs: drop extra
 trailing tab
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_progs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 963912008042..beed74043933 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -278,7 +278,7 @@ enum ARG_KEYS {
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

