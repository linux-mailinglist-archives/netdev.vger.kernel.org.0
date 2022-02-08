Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1061B4ACDCC
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245580AbiBHBGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240856AbiBHAfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 19:35:08 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33845C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 16:35:07 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id x4so4875042plb.4
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 16:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ohX6WgQSZdtzIGYetDyz4SH1tKE0l5Nqi/Ehqlrz/bc=;
        b=S8e9s2ZowWMNDdFpL/iIiW73kg/5zUBm4e0B0SSucm3KOAuvLBnZDaRycwjuaMLPxA
         p9mMgkSB6vEQHHuIkKlgy90YBnaDeLtkjN4XKmMdrTUycDSjcTVkIIeS8TKEuSgoNsFS
         RBAo07RDKpqyfDTQxoTzMtt9qn3mx6QzxLmdlUhrHlP/emL9km1q/fp4lCsqAme/yHAV
         93mPev2pDO3QZ0XI1WnBvyCy7fIbd3El/ZERu5qU/igSGSYrM5jsgjq/5HX7fZuAvUKX
         RX+ziSQOM+ocYV68hmh+gD3/3IzQ/wtNF0ZXF+tRHDugs3ueNkd0laBiN1L7DSD97eYx
         5nYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ohX6WgQSZdtzIGYetDyz4SH1tKE0l5Nqi/Ehqlrz/bc=;
        b=BrOhaK3T2ArrLJ/4jkk/nx5Tu8F81cuGRRh1we7UO/ehwxHg1orVtaqeED1PuerIK6
         +st5lQ3/bhyukCkAhjftDKUAlnqbekpDMPeUGV38thNzEHQ69EElistGK2NQc0EjKc3s
         02P2U/HHkeEOFEucMBf18oTDSmRVXw6TChveJDt/zR6Vhjg1EHZCKtF7NMsXJA4j8sM3
         59chkYAyubobqsG2+oAMnFtNu9Mv3XgWtMGq5jCrVRMdGes1aQ+K+9i+5aRqAxMlsOsS
         Y/ogPcG0iWaRyxI6oHx631jjJ1qzmrFmcDch/GzXXNsNx3nxvj242cjJb6vPPUvzbdyI
         vGJA==
X-Gm-Message-State: AOAM530oZPI/EgCttacWvNJfh7TJ/4A0qfbtD4bMZzve+xj+t1EyrqG7
        MkBd7giF1cCHwm9CTptIvB0=
X-Google-Smtp-Source: ABdhPJyKBgNbn/Y74KBpM7tOQp0shME+FwJuw1iC3Iv8JlwQ6vobf/nGveqGFcd9VhdDQD8m3n//zQ==
X-Received: by 2002:a17:902:d2c6:: with SMTP id n6mr1783911plc.99.1644280506543;
        Mon, 07 Feb 2022 16:35:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id x33sm14436121pfh.178.2022.02.07.16.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 16:35:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: typhoon: include <net/vxlan.h>
Date:   Mon,  7 Feb 2022 16:35:02 -0800
Message-Id: <20220208003502.1799728-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
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

From: Eric Dumazet <edumazet@google.com>

We need this to get vxlan_features_check() definition.

Fixes: d2692eee05b8 ("net: typhoon: implement ndo_features_check method")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/3com/typhoon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 08f6c42a1e3803006159915cfdae1e72c5e30335..ad57209007e1892656e60176ae464b7bdf3b0b49 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2257,6 +2257,9 @@ typhoon_test_mmio(struct pci_dev *pdev)
 }
 
 #if MAX_SKB_FRAGS > 32
+
+#include <net/vxlan.h>
+
 static netdev_features_t typhoon_features_check(struct sk_buff *skb,
 						struct net_device *dev,
 						netdev_features_t features)
-- 
2.35.0.263.gb82422642f-goog

