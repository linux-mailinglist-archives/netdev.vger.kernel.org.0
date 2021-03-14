Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C387433A7E8
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhCNUTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbhCNUTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:19:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB57C061574;
        Sun, 14 Mar 2021 13:19:01 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso10987931pjb.4;
        Sun, 14 Mar 2021 13:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6zkpgVZt2BIe8OcTFxAv6LSrKKZyzPlePvruyp8u7OQ=;
        b=rBHIlMruAv1JLCl94vtihHPFleqQbkArh1iXuIyqaI+nvkJDUT7GAwS/S+DKLn6JCh
         3N2frJUObwiV9dFkISN99m84BBwFppGG5Wb2S6xtIKS1rLc+80jcv0BlME1atYf4C/N2
         j+ibk3TWEsrKqsM/bvmGsmHAbap5c2VJnJbOjoyBzoM7i/Ip58l5kI0Df3TZWJmnS/lN
         b2Y18A+Ina+DhUh21jZtc7uuWqdcSsYTS+CIlIjjunPzYqXq9JgrCKak9YroBg4CdcrZ
         RoEkyxMV9NhLrYoTR23rK3A1NlPyMzT18QraOSHCh9wTO0F2qjnoJg4TDE9GnHR4ld4r
         MWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6zkpgVZt2BIe8OcTFxAv6LSrKKZyzPlePvruyp8u7OQ=;
        b=cMfIbg0TR4edT58FU+/3P0eLPTnlgQnwGByKXT65rnipEx1tYFpimQvK1VXN1b5EWW
         tPWkppsMURs+dLinl1pvYnxy0+kcSgUZnWeg/yiMfjTnLB295szooH8bJ34LQuLDUkJl
         89TX44a/TLmD0LFs7Q3NYDmHr3cRoD7C0TTRQpycx9kkmoTDwSFMF4B0+QzsnRoyyX9c
         9sa8YSbM7kfD7eAoZlCg8f23iwsqxStIFQoGsdysIHeWwk6D1yHhot4BgBxCaljp/6sc
         DDfV2Cjk7kUDk5Tzbt1HOO3r/dSip2tPVS/PmV1Dvaay9rE7c/NrcpRVLBC3hksbHu73
         Sy0w==
X-Gm-Message-State: AOAM532pgSJwzA3oX7FaBnvNPyWBExfFgB92uJFH7KPKN9ICoUFRXzZF
        0524sX0TVNxbNJXk3tiYobw=
X-Google-Smtp-Source: ABdhPJyRgs2rwju691EQ6yArpLDF/m+kWGg14mwPaiRSUlxvWfe8FRBl0q3p8T+NFa92wFOPHVNjlw==
X-Received: by 2002:a17:90a:e556:: with SMTP id ei22mr9196300pjb.214.1615753141264;
        Sun, 14 Mar 2021 13:19:01 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:19:01 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] rsi: rsi_hal: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:15 +0530
Message-Id: <20210314201818.27380-8-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_hal.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2017 Redpine Signals Inc."

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_hal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 46e36df9e8e3..d044a440fa08 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2017 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.17.1

