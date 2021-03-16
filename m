Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E5A33D76F
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbhCPPaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236777AbhCPP3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:29:46 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCF5C061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:29:46 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id p186so37277068ybg.2
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gj0mikrLZmWTiWANlej8ah5+G+uOw7wqH4StZRro6uM=;
        b=Lx/b5Cw+yhYZbdhLyuR2eLcbLQ3kZds6fnU8INFsRC9HVKuIkCEfqvGrrIaxzB2h/a
         ydE09NPvIeuGTkz9Ke45M76XVgSBSSDXelFGTsouDKQB5EjsQEOAlkW6ypmQTLxl4eSw
         tV67lf8c7CWJZXCz4Ip7g+prlw8SVBAWcsHSiaju+DVmgU7Rcx1g559dvCSic4HgNnzv
         5hUkxnegDflgSSBzy2AH63LdlfX0Iic+yY7jFUpTB8aYcR4twe33JcHbreiR6Y5EVwE4
         kCrUwNEE/e2C9jV3UNfzO5MXpypzR+tqM5EIxB7R0ICnT02yystsXuEvHexlZ+5yFtGd
         VB8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gj0mikrLZmWTiWANlej8ah5+G+uOw7wqH4StZRro6uM=;
        b=r6sPAIzJZCHPsvZFRvtJj0LYl9LfarHq/ZKreGHshYxA8U37wR4/BGd2cqlfXQ/qJ2
         /XMJWFRvmM6Bh+UESznSfsdnZYCd+dBbdecYDA9NiGgiAwV4nMgxr39c5P7TGK9Cw9m5
         vCgTwHLvjJzPLni6Kwlzd/Rky2XI8dVXXkrgCa2og8JHPO371loHv4cqBq8a+7Pbq+RG
         8x5egFnPBOX/nbp0pi3faYrUinS+NViTyJKDgAhT+LkI2KxLMaJqtapzgJUNvMfZfnTh
         04ND2KzAuwEuhzJf8cy1k3s3bksWJlnRwKvr4l7XJi2XpXWVgQDfxeWrdNAcYKUKIl7x
         yEbw==
X-Gm-Message-State: AOAM531aBSzaDT7cs3xe8w4HD4W+4X/yym3gaZYohjeI75tN7Ol54K+o
        1SPneLd7UtwL8yEaDg8QqyFoxkoPY8auGkpYivHD21yTgrc=
X-Google-Smtp-Source: ABdhPJweQgVcvL0nm4o77+qEY9tEiaUQZlzf97MY0tekfdQFGWCmVk3YCI2G8IGxAaH8mxceaKtKlWX6jd8ry2ArvOs=
X-Received: by 2002:a25:cdc9:: with SMTP id d192mr7418377ybf.290.1615908585614;
 Tue, 16 Mar 2021 08:29:45 -0700 (PDT)
MIME-Version: 1.0
From:   Anish Udupa <udupa.anish@gmail.com>
Date:   Tue, 16 Mar 2021 20:59:34 +0530
Message-ID: <CAPDGunN0v78BhJGVy-wZtBPTP047xGTefWWuV-ksg8_X7ibgUA@mail.gmail.com>
Subject: [PATCH] drivers: qlge: Fixed an alignment issue.
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
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
