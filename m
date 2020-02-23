Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D204D169AB2
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgBWXSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:18:11 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51763 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgBWXSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:10 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so7197616wmi.1;
        Sun, 23 Feb 2020 15:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CGy+45WF1yFjQt9PrNIN82SV4WB+MIWNf+141Nv3d4s=;
        b=WBallZcCQBVP54ycId2IyweZf0OIRq3Vs6MGepXlXQ3yqR/UyfmPea+5VtxZ9agXi5
         +XUHhpN7tc8mo2FBAgr6+0YVx3JoUk2iTX14/CVqlnaVfE3woUEVW5XXdtjVNUOH8UUz
         Xevzd/wE3T3ViJfH+pF6iy3SxPdPFuRnJ1BxCh0U1b5nKQAVNj6+knS78LyqvADTjq3R
         LbNYfiQpXnOLxzHR15UPmEMr96M9P1rOWxHHqro+NbETgIc22ECDlmVGTwn9SNYvM9Un
         6EhPhsenbowTuX8NY4rh2oollFLlvIrdHo4bIE8nkyNKEMtIvCkbTHDuerZMDOB5D3Wi
         NE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CGy+45WF1yFjQt9PrNIN82SV4WB+MIWNf+141Nv3d4s=;
        b=jK8p7aoRoupKRfpTOQObPi+T9l7V0L3xt4VNqJXmBoanZGczhGnczG+trAYxgEYioT
         oZCw73250m/IEHb9neSCqGdgAPJSSoKe6vUtXME5LIweYBp7QRJs3I+90xSTKDQKpYo/
         AGtwAnkUhHbBP/NfEdFciSf8NUh/fwYUNW5KY3OJPtJKIxDWiYZEf/s3DWs7WcJ0Enov
         wr/KoqBAGuYfP1LYlodCJ8lhYY7KK/w9/Q3dKyRtg9URPcAduqvvySHPM5U+PFZ1xqxA
         vNpq+ZRA73wKmKiSNqPQ9MTqDQH46IQc8IrrwHm1AG5/trovnuotzHQiVu9UFyXraX6g
         97eg==
X-Gm-Message-State: APjAAAVSo/vraY7GsGN7HtZZf9nR05anccTip0qYR3L+UiD9GoRnjLGL
        RirJalfjzJquuMzx4nuSVQ==
X-Google-Smtp-Source: APXvYqxfUeeF2Fxdkh3I1gfT9ho53f0a3bly5oHUY4FOJ5p1zPeLRyw9LvFNJf+hG3jJRxgl4JK4dQ==
X-Received: by 2002:a1c:f713:: with SMTP id v19mr17575701wmh.113.1582499888163;
        Sun, 23 Feb 2020 15:18:08 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:07 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-hams@vger.kernel.org (open list:NETROM NETWORK LAYER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 13/30] net: netrom: Add missing annotation for nr_neigh_stop()
Date:   Sun, 23 Feb 2020 23:16:54 +0000
Message-Id: <20200223231711.157699-14-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at nr_neigh_stop()
warning: context imbalance in nr_neigh_stop() - unexpected unlock
The root cause is the missing annotation at nr_neigh_stop()
Add the missing __releases(&nr_neigh_list_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netrom/nr_route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 33e7b91fc805..79f12d8c7b86 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -907,6 +907,7 @@ static void *nr_neigh_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void nr_neigh_stop(struct seq_file *seq, void *v)
+	__releases(&nr_neigh_list_lock)
 {
 	spin_unlock_bh(&nr_neigh_list_lock);
 }
-- 
2.24.1

