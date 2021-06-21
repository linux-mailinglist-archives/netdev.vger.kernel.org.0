Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255CE3AEA7E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFUNyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhFUNyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:54:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5432C061574;
        Mon, 21 Jun 2021 06:52:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g24so10006664pji.4;
        Mon, 21 Jun 2021 06:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cS/F8T1IFYAn7INxjRc02bXMnhEJgrDiWz1RpqB30qg=;
        b=SJCGESTjQtyYduI8KWTbHwthcEwAcmaxdU6hvYYWVh+GfYWmxJjiB0YEJw5i7+Hs+/
         7UNlbQQnS3Ixf218WX02g797CCw5A7nupA3Eh3COwpxuMd8H5rWsQhO+4S2EnVd6XjA2
         VIhOYoO/1rreePN2r3ARbaic4QcE20/gufqYpvJ28Xg+MmCAnxBMlHAky0lJM9vFlQP4
         IHAhRyMc8yPXLJjafnW7UXiGp9wAhBC0pDrE47/KRhyCnBN5emslw6hfGeuyF+DCYdc0
         t371rI7FASZx/JgDK2IJSW4oms1cjy6eUsX8kiH/9pBVU7QY0ORfMiGgW1O9BkcaY5Ej
         MtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cS/F8T1IFYAn7INxjRc02bXMnhEJgrDiWz1RpqB30qg=;
        b=mXsuHYcREAfuATfmHHDivTsvGNHGSlXyQDVvFmnQvBxUHElaulOEpqi2jxb/QDVyHw
         f0xwzhk2DQfpxk/rcfIMMNcWABpUkVrJ9g4eOw0vgMSqoSs0JJxBf9/CYUH/P0Nt7qQ7
         HMrqUH8fFiVFK1cPc8EjXD6AR/4ji+B+1a9MfjcqxZuZV06P8vSBqE0HV3VYBwL4Osgb
         wG4ZH2QqoAH2OkQVBwz3CQ0RbdWvmEw3yGUBIoxh9HCHHeFfpWN/tjDqfwyFiezZAez1
         /u4cB+DPVIGdQjiw1GnjY5vR5aKCmxx/nTWBMh0qGobhT7LSvV6W7bQEOws2mnm0ku2G
         NGxA==
X-Gm-Message-State: AOAM5302Bv5hEGGwCipoOAz/8AoNihzXkBWeG+mMUBCCZxEiRk/mmiya
        pmODv8poNxNVp1X35o0zhLk=
X-Google-Smtp-Source: ABdhPJxT9DTOz8C0+5X6I7CDf35WX5i4rQLGUTavO5WmXFb6c5vVq6gzP11MULWNG5JNW0L/EF4OHw==
X-Received: by 2002:a17:902:9f83:b029:f6:5c3c:db03 with SMTP id g3-20020a1709029f83b02900f65c3cdb03mr18185118plq.2.1624283537354;
        Mon, 21 Jun 2021 06:52:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h21sm14832500pfv.190.2021.06.21.06.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:52:16 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 19/19] staging: qlge: remove TODO item of unnecessary runtime checks
Date:   Mon, 21 Jun 2021 21:49:02 +0800
Message-Id: <20210621134902.83587-20-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commits [1],

- e4c911a73c89 ("staging: qlge: Remove rx_ring.type")
- a68a5b2fd3a2 ("staging: qlge: Remove bq_desc.maplen")
- 16714d98bf63 ("staging: qlge: Remove rx_ring.sbq_buf_size")
- ec705b983b46 ("staging: qlge: Remove qlge_bq.len & size")

and recent "commit a0e57b58d35d3d6808187bb10ee9e5030ff87618
("staging: qlge: the number of pages to contain a buffer queue is
 constant") has fixed issue. Thus remove the TODO item.

[1] https://lore.kernel.org/netdev/YJeUZo+zoNZmFuKs@f3/

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 7e466a0f7771..0e349ffc630e 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -1,4 +1,2 @@
-* the driver has a habit of using runtime checks where compile time checks are
-  possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
 * remove duplicate and useless comments
 * fix checkpatch issues
-- 
2.32.0

