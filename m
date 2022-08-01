Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B07586290
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 04:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbiHAC2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 22:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiHAC2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 22:28:00 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5120024E;
        Sun, 31 Jul 2022 19:27:59 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w10so9264718plq.0;
        Sun, 31 Jul 2022 19:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=t1JJqcabOe4+o0zd98T8fNznXcEqyhDGsc8ZsrH0sCk=;
        b=jkK6DfZ/Fkjxwkmz6LUNFilhGxwZX0blH3O1lIRWQlTy39s4Pn6ck80Mdntp4XX6i0
         HlsM/wQ2bdMsy3PKS0J18nYRwQgXj1FVZF+ZaBxVBRl4Oj5kfTFyQtLjgjbJtQQtYnZZ
         59b+u7Q/yJ9419AE4HJd0tJ2Jq35OtOiBAdJnuVOTHhy1AlRqofbYqbMSOtBocbxNMxN
         BgZvMHg3ucdkP24gobMDz7ZLPo8WpYXGRNO5e5YlJamqraC2J+k5DMnmxqDoS7V2wqJy
         aDikgWn24eFx2TRxV/JNicmmOGP6dhIda5OV7g93Fijc51yB0xsFIg9/SFf0UqWjF+ST
         btHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=t1JJqcabOe4+o0zd98T8fNznXcEqyhDGsc8ZsrH0sCk=;
        b=YbDUsgNNhhbeAnAb69r/DPhfPyNSFBRsvPA8KLSoYBa6cFKKxe20+HVUuGzD4CmBIJ
         eb+5YOaGAGMxTzbQsEp+A6Zw2TxrFqGgD2dkDM3S59dYEl76Xt0nRGdnv1xzAKmjktNs
         TB1nPc49u3Qstdx89KFaISezoDqzr2wbGTnlHew1aUt/ap+0zU/CaZynfTuHKbHMG0O3
         xBeqX+4d87QYHDns8W/GdPWLlHnSz+jsSRiCsOOvOXmAM5sP5wAnv/SzUyqS5/Gd4455
         PiBTR6vZEnAILKzBxCCtfnT6UOKd1EWz+cEDt5D2O+IEGUrs7OMaB05che468jWQU10h
         dFPA==
X-Gm-Message-State: ACgBeo3HKyUD6JStK5K2EHTOSCu0f/sXB0fcX7VjLirqm2/46axk4dD9
        FNUEW/OsktuICALngyd6kajOfN9LnHI=
X-Google-Smtp-Source: AA6agR42x2rttpahuV35R4ec+f6JpRQIGLk7ZqsWciuqctou4qNTcMVdkQ/7aOPyHqL5EZ854sTv0w==
X-Received: by 2002:a17:902:e5c9:b0:16e:f3b6:ddc4 with SMTP id u9-20020a170902e5c900b0016ef3b6ddc4mr1304236plf.30.1659320878734;
        Sun, 31 Jul 2022 19:27:58 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id z8-20020a6553c8000000b0041bb14a7520sm3965476pgr.81.2022.07.31.19.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 19:27:58 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] iavf: Remove the unused conditional statements
Date:   Mon,  1 Aug 2022 02:27:54 +0000
Message-Id: <20220801022754.1594651-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Conditional statements have no effect to next process.So remove it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index e78c38d02432..b75e3e1119bd 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2131,8 +2131,6 @@ iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
 		vlan_ethertype = ETH_P_8021Q;
 	else if (prev_features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX))
 		vlan_ethertype = ETH_P_8021AD;
-	else if (prev_features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX))
-		vlan_ethertype = ETH_P_8021Q;
 	else
 		vlan_ethertype = ETH_P_8021Q;
 
-- 
2.25.1
