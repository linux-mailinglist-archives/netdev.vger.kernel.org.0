Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB26F10B08B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfK0NqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:46:00 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39853 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfK0NqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:46:00 -0500
Received: by mail-pg1-f193.google.com with SMTP id b137so8542688pga.6;
        Wed, 27 Nov 2019 05:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=vERrabrkgnxjnqX37A97qe7ZrBqlXA28PjfJM9OLHEs=;
        b=vhDKKtQVYa3uip6zJLAtdyym54VzS7Sz3TDkyaSZUFFl5hi9nWz6QzzYE8u6jkR32Y
         myj890qYqUsJX79AIl3LKV4oLNaP477NtxC7V+dNWLL1uuCBzGEqMtaof+giXgg9Tavg
         NrdfO6FnRRgL2W6OTd66GktIBvTYvl3mCrqKVKy0YWXejGLmoPjsFmEatgYTfr+xL1gr
         MoRbC8y4/P29OUsENhxLXESjLWjLvEnnZjD+Rla9QVO68H/dLZcM4rBwMFFK0yJRgwf3
         9Psm/nytw4EM1Re/JT/6N+lBrAx/CxZaVc5T8L5D4O7suSxJGHdW8d7yM5ZMz+sG8G0M
         xXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=vERrabrkgnxjnqX37A97qe7ZrBqlXA28PjfJM9OLHEs=;
        b=Rl8UOdSflk3lqz6s0MrGzxOElRQw1EOeWlw14XnwqVFb2TX18129IFB6RSDXYm+aFG
         5iQXpUTsJYv8bZwgQm4nF5r0EFFNUrxsgxirZMIJ3dHH+OMwciph0rrvfBUo78kg1QP5
         NVNkHFbFTtLHmlrsjW6NS0ZHoT9uWrzl9yuNHrvUIMXDpdKYzza8drUZcAJkcErY5Cyo
         xTtMGZw7BI+N6yl24U26E2WmYl7YgfEmp/SLV7uDeJ3ira2untY2kdc96Un1iso9oaGs
         UMdKtNOXjdOpU5DKaZxJQygHtlFocX3oO62GlpvmSdJ3ByZ8mlvRO/RBV8ZHw6hQlaqV
         HDqA==
X-Gm-Message-State: APjAAAWxKHR6XinzaaAyBOm4KWW2sKnyuGNeFmtKPV8xKcnN2UjzV7VQ
        GCgTS3spvlLp0CVyYLlIpyk=
X-Google-Smtp-Source: APXvYqxW18iovg6dNYrWZseSM/kB1zPWk7S6zPWhKn7TTU+vLpJWFXlK/ZNf5Wz7oAxx/5gxXb9iXg==
X-Received: by 2002:a05:6a00:10:: with SMTP id h16mr49317604pfk.27.1574862359419;
        Wed, 27 Nov 2019 05:45:59 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id p5sm16813534pgj.63.2019.11.27.05.45.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Nov 2019 05:45:58 -0800 (PST)
Date:   Wed, 27 Nov 2019 19:15:52 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: aqc111: Use the correct style for SPDX License
 Identifier
Message-ID: <20191127134548.GA29603@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header files related to drivers for USB Network devices.
This patch gives an explicit block comment to the
SPDX License Identifier.

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/usb/aqc111.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/aqc111.h b/drivers/net/usb/aqc111.h
index 4d68b3a6067c..b562db4da337 100644
--- a/drivers/net/usb/aqc111.h
+++ b/drivers/net/usb/aqc111.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later
- * Aquantia Corp. Aquantia AQtion USB to 5GbE Controller
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Aquantia Corp. Aquantia AQtion USB to 5GbE Controller
  * Copyright (C) 2003-2005 David Hollis <dhollis@davehollis.com>
  * Copyright (C) 2005 Phil Chang <pchang23@sbcglobal.net>
  * Copyright (C) 2002-2003 TiVo Inc.
-- 
2.17.1

