Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2933A7EB
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbhCNUTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNUTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:19:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E30C061574;
        Sun, 14 Mar 2021 13:19:12 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x21so3997428pfa.3;
        Sun, 14 Mar 2021 13:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xDPIkNauRjvdC4N9WRReIUk9uXVYcVmVjBK/Gai4y8U=;
        b=DHm9sU1QRgxWAijUn6rPrjrtt7PFkbnXyRpc5WktUB8YXiW4zEKozRxEQfB7HV6HjM
         oodOwTRVhn/MP4y/K/5lyzD6CIEMXFQeJVCZEePEhjz6GCDnYXddBANepgTR6FM4Izg4
         +6sFLZ5lxn43+Hry4rK22TX12BByyiQtPU1il+9iT7H3a5OMGff/xnVo/ButrAGss7F0
         E5q21POFuwOWJSRom0vG2+t7AIlxDBLvZTzucS9MZawM36ell1DNmPPQJAWv8AVmLADs
         VmT9yXgYsgOmJ5ePq6aOTEcTJ8z90/COkALiua1RwI0wdyFALUkJhgqDvMXv2vO1O0x4
         6Smg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xDPIkNauRjvdC4N9WRReIUk9uXVYcVmVjBK/Gai4y8U=;
        b=VNlPbWanh7g4Cg7okCDhSJgwXV807biu529UFCfPaY1eMH1Liuq/pB5S1S8uNn+zbh
         kXe5p3o3jMsTkFEchVpeeFh6QslHGwRD9yQ3g/XLlpN4UuRBO6VTdLWE1qrO1uUUgIO+
         27pN8YXjMjdosahXQ2z2DWSY68+PnJQuGKQDKKeTBKWAgay93CHt/lATbzjHj0KSr19X
         r7vjztTaFgu+R4TmbDBN85xP47me0FVOsm1PCddghjPbmNtssT/4I6OVzTMMZvVwaxNG
         6vxO9dGvVEA0irOnr/sUkS/GWeODScpE05Wed3j/mqPrwuLoQD+zPreAbq1QG0tsWZo+
         /j3w==
X-Gm-Message-State: AOAM533ff3Hj4E46VvYJQ2kSWxz/AezrECSJcxk/2WoU2keq/+CL6/AY
        Eh4pGi3gnzOopjpA2LUFctc=
X-Google-Smtp-Source: ABdhPJypDWoi9HLRVB0QeuY4pD3fH15hbb9WD9wACe2w7z7Bk4RdI+Fhrsvpuzfe8xS/pL+hrP2NVA==
X-Received: by 2002:aa7:9e43:0:b029:1f3:a2b3:d9fd with SMTP id z3-20020aa79e430000b02901f3a2b3d9fdmr7662884pfq.74.1615753151744;
        Sun, 14 Mar 2021 13:19:11 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:19:11 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] rsi: rsi_sdio: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:17 +0530
Message-Id: <20210314201818.27380-10-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_sdio.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: Cannot understand  * @section LICENSE
 on line 2 - I thought it was a doc line"

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_sdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 1c756263cf15..7c91b126b350 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -1,4 +1,4 @@
-/**
+/*
  * @section LICENSE
  * Copyright (c) 2014 Redpine Signals Inc.
  *
-- 
2.17.1

