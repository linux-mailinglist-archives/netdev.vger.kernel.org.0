Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94CC173695
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgB1LzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:55:00 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33256 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgB1Lyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:54:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id x7so2679999wrr.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MdviBniUP1LTLTlxYrXf4cKTRz1/Aw4mUeuM3QyEeaY=;
        b=BH513kc2bjVfCoogIWJkQPhCfXVFyBq8iNap7ABg1XuYuZiyMESn3PhHMBuT0E6/w9
         b+G35KExpAyEQUFRnkW6OJ5TYjksyTo6+bgXsTQf6ptBiajUxYl/7N0QUbmAkQL7MZ8p
         dzjCpHFWz2sh7x8RdSnAHoWZilYlwT+HbQ+TM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MdviBniUP1LTLTlxYrXf4cKTRz1/Aw4mUeuM3QyEeaY=;
        b=Nq5O8XSSGiyikTSN4eDJD4rw71WtiUfx2Fs9znw2mi2GdxxtozEy1bhK0dGRn4mjYJ
         5Oa26e5TvRheK7cumqNXsPF0KqhwucCfKZhe3tc9Y4ltuWfPm3yNdFG5dRMoezFQ6I3m
         fRZRfUkgeRpbVnm5mlkFfLeq6GraGV98ppaJLHacMRKDIz9VBJofF/lACotXoHw+m0h9
         pLv+XS/7TR5jezNGXFa96OJj8NQP6VxkBFc+JB2BvQ4UK6JcHNbRQxC521JNR6cs7No9
         IDcpCau3YbegpNm84AczK9XmbdbMI60hpIk9g8QD2yj1T+dO0PZSDwTMTdAL40XvFLaj
         qXAw==
X-Gm-Message-State: APjAAAUpewt5wYaEHQv70EoNI5fAp1/VlUcOr0jaIcL81VaSJb69JjS2
        spN5QCtmcZRUqc/lGVu6PCLxgQ==
X-Google-Smtp-Source: APXvYqy6+1s+Iw2KKU638/K+YsQPGmQypYVGl3aWhpmEya+4vA4ML8sUFdda4aZNYwKKNv66XDMHZw==
X-Received: by 2002:adf:fecf:: with SMTP id q15mr4747203wrs.360.1582890889015;
        Fri, 28 Feb 2020 03:54:49 -0800 (PST)
Received: from antares.lan (b.2.d.a.1.b.1.b.2.c.5.e.0.3.d.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4d30:e5c2:b1b1:ad2b])
        by smtp.gmail.com with ESMTPSA id q125sm2044284wme.19.2020.02.28.03.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:54:48 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 9/9] bpf, doc: update maintainers for L7 BPF
Date:   Fri, 28 Feb 2020 11:53:44 +0000
Message-Id: <20200228115344.17742-10-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228115344.17742-1-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Jakub and myself as maintainers for sockmap related code.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 495ba52038ad..8517965adde8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9351,6 +9351,8 @@ F:	include/net/l3mdev.h
 L7 BPF FRAMEWORK
 M:	John Fastabend <john.fastabend@gmail.com>
 M:	Daniel Borkmann <daniel@iogearbox.net>
+M:	Jakub Sitnicki <jakub@cloudflare.com>
+M:	Lorenz Bauer <lmb@cloudflare.com>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
-- 
2.20.1

