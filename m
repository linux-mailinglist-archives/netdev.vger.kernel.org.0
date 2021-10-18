Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B702431288
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 10:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhJRI5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 04:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhJRI5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 04:57:41 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52854C06161C;
        Mon, 18 Oct 2021 01:55:30 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d9so6996913pfl.6;
        Mon, 18 Oct 2021 01:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eo2W3oLW6kyHLNTQG7LMGLKMpzcWGs37OvnaqmUei5o=;
        b=VhrOUvlpu02saLHwQ4ci8x2axsf6ZZ+HaO5kwkficOrC60pajTlirVOjR1sxouAB9X
         CalWe94F4pBIqifLaQtZ0FsLQj/dIKF+yHr79cu64KHqiglCsgTJvSp0WE/DgA4tZtT1
         FcmTqVdcm+qZJw8+aBbNen9dw331j8Nrv9CII1lQHetcQxHi94vt/xt3jeL9WduOnXeD
         Bdxzkb9USMmSj/+lrrWy1A4F6nZ11MqcY7Q3KS1CfEsVum4GwBgduPCTl1KunhnzTTSV
         M9xLGPLthCkmyi3U908Fne5/KXMxOfkIzSxQmUTxYLkkHM/rNHvSUKTaVl+8WuHG17gt
         e6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eo2W3oLW6kyHLNTQG7LMGLKMpzcWGs37OvnaqmUei5o=;
        b=P1UzZVF6y//U89evZrnYw93vtiRfsNcRr0IG0z+Z7E3kc6pTzA8qo5OeprulqSEDUK
         c2UJK25wWXCwUKZhtuCXi9WOWJtVxNhcYYKXwBBqfg/pzKx4Jsbhe+RryBwCUw1PJCMa
         fMbaDpUjF0lBlA50tRo9N192HUg8oyIzEUBIrU5OLox179em+aMd0PYZe6Z0A8PbvYof
         fyngjcEUMZt1cmqJkSX6V67drca9uAxqM4QnrxiGP8l6IYqeA2CEaRvViWAOk//a+UaC
         54D+So2C2Y0dVuggvB4auCPZSdYcEjnmUIgja/irV1RNwJF6zOwrcKp+zpEdgqOxoDoW
         eDCg==
X-Gm-Message-State: AOAM533bOLLx2Yiw9UHUTqjReWLt/EvQE9diPIyZyQM+Kc2Zius7kXS6
        PbqYQ8N8ElEGgpzFSfYF/Ap9ItwNJs4=
X-Google-Smtp-Source: ABdhPJwp9Fecn319JDIil35EiJ2jyAJzJ19yVtQHI7k3Uzor1Qk89cZAduAoUCp5HczM/he39h/j/A==
X-Received: by 2002:a05:6a00:21c2:b0:44c:fa0b:f72 with SMTP id t2-20020a056a0021c200b0044cfa0b0f72mr26905893pfj.13.1634547329865;
        Mon, 18 Oct 2021 01:55:29 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g14sm11917558pgo.88.2021.10.18.01.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 01:55:29 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc:     Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ethernet: Remove redundant statement
Date:   Mon, 18 Oct 2021 08:55:13 +0000
Message-Id: <20211018085513.854395-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable will be assigned again later in the if condition,
there is no meaning there.

drivers/net/ethernet/broadcom/tg3.c:5750:2 warning:

Value stored to 'current_link_up' is never read.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/broadcom/tg3.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index e9518b9..b1328c5 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -5747,7 +5747,6 @@ static int tg3_setup_fiber_phy(struct tg3 *tp, bool force_reset)
 	tw32_f(MAC_EVENT, MAC_EVENT_LNKSTATE_CHANGED);
 	udelay(40);
 
-	current_link_up = false;
 	tp->link_config.rmt_adv = 0;
 	mac_status = tr32(MAC_STATUS);
 
-- 
2.15.2


