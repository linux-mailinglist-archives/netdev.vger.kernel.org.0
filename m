Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8A1BB5DC
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 07:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgD1FY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 01:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726042AbgD1FY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 01:24:59 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255A5C03C1A9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:24:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a31so625829pje.1
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6ZztKMF0gJTysRYFaXtbA26j/uzd2V5s9H47yx0vHpw=;
        b=Q4QHNDsj1RCURU9n67cv6Czff3oAR7G7VcxMroQAebOGci6pFdq2GPEw5etEC4Am76
         pPAhwDFgRTElkGSB7vR2q6TD21SWv42zbf9xPDgCxo5DiI+yjSN2ekxbuTl1hcT5I+Fn
         WeKejrUOrdE0YvpHqJtDM//kstH0MyzjmZR20b//AB+rTmCsW7gObXhIi8i8zupJuaXk
         stQ4zmKSnLyK81sprquf+s/qav9qQMj6YZz7lEhW827x2VS892V2JQVsFwAsqdA3wXBl
         Bqns7y2ytdwYomEFJwRFGSvPSuTqp7WE9jKm8yGn4t3WdmX34BgPKFl31kAD+pLopKmK
         NeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6ZztKMF0gJTysRYFaXtbA26j/uzd2V5s9H47yx0vHpw=;
        b=KZOVL3AIxYLNYypwmsqxRYw5bEqKNpsjuU7xd+BRqkgpmqXRXHsn+lJSRU6fqNlg3n
         7i37xVlNQc0k+QEcLcaJp9EmZof5/TrJe0tFA8s5LlqM8te2Qri1hJcnh4YYN6CeJeSR
         sjphlDyrkgDYsU1VOD0qKepRXeKBWmNKqMOSUdNJ0TOMqf5kXqBC9rCwjrGK6+USNOYe
         8UPPqllL8/ZU7aYhE2+O+dP7xb8uhKQptMgRZVjemyZvBTiIthpdDlY+tYgmAzM/g9kr
         l1slkKo/QSIeMTlG7lkQzbdLg79/k6CvB6Jlooc1HpgakI+bAHCnQ55dgEvUAsXEO5/r
         Z4xg==
X-Gm-Message-State: AGi0PuYslKpnyGKZTHA5umU2Uy2S6iXdqfLMzPNizL23jKoi9Z9Ee+zK
        /KnfVcDUKfHq+N+JO7eplBQ=
X-Google-Smtp-Source: APiQypJSEVpKR/Mjg1sKYHGDCleFDpxa3rxDH/8Bh4lrIKeSyGwkL+qLmTDn4MElia7qX/Tje5Z9xQ==
X-Received: by 2002:a17:90a:80c2:: with SMTP id k2mr2952099pjw.6.1588051497698;
        Mon, 27 Apr 2020 22:24:57 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id d8sm14093044pfd.159.2020.04.27.22.24.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 22:24:56 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     paulb@mellanox.com, saeedm@mellanox.com, roid@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 3/3] net/mlx5e: Fix the code style
Date:   Tue, 28 Apr 2020 13:24:15 +0800
Message-Id: <1588051455-42828-3-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 55457f268495..6b68f47e7024 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1367,7 +1367,7 @@ static bool mlx5e_rep_has_offload_stats(const struct net_device *dev, int attr_i
 {
 	switch (attr_id) {
 	case IFLA_OFFLOAD_XSTATS_CPU_HIT:
-			return true;
+		return true;
 	}
 
 	return false;
-- 
1.8.3.1

