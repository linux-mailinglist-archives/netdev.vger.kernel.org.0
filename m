Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CCD4D3A3C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbiCITZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiCITY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:24:58 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F844D244
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:23:38 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id bn33so4656075ljb.6
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ZqShpqFAcUbpT75QG5gyMmysdEWZbn6yRP47b19+9+k=;
        b=FChGwr9Gj+9l1unS77JQ5t0uP/XuMX1RFqUOQKc/u50L03aQxqPOujhDnHqBlQht5E
         b2V1KMY4F6f+i0mQ8PqEXcShL5CzSYAl3IMvzJ46elDCtVw6OcTBORKe1E/pnKndJDxG
         TLdJUVq3WWEIns18aUAe8N7ExxbKoUz0ExdcK2JE3XiblfstxJ6uDdp5896WQ8wqXFyS
         ZLOK28/mMSF4GmFnv7xCJM1NAFSuLszMH3ZEtdU6WMdeYtI0sgq8V7Y6e5YGHoS7I/BF
         D5kapWfrZtXMc2T6QBMp29DReFv4J4zQIYQQ0a+7w6fgHO4USRIJJJN9nqGVM3kkWINy
         BqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ZqShpqFAcUbpT75QG5gyMmysdEWZbn6yRP47b19+9+k=;
        b=XD8OaaXfd6fsW2e/dB5NnYZC+5DeBDO4qJpqc3TjAyawSvtwiv7hLoYrpiHf2Dk0DV
         4MO/wg3hAOifWJzyUQBRAS9DJW2iNeDa7Uu5MfQ65910pdB9W8Gi/XV+8mLcjfxJ0WeA
         CbPKlDOKx8fMeIITED5yRgnu9OZDFLk2kOw2tN3ALb6zPCXsx8obFMQ0ZhIfXSyPAotk
         Se6RYli3i69VB96CUFvX3BZ2S2Qvw6406weKk2ngHWKAff3ooSQRlwgIJQNAfXZqCtUA
         6v5Gl7JuP+ADHzksiiGYxd+gMBUsepNkFbIyHfbiQYLzlhn2KK+41QSjJ8u7dtQwUvIp
         GY1w==
X-Gm-Message-State: AOAM5325E4p4d6FG3nBfecAyEMVKvA9i88G0t3cqooE3Mzur5iW3e9RS
        YE8JV+QU7CzoFVU0NnVDj4pgDsaFrHCdlA==
X-Google-Smtp-Source: ABdhPJyJAhJ2k7yAeSbJMiHrvTsxJOGE1PgS3ehi7bp06RY21/kEwRvijv2LHBPTXrXVrAyybMf8Gg==
X-Received: by 2002:a2e:b5b0:0:b0:248:47d:6abe with SMTP id f16-20020a2eb5b0000000b00248047d6abemr638162ljn.75.1646853815735;
        Wed, 09 Mar 2022 11:23:35 -0800 (PST)
Received: from wbg.labs.westermo.se (h-98-128-229-222.NA.cust.bahnhof.se. [98.128.229.222])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm540691lfj.164.2022.03.09.11.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:23:35 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v3 3/7] man: bridge: add missing closing " in bridge show mdb
Date:   Wed,  9 Mar 2022 20:23:12 +0100
Message-Id: <20220309192316.2918792-4-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309192316.2918792-1-troglobit@gmail.com>
References: <20220309192316.2918792-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 man/man8/bridge.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index a5ac3ee2..88f461aa 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -124,7 +124,7 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VID " ] "
 
 .ti -8
-.BR "bridge mdb show " [ "
+.BR "bridge mdb show" " [ "
 .B dev
 .IR DEV " ]"
 
-- 
2.25.1

