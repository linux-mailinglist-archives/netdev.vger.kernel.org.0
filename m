Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7F14DBB6C
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 00:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353921AbiCPXyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 19:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353063AbiCPXyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 19:54:03 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDD71BE86;
        Wed, 16 Mar 2022 16:52:45 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id p9so5077016wra.12;
        Wed, 16 Mar 2022 16:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zKYyk16OQXNqPDT/mUJOjq8mRTj4QHt2PWKklBsV4+Q=;
        b=Joc8R2f8jiNuENQ5gKMjNwDJ8HBnaKtUrlFOMs6FJH2hLEgJoJTH5PdYKzLQ4ixZwg
         pl+ep7l24HdaEzUEECjQLOYm4R3vjAujf58FvVyX+Zjoh4fJSz4SWM2uhIBBxdfcGJKe
         3B3xwvwadt4nZuBdoes8qwlxD7ki9xxq8AgjhXuqL9ZELJ/CIqzusMhM3a9YBhHFyHjp
         15kkaUdDlZ2y6pvZx1l5gcffLhmDtdu0Ew8k1LYlFACCO+HnzeGClnuZIyuBIJaSAfH8
         dJ9BA6CAGWW73HshqTzP2lHfvowEjVFicCKmb2tj4qPufYv1GtIwJQSjNPggi0ptt4cY
         aDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zKYyk16OQXNqPDT/mUJOjq8mRTj4QHt2PWKklBsV4+Q=;
        b=RVvGM/7KIXkuRe8lP620eO9c1Cd9LAY81OcJSF7QdkpcJzHLTtvvG1qyORG+0BXB9F
         malEOKeJkHQ20fT+rYA3d4OeD7XSPU15C88Gbegspywb0MqTD3zSvKQhXv1H4QJDAgeE
         yzeRf2tkJo5XtL4kr/7UeuGJuICnk8fnz8QeAEUR526JXQ3tjZScGAQ0m8gxNefmc9fX
         5Dpph+Yl/HFkGBTrvH5CYUtq8p9n2O+Lus4HLVngJdQZeiLPMQdEhKSH0NmmqFagAULL
         7juhSZViF+Ssxk45O3VoBvGqr0GZpeyjLjT4JZH5wDkerAKwZ6HLdjTqJDuv7R+w+6/n
         eshg==
X-Gm-Message-State: AOAM531vueoO2WE01eJzADrMVt+AF2EuVyKTLuTSV0wct1KnyKhkeG9m
        ZvL5DLsajPYOOjcfipJTKRUiPcYjgfiGFw==
X-Google-Smtp-Source: ABdhPJzxOptlpMedYnGOKD3rYyxwTC4gVB9c93ji9zMQQ/lGZbyiKsAbJS9WDh4FE85/mw3hbDnThA==
X-Received: by 2002:a5d:6d81:0:b0:203:e187:1faa with SMTP id l1-20020a5d6d81000000b00203e1871faamr1773716wrs.381.1647474764098;
        Wed, 16 Mar 2022 16:52:44 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id f7-20020a0560001a8700b00203c23e55e0sm2832308wry.78.2022.03.16.16.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:52:43 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: Fix spelling mistake "upto" -> "up to"
Date:   Wed, 16 Mar 2022 23:52:42 +0000
Message-Id: <20220316235242.56375-1-colin.i.king@gmail.com>
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

There is a spelling mistake in a IWL_ERR error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index a2203f661321..ecbc5a3f3d18 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -898,7 +898,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				drv->fw.img[IWL_UCODE_WOWLAN].is_dual_cpus =
 					true;
 			} else if ((num_of_cpus > 2) || (num_of_cpus < 1)) {
-				IWL_ERR(drv, "Driver support upto 2 CPUs\n");
+				IWL_ERR(drv, "Driver support up to 2 CPUs\n");
 				return -EINVAL;
 			}
 			break;
-- 
2.35.1

