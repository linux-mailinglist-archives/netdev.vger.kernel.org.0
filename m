Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AB1B9E1A
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 15:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394232AbfIUNpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 09:45:34 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38771 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394165AbfIUNpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 09:45:34 -0400
Received: by mail-pg1-f195.google.com with SMTP id x10so5426311pgi.5;
        Sat, 21 Sep 2019 06:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Jampd5QY3jFhxyqLwQVEL6NDlN7nbV5HR8jQMKngBSY=;
        b=myJaWfPFcB/VrUw59ASvwqkPpI6QMhrdY3JKtWbX0VBlOwaLQ8c1obt+Aw8gMje9/n
         GPGM8Vs4fExyRZCo+KKCaxHEthyiXyKyeypkqDX6rPhlmYe97tD4xkZfoLuLGQ8Phx3W
         rSaAyAX1EtOlTciYWfec2XPHZqd7PDi+7eptyDMXzJBLK+Y427R1srGj+S6iZu/KJtGL
         rVHzoR2khMOs8AnxozLi5HegTw0DeSZcY34hAr/n2IFqnWHzOZCQUu+n4yhxeL2nTrC1
         /hfDrBWVFtQ2rUJoy5pEzD2n5BX5j1uV3WYMW3kEWZ/ihl12/BRZXQ7Z4dQTW6QSp8Si
         6dbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Jampd5QY3jFhxyqLwQVEL6NDlN7nbV5HR8jQMKngBSY=;
        b=gCppLxzQfJ5bZhtXZsixb81eRrpNeqCL2AZTjB+j0oYdng0/gWXrhyCM7YEjt1Trsu
         G5G8NKYZuJ2gykNHRO8sCYE/F5+HzRPmC2hc3ykhRmGg2aWTi+zIVcM7cCyRhRY7zNMl
         xeJZTB26jBsqvpevyBLr4eWoeql5T0QctVPYlCZCMcihqNjsEVzOdrld+meTAgEyJB9J
         sDRKccj7QW8f0FxqxH+9w+eEzBODvZEXMsjddGY7Fwo3gBuqv6z9r7RCKa3nR29+Gohq
         WQlSpJyqUfwKn54bfGQFrSpe0G2q+UG+90OiVbLqriik6OM6Jxe8Q4B0qFxO6YUMHzhA
         vT8Q==
X-Gm-Message-State: APjAAAWNo/ctuSn6iVs31dMYtZ6sKPMTqVhPbyKhc+AAzgBlh7ASmqYY
        fJpdAGbezh3r6g0UuY4IOR4=
X-Google-Smtp-Source: APXvYqylbOMNWzPXkQCyx1fdsnM9gzLcWS/ReJPYB/LwereZThQ7ooEHZnY1Cm+JwTFl0NYK0AiCaQ==
X-Received: by 2002:a62:870a:: with SMTP id i10mr23043761pfe.259.1569073533602;
        Sat, 21 Sep 2019 06:45:33 -0700 (PDT)
Received: from nishad ([106.51.235.3])
        by smtp.gmail.com with ESMTPSA id o64sm5543682pjb.24.2019.09.21.06.45.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Sep 2019 06:45:33 -0700 (PDT)
Date:   Sat, 21 Sep 2019 19:15:25 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: Use the correct style for SPDX License Identifier
Message-ID: <20190921134522.GA3575@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style
in header file for Distributed Switch Architecture drivers.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/dsa/lantiq_pce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_pce.h b/drivers/net/dsa/lantiq_pce.h
index 180663138e75..e2be31f3672a 100644
--- a/drivers/net/dsa/lantiq_pce.h
+++ b/drivers/net/dsa/lantiq_pce.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * PCE microcode extracted from UGW 7.1.1 switch api
  *
-- 
2.17.1

