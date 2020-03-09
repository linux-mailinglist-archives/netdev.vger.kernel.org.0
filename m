Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F4717DE57
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCILNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:13:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32939 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgCILNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:13:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id a25so6731222wrd.0
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 04:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vzahiIr6twtVt6VsSfZyuBvY9ZwGAcuWVXdLGiISKKI=;
        b=vL188LnzEsS+MsKXijsoJluXMPgIutt8/sArmz7u8w2jTAIn9HLd5FDsnv9iuhYX+p
         avQyieMf2HVcYZunpIGMh/orN7X6vV5YORoDbtlRuDfBwP8c+ODaShEJbzTHssWOsUG3
         iK44quOq9mHpXIO71HTFbLiU+TQBM1XuzFBjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vzahiIr6twtVt6VsSfZyuBvY9ZwGAcuWVXdLGiISKKI=;
        b=npO4xnrBeWXDGW1mMtzQ9M/3e29m5YkjtlmXR5/Zy8vJZQkOmo11oz6svci3GDuduY
         IBJ3g3+HXeu1hv2IWLpZgE4TmxbAdfnFXdmkJ1lhYBO+f2URxCEVBurfwCktyjZKDri4
         2L7R9ORI1MWdZEiNnNh/N21wV+ck4y2ZvkQlKZG5rExZqFx0YkrzFYZ1usiGZkgzcxjV
         GNlVYyMbVlqxo0cFUwKyUKSdXeLCszoPg48+lyUqBKe5tq6BloduvNPur2KwJmk8QTA2
         W2qLwILFqFnY5UD/kJJ3cV/AI73913EPJliKSUkmN/z9ACHWqhhM45ru1nZAb7Udg+Sw
         ktoQ==
X-Gm-Message-State: ANhLgQ0oaDmZsLr48pE3bbdGzzPDKytuzxmU5IAGBADHFiEu4eHRAD3x
        X9XsEfNcirx06dA6L4Gn6xdrxg==
X-Google-Smtp-Source: ADFU+vsNhSDq+4c6qa3NLLHn3/xIV3phZyRLu07jB2TtZmct8F2GzqbRAyf6VGtqPNUqtLII7mdYEA==
X-Received: by 2002:adf:f0c6:: with SMTP id x6mr19533874wro.273.1583752409755;
        Mon, 09 Mar 2020 04:13:29 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3dcc:c1d:7f05:4873])
        by smtp.gmail.com with ESMTPSA id a5sm25732846wmb.37.2020.03.09.04.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:13:29 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 12/12] bpf, doc: update maintainers for L7 BPF
Date:   Mon,  9 Mar 2020 11:12:43 +0000
Message-Id: <20200309111243.6982-13-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309111243.6982-1-lmb@cloudflare.com>
References: <20200309111243.6982-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Jakub and myself as maintainers for sockmap related code.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14554bde1c06..adc7fa8e5880 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9363,6 +9363,8 @@ F:	include/net/l3mdev.h
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

