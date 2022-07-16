Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FA0577049
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 19:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiGPRBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 13:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiGPRBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 13:01:19 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96991F621
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 10:01:18 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r6so9989165edd.7
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 10:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o5SHoKOlnIy7h2f2yOMygK1Ar0sEJbou+Jr7kQWQWPk=;
        b=pcZqNzB7ZJ5tm4qEGbBxeyD5nosknoKSBJSrW3BjFwMUsUoJCIwBb48kpHkD0t9a7b
         fbwmnjsJ++wB1WpDVOjtacgwPae9ogUSWYITD6H6i08N6cJVT0JQbBMfb+LoYR0fU/fC
         t4/FM+SRVJrG+fw1u4wGKSYoxBVsADZYnzg9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o5SHoKOlnIy7h2f2yOMygK1Ar0sEJbou+Jr7kQWQWPk=;
        b=jfKtqYNN0Dd3BxFaBKcXXFxbODVXK803qokMETiUyHr9nRZy/ccTQldAX0/yPT5ADV
         ACySZY0UqLyU913DKpbO3PTH/gzDAWQCmao7iY+UktfIl1AWzp3V8ZWvzETad0zqH1rX
         +cyh3lvB8hXAzXJKiQTp4RwG5D2zHchETwCcwg1cQKzEz1PE6rvThsZFnPdL9RWfWvJt
         gdJx3n7knmSLddALx8z4HgxCUTcvVDTpDi7cNb+JDocFKSQkBIo83H1ip3gx/LXgBToe
         2Il5DtB479cvGiPbZfZ8WHyJ56wY3xWvim2su2/w61X86TSkf8dagyFYBRzTvPv5nqYl
         sBIQ==
X-Gm-Message-State: AJIora8b4/I5HSuSjcwA9FgR490BTO3A806eH9nTV+K2Ji/nDkhjFpuC
        RvBR3HYm6febKngkXbfSQYxaGw==
X-Google-Smtp-Source: AGRyM1sGWHM02srFYC9mHTuQJ/Y/gQ2JJJVPaV8AMXtdV9bGhz3PDauDqKpxN5d3cU0Gm+q+mbimfQ==
X-Received: by 2002:aa7:cac7:0:b0:43a:c5ba:24a6 with SMTP id l7-20020aa7cac7000000b0043ac5ba24a6mr26254692edt.84.1657990877524;
        Sat, 16 Jul 2022 10:01:17 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-182-13-224.pool80182.interbusiness.it. [80.182.13.224])
        by smtp.gmail.com with ESMTPSA id i22-20020aa7c716000000b0043a64eee322sm2953898edq.28.2022.07.16.10.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 10:01:17 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] can: c_can: remove wrong comment
Date:   Sat, 16 Jul 2022 19:01:12 +0200
Message-Id: <20220716170112.2020291-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment referred to a status (warning) other than the one that was
being managed (active error).

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

 drivers/net/can/c_can/c_can_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index a7362af0babb..ed4db4cf8716 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -952,7 +952,6 @@ static int c_can_handle_state_change(struct net_device *dev,
 
 	switch (error_type) {
 	case C_CAN_NO_ERROR:
-		/* error warning state */
 		cf->can_id |= CAN_ERR_CRTL;
 		cf->data[1] = CAN_ERR_CRTL_ACTIVE;
 		cf->data[6] = bec.txerr;
-- 
2.32.0

