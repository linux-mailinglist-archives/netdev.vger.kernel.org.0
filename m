Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32E96456BF
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiLGJnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiLGJnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:43:20 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ADD2AC4E;
        Wed,  7 Dec 2022 01:43:15 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h10so17695327wrx.3;
        Wed, 07 Dec 2022 01:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=09w5K8q+Vo1x6aVGPUuFNxXTP2+qz4rNcAnPf/61v7I=;
        b=NrOIn7R0KDNsGOOtkL5Ic5J6tkYNfZuWs2Dqrb2ZO7B80AMKzUb2LKGGMAa7ORVgpr
         jq3VsgSnvEF07ZGi64CJAe9wVFZgdQMqNEKt+42NX+vNbnriZWLAyNE0hZTWkvBaWI8U
         VWJrXpWAPPSxVOyx9rstT0jK0UME2xsrpmgiTH8yyVTKRX4iVujtei0/EAYamgpwvMy0
         B0Abh3l7sEr6Np/TICPvDwgStOAJAZmyjFbQvzv1opQnAiigctzjJjQ58DgHac0Y3bDJ
         tzCVMWrUxbptHx9/AzvFU8fvHQbRc5op0MUAWfZl4ipuVE9ET3dnuMiOU5PYlVEeCedr
         IZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=09w5K8q+Vo1x6aVGPUuFNxXTP2+qz4rNcAnPf/61v7I=;
        b=VaqQ9jKLg+uJxfseul9GEQTjo4SNMBTZPwkmmetQuWr47ttCugEwlUyIoK6o3knfaI
         1/DJH4oN5g9gLwpoYX9UjL3mlUznovYLws0oafIVOEGHQar9hGM3igERK9680nr8Vq9J
         SmiXSQ7/ZrpcbPg84xmatcvB85fPYE3lcvxRXqdPAx3IE0hgSQViqXRg1YfJQdiY87PK
         TTr0FPu9GeRAwdgRRw08TOF7veuFU5Fk+NjoxF4U/w9hYKUO9J/o//7NRUAjjqeK6f2O
         QaWNs1J2H5Djtu82k6cSP9DUg9OVhT0Zdb0RC1JiNVXez/mtD8VuzEuNj7fbV94CuZkn
         izVA==
X-Gm-Message-State: ANoB5pmNKNCKaKr4kKI+WtZnB++UHGHT7E8I5rquyGU0fvMaBXj2ZyjX
        RCvgQ0t2s5SirsPXXtP2iIe7lBKwTMkDOyzJ
X-Google-Smtp-Source: AA0mqf7nRTfOhWbNWVuEKpAj8Cqhsvjc2YnSbUysoqefJ9gzGRtYI+1gICzJFh2J88UVck+BFX3Fxg==
X-Received: by 2002:a05:6000:1084:b0:241:f866:6bc8 with SMTP id y4-20020a056000108400b00241f8666bc8mr36015720wrw.501.1670406193950;
        Wed, 07 Dec 2022 01:43:13 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003b476cabf1csm1061791wmp.26.2022.12.07.01.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 01:43:13 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, oss-drivers@corigine.com,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] nfp: Fix spelling mistake "tha" -> "the"
Date:   Wed,  7 Dec 2022 09:43:12 +0000
Message-Id: <20221207094312.2281493-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.38.1
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

There is a spelling mistake in a nn_dp_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
index 4247bca09807..aa8aba4ff7aa 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
+++ b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
@@ -503,7 +503,7 @@ nfp_ccm_mbox_msg_prepare(struct nfp_net *nn, struct sk_buff *skb,
 	max_len = max(max_reply_size, round_up(skb->len, 4));
 	if (max_len > mbox_max) {
 		nn_dp_warn(&nn->dp,
-			   "message too big for tha mailbox: %u/%u vs %u\n",
+			   "message too big for the mailbox: %u/%u vs %u\n",
 			   skb->len, max_reply_size, mbox_max);
 		return -EMSGSIZE;
 	}
-- 
2.38.1

