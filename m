Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38D64E81DD
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 16:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiCZP7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 11:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiCZP7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 11:59:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904C4522CA
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 08:57:32 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso11359130pjb.5
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 08:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=w4cYQke84dligvA/rgfXqFeYpCNqH3mB/D1cFZVJmJA=;
        b=40bYQYua30XUUgVI/UYIFF23HASwJ+pTa8I6+5kBw8sm8xdNYTgkFs0bs0W1JTgsc3
         k+Gp7RlVFMpTT52WyCjNnPZUloNyVpfnZEfukw1sSDTR/FRDHdIFJx5FLfvkb7NubrUb
         4Vd2aWzdEt36XAFhpEZA4zzhAZWd3VrLWbXO8kG7BrCIW+WOqHQ71jS7Yzx3pQ0/+d6W
         BHDqxdMUbPSo6c8/xCS6X4RE7LWzQKqa3sJZ6M2HQuf/621rljl8fYGupvFS2hW7GCfy
         KoscK+lsp4EtCnWAwMENP5k8RRhDy4ayIKjgST8Ibmo9bd5Lke6A4WHKr16dbtPfZyW3
         j/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=w4cYQke84dligvA/rgfXqFeYpCNqH3mB/D1cFZVJmJA=;
        b=2MjfDOowDN7BNUdtxTM+AJptiW3Mhbd/x99dtEquczKRIC1iyF1o/CkEc0mWhQaKGc
         3c8Kev4Dop0ZuZFpIVfhYmu1K+tnc/L4DzhVlLI5RVc7mexToKz2/1Khcai73mfjEAxg
         0hD0z/3XENpIXb3r/TlN3wZnX69ZtS4L6QHhGTKovXKOmLn3JQn00YIebUOgEEO9P2jU
         BP33ANumtWV2u0JFmcj8/XJIWTzSxhJZKZme9K7ooakSSFna12rB+CA9D3ZHA37ahyUY
         hGoV9z+SEBTx6+p0wkEVqT9FmtoJJ1wtRh0zz7T4ggRm9/4o9wy+gSJv2FL1f1+xdXk8
         S74g==
X-Gm-Message-State: AOAM531N1G5/aQxyPOcvejzBOfUj0O0MIXdM4//cmHQvxS0XQg9TdXZB
        UdjU18uDNKxnwIiLkvjN3HVO9EC5BC/hpy+3
X-Google-Smtp-Source: ABdhPJzg9xutIhNdWl8sYLNKoqWhI0qnzaWfJq975to2UT+zYEY6sDRSRo+R2taKNCX/ghYJP0wp7Q==
X-Received: by 2002:a17:902:db0d:b0:14f:b047:8d22 with SMTP id m13-20020a170902db0d00b0014fb0478d22mr17252754plx.90.1648310251795;
        Sat, 26 Mar 2022 08:57:31 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v23-20020a17090a521700b001bbfc181c93sm15320124pjh.19.2022.03.26.08.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 08:57:31 -0700 (PDT)
Message-ID: <8d326eb1-03de-6b8b-009e-7365255dd271@kernel.dk>
Date:   Sat, 26 Mar 2022 09:57:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     netdev@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] net: remove unused TCPF_TSQ_DEFERRED
Cc:     Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_release_cb() checks for this flag, but nobody is setting it. Just
kill it off.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 78b91bb92f0d..7d803ab7da45 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -428,7 +428,6 @@ enum tsq_enum {
 enum tsq_flags {
 	TSQF_THROTTLED			= (1UL << TSQ_THROTTLED),
 	TSQF_QUEUED			= (1UL << TSQ_QUEUED),
-	TCPF_TSQ_DEFERRED		= (1UL << TCP_TSQ_DEFERRED),
 	TCPF_WRITE_TIMER_DEFERRED	= (1UL << TCP_WRITE_TIMER_DEFERRED),
 	TCPF_DELACK_TIMER_DEFERRED	= (1UL << TCP_DELACK_TIMER_DEFERRED),
 	TCPF_MTU_REDUCED_DEFERRED	= (1UL << TCP_MTU_REDUCED_DEFERRED),
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5079832af5c1..a53bc45a2053 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1064,8 +1064,7 @@ static void tcp_tasklet_func(struct tasklet_struct *t)
 	}
 }
 
-#define TCP_DEFERRED_ALL (TCPF_TSQ_DEFERRED |		\
-			  TCPF_WRITE_TIMER_DEFERRED |	\
+#define TCP_DEFERRED_ALL (TCPF_WRITE_TIMER_DEFERRED |	\
 			  TCPF_DELACK_TIMER_DEFERRED |	\
 			  TCPF_MTU_REDUCED_DEFERRED)
 /**
@@ -1087,10 +1086,6 @@ void tcp_release_cb(struct sock *sk)
 		nflags = flags & ~TCP_DEFERRED_ALL;
 	} while (cmpxchg(&sk->sk_tsq_flags, flags, nflags) != flags);
 
-	if (flags & TCPF_TSQ_DEFERRED) {
-		tcp_tsq_write(sk);
-		__sock_put(sk);
-	}
 	/* Here begins the tricky part :
 	 * We are called from release_sock() with :
 	 * 1) BH disabled

-- 
Jens Axboe

