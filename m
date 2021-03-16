Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077CE33D86B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhCPP5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238243AbhCPP4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:56:47 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DC3C061756;
        Tue, 16 Mar 2021 08:56:46 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id h82so37274910ybc.13;
        Tue, 16 Mar 2021 08:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gj0mikrLZmWTiWANlej8ah5+G+uOw7wqH4StZRro6uM=;
        b=VH12ZdGfTi9p8W2BDp9E2Cl/hd06N5/fFLrRsw5RKEaXK4SWQkkfb9k27Pt25BFmIG
         Cj9B0cGPjrPE2sLXdDIgr6Kh6eSeW4EimEByQO6BKni9SzrAgtWcsAEvqnFEhmoicX4A
         d1MbnRBkF7MYSeOCu/3hLE1hx2rZJ/NpuG6qJ8ZsRGybXbi4L3CkC+WsQyEBNehl5plo
         yCU4FtVU0wr3fSWjHVX3g0rhdPVeDXMdPgVjGIr/dpSkqPo39PAxqY9QD1FXPaSRs9ZH
         4mxZHWPphJ2vDjUcXPVllnA3RSPhNbRwkl0sI4OZ2LVnbTOhqk1+NvdT9bPGphDYXUzb
         Gj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gj0mikrLZmWTiWANlej8ah5+G+uOw7wqH4StZRro6uM=;
        b=WxErs9ofSJGyTNHRZ2wi+IaMPq5sOeM90tsefv0NHpP8Saj/kDxGDMPHgt+tpVzs0h
         RaIVvL6+epmH9SDvNzZsKRHxxq8zrZfEd1yoZQO3+1STlUgvMdsS26MOW5vzkbFPUpxP
         vDluhUspdhB59y7+w5i8Qxfl8YXKGrgnp0cIPlvTH27vojaKi1vciCK7Qi1uBYnD39n/
         RbuXEltDJDqW8yeKp/HQO3xKs4/rGxKqyTi3J/wKuVLkEpxXb+gsuIYIwJMsJYw8KQlQ
         zzjvPHbiBuFjQ0VxIT5935NX9JZyzcuX3WrAIsBHTP+vXiDm5M2sf7J5gLixS+ldtPpZ
         HHjQ==
X-Gm-Message-State: AOAM530muYGZgDhmREwGxC0chcgjLxg+PfRYW2bf4YfWTHdnZ8RjZbL+
        /06e7lJTDiWxPbLDDsSE0mIN3ory58G9nUZ79jY=
X-Google-Smtp-Source: ABdhPJyhDSvvhWGBvqyaYl9vR9nKh/92wVzyMLuqOOqYHEgI6MvjBAz8Ik0zwx4gkvN36heRJFT3ixNSqt7kDBxcd30=
X-Received: by 2002:a25:6c85:: with SMTP id h127mr7359838ybc.341.1615910205513;
 Tue, 16 Mar 2021 08:56:45 -0700 (PDT)
MIME-Version: 1.0
From:   Anish Udupa <udupa.anish@gmail.com>
Date:   Tue, 16 Mar 2021 21:26:34 +0530
Message-ID: <CAPDGunMo-ORwDme4ckui5kxxW6-Ho1J_MjcTkxdDdKLMDrCFdg@mail.gmail.com>
Subject: [PATCH] drivers: staging: qlge: Fixed an alignment issue.
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The * of the comment was not aligned properly. Ran checkpatch and
found the warning. Resolved it in this patch.

Signed-off-by: Anish Udupa <udupa.anish@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5516be3af898..bfd7217f3953 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3816,7 +3816,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
  qlge_tx_ring_clean(qdev);

  /* Call netif_napi_del() from common point.
- */
+ */
  for (i = 0; i < qdev->rss_ring_count; i++)
  netif_napi_del(&qdev->rx_ring[i].napi);

-- 
2.17.1
