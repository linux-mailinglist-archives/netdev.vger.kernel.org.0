Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DEB1A4CE1
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 02:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgDKAUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 20:20:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39469 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgDKAUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 20:20:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id y24so4360688wma.4;
        Fri, 10 Apr 2020 17:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=neMHyWmt5aDs4XMeVy9/rpYrSAQCVVUJ/oaGM9211Q8=;
        b=ncIQdvrnO5Y2UQ4dYx8USO2hUvroaLP7i3q1a/wfun2XI+gGPlRhgRiJU9OTT314qD
         8q4YUQxdkfr1r9NLN2vyQjnAjRHRpkkmQY38RO7bvSia1aBpxZDnGwzZAyqFw6+kX6sK
         6oXnPqKMY+TTO8Thr0aP15hIm+e394UBVPEVfsmsHST31qnML9qMB/XpPwRjIy0xzE+H
         swmgg5phJbFpAayDQeTDasnKjdsuyJWAPqHSwWR2CWlowB/tqBPVmKjIp+RNpODjIbYM
         cX0WpMgT/BaWa9ABnWzeSV1KOjR8lLR3Jewk9SX9yKI63TpUBY+m1qpoNoWSJ+XQA2Kj
         KVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=neMHyWmt5aDs4XMeVy9/rpYrSAQCVVUJ/oaGM9211Q8=;
        b=V7sO5CQaJsAgKuLpUqSHMHDl6SsI+Zdb021Pf2q1eD4SLcfgdRjTRzT8f0Trmto6re
         BPk+h8He0r17tg1gcCLaGVSYagCvcVq+rQe3InvrKWhd64/gLflPaVUzeIzFXZVSJp4H
         YDXyYLeJuLEy7+8zKiq4+tD20cl5pN7P3YFepm0T/FtKRO1ei1a0oY3A8UNAFylyojHH
         tk+NmB2je1ziHmVltd15yS3FMf45t3XGHvW/JjfnnUcEJ6JNGT+rD6mBWIMhOoROncTb
         k6qSeH6rk+dYMd9Ozb+RA+7B+6R+MNA6EyqQhJApMxL8imPrvTMESKrznnUz/5/Q3LYr
         +s1g==
X-Gm-Message-State: AGi0PuY+p67iiOFbTmqPR/c+ouOYa/Og/teVgLOoVht+C1g20frfR+S6
        J99h13Z2lT0yrPkbrW7lpYCw+TNpZER3
X-Google-Smtp-Source: APiQypIrfTUAeUpy3epoyJ8Ai+C1TsIbYkXmSFwo9u3pL1BWDnOWYKDkrOgbFpJir7rAeRe2FOxCFA==
X-Received: by 2002:a1c:2d8b:: with SMTP id t133mr7726176wmt.131.1586564411392;
        Fri, 10 Apr 2020 17:20:11 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-153.as13285.net. [2.102.14.153])
        by smtp.gmail.com with ESMTPSA id b191sm5091594wmd.39.2020.04.10.17.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 17:20:10 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jouni Malinen <j@w1.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        zhong jiang <zhongjiang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        linux-wireless@vger.kernel.org (open list:HOST AP DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH 3/9] hostap: Add missing annotations for prism2_bss_list_proc_start() and prism2_bss_list_proc_stop
Date:   Sat, 11 Apr 2020 01:19:27 +0100
Message-Id: <20200411001933.10072-4-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200411001933.10072-1-jbi.octave@gmail.com>
References: <0/9>
 <20200411001933.10072-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports warnings at prism2_bss_list_proc_start() and prism2_bss_list_proc_stop()

warning: context imbalance in prism2_wds_proc_stop() - unexpected unlock
warning: context imbalance in prism2_bss_list_proc_start() - wrong count at exit

The root cause is the missing annotations at prism2_bss_list_proc_start()

Add the missing __acquires(&local->lock) annotation
Add the missing __releases(&local->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/wireless/intersil/hostap/hostap_proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_proc.c b/drivers/net/wireless/intersil/hostap/hostap_proc.c
index a2ee4693eaed..97c270845fd1 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_proc.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_proc.c
@@ -149,6 +149,7 @@ static int prism2_bss_list_proc_show(struct seq_file *m, void *v)
 }
 
 static void *prism2_bss_list_proc_start(struct seq_file *m, loff_t *_pos)
+	__acquires(&local->lock)
 {
 	local_info_t *local = PDE_DATA(file_inode(m->file));
 	spin_lock_bh(&local->lock);
@@ -162,6 +163,7 @@ static void *prism2_bss_list_proc_next(struct seq_file *m, void *v, loff_t *_pos
 }
 
 static void prism2_bss_list_proc_stop(struct seq_file *m, void *v)
+	__releases(&local->lock)
 {
 	local_info_t *local = PDE_DATA(file_inode(m->file));
 	spin_unlock_bh(&local->lock);
-- 
2.24.1

