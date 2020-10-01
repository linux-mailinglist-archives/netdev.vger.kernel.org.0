Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2EA2804DA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732934AbgJARNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732417AbgJARNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:13:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4248C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 10:13:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e15so556001pjg.0
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 10:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QGkeO28aCdyAtn7iopguZLVSomHycr0aDille9Cl/G4=;
        b=SIL6Kp/mu/amAEaslizumNwz3rc2njH3Ja8mrmqCMv8EeebBqI3fSkMAZ3taRnyFQu
         3WuagCDeaCPZo5UsOF5MWpWynWcFJTinAyDl4NJfgtvFGj5VlSTkdvs8aTtUmLT6BlNA
         mU6frXSa6ybIE+OU/rr5p5C3I/6KoSRBsM8AVdYqaFSIivu6QjUNB2obkgwh/vEunxjr
         irbMrMz8ibH5PzfhtwWeeG6Q3+K3+KFFEXBNgbTk/KEulzf8C6SI5pN1T+ce/WpFEZap
         SabNupr2NLeHF+YxwxULYP/BydiW5Tcqw75vH7BNvBnyOzS2R+BfFGISjZu1J12to/TB
         o7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QGkeO28aCdyAtn7iopguZLVSomHycr0aDille9Cl/G4=;
        b=Rf1CLf0yCdNUEF7eIvtaycVqLZSUpymVaPwi9JJW8H+v7ZaNTdLrD8W0Jl/Y0XOHsi
         L7kNn0eAoCThupNqTbVG3XGUDbur5KX9LXREma6nbDi9nx86/DDNWogiAAAmOjUmuQ73
         1SnnlpDTKlxnDpn1ltCCPikn/X74bOpj2vuWGltdhD6l0Owo5fgx0ezuGU0n2TWaop4O
         6z65u0urLORY4kRp/FIjzlazqPByme7rqtxqMwfW9Lb1X6v0oIDoHXMwBqa4nOpCMfA8
         kpyJjse7WSYMbEeCav8TQqDlt6XM2SIbuz8JAyXyF+dFFKtp+ffMFglh8hiwoBOreMgw
         9N7Q==
X-Gm-Message-State: AOAM533wtsQyGhtkXfBTlsr3lMFvP08vzqNkAY6uRhQ0brsICZdWuGmA
        E7umM5kdcNm0nl9tqtfLhI0=
X-Google-Smtp-Source: ABdhPJztirrvMylHi+TrlWMdL0lhMs65oLvV/evvSuqbZYKIDb3HDHvIA0g85xQjkXlQLZUexWckUA==
X-Received: by 2002:a17:90b:1b50:: with SMTP id nv16mr893503pjb.153.1601572389148;
        Thu, 01 Oct 2020 10:13:09 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 32sm5813105pgu.17.2020.10.01.10.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 10:13:07 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] net: remove NETDEV_HW_ADDR_T_SLAVE
Date:   Thu,  1 Oct 2020 17:12:50 +0000
Message-Id: <20201001171250.10727-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETDEV_HW_ADDR_T_SLAVE is not used anymore, remove it.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/linux/netdevice.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 28cfa53daf72..0c79d9e56a5e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -212,9 +212,8 @@ struct netdev_hw_addr {
 	unsigned char		type;
 #define NETDEV_HW_ADDR_T_LAN		1
 #define NETDEV_HW_ADDR_T_SAN		2
-#define NETDEV_HW_ADDR_T_SLAVE		3
-#define NETDEV_HW_ADDR_T_UNICAST	4
-#define NETDEV_HW_ADDR_T_MULTICAST	5
+#define NETDEV_HW_ADDR_T_UNICAST	3
+#define NETDEV_HW_ADDR_T_MULTICAST	4
 	bool			global_use;
 	int			sync_cnt;
 	int			refcount;
-- 
2.17.1

