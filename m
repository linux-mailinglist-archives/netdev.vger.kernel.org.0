Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F83645660
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLGJXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLGJXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:23:19 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B083B1A230;
        Wed,  7 Dec 2022 01:23:17 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l26so6883853wms.4;
        Wed, 07 Dec 2022 01:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mp7IkQilsHJq1Ek0bhLypo9ye+2ulLNr79KyJ290OkQ=;
        b=V/1PP5ugnQD3HtZI2CHfhf2OvV8wuimKi2nxm5esC6nBSO8i60D82nEL3Ug1nlJtSs
         D8+yMU4EOyYHjaFseKS+j5Kilz03DJF/zGLAWR33QOiVmkC/J/IF6LLA0o63oMe5JB7R
         0/CGch7Hod9/IaxHMMXHjiPm0PkYJLE78dXRgBwlYA/ok+p1Wi+bN2r0ke1xWMGd1diA
         2Xp25ZW4xltMIppGDDrLV/wpmYksgzMalEOaFWT2UYGZ+tTVQqRq3mxxcgrFrsKOIkAx
         yaMPacX1mJbN1RmxGk0m3B2gbPE/NLvyQZtU2lbMsQxW/V9JTU96Wailf0f22IHm5rQu
         u7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mp7IkQilsHJq1Ek0bhLypo9ye+2ulLNr79KyJ290OkQ=;
        b=HAswyaGsrvQMkmA3tLbZdZ6W2q2m4Opt1XA6NRtWmHmrj66a0zVo5M0xR8j+csNGVw
         mX8G0M1g/6OOQba1pyCEB6/iqIuWZQEFjvjXSZz+GTLEiN3HkPpsbSubMfk6j8fvNgN5
         AZUbhV2GfEpYcR9bkfOSQEEqLgd+TkJv3e5Ij9WcdMrni6bimEoSkkxRbiEpGDhXhZAI
         C7/OeKHhJfUKz8LfHpxrqNiadZVwna3KNPNs0vJCduJyfcQdkUngSSpG4ccs2tzzAiQt
         qWDqHfMysXtC7efdOLfVJRHppC3095h/500uIYFHosUp2HVncbcZg5aKeHmALfCQd6gq
         pf0w==
X-Gm-Message-State: ANoB5pntvk/cwRJ5XBcxXXjb6flyIS75nlEuPjdDjmF3WTgsfEA1vYI7
        OtJlCTfEU1YGeZ49mRJX50o=
X-Google-Smtp-Source: AA0mqf70WKp0djLuEZ+wipgcuqi1y/7k3VbUP9ZuF7jEtcrnXqSRpqyOKVVD7RP8FHU63pDQxXDe3w==
X-Received: by 2002:a05:600c:1907:b0:3cf:7981:9a7 with SMTP id j7-20020a05600c190700b003cf798109a7mr65485568wmq.87.1670404996211;
        Wed, 07 Dec 2022 01:23:16 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l10-20020a05600c47ca00b003c6b70a4d69sm966248wmo.42.2022.12.07.01.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 01:23:15 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] xfrm: Fix spelling mistake "oflload" -> "offload"
Date:   Wed,  7 Dec 2022 09:23:14 +0000
Message-Id: <20221207092314.2279009-1-colin.i.king@gmail.com>
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

There is a spelling mistake in a NL_SET_ERR_MSG message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/xfrm/xfrm_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 3e9e874522a8..4aff76c6f12e 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -379,7 +379,7 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 	default:
 		xdo->dev = NULL;
 		dev_put(dev);
-		NL_SET_ERR_MSG(extack, "Unrecognized oflload direction");
+		NL_SET_ERR_MSG(extack, "Unrecognized offload direction");
 		return -EINVAL;
 	}
 
-- 
2.38.1

