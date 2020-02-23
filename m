Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39680169AD1
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgBWXSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:18:10 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35766 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBWXSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:09 -0500
Received: by mail-wm1-f65.google.com with SMTP id b17so7457829wmb.0;
        Sun, 23 Feb 2020 15:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=snlmcYtYDuvHwXmAmC2g0GkUCFgaXil3Rfxn4Ydoo+Q=;
        b=ZGuy3lgMu6uKf/X9D2SHX21zkV8GcEgjqUfqBX2/VsMNPWYVv9yk3VmWIbeXKBoX6h
         IEJ5XfchVqFSi5MortQ5DvdrkJ+w6DJtKX2ZjIJ6wkteB+gd7FLkaXNDXHT3keEqhEGq
         7+VzVRQE9s0hXskUNxNOZ1YsJPA+Ll+rRERd8aC840MN4w43/E4tHYsQuiRIN+mOa3aq
         X7VT1xs+3VvF/1BZzbft8ylQ9pmp2UcMokZfMj713duCV8mVFuct7/zrHVwDxHr3ZCe6
         3w6dfyqLL0yA7WnUEHuuQNoqoUNTw1sula3AR/Ic6Ip3Swd+DPlzTjzyNTVt6RVbhvWV
         dxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=snlmcYtYDuvHwXmAmC2g0GkUCFgaXil3Rfxn4Ydoo+Q=;
        b=Cvs7UMkLovrfydS2q655NDOuQM23EBaqVhxc9Bu8I+AxuY8LaKWrfMv5gsQGIRmuLy
         ks7wlEcRNKmoKLazfYI/yLi/vzzgHLa2vMGNSis5sCd49Rmn9Vq/MYa57nGJY2Sd63kB
         v6YE1MoAAd15Iq88zVptocS5KBkrZ/ignHkzvy1Y3uQ/nM0tqe2zh4iRXtLu1zAWdQMe
         9F/KTHMSuY3wQqtMsl2kf4Xxz6K2HP4EG23JI8NF/ZV6k0tIbpy+IcVJ9+ak0JiI1rDd
         AgnP/yI9IVuDc/sIlEmbQWt5dys8n+CkMrsAjhaLo84NpJFD00Lk2MITAOlX6lYS0JW4
         8cwg==
X-Gm-Message-State: APjAAAUnl8ZepI85IR1Cw10meyMwzLIM3jvly+IvBRjUr88OZb2HHidy
        ilHG0oDbzBGir/edMdNIZYthUdeObvnv
X-Google-Smtp-Source: APXvYqyYZ3oMJ78+zymZmXiMpsjrXDyNhGOu0imdZd6MmzJ1dwnZa5BV+hh38cDu48X5BkdbSg9p7w==
X-Received: by 2002:a1c:4341:: with SMTP id q62mr18101720wma.107.1582499887152;
        Sun, 23 Feb 2020 15:18:07 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:06 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-hams@vger.kernel.org (open list:NETROM NETWORK LAYER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 12/30] net: netrom: Add missing annotation for nr_neigh_start()
Date:   Sun, 23 Feb 2020 23:16:53 +0000
Message-Id: <20200223231711.157699-13-jbi.octave@gmail.com>
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

Sparse reports a warning at nr_neigh_start()
warning: context imbalance in nr_neigh_start() - wrong count at exit
The root cause is the missing annotation at nr_neigh_start()
Add the missing __acquires(&nr_neigh_list_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netrom/nr_route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 637a743c060d..33e7b91fc805 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -895,6 +895,7 @@ const struct seq_operations nr_node_seqops = {
 };
 
 static void *nr_neigh_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&nr_neigh_list_lock)
 {
 	spin_lock_bh(&nr_neigh_list_lock);
 	return seq_hlist_start_head(&nr_neigh_list, *pos);
-- 
2.24.1

