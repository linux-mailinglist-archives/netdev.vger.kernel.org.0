Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8443566523A
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjAKDRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjAKDRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:23 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE0513D06
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:22 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so18571688pjk.3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTIDmb64m6AEUf4Y7zL+qw9wvZsnktFS4l2duhJJc1w=;
        b=30jXRwYOM5h92unnhzwFFawg5skZUqiP6WfkKhEgDbCZ35NOTaz/ECSmjUsafqFuNG
         VbGyAZiS3r5514d04Ue8I1AP0DeFz1f9aA36h4p9PZCHW5YUHO/liDrFgJCQSdHcQBYe
         7Hf2sPY/GYuMzLiHq2+9twpam5A3q70rcRa0in4xQ9FPAZW6xBcme7dt7NECRB8zTrzt
         wTfxqoiK6bZVgjqaBL/hUKAw2JZqglPQXEX6qmW+EDb2uuowteP1UsAfpbyyQneyPYWP
         uOEX7vXWZMnpdip6YN5u0FrLLvQcBYiXmhM7PfYqWV2K/U4msVmjcnzQC6BHc7x2Erp4
         WOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTIDmb64m6AEUf4Y7zL+qw9wvZsnktFS4l2duhJJc1w=;
        b=mFAtL7NzmRvX1LCEe+/rxO7Yv0K/fxPyO7eL1DjfrX6FoC4nW/pYSE39Uli2/53dnm
         znU+D19BFoQQAhBQqrs6RkrmAd1dxxrNNPLkmmtJsARtVp/J/wjBY735oGQZq+fESR+l
         2WNR2IzISfVlkux3In6//cpQ2daFlw29XsBu3WvtBWnpF9lKjX1nheAeZgbH+l1kpqG2
         +nyAbRDaXdimOpFMoBe6QzwxXCVg5/sxCpnc2htPRlX7rR9A+QR7b9Vqn+fNYRisO8KS
         NbVJ31spFKyDk33XedONDq4xIm4vMPXh2y3v+fcZhAydae8NZS+45yW9/jzjjUPAhaXm
         AM0Q==
X-Gm-Message-State: AFqh2krkQ0WTnoyKI1+caCu9uNR5U7yO4sbBUiuqFSvkTyT5XwQO8awF
        6IQnZFC6qDr//tHKWP8hpzFXNCXulZ3Yl9NFhqA=
X-Google-Smtp-Source: AMrXdXtny0YpRFZOvcjjMxKPqVX6i0uWm95elazWdbTnf5W7VA9an26gMaKRvBrf5rUSwWpsm3454w==
X-Received: by 2002:a17:902:ce90:b0:192:8a1e:3293 with SMTP id f16-20020a170902ce9000b001928a1e3293mr72595429plg.63.1673407041586;
        Tue, 10 Jan 2023 19:17:21 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:21 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 08/10] tc: replace GPL-BSD boilerplate in codel and fq
Date:   Tue, 10 Jan 2023 19:17:10 -0800
Message-Id: <20230111031712.19037-9-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111031712.19037-1-stephen@networkplumber.org>
References: <20230111031712.19037-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace legal boilerplate with SPDX instead.
These algorithms are dual licensed.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/q_codel.c    | 32 +-------------------------------
 tc/q_fq.c       | 32 +-------------------------------
 tc/q_fq_codel.c | 32 +-------------------------------
 3 files changed, 3 insertions(+), 93 deletions(-)

diff --git a/tc/q_codel.c b/tc/q_codel.c
index c72a5779ba3b..03b6f92f117c 100644
--- a/tc/q_codel.c
+++ b/tc/q_codel.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Codel - The Controlled-Delay Active Queue Management algorithm
  *
@@ -5,37 +6,6 @@
  *  Copyright (C) 2011-2012 Van Jacobson <van@pollere.com>
  *  Copyright (C) 2012 Michael D. Taht <dave.taht@bufferbloat.net>
  *  Copyright (C) 2012,2015 Eric Dumazet <edumazet@google.com>
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The names of the authors may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Alternatively, provided that this notice is retained in full, this
- * software may be distributed under the terms of the GNU General
- * Public License ("GPL") version 2, in which case the provisions of the
- * GPL apply INSTEAD OF those given above.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_fq.c b/tc/q_fq.c
index 8dbfc41a1e05..0589800af0ea 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -1,38 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Fair Queue
  *
  *  Copyright (C) 2013-2015 Eric Dumazet <edumazet@google.com>
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The names of the authors may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Alternatively, provided that this notice is retained in full, this
- * software may be distributed under the terms of the GNU General
- * Public License ("GPL") version 2, in which case the provisions of the
- * GPL apply INSTEAD OF those given above.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index b7552e294fd0..9c9d7bc132a3 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -1,38 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Fair Queue Codel
  *
  *  Copyright (C) 2012,2015 Eric Dumazet <edumazet@google.com>
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The names of the authors may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Alternatively, provided that this notice is retained in full, this
- * software may be distributed under the terms of the GNU General
- * Public License ("GPL") version 2, in which case the provisions of the
- * GPL apply INSTEAD OF those given above.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- *
  */
 
 #include <stdio.h>
-- 
2.39.0

