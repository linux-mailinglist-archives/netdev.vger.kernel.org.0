Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722B148D0BE
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 04:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbiAMDRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 22:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiAMDRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 22:17:06 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69BAC06173F;
        Wed, 12 Jan 2022 19:17:06 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso7799205pjd.1;
        Wed, 12 Jan 2022 19:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lGCgkERBjOX3/0F+qSCLrYLXFxUOLlIuMM6BUTQfes8=;
        b=SS/mFYUM4hVhS9bdXf4TQXcsGJSXJ9wGBTrd9XPs90acty6HlRgTyv8XlHJPHfftUV
         I0lW6Cm0yjM6JMSxn/jm7v6PmQReD6q+dGAs0+olSXa0Ledky6IkbyjUg56+D8KfiL2l
         /hNw9O+HMzgV4hZcm+MUbgivLeJOVp6V3rs98veFDozPc5V2ufYhuOvTUyVc4/17uJE9
         DUNgia7J/Uae6Zn0Ejo1I1+9WD+afV9lPfUYm2v+qHSxyB1iLPKUPFpPJT9+GSbX1nTY
         x5edum92fGR+ZjKuDhswRY2rirEFKVXUPUoQMeJrSDh/BsuU+Vqk2LCvuM9EJbrLZaaB
         oogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lGCgkERBjOX3/0F+qSCLrYLXFxUOLlIuMM6BUTQfes8=;
        b=qJ5xwxaUqTti5TxkVitDTng0TlnIDVa5lOcpddxm1hJ6w07W6msvJ3r6A4mAKWPGis
         kw5xeZ7swesvgbSqURPWQPmGlHI8xVRV9OeTYW2cqLw8YNEzog/ByFcJOiTapREe8wQq
         SSB8Fuhgr34ovk08faT4/RDNROXSZytvrX9RzClHYJht8e6eWkZs6FZMbTkTAn7qPeLB
         grtNW6exd4tKQh/5jL7HVZbvL5mq69R+hPv9ZvFcUj8xMQZqW/BekOAM5C6Z9q34MyOc
         btd1/pqr+ERzLc4Glw+9giUljrPVOG1Qx2cXsipbQk0c6eJsdXj+86u69nht7hHzSr1j
         KyxA==
X-Gm-Message-State: AOAM532WGKON9DpM6GYp3RHFdFkkYE5pPSTjs2NQ0Y5myZfGslpJzEQS
        bn6/atdMmxB8nWpJtZ2mm/zpcVdbdVU=
X-Google-Smtp-Source: ABdhPJwET2ImbEGWTibaO3bDAbRt8zdZuQp+i0XaBzfHtv5y4YU4ZFN/oSmELrNQc34iDO1lxIM2Xw==
X-Received: by 2002:a05:6a00:8d3:b0:4bc:3fe0:98d2 with SMTP id s19-20020a056a0008d300b004bc3fe098d2mr2596964pfu.3.1642043826274;
        Wed, 12 Jan 2022 19:17:06 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id j14sm1015338pfu.15.2022.01.12.19.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 19:17:05 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        davemarchevsky@fb.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, imagedong@tencent.com
Subject: [PATCH bpf-next] test: selftests: remove unused various in sockmap_verdict_prog.c
Date:   Thu, 13 Jan 2022 11:16:58 +0800
Message-Id: <20220113031658.633290-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

'lport' and 'rport' in bpf_prog1() of sockmap_verdict_prog.c is not
used, just remove them.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 tools/testing/selftests/bpf/progs/sockmap_parse_prog.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
index 95d5b941bc1f..c9abfe3a11af 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
@@ -7,8 +7,6 @@ int bpf_prog1(struct __sk_buff *skb)
 {
 	void *data_end = (void *)(long) skb->data_end;
 	void *data = (void *)(long) skb->data;
-	__u32 lport = skb->local_port;
-	__u32 rport = skb->remote_port;
 	__u8 *d = data;
 	int err;
 
-- 
2.34.1

