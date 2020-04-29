Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4FE1BD904
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgD2KGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgD2KGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:06:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A315C03C1AD;
        Wed, 29 Apr 2020 03:06:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d15so1795779wrx.3;
        Wed, 29 Apr 2020 03:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hiVRqIqWp82b6MTssb1AB8jneuevgT3OTDW/kBeOt0I=;
        b=SKJd4TTwE7XbjN/pvdpafc4kMmTuwVVmXWyB2OfwJkqeQvErPCR1Dlw0biozxaoAV7
         L1VJSuUofn36L9umUizkUkyW+o2dDLzCpKGC/t6msVENR6x+612HFXHUsN3Ew9pnul8s
         STMxaVPJpY2ZVcXszTki1iMKQ9P+DXQ5ySW4XluKTRwn5NR7eKrqEkQwmop0SuZCc0Dg
         ZDdp+H7zuV5ru91jWxypd5kZiUpW0vJPUIl3h0sMaqB7UJKHMc2sgs5QkaZrj+Tai+yw
         0zSdk5Ji+yw2DunNurRLz8v7gPZPgpjfcxZMKJclAHYYSzITrx5c7zBxXVnTxvOKC/Bn
         QGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hiVRqIqWp82b6MTssb1AB8jneuevgT3OTDW/kBeOt0I=;
        b=aio2n/pYbLh0Quj6ulEzomK0Oeetzu6ypEN79KlKcZK1cfOcoaYsGJ5b7fBH8sDgBi
         Ko6vejEY1x600uBNOpn3ObxyfvpNd3ZrEvo3nDB33YizLt/Sbjol6HuOI2jpJOSPCzah
         NxFGEGpYU3+dh9Fr5cJiKqlrYzbvfr1N76zBa3ki9F2jbg6pLH1tJSkpf5EIlhKNIEt9
         95rwrriRBB1OfKHdYl+8YUHTnoNbKG90A8usJCRbAugxd5GRu6IlTw7umxre4nLDnEM0
         M0p/qI9BnTfDH0aO+NymLKkjGCiZis200Ew76+Jb38NIyUAXNIdelBmt5MaQZin2RxGg
         BYfg==
X-Gm-Message-State: AGi0PuZoNrNZdyBHyUjnhrmS0fg7oJZGtLoBoNidSXjo2pqeRDiiJIGt
        McVFsnbvUA2XgElWfTgDQLO6vWeUznGA
X-Google-Smtp-Source: APiQypJqiZPEPK7K5FK4ZJwgGP1FPoIZh2+iRsAWJUUR7ERDAuAoyfbGQHMYIDwbmn6xnQ3RqTq2UQ==
X-Received: by 2002:adf:97de:: with SMTP id t30mr39832469wrb.135.1588154808257;
        Wed, 29 Apr 2020 03:06:48 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-195.as13285.net. [2.102.14.195])
        by smtp.gmail.com with ESMTPSA id 1sm7205478wmi.0.2020.04.29.03.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 03:06:47 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 4/6] net: atm: Add missing annotation for lec_seq_stop()
Date:   Wed, 29 Apr 2020 11:05:26 +0100
Message-Id: <20200429100529.19645-5-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200429100529.19645-1-jbi.octave@gmail.com>
References: <0/6>
 <20200429100529.19645-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at lec_seq_stop()
warning: context imbalance in lec_seq_stop() - unexpected unlock

The root cause is the missing annotation at lec_seq_stop()
The __release() annotation inside lec_seq_stop()
tells only Sparse to shutdown the warning

Add the missing __releases(&state->locked->lec_arp_lock)
Add   __release(&state->locked->lec_arp_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/atm/lec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 25fa3a7b72bd..22415bc11878 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -940,6 +940,7 @@ static void *lec_seq_start(struct seq_file *seq, loff_t *pos)
 }
 
 static void lec_seq_stop(struct seq_file *seq, void *v)
+	__releases(&state->locked->lec_arp_lock)
 {
 	struct lec_state *state = seq->private;
 
@@ -947,7 +948,9 @@ static void lec_seq_stop(struct seq_file *seq, void *v)
 		spin_unlock_irqrestore(&state->locked->lec_arp_lock,
 				       state->flags);
 		dev_put(state->dev);
-	}
+	} else
+		/* annotation for sparse */
+		__release(&state->locked->lec_arp_lock);
 }
 
 static void *lec_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-- 
2.25.3

