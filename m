Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109596AAC27
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 20:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjCDTon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 14:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDTom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 14:44:42 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6BFC67B
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 11:44:40 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id j11so3744900edq.4
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 11:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677959079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XkNgHwe2JijD4m5UMvLOyFgQTgbLZZm1JwGqDIGqcMM=;
        b=UjscDOZ1LLbZ3zTo9Id9eM8KhXOGL5TJ+tIz09KWQo/vybmjP7YZ2CM+IvQsyh9rFJ
         z4JScTXnSeHs70JNZcp4cY09QGF4+NXmHsnV5NcuwITbTU4Ssxkb/ZWux7mYamqXVPUk
         3sMZXNynvkEftbEJ+xILjdHD3p99VQdw7gKYJKYlf3rTcwyrrtSLlyFliZ5JTq9IDEsv
         OT099U6RHbrNKBNzgG90in+aPcEY9RhS0n0n1Q58WUa7I5PY5GuqZ4VRNtV3ukqFKWD4
         czFR2oefGCkmRySF3V25jRoalPYibdkVffmNSabhFsz4YAW70K+xmtVNP3t7srcftgJJ
         tTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677959079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XkNgHwe2JijD4m5UMvLOyFgQTgbLZZm1JwGqDIGqcMM=;
        b=Vcfhme7t4JO6YCiSKm3Kjf1FXpU6nNc2KnIq5HndOQ+szfHKs4fISDvrPkxjtcCKwY
         2Aaw9X04eJAA6Azf/xWsu5y/OaO1KCAiopn8Tt8d/X/+plgmhaX7HgPPMITYTBTNltTQ
         Mzj4y3gxPA+9ms0lJiCD2Q3oA9mS2TfRL81fET8Q8QmrwmHWslsUyjPRYbSIjo3kJkyc
         5RWrtA5omduDYUdm9LkqQui6uGBrm3Qy/obTfv/bibGaQtd5j9vsFP7g7rTs9N+GTleC
         MQQPnyIgLTP0J0G12C/rriv4RMW4vkIqcq0absGCHTdyPNH0g1/BEe79wV3sd2HoVVF4
         vJag==
X-Gm-Message-State: AO0yUKUnIZuOIcPEdRgKY/SYmqQYCxtzuggUtWBFgJjRYoKjotgjWP4Q
        GJKkfAmGjH5YWuU5PRBGTGDwZRbMP7I+qn/I
X-Google-Smtp-Source: AK7set/pLuLjy9s5qAhENsTJ1KCWoUX2ZkQFBkRLEZyhSPSIzFIiw1uqYoA61sP3cuVAZ49wtxdRqg==
X-Received: by 2002:a17:907:6d08:b0:887:dea8:b029 with SMTP id sa8-20020a1709076d0800b00887dea8b029mr6902854ejc.1.1677959079133;
        Sat, 04 Mar 2023 11:44:39 -0800 (PST)
Received: from localhost.localdomain ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id kt21-20020a170906aad500b008d398a4e687sm2344775ejb.158.2023.03.04.11.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 11:44:38 -0800 (PST)
From:   Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH v1] netdevice: clean old FIXME that it is not worthed
Date:   Sat,  4 Mar 2023 20:44:33 +0100
Message-Id: <20230304194433.560378-1-vincenzopalazzodev@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
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

Alternative patch that removes an old FIXME because it currently
the change is worthed as some comments in the patch point out
(https://lore.kernel.org/all/20230304080650.74e8d396@hermes.local/#t)

Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
---
 include/linux/netdevice.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6a14b7b11766..82af7eb62075 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2033,7 +2033,6 @@ struct net_device {
 	struct dev_ifalias	__rcu *ifalias;
 	/*
 	 *	I/O specific fields
-	 *	FIXME: Merge these and struct ifmap into one
 	 */
 	unsigned long		mem_end;
 	unsigned long		mem_start;
-- 
2.39.2

