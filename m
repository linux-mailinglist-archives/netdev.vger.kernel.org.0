Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CF73F2FB5
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbhHTPmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbhHTPmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:42:32 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A46C061575;
        Fri, 20 Aug 2021 08:41:54 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id j12so3544019ljg.10;
        Fri, 20 Aug 2021 08:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CO7WIKpoxfJdWHygasZxPg+IbRdNNrjO+jU5oMl4qkw=;
        b=qt9b21nJhK+40MBPA7cRwBBNzy8Ont8m7QEfXXUcf6m3BDcg+xtPn5HbIWasJDWREx
         3dMMYS2v5wXkHGw3uDbFAflhfh0EKQxdpHP8EktgG6eJG8qkcgBDss9Pu5bpqt58K2po
         vKCtldcW6wRjwPp5OtYMxhe9E3d5QjYwiOb24CVXh+zSarUbQwsBzKTXjNGXQ99b069J
         Wugt40p8oTfeaA3UhNVfTw/xCnuzpwmQbNZhkfIVlDeKFykqiZK6KjG0fFhtdxM75Xk5
         1fXTjpPEOdQTHOS4+T30bFiBPIlw0ItMgOPuGvwMgczTUnOj8+5zIOsAkrgI2tkihyjZ
         Bb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CO7WIKpoxfJdWHygasZxPg+IbRdNNrjO+jU5oMl4qkw=;
        b=HCPLBaEHU9liGqVjTNUZRd4I5jlc1H1CEvWEhsxwKnC69CMxO3Vhc44xdDqNMbeUA6
         sJav8IEh2TxRZN/14wbTSFtqmotbH12TnZedudqSDJOtBF/56x8D+V/8TWNHH9SXWjMj
         lmgRd/VBytIR1sbkMPhv2ly6o0WC9tkHcKgIZrYThzEnbe/o+9ovLWH+jbHcS5suk5B/
         yqjXCPwxEg7KV73/g+QbD33PzPAzf0R2x9CUUJ9/RGA8iMfT4Zs48NQxOL3LSKc26ACU
         DdS/MTs8YYuhaZ7g1f7VyyHisM8wSGWDyBFIG6rOMuRIMrn02n/abZNBN4R7/Pmol2i0
         gJuw==
X-Gm-Message-State: AOAM532QYF7P+v6f3iYD/sFPqUo/L74+b5sA24MrCgr5EzHBMHWLPL3R
        q0EyEjCXZIwaLJulzj/4DjuR/CrriW0qwFow
X-Google-Smtp-Source: ABdhPJySbeXAocxwBvYPCIAYiSSf568+u6MbgG8PvnMD5g2ar+tqYE9Q4d2kYAGWtIAYpX5yJmZFdg==
X-Received: by 2002:a2e:a4d1:: with SMTP id p17mr16409560ljm.82.1629474113012;
        Fri, 20 Aug 2021 08:41:53 -0700 (PDT)
Received: from localhost.localdomain ([185.6.236.169])
        by smtp.googlemail.com with ESMTPSA id q5sm660895lfc.283.2021.08.20.08.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 08:41:52 -0700 (PDT)
From:   Maxim Kiselev <bigunclemax@gmail.com>
Cc:     Maxim Kiselev <bigunclemax@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
Date:   Fri, 20 Aug 2021 18:39:51 +0300
Message-Id: <20210820153951.220125-1-bigunclemax@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Armada XP datasheet bit at 0 position is corresponding for
TxInProg indication.

Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 76a7777c746da..de32e5b49053b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -105,7 +105,7 @@
 #define	MVNETA_VLAN_PRIO_TO_RXQ			 0x2440
 #define      MVNETA_VLAN_PRIO_RXQ_MAP(prio, rxq) ((rxq) << ((prio) * 3))
 #define MVNETA_PORT_STATUS                       0x2444
-#define      MVNETA_TX_IN_PRGRS                  BIT(1)
+#define      MVNETA_TX_IN_PRGRS                  BIT(0)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
 /* Only exists on Armada XP and Armada 370 */
-- 
2.30.2

