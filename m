Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F394D04F6
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbiCGRKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbiCGRKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:10:35 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F99583021
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 09:09:41 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id o64so2421468oib.7
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 09:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W97laJc3T/JFTb+ne7pXDkM94WxViNvfMH0iZcHk6yY=;
        b=ZBV/wXwumpBs1REjky+aXBh9lQrgBBPmYfM3a13zXU4n/x69GQYJQRU3H0Mu0Hsx6k
         /bPwbXDv+6kDjmGo1rkQyo4TnZW7+agd2WJsXZWyLlFVAcO3qEC2k5qx77OxX4E4Pj8u
         fay8UVFCRCnlNQsP4af5h9LHKcjknouExttdP1sVeFBNrDwuZuR6ng1Mg1G2fYz9Ns5B
         b8kL3+YqxUv95j2+AB5tHtP21RiBBBzZgAzE4+2Mrj7ycFjHPlDJ7zyyfoWo4Hkapn4e
         d4dixHo5rdlF4RwSGbtqWdqQJLuknO6fEEUaTB0+d5JlLi0qDIp+XLNArHuRLIZPX5ne
         zxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W97laJc3T/JFTb+ne7pXDkM94WxViNvfMH0iZcHk6yY=;
        b=ceZDWKXls2bUZptHI8O9Ajt2dNnBpEGM0sPJvZmjH5WbC0nj20J8I/fCC7b7hPa8Al
         26+flThimRx13OVvLaz58oyFi0ENPfOC0kj8eOkoVtI5jHJ/flgXqA89TeI60l5sMJKZ
         H9mn9ceEVD+8fUUalxKr2EuzQVHFdLHPXR2r6S0EaP84T12YTjeSMc5SwbcO74rQ1wgQ
         ZcmY8RlRA+htsA+6BfusBkFgKTsFNNwBZO0PVT0WcRZfes1AkK7KboG70gD9hGEgGgxQ
         JY7x8ye6I8xAhbcYnlbwrL7VvVdfLmndGpOQc3X0+q5sXb/1BQdzK/GlVZOaZa8vOwcm
         /Idg==
X-Gm-Message-State: AOAM531PDi/K+xgskLlwO/ORCJPvU2Wg46Io8ow6/pxZQrxA7/G3rP1d
        hhNBCQ+Jt9MQ+bF0AJw9nkCaqOJRXjukyg==
X-Google-Smtp-Source: ABdhPJzu52o/Y2WsqcEByM8N2y6ZVO7A6FUjJtZ5DWbLjlXy7b/x/Mkv325UlOvCZIN6ttBqk+I7ug==
X-Received: by 2002:a05:6808:3008:b0:2d9:a0c7:dd3c with SMTP id ay8-20020a056808300800b002d9a0c7dd3cmr7903645oib.181.1646672980188;
        Mon, 07 Mar 2022 09:09:40 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id l15-20020a4ab0cf000000b0031c0494981csm5894296oon.9.2022.03.07.09.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 09:09:39 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next] net: dsa: tag_rtl8_4: typo in modalias name
Date:   Mon,  7 Mar 2022 14:09:27 -0300
Message-Id: <20220307170927.25572-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

DSA_TAG_PROTO_RTL8_4L is not defined. It should be
DSA_TAG_PROTO_RTL8_4T.

Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 net/dsa/tag_rtl8_4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
index 71fec45fd0ea..a593ead7ff26 100644
--- a/net/dsa/tag_rtl8_4.c
+++ b/net/dsa/tag_rtl8_4.c
@@ -247,7 +247,7 @@ static const struct dsa_device_ops rtl8_4t_netdev_ops = {
 
 DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
 
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4L);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4T);
 
 static struct dsa_tag_driver *dsa_tag_drivers[] = {
 	&DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),
-- 
2.35.1

