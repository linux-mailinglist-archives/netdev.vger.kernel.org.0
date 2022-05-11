Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201135230E8
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiEKKoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiEKKow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:44:52 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BBD25A;
        Wed, 11 May 2022 03:44:51 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso2969720wma.0;
        Wed, 11 May 2022 03:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sSANPAJEcLApaNo9JQsHkO1TMkxVWZ0hRpqjKUJDwiU=;
        b=J2uIr9J3ZBKzU2GQGiMLPp17ZHBWsGTy+hlqS06Gg7ufytIF+2hD7+NsdirvYjvOxU
         t7opLzS6zOcLDtSO0u/Qr3ofmCuRQLpi3rrCxb3DhM5qi2TluLdd+eyX74OxNixQpKTB
         p+wtVCxAyqwnAUwekAMWmB1cQ6hXTye8GQ7V/jBZhSUImnAilcZz32hBILwLz3FBqrbR
         ZMYGSP/9RvZGNtQ5NQ68NLywY9/KLpVvX6q82dMbcABgBmx3AbEai6CToVRXIy+PHSxK
         LS9E27lx/LC3mYIVvhWnri1Awg0zFlGM3fBpMJkZt0xjNLNfJaWIJiQsSvtRP4tmx2co
         WX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sSANPAJEcLApaNo9JQsHkO1TMkxVWZ0hRpqjKUJDwiU=;
        b=AcS5s7hJmZVMMd6z1WHfVZPWbmEzLT/7ThqExz7JuUjz132RLyaqz07cRhlR3Zhy9Y
         Yld4dsbnpv7Pkj0P3YFB8jWOupMDY6Z7Yv3fQwdN3pzBDmEWX6zAvVmiuS40ie2W5RX6
         77FlU4MblX6ug0gEK76I3McS9mqGnE0cNt2GW61OF+E/rIB7oBUpBDZ6BU2uoT9ddfbX
         Gjsi/wj1J60DMIw1jnfDvJoLKXGsawf9PqxPioXlOjUMst6wgFVttVKBDw8pSxWbQa+6
         dmHASmZR+O7hYeYyLeaPD8bFct7fHCmNoWkgbVpSyKOHqRadig8NKAsD5ofQbfUeZFQi
         DvfA==
X-Gm-Message-State: AOAM5331UgGvPhEYO5m1wkAbKxMZioMqvLu/O5vcUL6HM5zjwp4qi3/d
        mtHr9R1RHPr8zflNF7DMjnK9Zt377YHTUw==
X-Google-Smtp-Source: ABdhPJxJVetvp4dl7ChKMxe08Vd94vwV8ycZYPR3kb+dqAjW/maTyX0FPO1OtEUZvyP8RUhSnvY1dQ==
X-Received: by 2002:a7b:c0c3:0:b0:394:70a2:89d1 with SMTP id s3-20020a7bc0c3000000b0039470a289d1mr4172421wmh.12.1652265889835;
        Wed, 11 May 2022 03:44:49 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id a22-20020a1cf016000000b003942a244f4esm4954134wmb.39.2022.05.11.03.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 03:44:49 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Wells Lu <wellslutw@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: ethernet: SP7021: Fix spelling mistake "Interrput" -> "Interrupt"
Date:   Wed, 11 May 2022 11:44:48 +0100
Message-Id: <20220511104448.150800-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_dbg message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/sunplus/spl2sw_int.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_int.c b/drivers/net/ethernet/sunplus/spl2sw_int.c
index 95ce096d1543..69b1e2e0271e 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_int.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_int.c
@@ -215,7 +215,7 @@ irqreturn_t spl2sw_ethernet_interrupt(int irq, void *dev_id)
 
 	status = readl(comm->l2sw_reg_base + L2SW_SW_INT_STATUS_0);
 	if (unlikely(!status)) {
-		dev_dbg(&comm->pdev->dev, "Interrput status is null!\n");
+		dev_dbg(&comm->pdev->dev, "Interrupt status is null!\n");
 		goto spl2sw_ethernet_int_out;
 	}
 	writel(status, comm->l2sw_reg_base + L2SW_SW_INT_STATUS_0);
-- 
2.35.1

