Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF74A34B2A5
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhCZXRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbhCZXQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:56 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE09C0613AA;
        Fri, 26 Mar 2021 16:16:55 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id x14so6948339qki.10;
        Fri, 26 Mar 2021 16:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a+VWWWHlMS/iq1KVs+7h3vpEbYcUnUosOcWBIMdkuRE=;
        b=GKxnDuwoyXTaHlzj3gsuVnuXKw5yl313e+xLr7uEQrVr6akQTDw/aWipghHXhacJah
         qWd88DycCmVRYlWtrrT+AA4BeAkSfDw347s8Y011D2ZoJCeLcRZHLtqEAt/33hwAUeje
         AovEA9KmP+9xK3SvHtRf/vER+mAjGOdT0X6pX6q1JtecagYpaSisBR39G4rmq+MKx9mL
         8Qt1bKIx03gYhbvpl0KQ48XOnTnHfl9262uqzqbJCZP2DR2YftyOFjTNVWvsoqV2UV4K
         LW+o5136Kn4sR0sL8lVnEd/L/SJ4E7GdUYJvlUrZN2JsBaG0XTiCwWlu9tAK+3/tAyFO
         lvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a+VWWWHlMS/iq1KVs+7h3vpEbYcUnUosOcWBIMdkuRE=;
        b=QIAfJaogjDCMcJaRziazfGECCTMkaO5JhRn2oiyl9ceJpcfH77B2ew+qlYm8c4omNU
         vKtnvJy2tF+Q2uuebMA67DOReLYG2HXxnpkCKRSQEtjBoUqJ4vbj7b/g0wSigbdQxVZA
         MQ7lhfHFoxkAld8Fi2cIf3TgNl+LjWHhMyqxs61qMqvcL2SE9eMJbWHXS/EdyrxYjK81
         l/Tkaec3R+JeMLeolmMnuWH+g+S0SvfeVS1mz+TzwbMZOvXYh5CKrpWPiduZe2LKPCPQ
         NiejQaTLBR07URvxHKNKNwax+XikPyiwpgc54nlCFGC0b8y377sBX//Kozf086SUnx7d
         83RQ==
X-Gm-Message-State: AOAM532K8po+tCwguFHOMwOUaDL4qaiQ1MNnw4lj2iiav2Jrbuv/aM8P
        9OiFa7JjRTXhRgme7zvi75E=
X-Google-Smtp-Source: ABdhPJwwfqVCyJ3A1Y2gLHP5pu09jtffC5y68aOvyZ63a6Hf8dLqPxBF71P6V1Dp6bhvtLqGLHUSSQ==
X-Received: by 2002:a37:e16:: with SMTP id 22mr15193829qko.145.1616800615182;
        Fri, 26 Mar 2021 16:16:55 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:54 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] ncsi: internal.h: Fix a spello
Date:   Sat, 27 Mar 2021 04:42:47 +0530
Message-Id: <20210326231608.24407-12-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/Firware/Firmware/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/ncsi/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index e37102546be6..49031f804276 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -100,7 +100,7 @@ enum {
 struct ncsi_channel_version {
 	u32 version;		/* Supported BCD encoded NCSI version */
 	u32 alpha2;		/* Supported BCD encoded NCSI version */
-	u8  fw_name[12];	/* Firware name string                */
+	u8  fw_name[12];	/* Firmware name string                */
 	u32 fw_version;		/* Firmware version                   */
 	u16 pci_ids[4];		/* PCI identification                 */
 	u32 mf_id;		/* Manufacture ID                     */
--
2.26.2

