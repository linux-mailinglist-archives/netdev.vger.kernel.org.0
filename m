Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF1433A7E3
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbhCNUTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhCNUS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:18:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACAAC061574;
        Sun, 14 Mar 2021 13:18:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso13618064pjb.4;
        Sun, 14 Mar 2021 13:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V/KEl6U9B92FjP8yt5NHoQ/3iiQ4uIjsjneLAe8jps8=;
        b=JsV89PydC1Lu4N93Do3t1o9brmWKOq12cRqkxTBFYQ+m5iCyVlYIZLVNPc5CpZnkMu
         5yhnETk8jd7caTraGXwOAbhon0P86XKs63RnVLojQ6xzuF7tBarG3G04kyjc0RVFmdSa
         Jp6AdYQ+S8BGDhRTUwFmDkZN8IL18nCnPlV7uelN/y92G43o6zU3LybINcWRA72bm5Fc
         hTlmoXnbs6z6GP3jjlVywAC9kK6clreqIzT/kq8nTANU8Q6qrKhAIRqe7N7GkDLLgWUJ
         bPZBbpdmYYH5FK8XSxp82OWxqVfSuuyPtvAtUw+zzwIdhSCBVF5TxDj67h5aX+4r97G8
         Ns9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V/KEl6U9B92FjP8yt5NHoQ/3iiQ4uIjsjneLAe8jps8=;
        b=qSTExoS//SQilx7urANEjBJDpC0JX13YXM4cUsI+xOf+ahOhNc4cpoYo3Khzwgeg93
         olMGdF1kqHAscyn+vn1BySpWqc4vwZeS3S7rUFje1pT66w+SvDLX0tNhN8gTgXt93Bxr
         mZsgxAviSfAbOhvDutDXnCKutEbIK73OQHGsWFx7RPmCP7CZvAdBoRpX2/D2AjZ9PF4i
         63t8r08rl2W8YImgJJXfOA0f6EgTnowZzGFU3a+NZEUo6QOYeGwO28E0+o22HUj8u44M
         L3RWkprXwgr+JvL95ImQQ2HuaKxW2cCExjM6DkWdHRaOseX/qWG38QmEc0Loh7JCJOUR
         OtUQ==
X-Gm-Message-State: AOAM533ksloGC6AS4nq+kJzbLSnQpZ/3qH38WOnolcoctLj4nkpBPySf
        A3CtlntIt7O6Eq5M4EQDFwg=
X-Google-Smtp-Source: ABdhPJzqednKD1bnj8Yn51WS0b3g0e0EJteqOkYBGddmCgLfWEL/bJasLfP7rC4P/FVhQxennVD8yg==
X-Received: by 2002:a17:902:bd41:b029:e6:933a:f3ef with SMTP id b1-20020a170902bd41b02900e6933af3efmr8168356plx.19.1615753135914;
        Sun, 14 Mar 2021 13:18:55 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:18:55 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] rsi: rsi_main: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:14 +0530
Message-Id: <20210314201818.27380-7-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_main.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2014 Redpine Signals Inc."

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 73a19e43106b..a1065e5a92b4 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.17.1

