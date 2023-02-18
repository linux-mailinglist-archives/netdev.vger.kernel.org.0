Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D09569BAA8
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 16:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjBRPaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 10:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBRPaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 10:30:20 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D80166F7;
        Sat, 18 Feb 2023 07:30:19 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id ek11so3751995edb.9;
        Sat, 18 Feb 2023 07:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAX2N6AbPGFaXeQ/ovhQE8jiqNbqXdojdWHTF/rY/eM=;
        b=PtzeIhjC1ZIl+el5rAE5SO9jgu6i5CMiyrTNKiC11SATiM2IaeoZoH10VTqM0Pd87R
         NjGNzwojd7oDMC0PDoHxn4P/D5tDcw0tSGTFeFySvQKFAlArwStUL0tj5UwwpzYjNQJJ
         jyZsHidTIs41U8DzcFbZZQa3pMnyvmscU6civdekkIWg7b6zRpB0QB1MSm1zn1dezCRp
         NkaOgwajaxVt5mSTFzS3ahNVPRFFiOk4IvaXb3BjnSkYxyym4ohPYTWBopDSOSnmXsTu
         NUGqT6WY5n41S5xB1ijS/14uES5mkcrY7x+Bo76FZqyF0uEhwSw4zE1sIoh6vtUpi+Rl
         K0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lAX2N6AbPGFaXeQ/ovhQE8jiqNbqXdojdWHTF/rY/eM=;
        b=3lzRBzvL/mEDDakSgoPxE8AHfz8GpLWGhgFZ9d6tiWsYAxVMQUgOWzCBMLzHqamplb
         arM8vZs6c9v3eGIHp4VG6ZvyYSfEdiw9ZxggpPmlGU8PnmMYOxEleatXvvAk33DQML76
         rDE3W624oVmRWC3zbJIcO1JtKmyoQrylQwD2UmlAxX/ghNWbMZME6rOgrltai0B8NALt
         HIOIbbDej60+gaXvhJgjDUDHDI/iMIq1GYsFEACUAospmw2oBkQG8MsvgiEEYl/wbMSz
         X5n8tmf3nqiIgf+bnGSRnrynmSZfChwqPrES7CS4ivy0I9VgCe2NLtWI99H4jtA0FTei
         HxIQ==
X-Gm-Message-State: AO0yUKWVvpnkHv5pJgMYtrJJwmp8iptsLkcks7P4PBcASjVD3YKMC6Ru
        JlQdkVAkxIL3nSMJDLodQ7NIptK94as=
X-Google-Smtp-Source: AK7set+NuC0A8Oew/bYh6372+JpMtkhPa/2UXxN52lGuNh1/+Z5IFABcd++LRmXiifx1YGSBHQlDEA==
X-Received: by 2002:a05:6402:d2:b0:4ab:4ad1:a37e with SMTP id i18-20020a05640200d200b004ab4ad1a37emr817334edu.16.1676734217077;
        Sat, 18 Feb 2023 07:30:17 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b8cf-1500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:b8cf:1500::e63])
        by smtp.googlemail.com with ESMTPSA id a65-20020a509ec7000000b004acc5077026sm3742554edf.79.2023.02.18.07.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 07:30:16 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 2/5] wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
Date:   Sat, 18 Feb 2023 16:29:41 +0100
Message-Id: <20230218152944.48842-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
References: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
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

txdma_queue_mapping() and priority_queue_cfg() can use the first entry
of each chip's rqpn_table and page_table. Add this mapping so data
transmission is possible on SDIO based chipsets.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 3ed88d38f1b4..6a234eec09ff 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -1033,6 +1033,9 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
 		else
 			return -EINVAL;
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rqpn = &chip->rqpn_table[0];
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1195,6 +1198,9 @@ static int priority_queue_cfg(struct rtw_dev *rtwdev)
 		else
 			return -EINVAL;
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		pg_tbl = &chip->page_table[0];
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.39.2

