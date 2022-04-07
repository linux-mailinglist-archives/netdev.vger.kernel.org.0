Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D544F7CC3
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiDGKac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244238AbiDGKaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:30:24 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1FD7562E;
        Thu,  7 Apr 2022 03:28:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r13so7142600wrr.9;
        Thu, 07 Apr 2022 03:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ysgmGY6z1GzJduDa17oOz+oi20hGek39JwUR/trWayM=;
        b=p/UKZVzzSUUKarQCEnoZqYwnOj+5vqcExcRo3+EUkYFVCcXjRLJIEQI5GVNfNtmCcF
         v8midJ0etw5XJGZTnMUnHCf95YASegao9CAoqK5BkIPREypo3OSYwoAVWIsB868p7x3N
         +xt6oxh97IpMEpGqXt4G5QNCPIcjcbqaDG0lxhtXHlJrTG/N910e2LFuEBqson19rxh1
         XF9x1CyDwoUwZPMo/fa0ngSje09cbZMublaAXz7je8SfS8mhDo4Hl5eDAkyMWWJREsbO
         3rgFQBxtbt0v98Zg0m3Uya9j10VNdFDtllzVNsDdpUsI/OPNmjcjDMFIdH/ejYcNbo6/
         LajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ysgmGY6z1GzJduDa17oOz+oi20hGek39JwUR/trWayM=;
        b=RAhyODHFcMUSpOjfZfZh20hkkeYyz266nXi4hJ9ZmUI2ZNiqlADblfK4xP05QE8dYo
         agvSGOzpIfRZoWQrgC72eiLjbBimzvnlg9pwvV5i7ANtjPHMYWvqiOh9pb2wylYlu4nG
         m7q28USKtuTb4fbCnbxKZk447Y2iBaZyHRhIqt2xyNpZtKz92SUkHxZQ5HvmrXBk/HYC
         K9bKv5FM8I0iH8ofX/m58XI28/e1tdSyUXGJpfstSwHo5Hoqe3Sl8EdpJBP51kUXN0dS
         7aeFZtJK5OiQbj4LCl+jpZ6/3aZaPO9NqEBR9CYbyXqK7IoV1vV2GmiPC/qS5cBnaLog
         3uVA==
X-Gm-Message-State: AOAM5331/t+MXWUL80q1sRhacNakGLB+fEEuCyUob3zsdjx+nx284QyU
        6YvJgcSX02uivf+XZv0JucI=
X-Google-Smtp-Source: ABdhPJypRKzmEZSzNa0J3mxMTVI9MuNVTozm69KlQDYEEvfmJj13FcjuX0vcYG5/HgQzqulKmvGw7w==
X-Received: by 2002:adf:dcc1:0:b0:206:1a02:95a0 with SMTP id x1-20020adfdcc1000000b002061a0295a0mr10127116wrm.183.1649327302637;
        Thu, 07 Apr 2022 03:28:22 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c3b0500b0038e7466b048sm7727933wms.0.2022.04.07.03.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:28:21 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: Fix spelling mistake "reseting" -> "resetting"
Date:   Thu,  7 Apr 2022 11:28:20 +0100
Message-Id: <20220407102820.613881-1-colin.i.king@gmail.com>
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

There is a spelling mistake in an ath11k_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath11k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index cbac1919867f..1537ec0ae2e7 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1567,7 +1567,7 @@ static void ath11k_core_reset(struct work_struct *work)
 		 * completed, then the second reset worker will destroy the previous one,
 		 * thus below is to avoid that.
 		 */
-		ath11k_warn(ab, "already reseting count %d\n", reset_count);
+		ath11k_warn(ab, "already resetting count %d\n", reset_count);
 
 		reinit_completion(&ab->reset_complete);
 		time_left = wait_for_completion_timeout(&ab->reset_complete,
-- 
2.35.1

