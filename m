Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41E9E0C6F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732915AbfJVTSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:18:16 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]:37451 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732810AbfJVTSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:18:15 -0400
Received: by mail-qk1-f180.google.com with SMTP id u184so17390015qkd.4;
        Tue, 22 Oct 2019 12:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dWKTTugTGOTAxmBT2CipEcIGsfmcg1KJPSrEI8Zo/tg=;
        b=a7ljsWsCc/4Bghe/SCSDdYexeZZP33WgyGqgJzUtJ4mhoXtnyVld7wXJZ5hSFrPXU3
         6/EHSJMJc7xseT/MOnFvW42zIuBlVQApB1LMI9WX/ITVxqx48c75JRTCtslzmiCITLXl
         e/v8bCrsx2B/2MybdoPvaoeCq1oXmOj5AUCpSX5nt1gUOmy49D4j2g1ozjtmq3t9aKL4
         2kzi7ZqBtAdlAJXcS92Dd/cqyAsT36cl/we6V+c5N3wpBZTJzUWhTj/mhWtJlmx7MtCO
         fAixR1REoGf/X/eH3uz+PW6cLLvZRK0jXeRu1hLYDYj7YxSLtcGPFXUSWdOBewXgIfMO
         //iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dWKTTugTGOTAxmBT2CipEcIGsfmcg1KJPSrEI8Zo/tg=;
        b=JEVmMjCTbaHFxrv4Coz+ivfL3n90II46FYcawO1K74SaLcRxWBG8L61jo5mhcJeIT/
         6TNRBavA5M5bJeB5D6agLCeF8eE9cWSUNQ+RO46dIYIBDj187ClC5QDhNx0f5BbBmP9f
         q2Cd9ZPoX4anhX01fTnzuyXXU5QU+bE2Hb0V2KCI0KQgphsPXiKzv3R0noIMhMMsRGb8
         gwtn1ipwLrxY+hmvY/3gjk5cprGX9nzWC4tZtgvK02GhYpO0lzYmDlKaK1womwuwE+9O
         pt002SSQyCCLP97EhaSDQt3SOQ3zb2DPyKc4IY6eDWgnadpQooWTq6WrtcrttKJ2zU6m
         TUzg==
X-Gm-Message-State: APjAAAX8k29w86icvRkynVDKkRppzRgBqcMQPwIj9Ddg/O0eGVYVNYEr
        67OE4kAmfeSAkZo4Ubkzmfy6LhszufdvVB7E
X-Google-Smtp-Source: APXvYqzXFVeITHx3x74ps8yYB7QAvlyWCveljANotGc2wyAdd9eVCog83fmqZoAOK1JvN/BbXNUDVg==
X-Received: by 2002:a37:4b4f:: with SMTP id y76mr4491493qka.488.1571771893770;
        Tue, 22 Oct 2019 12:18:13 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id r36sm8015969qta.27.2019.10.22.12.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:18:13 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v15 5/5] bpf_helpers_doc.py: Add struct bpf_pidns_info to known types
Date:   Tue, 22 Oct 2019 16:17:51 -0300
Message-Id: <20191022191751.3780-6-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191022191751.3780-1-cneirabustos@gmail.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add struct bpf_pidns_info to known types

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 scripts/bpf_helpers_doc.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 7548569e8076..021cc387d414 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -437,6 +437,7 @@ class PrinterHelpers(Printer):
             'struct bpf_fib_lookup',
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
+            'struct bpf_pidns_info',
             'struct bpf_sock',
             'struct bpf_sock_addr',
             'struct bpf_sock_ops',
-- 
2.20.1

