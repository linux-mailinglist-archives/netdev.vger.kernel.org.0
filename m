Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36291DDF4B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgEVFX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:23:58 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:57186 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgEVFX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:23:58 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 49Svzd02VSz9vJsG
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:23:57 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mdmVogji1N1D for <netdev@vger.kernel.org>;
        Fri, 22 May 2020 00:23:56 -0500 (CDT)
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 49Svzc5PKhz9vJs4
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 00:23:56 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p7.oit.umn.edu 49Svzc5PKhz9vJs4
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p7.oit.umn.edu 49Svzc5PKhz9vJs4
Received: by mail-il1-f199.google.com with SMTP id x20so7632988ilj.22
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=gMkSYpaYiObsrUAVjFqJo6jrnyjpZK7kA9iCJfIjrqc=;
        b=K46G5HlWLq1auBODxrIzWkUvSV1jUEIMLHROEWmKaZZxC32phG4tfLMl8okF/csdmU
         Qb7d4/gZfZBmI5FFy/CTuhYTjf2XFyJn/Lz58hnRoh6IDboSeixagSp/3EOh9bqeKaXg
         kNh+s14RC3ogRe/maSFJvzUAdyi3IpaZlrNBR3nc2ouwvsXXKD5XiI2OSsvOYtePv5y3
         Li1xzhSOlRYK1iGyU3LvgGDwlSscEgxEHCUPo+9cK9a+h+2siKz4EJMGu0wqasrfgjlN
         kPauEuxP8pTiLDeFVqoJ172uqZ0UMqu/r5aQes6a4/HmFAl+96BRgXKmuFVpqIqHDaWw
         CxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gMkSYpaYiObsrUAVjFqJo6jrnyjpZK7kA9iCJfIjrqc=;
        b=d/3ppLM2on9RTPbD+4L0bcA9v7HZBAELadhEc18+UbH9TsUNUR9tACOg4TrVvkWwJa
         YEl5ZDvZh2R7j/Gy6oVcGU7n8WlC5hen2RX0WgD2m/Qtyb5FJL9mCxGrH8jLE7szfgxo
         t6/EnggXxTykTWR1ngZdNOYGlnz+bEuiYZEvg+FXWn0UYt/FAZSpgCa0s2HJ/mlUCdg5
         a9Zf09pAt3YJGfVdP92JdnxZv+q3CVcB6dEJ0LWQUznqbrPm7lYAC6iDQV0KJvWzoPMm
         azov83FVEeFhUVLjjdxMnwY3KRa7pKJzVVRNHPyjWahWYM4fA3R2Vz5QNGTjLl+JvqHf
         uByA==
X-Gm-Message-State: AOAM533ZiGTJ9Y1WECsuKAdy6ck96jo9Pl1r9fvTQMxa78AsBXGLX+EP
        hLDap4qiiuRliKtZPrUqndZn0wkl+mMHTN0x3FElx7KSiXdk8sXIKYkLOnLXPjYkw2U3CgNuIK0
        eosuuF+L5dbx0JWlI4zMH
X-Received: by 2002:a05:6638:12d4:: with SMTP id v20mr6892438jas.96.1590125036283;
        Thu, 21 May 2020 22:23:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9YKaP7wbCt6UDzTnd/OuhdJydO+ARIMKhGdek3jVG5RqkpTWXM/g1l8gx5w/z/sQO+Uq0Qg==
X-Received: by 2002:a05:6638:12d4:: with SMTP id v20mr6892420jas.96.1590125036048;
        Thu, 21 May 2020 22:23:56 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id i10sm4042490ilp.28.2020.05.21.22.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 22:23:55 -0700 (PDT)
From:   wu000273@umn.edu
To:     tariqt@mellanox.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kjlu@umn.edu,
        wu000273@umn.edu
Subject: [PATCH] net/mlx4_core: fix a memory leak bug.
Date:   Fri, 22 May 2020 00:23:48 -0500
Message-Id: <20200522052348.1241-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

In function mlx4_opreq_action(), pointer "mailbox" is not released,
when mlx4_cmd_box() return and error, causing a memory leak bug.
Fix this issue by going to "out" label, mlx4_free_cmd_mailbox() can
free this pointer.

Fixes: fe6f700d6cbb7 ("Respond to operation request by firmware")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 6e501af0e532..f6ff9620a137 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -2734,7 +2734,7 @@ void mlx4_opreq_action(struct work_struct *work)
 		if (err) {
 			mlx4_err(dev, "Failed to retrieve required operation: %d\n",
 				 err);
-			return;
+			goto out;
 		}
 		MLX4_GET(modifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);
 		MLX4_GET(token, outbox, GET_OP_REQ_TOKEN_OFFSET);
-- 
2.17.1

