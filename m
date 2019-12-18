Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EAB124F8C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfLRRiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:38:54 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38675 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLRRiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:38:51 -0500
Received: by mail-pj1-f65.google.com with SMTP id l35so1199929pje.3;
        Wed, 18 Dec 2019 09:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dWKTTugTGOTAxmBT2CipEcIGsfmcg1KJPSrEI8Zo/tg=;
        b=D5NnhQbI+mDaV1PQ4wBHjLBzJKH9ScxJC052WKvW4Z6uaUXUwQ0gBnyT72EnwqYCsv
         IQMG4CS1ihS79lMMdcZlf8adV04jocAb6ky054iehZffDFg5nwUVTLCDqclQgZ5ArOV3
         HbwlMg9bcwmSRXTDoZ2QJQLEojYeA9wiZVbNWhJmsqi4Y93lPIOq+KJ1V9/dTky6r3P9
         mUTSbGgGM4e5Gfqp1MDJ3TWcm0l+8exPIqWzIP0jf6738PXoijZIgemK6Qm6ybONW+oO
         SgcY4ld+zCEY7P2J0opCoPvmN3v57iShrQoIHHuvFSeQSPTmCaqgQpN0Ay+lKi5NMshU
         ZVAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dWKTTugTGOTAxmBT2CipEcIGsfmcg1KJPSrEI8Zo/tg=;
        b=naD329H2z77Pj/rys21dGBHGFLZ7bYokFO1DLZOUZ0Yc+xLROpkz9S0loFBoKaopnk
         2yUcU9kSgo2IWQqyAbMCn8pvNcFKEXQLnj9tlnhpFW/woPY5/oBAJUM1mFAqEy0g4FH+
         W9wB4gypLmM50ESNLG5FNEUyKUcvzO5r6W+xQbFwDKch5HxcDEdAHtGTD79x4il7OuiV
         t+8S/CaETRHXcBIRjYA6wGyRhzWblUjj594RfvkKnHp6hI8VMtkv885+6qC8QTX99RRa
         AYZIT2HGXaJqaglspCt6oPK8G0hpjhEDzEVKTcFbwN07STJ/FRPaPgun/a7zx7b/V4B1
         yWpw==
X-Gm-Message-State: APjAAAWGYHVWtUSIfe5nIVH+eBxZQ0HTM8RbkB0g5eJI7HF+7B0UgVl9
        7qYZk4vZ2SJ27TrwyLUacI5PwvX485E=
X-Google-Smtp-Source: APXvYqwJz146CAnZE2imfyh5skgR8nGQUP67rzwpH9rPhAjEbV67e/6su1iR3e9KEQz46PDr29taZQ==
X-Received: by 2002:a17:90a:fa92:: with SMTP id cu18mr4280234pjb.114.1576690729976;
        Wed, 18 Dec 2019 09:38:49 -0800 (PST)
Received: from bpf-kern-dev.byteswizards.com (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id s15sm3991925pgq.4.2019.12.18.09.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:38:49 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v16 5/5] bpf_helpers_doc.py: Add struct bpf_pidns_info to known types
Date:   Wed, 18 Dec 2019 14:38:27 -0300
Message-Id: <20191218173827.20584-6-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218173827.20584-1-cneirabustos@gmail.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
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

