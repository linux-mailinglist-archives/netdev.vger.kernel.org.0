Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805B861119B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJ1Mg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiJ1Mg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:36:28 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0C61BC17D;
        Fri, 28 Oct 2022 05:36:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v1so6410183wrt.11;
        Fri, 28 Oct 2022 05:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wycqnBb9yJKDEW3bJJPSC5fzrru3Jf1qAMB2d8ApDxo=;
        b=gzkjkw5P/S/NQ5bDEx5+kVzA2gyLzAYxK4tR2JIj6cXczSIqSaEzzQU037hVBIL16a
         PusCBQhOM0J7teGkkkVh3OfznGGF9Q6L5mfyCBXOOH+0GMS3yO0YpeNesuNqCLIYBHdg
         yea77P70ifuxmvgbVk0Mt6cTVrI6GCNzmDZEva7+vd6a4FzbymsXcWQ2DYwziUvdMZJB
         i26mvrLzTimZ4TtA6FRC2Y5o3VJPdzlpFfNAIYWW8AevfLJjbQzO1qQtPfKNZiV2ADCZ
         h75K5qE2lqhTM3RfjQiGMZxhJ0fyavFWeB+cHWGKCemZxtMhbJrdIAcMcSr3p9V9pA+0
         Xvzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wycqnBb9yJKDEW3bJJPSC5fzrru3Jf1qAMB2d8ApDxo=;
        b=0J8Ip/y3TBNSRSCuaAgPz/vR+OE441uJNWkr9KLQHn9ZHOCnAn4aJ9WxYtcjAzDB2W
         UU+A/J+Mva75wFoXJvt1Lo1Lsa4R7sXw+VOHe9Vm1Yhm+XDqAxetbIS1SZooNErWzSR4
         Qp6I6JPeB43YEa09Nnd0Enoagnk1K+O6Q06FonaIM1aby/S0LYbcqZw3JdkA8He9Dg1V
         UPx67Zbq/+PrdqsiUGE10tLlpRo+q4SGcQfWg6x8Ns1s6zDInnuz2WwrsMeHZwiEor6X
         2UAQzNWaZDyIw18mGVEn6wH+qzo1tyj4oPEPgQKEYFft33kQg2andtAsNK3acobGtZjS
         s/Kw==
X-Gm-Message-State: ACrzQf0DATWXs7pTp9S4dJum3TNXM1BX4FrbV9224TIOICwHxEK8aJjd
        inm+yhUfb3fm00fw6JZBYmc=
X-Google-Smtp-Source: AMsMyM6EAHFcT3yApGhskQ5vTnRyjDcjeNd3iqGjuID+2QCUVl97vKfRdRAgqE//BMZUHK7ccuYQlQ==
X-Received: by 2002:a5d:584d:0:b0:230:c250:603e with SMTP id i13-20020a5d584d000000b00230c250603emr34325437wrf.143.1666960585600;
        Fri, 28 Oct 2022 05:36:25 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id 6-20020a05600c230600b003cf37c5ddc0sm4029403wmo.22.2022.10.28.05.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 05:36:25 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: mvneta: Remove unused variable i
Date:   Fri, 28 Oct 2022 13:36:24 +0100
Message-Id: <20221028123624.529483-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable i is just being incremented and it's never used anywhere else. The
variable and the increment are redundant so remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index ff3e361e06e7..1822796f8498 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4266,7 +4266,7 @@ static void mvneta_mdio_remove(struct mvneta_port *pp)
  */
 static void mvneta_percpu_elect(struct mvneta_port *pp)
 {
-	int elected_cpu = 0, max_cpu, cpu, i = 0;
+	int elected_cpu = 0, max_cpu, cpu;
 
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
@@ -4306,8 +4306,6 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 		 */
 		smp_call_function_single(cpu, mvneta_percpu_unmask_interrupt,
 					 pp, true);
-		i++;
-
 	}
 };
 
-- 
2.37.3

