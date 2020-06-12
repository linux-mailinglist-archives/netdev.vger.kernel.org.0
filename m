Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22B11F715B
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 02:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgFLA0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 20:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgFLA0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 20:26:49 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3856FC03E96F;
        Thu, 11 Jun 2020 17:26:49 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c14so7453326qka.11;
        Thu, 11 Jun 2020 17:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=XihjhM7PNDe6DTRFb+Tb27kII0d9sFsX2YnNNfTFAB8=;
        b=avRfAddoVxJIjKVncxYfHxppQQ7YN8qOh8YfKqE4FfoemEVefjMYlKjkqkOznaYqmZ
         pyZzyLpXUOiiBUHGxpFH3AH5eylL8l+dhxkqKAdgeii/rtRqL0SLBJrrWQqNuYkwGBih
         8wfe6q6YWxLZ1TrsRGWbaYzaBoUJ1pwgoFcSiy7QMspcAeqycVXGF3yBXeyvxlm0sGye
         XTpS48XBPAUwRr7PRrKM7G9huEk8qq6w8HcPzFegv2ldPlN26HldKlW+PguCO516uTtI
         F3BWZndIqcsZi8O3yO7U34vRbY9mGR1XPmWJSZ5H6un/mTY0GAA8SAFGbzE9UGyzaP+f
         4gmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=XihjhM7PNDe6DTRFb+Tb27kII0d9sFsX2YnNNfTFAB8=;
        b=MgXUmTEMzBLRn+RK6q4xLJLC/BPvzvKRUGBfrMTfILR/urnOzQuFSS+RBNDiBWVB63
         WzYTt1EDH9ZkEhBKZkEZxkkcvBbpGQaJ7J09X5xugVTVtJGXJvKP+wnLGhH7gQFuvXzF
         ZbOho2oAS3rGrHW/zbYk3eRiKcmFUvJOFuycAcmcyM7JWlCRVAyvEYAxx656RQE1pKVp
         1TzNUuiScAO7QJFGNdsmfNhdo9XlqnmgBn2CkOGkD5PGeYYPgdsD8+3hwbzf4a9iuheL
         Mp5SrDvwjL6OjdcBFcaSLh5E2FAKIU1tJXJGFX/4IkUXVOt9gaMtIK6BFYo7cE+BOP92
         qmQg==
X-Gm-Message-State: AOAM531rnSQj8ago5NDdPlk5puvTlyIj58duWOKkNZgqDDUWrY1HrtQY
        l/5rHSWXJDmmEwFBDtT1U3xrLxXlk5Gs5Q==
X-Google-Smtp-Source: ABdhPJxDqnEbvb8lxMuzHTWY9tCTZCqUUTQzLRifCeRxqyhsYTRHsS2yVdhnOePkUXI6mVlOUo7sUA==
X-Received: by 2002:ae9:f40b:: with SMTP id y11mr604223qkl.107.1591921608305;
        Thu, 11 Jun 2020 17:26:48 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:f00a:33d2:6ec2:475c])
        by smtp.googlemail.com with ESMTPSA id g47sm3696421qtk.53.2020.06.11.17.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 17:26:47 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] xdp_rxq_info_user: Replace malloc/memset w/calloc
Date:   Thu, 11 Jun 2020 20:26:33 -0400
Message-Id: <20200612002639.32173-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200611150221.15665-1-gaurav1086@gmail.com>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace malloc/memset with calloc

Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info") Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 samples/bpf/xdp_rxq_info_user.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index 4fe47502ebed..caa4e7ffcfc7 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -198,11 +198,8 @@ static struct datarec *alloc_record_per_cpu(void)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	struct datarec *array;
-	size_t size;
 
-	size = sizeof(struct datarec) * nr_cpus;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_cpus, sizeof(struct datarec));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
@@ -214,11 +211,8 @@ static struct record *alloc_record_per_rxq(void)
 {
 	unsigned int nr_rxqs = bpf_map__def(rx_queue_index_map)->max_entries;
 	struct record *array;
-	size_t size;
 
-	size = sizeof(struct record) * nr_rxqs;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_rxqs, sizeof(struct record));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_rxqs:%u)\n", nr_rxqs);
 		exit(EXIT_FAIL_MEM);
@@ -232,8 +226,7 @@ static struct stats_record *alloc_stats_record(void)
 	struct stats_record *rec;
 	int i;
 
-	rec = malloc(sizeof(*rec));
-	memset(rec, 0, sizeof(*rec));
+	rec = calloc(1, sizeof(struct stats_record));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
-- 
2.17.1

