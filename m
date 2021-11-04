Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8051444EC4
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhKDGY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhKDGYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:24:25 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CA6C061714;
        Wed,  3 Nov 2021 23:21:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id n23so4553492pgh.8;
        Wed, 03 Nov 2021 23:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BU1vTOLCxtgz/R6wOs3WVjyoqwIRBdNGoJVHRdiND2w=;
        b=QL5lW4MUReHLzSIJL/ZYcrYICgVbghlJ4VFBqkUkaO9NocZA5kO27dJ1eKgrRBVmFv
         0eL083EWkk126pO8iXtLGvmxxKrUcz4Nwex1SU3XPT0PISiMskWdfVXQ/RfotT9NmsTu
         hVMP/WRG6kk5pEYanK/9cpL8HtY1GM8JVC4iT1jFNZErMQa80IVXXpq7hU+CvG2GDor3
         9gv3VP0kh7eDxduG88S/N2lvYtfmXG+rfeC1nG/Gworu9cTZaZQqsnknjPF1tm2W9y7s
         OH8SBsCTepaGEFBryoIkqUOFJXUUDGQfYrw8+piNaJE8nsJ7WkYmbAm/zOgpRTNjx/yE
         6akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BU1vTOLCxtgz/R6wOs3WVjyoqwIRBdNGoJVHRdiND2w=;
        b=ykearN7nROJvf29CfZ7qJ6xFK+NuwtPveiokzFoeth6BZfpgTnFor7HdbINUCmJZ87
         Z2WmaB93e7c8THYYinYeTdlNDvXG1U/UO4aEzu82+m0FauNKvOCFoCKCCRyC60SKV3FB
         73RbJcmRj1nXqAhskufkoMWJkDGZ/5jF1Xeax1B3NUAp0Cdv8JTpuwfavNgIv0mjjTHS
         SWLzC5LUWDhBMUCbjjzTZW5EbL5w+Y0WIDyfDtRNtfOEXG5L+Nv2Bii6LzNFYwUTMdQ7
         LgqQ7Hn3mTdTE9mn8YRmu6UNgihNrrmekWKtGtzPwnq7NuQOE1ReKW8GPcPs2+3vNH0s
         KGKw==
X-Gm-Message-State: AOAM5308Rw9Yi+jBYE7DOucm4kPGNfOlDhefw9ky3zisaaWGDKu5IBYk
        sWA0Qkm25HBBAH2ERHQ2LBk=
X-Google-Smtp-Source: ABdhPJx3RnvYexqW6YTa8PjOPjho7WENcTm5Dg9Jmr6FpZThwO+ChHZmiDNWzDJoI55KgEHgoCLK0A==
X-Received: by 2002:a63:6945:: with SMTP id e66mr6443454pgc.9.1636006907789;
        Wed, 03 Nov 2021 23:21:47 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id z22sm4014737pfa.214.2021.11.03.23.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:21:47 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc:     Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] tg3: Remove redundant assignments
Date:   Thu,  4 Nov 2021 06:21:38 +0000
Message-Id: <20211104062138.2386-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The assignment of err will be overwritten next, so this statement
should be deleted.

The clang_analyzer complains as follows:

drivers/net/ethernet/broadcom/tg3.c:5506:2: warning:

Value stored to 'expected_sg_dig_ctrl' is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/broadcom/tg3.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index b0e4964..c5a5a6a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -5502,7 +5502,6 @@ static bool tg3_setup_fiber_hw_autoneg(struct tg3 *tp, u32 mac_status)
 	int workaround, port_a;
 
 	serdes_cfg = 0;
-	expected_sg_dig_ctrl = 0;
 	workaround = 0;
 	port_a = 1;
 	current_link_up = false;
-- 
2.15.2


