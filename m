Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873012EAE25
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 16:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbhAEPWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 10:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbhAEPWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 10:22:38 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103D5C061793;
        Tue,  5 Jan 2021 07:21:58 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 15so41490pgx.7;
        Tue, 05 Jan 2021 07:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XVD1XX3XannWZQkiPFGE0hM1GlNO9UtMwgSsJNHwDMg=;
        b=QKuUUVMX/n857o6VHwgDSqWTy/n713BPYakWBWEdURp4hpDi9/0heOFJb3AOmVCJ49
         Qd/Opsl4xmFvFChH+s82FEABDhdC8JpYNN1PnEk9iU2X+gvSwODydEwyK/hOnBT1Cfy1
         Os4FHV4TMfnWGxI/EIIL3rSEa8eE3CzyowquQwVG/7N+RFiU5YGeEqQ4+D8l2P17bJcj
         QSleZT7aH2ClSLL1ZrlWJhmNGnAuUexMBTC0WZRTk56ywmEXqVYYNpMzGZEn57U1XypU
         On3HozuwuAj9uE4e/LgIauJE2AyUUJ9LN/FVpwFsuDeRoBKgtGDiEkdvGYTPWJt6LPcS
         svRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XVD1XX3XannWZQkiPFGE0hM1GlNO9UtMwgSsJNHwDMg=;
        b=ILwHH1Nn7KJSjvGiO2L+X1+GO/NMpq7VHqKFDK6b8fIlm46vzmLLxJm7aCAwFYbTFC
         WK94mRr22jN+FZEguEI1o7hJO1oBnYh2p8HWsK9pVQa+ouPEXFzesQWkReEyeosAvkjf
         U522D6+rrUga4vj0m5cDx3LOXVo1/ZSJu80RBxEGedx0i6ZnrjcbsaM1xTIXG2v9zWCV
         biDjPczp4oq3BpofrLPFEbDZDQlvOXzYG8UQtk0IeivQF4U0PFOWLjYTWJaq0JjgCGn5
         hKz2BQRmfEIMEw98xsdXsH4z5Px9nHffAk3E9VuZ/5tbPI2fm0nxsH3uPujiiuct6/VW
         sljQ==
X-Gm-Message-State: AOAM5312zcWwHmvVNsMXLI+/L5ttqLv1T9FAfVp51jdQHTguNP96mM58
        PZfIATAK1yv1G9zAh+KRW9bzl7rwF0o=
X-Google-Smtp-Source: ABdhPJwYw1QXF4XI/GYprpYoDV0KwnTx7v/DjcAXf+m06a2+DS1FV4Ptn6MjXrxKHRAZf9h4+G2k9A==
X-Received: by 2002:a62:7693:0:b029:19d:92fb:4ec1 with SMTP id r141-20020a6276930000b029019d92fb4ec1mr47108934pfc.4.1609860117655;
        Tue, 05 Jan 2021 07:21:57 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id b18sm15560pfi.173.2021.01.05.07.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:21:56 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        jamorris@linux.microsoft.com, dong.menglong@zte.com.cn,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/bpf: remove duplicate include in test_lsm
Date:   Tue,  5 Jan 2021 07:20:47 -0800
Message-Id: <20210105152047.6070-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

'unistd.h' included in 'selftests/bpf/prog_tests/test_lsm.c' is
duplicated.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 tools/testing/selftests/bpf/prog_tests/test_lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
index 6ab29226c99b..2755e4f81499 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
@@ -10,7 +10,6 @@
 #include <unistd.h>
 #include <malloc.h>
 #include <stdlib.h>
-#include <unistd.h>
 
 #include "lsm.skel.h"
 
-- 
2.17.1

