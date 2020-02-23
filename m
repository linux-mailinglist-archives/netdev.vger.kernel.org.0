Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF28F169AD6
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbgBWXTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:19:35 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39016 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgBWXSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:07 -0500
Received: by mail-wm1-f67.google.com with SMTP id c84so7453448wme.4;
        Sun, 23 Feb 2020 15:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mf++eeayLsVrcTVe6kbYrrnwfp2AEx+dRuICz5iDthY=;
        b=scWgaIOmdbwqRz8XkqHo3LJ08oQDqJ3XycbTlHUlm8XzHxJhpKqJfSdF0FCZSu+wt+
         EJQQ9eT8yxLTRUnQ82BPqcNqNkxMEAa3G67UWTrXc/6+ahq0CKSGNtKwuFHuZWUn9auX
         azqIYlkeRinAvqOhM7MQ+IOrq13QADRIHzvzY97SyucZERwLddvzN60FbpklkB0dSdLv
         ovhemh57TsX4vmc06v3yPGdNy7HrzZcO3tRLQc6sqAoPE9izZ+ZK72Vac+wW7Mlq1RBI
         pYZj6uRzVeaSd4q1+91EHj8tXrUGT5XJdA5Or2jCnSdrSDGCgoIzJeGlzyL9jiYy+K0Q
         6XzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mf++eeayLsVrcTVe6kbYrrnwfp2AEx+dRuICz5iDthY=;
        b=YZgxOHKNdGtkNKx0y7EwNe0j1eDr1jaT/MzddL0NUXyUjiluekSVUOS8HpKIe82cVR
         XfTPXLM0ixKTfRbpCL1Nx9nUyYBgQLZpKsV8lk1D7wtXruN03rzRHPiZvB075saRtV2a
         kQb+9HNhGzzyMAyleL4dp5tEJJ64JTfC9jSAhqbkdlQU3HbTR7YNqj2Auu7wSW3EHmq4
         72Bj78dlKEj4fqyLypAO8Iudi+LqEPEQa+Z7MQd2ag4AXPQoY/D0eCcmtXsxc4Vo+L42
         fExLEOC9Docx3fiDax5MFKS2abQyTQE4c7uGcRxdHEeoAmGyhnpRhP6fmDrKbhsUvUei
         ykFA==
X-Gm-Message-State: APjAAAVaqu/6gv/oMRHtSADsnaeTKKaHlA1XUuri0EuOXzEpqWfjPA0i
        HX0WsmD7sIxgE8rswUg80PEbwdjGpNRv
X-Google-Smtp-Source: APXvYqzq/ul2JMElKpOHKENYRd3jQpfODd0F76DbNRMFBLppm1MGe/qJ2X3oHiWWCCm1fHfeGC+qHg==
X-Received: by 2002:a1c:2645:: with SMTP id m66mr17508997wmm.98.1582499886116;
        Sun, 23 Feb 2020 15:18:06 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:05 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-hams@vger.kernel.org (open list:NETROM NETWORK LAYER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 11/30] net: netrom: Add missing annotation for nr_node_stop()
Date:   Sun, 23 Feb 2020 23:16:52 +0000
Message-Id: <20200223231711.157699-12-jbi.octave@gmail.com>
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

Sparse reports a warning at nr_node_stop()
warning: context imbalance in nr_node_stop() - wrong count at exit
The root cause is the missing annotation at nr_node_stop()
Add the missing __releases(&nr_node_list_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netrom/nr_route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index fe278fc24153..637a743c060d 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -850,6 +850,7 @@ static void *nr_node_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void nr_node_stop(struct seq_file *seq, void *v)
+	__releases(&nr_node_list_lock)
 {
 	spin_unlock_bh(&nr_node_list_lock);
 }
-- 
2.24.1

