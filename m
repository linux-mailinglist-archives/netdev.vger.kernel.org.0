Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4679B24490D
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgHNLmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgHNLkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF4EC06134C
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:10 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t14so7661490wmi.3
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G92Ao+f6UU9daDqYyJPelJ9Oma/zXF8WiVDQ6/EyKiQ=;
        b=FCCb3jCc8ESxa9cFJSrHLhg/dqKu1GyVrMcfpJFR/AfZ7hxTgmwU+2hXGAfqpV1l4a
         N6Qs+IMotRajedSDhzcO/Lmy8xqD+XMPjeFAZLDBZHuu8kkIHPu0OotmkJXMgxaWJa2B
         xfOX90wvVzcQKqKAKz8h3YPQyz6LKIy0c+fRFAbFUzXrxpmAw9TKre+BD6fQKqo8g990
         ry9nOnM7gMzwjxCmFrjDZsHrEQed5mI88J05SeEhrrlbVfUAdhBtL2xi0EbmH+I/cnlY
         P7Jd2aoL7pebjWOYkgv3siRUR24TZ98TkpQgeDV7UtilswMZ5y8Oy4Y820OK+hj8CmJh
         oo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G92Ao+f6UU9daDqYyJPelJ9Oma/zXF8WiVDQ6/EyKiQ=;
        b=oM/zr0xq7k6UdYjY8g72X1/4UQsJRbTf4SPv+Orq4orFeOZUXrrXxMMMSCVAYJZrkD
         a/S+7yiXmKajV9Ui5GfSsef9TuUPorFF7zTFVjw0uWibPYulv7/8KVgd00pEiiAztBj1
         4U3QRbWDaty+I2MkM5JG2oBLjoh8uZOJq4HvoAK6TXTyDJQnux2Wx+b0IPqdaNJt0Mul
         cgnty6Vi6z5v7h0zevKevbCH1HKsj0pGZxS8dyfvyg2wY6v79AjAVf8ZO29gBDKvaq+D
         mo/wLphlv+4+hXVGBfsjOvNxtpUXXQi1Jy6oB6v6RL/efiH0G/S8YejnTJxAQgCvXpeE
         PhBA==
X-Gm-Message-State: AOAM531fo5t4UTfmfplRfXCvud3VOlcWI1NQUs4ZKsVZjBkgh2RL1120
        XSltE2VRbRjyV6jMyPT6BLsmjQ==
X-Google-Smtp-Source: ABdhPJyLdf4QkUP+eb0gx0AtBQxdo38TWZ7Di17lJ+2gTouJkLg6XKL07gle+0TlXo0OfEukIxfqmw==
X-Received: by 2002:a1c:9952:: with SMTP id b79mr2231590wme.68.1597405209108;
        Fri, 14 Aug 2020 04:40:09 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        netdev@vger.kernel.org
Subject: [PATCH 18/30] net: fddi: skfp: hwmtm: Remove seemingly unused variable 'ID_sccs'
Date:   Fri, 14 Aug 2020 12:39:21 +0100
Message-Id: <20200814113933.1903438-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This variable is present in many source files and has not been used
anywhere (at least internally) since it was introduced.

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/hwmtm.c:14:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/hwmtm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/hwmtm.c b/drivers/net/fddi/skfp/hwmtm.c
index 3412e0fb0ac4b..1070390565114 100644
--- a/drivers/net/fddi/skfp/hwmtm.c
+++ b/drivers/net/fddi/skfp/hwmtm.c
@@ -10,10 +10,6 @@
  *
  ******************************************************************************/
 
-#ifndef	lint
-static char const ID_sccs[] = "@(#)hwmtm.c	1.40 99/05/31 (C) SK" ;
-#endif
-
 #define	HWMTM
 
 #ifndef FDDI
-- 
2.25.1

