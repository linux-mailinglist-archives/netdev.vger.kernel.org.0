Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5385EDEF0
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiI1Oio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbiI1Oij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:38:39 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEED0AD9B5;
        Wed, 28 Sep 2022 07:38:37 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h7so7728726wru.10;
        Wed, 28 Sep 2022 07:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=jzb2tlFDO7113hwXJyTmEyrv070pVMBorQWNbdu3q1M=;
        b=pBx0BuzdgJDgcsZ8f57VP8/c2/uyQYL9ycGYHrIIRZDcL1Ro2p68mQIBRfzCgvNjnY
         VqKRqE/z07+oRnE+K4Wxw1BU5KlQ3fzHUdPOG1sc7nA94tOjZbyyyJU+e8xXEaHqKpX0
         kKtdPXKPTHNSNxIsowDyubr5YzqTW/XAmPFYC85wX4bgz+nzXHIHreN3SbBV2Z8WgX/F
         wjg29IJrg4y0IGZUDqO6AEYezVmWt1CY5iTzwiiHUfX2Wa1Qosh97IcEJI1FqeMBUtsc
         hWWwAXRbwYVW1/Rq7AMxeMvImunrzyX7Puxj0RnZDi4SlUxIJhKa5bVsy5ngu0Qt8dyK
         JcmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jzb2tlFDO7113hwXJyTmEyrv070pVMBorQWNbdu3q1M=;
        b=yHLXzJDrIIa4JBA1QrsR5Zuq+F1gRXrADqu5ys41F98JdedtnriDz12vuVJkOvBynK
         z09XUX1FgKQ+LsGpcuDgPi2lTmOsvUfXvOrx5iEj29H7MhwspNVlLtpd7ijO/KwKe0wB
         XN5YmANdA7OA2DTUS36SNuZ3i1uc1WeoyftC9fQWsRbJNQFIXQCn5+abIG91HjLYuqMt
         /uT22kTm0BJy7W2m4bSQw2d7KS58M+ftz9lHQWyPvBObV9MXJUoRd/z9x65eyDF3phEM
         3KnvotYkGC0EAjQb2B3dbh2OekwWzBeq3yFwCypdN0XunGOMMzzKbbuXklS2u+459qmA
         gF1w==
X-Gm-Message-State: ACrzQf2+4VKS+MAuIhroH2fbiBq6cNVc7E1AYZr6JxW2evnwYDVtenHX
        HDhfDy1iiqQp7XfP9F/YEKFbrpq5sjKLpnEi
X-Google-Smtp-Source: AMsMyM7D4vDM49WeiylJ/FA5Xb/66OVGI9cD1+tX27Tc7I3mrmERqFSLMPH9fv7f7EwlHDt/UpfGAg==
X-Received: by 2002:a5d:6484:0:b0:226:dd0e:b09c with SMTP id o4-20020a5d6484000000b00226dd0eb09cmr21343882wri.388.1664375916303;
        Wed, 28 Sep 2022 07:38:36 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id p25-20020a1c5459000000b003a5c7a942edsm1940253wmi.28.2022.09.28.07.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:38:35 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] wifi: ath11k: Fix spelling mistake "chnange" -> "change"
Date:   Wed, 28 Sep 2022 15:38:34 +0100
Message-Id: <20220928143834.35189-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.1
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

There is a spelling mistake in an ath11k_dbg debug message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index fad9f8d308a2..2a8a3e3dcff6 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -6829,7 +6829,7 @@ static void ath11k_wmi_event_peer_sta_ps_state_chg(struct ath11k_base *ab,
 	}
 
 	ath11k_dbg(ab, ATH11K_DBG_WMI,
-		   "peer sta ps chnange ev addr %pM state %u sup_bitmap %x ps_valid %u ts %u\n",
+		   "peer sta ps change ev addr %pM state %u sup_bitmap %x ps_valid %u ts %u\n",
 		   ev->peer_macaddr.addr, ev->peer_ps_state,
 		   ev->ps_supported_bitmap, ev->peer_ps_valid,
 		   ev->peer_ps_timestamp);
-- 
2.37.1

