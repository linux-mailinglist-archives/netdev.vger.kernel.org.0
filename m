Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFA9180D28
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgCKBJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:09:33 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53151 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCKBJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:09:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id 11so290509wmo.2;
        Tue, 10 Mar 2020 18:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qNOlzK/j2ABuDiTQyPDlyVcS7soeVQMuTQgrAWWcf9I=;
        b=rgwYt8hQrRtJDhPqL6acSbVwj/ifctSn0OpICmzrNnRH811aS44QXkIK0YtQwU7F5L
         V771hlOItZjHjl77Kw1rboEs1OxQEIH7/6KCMqUaqzeyAkHMox3zNhiQbBQfMs6Bg1Bn
         paqYACEq4IdQ1pCsXEsK/pnJGvzCyidgzQl1AkzPSt36fj3wl231L636qb4RDEtHgFyG
         56qYR2bST/BXbOV0+THwtrfBnS64s9rNpql8Nr04Rsa6NEJa6lBdhmKibjg/oNFH787L
         A3iDpPqrVCzsEjTH/19w3Y30JcTgee1BKiy4AOJwm1Cpbx4NRvUdu+U4CYazW6B6dvkd
         KKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qNOlzK/j2ABuDiTQyPDlyVcS7soeVQMuTQgrAWWcf9I=;
        b=gkd1RL2TxXg+TQgwG/GWg9l/W7tcBxV360BnPYrTfi78ri6OWEiUvRZE25PYMxX1P1
         gX1LrFFo/wLD4ueS+9wRQpsB0QRiqWa+LipO/ydPL1zFKVPsXRGha87uW01j5rmKhPM0
         voBPt24kLSPWwUd8uBAEPGBxNxBwbnXHFwZgwX292aOcGhPCDFQLIQA1t7afNyi1iVDJ
         Mj4KhdwKrEbgXFT8Q6XP5c03Q9/B1jTQvvNXnBcrZhdJe69p2hRyjz4OabpQK0XzPLGf
         00khDMGRyUVGPpC3x3L+lCn87O9l8IRI28Ddu5JerNS2iOynZd6NxAKraKfMA6YRwMnW
         riTA==
X-Gm-Message-State: ANhLgQ1E5iMWz+TKVUEYXyYkmQ6lU/HDhtFMHK4PnYOUu9E/Tf7k7I+5
        JnpzwfoAZP4nwYedqdz7YA==
X-Google-Smtp-Source: ADFU+vvS7Pttdevps9gifoKLvKQrBzQS8bWMSeCk2h0Mkhu5EINl/B1G/nGvhGQtr5gketgYUTQ7qw==
X-Received: by 2002:a05:600c:280b:: with SMTP id m11mr415679wmb.93.1583888967050;
        Tue, 10 Mar 2020 18:09:27 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.googlemail.com with ESMTPSA id i6sm36658097wra.42.2020.03.10.18.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:09:26 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/8] raw: Add missing annotations to raw_seq_start() and raw_seq_stop()
Date:   Wed, 11 Mar 2020 01:09:02 +0000
Message-Id: <20200311010908.42366-3-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311010908.42366-1-jbi.octave@gmail.com>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports warnings at raw_seq_start() and raw_seq_stop()

warning: context imbalance in raw_seq_start() - wrong count at exit
warning: context imbalance in raw_seq_stop() - unexpected unlock

The root cause is the missing annotations at raw_seq_start()
	and raw_seq_stop()
Add the missing __acquires(&h->lock) annotation
Add the missing __releases(&h->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/ipv4/raw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 3183413ebc6c..47665919048f 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -1034,6 +1034,7 @@ static struct sock *raw_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 void *raw_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&h->lock)
 {
 	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
 
@@ -1056,6 +1057,7 @@ void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL_GPL(raw_seq_next);
 
 void raw_seq_stop(struct seq_file *seq, void *v)
+	__releases(&h->lock)
 {
 	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
 
-- 
2.24.1

