Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706DE169AAF
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgBWXSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:18:06 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55193 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbgBWXSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id z12so3994992wmi.4;
        Sun, 23 Feb 2020 15:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pyULC8zRDdQ34YS1FTwq1d6c2T2bCIAgmeM9ejfxUJc=;
        b=dqmHA7Di0z6aZI3DD8tanMjnukyJD16fQbr/5grwhOZtuCqBEYND7nYu4+UmdUsJAx
         hSJdgFo0+xzAwCJLYtxmAl/EMFGp2kZig+OA9U/Rh3hrYBMavTHWGGNxzkFVVQ4cA6Be
         3fW61yP6HjwLvT5IzDfVnEjYvkDY9llWN7EtVmTZiRtocnsO14/e9qqrxnvps0XS3C5b
         Kxu5hhHUtoZSsGCUxrC+Anz2EOQ+QHv5tsyaELIcxjd+7Kdp5ofgnCIS1g2mY2dmgw0a
         vaHA4rZU/Im0r5Y8oMpnzyUgFvR6MZxrlHn4+bTYkx+DPFCQO/HEo1dCmtdMzzRlTBE5
         BedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pyULC8zRDdQ34YS1FTwq1d6c2T2bCIAgmeM9ejfxUJc=;
        b=bg7NH021NDCHwstdyV0qOcNmUSBZUncdOnQ6mCdswSl0SCABSphPJvx6Pe+zaXyy5m
         AMhXoPRkgAut54iQppsEQH+KpacZY9n/AbGVAJIapwBmDUXbbalJJmVToxycODv/jX34
         8dRrSxDkRosHMV/PJr2CIo9eng/TvuhxvxlJFP6Rb1GwWoc2GWTsFJ8JSqucIE7P0okE
         WZ706ZKNCnDo1oEjrQVSEQtoI6BHmPJ7LK6iXgFnEAvRTvuYUxbYwqWJsQwNNmQtctOj
         YVPBDEc0vZBn1QOMTWr+cFcQU8VuOW90594Dw3QMy7Liu3Ah6exfSFezkfGbysBVGqq5
         o7Jw==
X-Gm-Message-State: APjAAAWsotMFdNipyEvzTW5EWzlCuz4vwpS89LAW2+J2OxiOQZXrsjxt
        3Ilhye8/wOIhKCSS4VzTnO5qhS9qOGe/
X-Google-Smtp-Source: APXvYqwUpWLcG08hfH/Ti8ghBQEFvbl9xtMZx1Lq+qbVB1C0woND51q3CqSdQBLf9+tcdyIS/jVyLQ==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr17169102wmg.147.1582499882949;
        Sun, 23 Feb 2020 15:18:02 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:02 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-hams@vger.kernel.org (open list:NETROM NETWORK LAYER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 08/30] netrom: Add missing annotation for nr_info_start()
Date:   Sun, 23 Feb 2020 23:16:49 +0000
Message-Id: <20200223231711.157699-9-jbi.octave@gmail.com>
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

Sparse reports a warning at nr_info_start()
warning: context imbalance in nr_info_start() - wrong count at exit
The root cause is the missing annotation at nr_info_start()
Add the missing __acquires(&nr_list_lock)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netrom/af_netrom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 58d5373c513c..8be06e61ff03 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1230,6 +1230,7 @@ static int nr_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 #ifdef CONFIG_PROC_FS
 
 static void *nr_info_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&nr_list_lock)
 {
 	spin_lock_bh(&nr_list_lock);
 	return seq_hlist_start_head(&nr_list, *pos);
-- 
2.24.1

