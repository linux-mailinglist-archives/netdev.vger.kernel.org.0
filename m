Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4A634397D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 07:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhCVGbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 02:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhCVGbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 02:31:36 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03CFC061574;
        Sun, 21 Mar 2021 23:31:35 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id q26so4267398qkm.6;
        Sun, 21 Mar 2021 23:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/z2NAxlUnKAZ7dF5uRiLEmrIPyqEl9pEWp4DF0Cn6M=;
        b=L6cnt8NLNH+DvzdzU4i7GWj8AOekPc2cSQooPpUTjvbaCktPfJQgiFSUHjx8aZ0x4i
         91CwBYb/NkA+c4Jl7ov3GexpUtwnqKkuTA/l+TSzJKe8o50/XCULbBpxuZV2sL2Ho9aV
         H2S0/nB+KkO6DVSvb5HyyOJnc9DQ4gx4UI2fIsTk18AexelPCjfM4rHNZRMoIvgsUmdr
         SRx3jKKwEewppdM3XCvq5c0orLksqEdAr7Wod3E7A3OYPIgC6aPRuPmjQYH8rQkPaA0O
         tJAwzrCq2cCJEvmflYtkNyHydaXafRClsi/e2Sax/ifHDvUH+6/TAow5UOWS2KbxXBWH
         pj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/z2NAxlUnKAZ7dF5uRiLEmrIPyqEl9pEWp4DF0Cn6M=;
        b=hW3ydjIgwXB8Q/tN08ZcSk6g89oMpQdRDkM/YHAqSgBoikk4lp/MiQmwFRCTY3J5Qf
         BmDz43LY6gwLgT/niypSnFrTqJYuzYho8xA+LWHlebYhj5xQ00Lk0c5cNcuiApiOalvE
         hO4Jb/2DhevoYcPQ6qviIhhHr8+rP4ATbL4XVY2Y8So6/xrzI0ZNqWxWDJf8tfHLkN3y
         gF+ZdBg2KsQmRHT7tohMY5VuocfyPI3w4DFqy3N41E/lrDXVZ8coqHEW1RAtt9CfGP4K
         6lLj6aWHWuFBTiqW29Y82N0mNbxHauR8kLD0MPbEINlcO8ms9Lvsm2mpCRNYzq07FL1T
         6tHw==
X-Gm-Message-State: AOAM531STpcacpBfeUgQ9RB48HzzeTBqTIL49OWEPBdF2D/zgPixy6kQ
        M+jMD34RXjC5Z+iIsqWCrsI=
X-Google-Smtp-Source: ABdhPJwnJHO28Tn3reXBs6PKF+0UhIHlWaSME1sgJ/g8FWRjm/BR79nWogek5WzdXLATsdLp8ebo7Q==
X-Received: by 2002:a37:b07:: with SMTP id 7mr9193155qkl.437.1616394695283;
        Sun, 21 Mar 2021 23:31:35 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.40])
        by smtp.gmail.com with ESMTPSA id q65sm10153239qkb.51.2021.03.21.23.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 23:31:34 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] liquidio: Fix a typo
Date:   Mon, 22 Mar 2021 12:01:22 +0530
Message-Id: <20210322063122.3397260-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/struture/structure/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/cavium/liquidio/octeon_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.h b/drivers/net/ethernet/cavium/liquidio/octeon_device.h
index fb380b4f3e02..b402facfdc04 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.h
@@ -880,7 +880,7 @@ void octeon_set_droq_pkt_op(struct octeon_device *oct, u32 q_no, u32 enable);
 void *oct_get_config_info(struct octeon_device *oct, u16 card_type);

 /** Gets the octeon device configuration
- *  @return - pointer to the octeon configuration struture
+ *  @return - pointer to the octeon configuration structure
  */
 struct octeon_config *octeon_get_conf(struct octeon_device *oct);

--
2.31.0

