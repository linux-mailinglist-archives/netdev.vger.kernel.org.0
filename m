Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94912F273B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 05:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbhALEnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 23:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbhALEnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 23:43:32 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74833C061575;
        Mon, 11 Jan 2021 20:42:52 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 81so1365993ioc.13;
        Mon, 11 Jan 2021 20:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/RsQ8+tqR8SqIOB6a09VH+U+kRQ1ioeuOmyKXdfomv0=;
        b=N2aroRGk5iUtCtiduYfpPzGPwj89M0i2RKlZLzGUVOinOBRcGmsBytB8OtUWnqTckS
         OqviiUTlTQy1gPIxC0AxAtbrPgcVih8xHetJqaVtqmxpqCI5JNKZrxmAWy3IsUFDCvYh
         FS3n9uVb8rLXP/XnU6ZQKRMp/GGWgDb0Jx0RPt/2s1kKbrbb+Mah9LkbTDy7QVd4T02O
         UFaSjWsWw+gy40etnHqIQbNoo1CJM0z9gj2mwzq8fjaecn63Hj7xflaFONtoVcMdezFt
         /u69WGHfhb6sL3Y1YdO5ivUypGK2/Ws4RDqKo6ksOmXoqjbI26wtzWXx/89XdC0UCipu
         wVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/RsQ8+tqR8SqIOB6a09VH+U+kRQ1ioeuOmyKXdfomv0=;
        b=geG8x3rg1pBbsQf47A2RQrar7PNNBUpLJmFn/HvEMfhCilZjhc6X1hOsi1ufPKdNEc
         fBgBhARrpyOjL5CugZcQzLuWPDmUvsyMj2oRxfKzPw2KJvjM1xlH/AxvihTXKdABbfta
         p09ULFI3Oe4UZLD5vinq5oH8yjlQPZpNjRysTlcAHM4cI1bvMsOOAac8VCJpg/28Tw+j
         oOSSVPGsYyXOWD5sG645EnlIWm+r+nZ1tR+qiYBFA0rROBFkelJjDDcjiJg7pUvaRRff
         QYRsII4cOIPwt47Ksu/LAAYhpLlcM5h15mf1MvZR9hYWP8goP32pFH2haaLZsM7GCIN8
         Z99Q==
X-Gm-Message-State: AOAM530xzF9U6QcEr8/Rj5kP2f12i02/B4kcc1QxFzlPl2Mu6IhYhabD
        oe7fcQi89ZARgdtxfjGoPOI=
X-Google-Smtp-Source: ABdhPJxEtq01nSI3TY0qOFDWcYf3Hkmpr5WVngMZwMwZJJf6udqr9Js3zuByjS4oBqeqWUgHaoaCZg==
X-Received: by 2002:a5d:8a1a:: with SMTP id w26mr1945300iod.112.1610426571857;
        Mon, 11 Jan 2021 20:42:51 -0800 (PST)
Received: from localhost.localdomain ([156.146.36.246])
        by smtp.gmail.com with ESMTPSA id n4sm1535777ilm.63.2021.01.11.20.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 20:42:50 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: net: ehternet: marvell: Change controling to controlling
Date:   Tue, 12 Jan 2021 10:12:41 +0530
Message-Id: <20210112044241.10829-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/controling/controlling/p

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 8867f25afab4..24034fe1e148 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -143,7 +143,7 @@ struct mvpp2_cls_c2_entry {
 /* Number of per-port dedicated entries in the C2 TCAM */
 #define MVPP22_CLS_C2_PORT_N_FLOWS	MVPP2_N_RFS_ENTRIES_PER_FLOW

-/* Each port has oen range per flow type + one entry controling the global RSS
+/* Each port has oen range per flow type + one entry controlling the global RSS
  * setting and the default rx queue
  */
 #define MVPP22_CLS_C2_PORT_RANGE	(MVPP22_CLS_C2_PORT_N_FLOWS + 1)
--
2.26.2

