Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84DE169ADE
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgBWXTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:19:55 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55193 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgBWXSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:05 -0500
Received: by mail-wm1-f66.google.com with SMTP id z12so3995013wmi.4;
        Sun, 23 Feb 2020 15:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=izHY1F8j+df2t9OwA9fWXu5eRF5eYehm5029wXHxxig=;
        b=LreYWf0DBloZvb0KlyMsbV8daJZDxN7BzedhxGS2M1vxfwFELagpDmYWt5Jqr4vQl1
         6H3cfxQLjYeYnA6UqxYh7KwwxqS8sxUbiYUhf5kVlbodHMYsT8a8UyxPEF2hCH9q8sds
         I2dvpeuvF5WRifLIwgumAkIalFx32wfYw1G7XsaYUK+ptM0NQXNJZTejWvLnSdqp5Ysh
         NREckGmZ9lf8PsCgrmYObPP1KZrSYO6uyXNc/e6ApYZqWLU309w8sEEA7wd+bn7MC4bB
         g10ZNjs0NPwIyCwAlJPcru/B/TRmEWKCIGv4p6bLccdyIILCnQeeiI7HmePQa6dIfS+a
         Oe0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=izHY1F8j+df2t9OwA9fWXu5eRF5eYehm5029wXHxxig=;
        b=UAh20UBx8Zzc0DrHBa8mdN2SlZ3qkNRTgQuKma5ecTvqTMsQrJFBuqe3ojilniuShX
         9ccApw00A8k3Ka/4aXUJK1nICqc/u3p7AH8tjJUUJtJhSxlm9+9dyiH5oGqTSJQF+ly5
         hid5rqc1JHSYgaT5ngfOGzonvqzqufdhrvFXNVXZuXZaghY3zd9RneK23selnfViZHNY
         TYUuE4UXjOMb5tXdklv/naq4L/sxpYe1hrUbHimkFuhvSnNzbg7khsJsZEwV7NsR8sEH
         hUXXlg4Oj2A4NCNy0KdmlpFmXzFd6wRMzLzyhxsos3CErhhZ1upP5Wfw/yFIQtX5S1Ps
         kqFg==
X-Gm-Message-State: APjAAAVuPRsC4Kt6L7BoS+aKm6fdiXUQHq54/k5urFH0lbeybM84bYDM
        jfB+GJ0J5NSaLV46ckpX3g==
X-Google-Smtp-Source: APXvYqwyHc0nNrbOi12Sj6zEaiUGypjYKwRVLIaFMUUCNlOvo24h7PuTDa6V1OgusLD6vCalvWXLMQ==
X-Received: by 2002:a1c:1d8d:: with SMTP id d135mr18045693wmd.92.1582499884063;
        Sun, 23 Feb 2020 15:18:04 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:03 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-hams@vger.kernel.org (open list:NETROM NETWORK LAYER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 09/30] netrom: Add missing annotation for nr_info_stop()
Date:   Sun, 23 Feb 2020 23:16:50 +0000
Message-Id: <20200223231711.157699-10-jbi.octave@gmail.com>
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

Sparse reports a warning at nr_info_stop()
warning: context imbalance in nr_info_stop() - unexpected unlock
The root cause is the missing annotation at nr_info_stop()
Add the missing __releases(&nr_list_lock)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netrom/af_netrom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 8be06e61ff03..7b1a74f74aad 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1242,6 +1242,7 @@ static void *nr_info_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void nr_info_stop(struct seq_file *seq, void *v)
+	__releases(&nr_list_lock)
 {
 	spin_unlock_bh(&nr_list_lock);
 }
-- 
2.24.1

