Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D630E1F46
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392441AbfJWP0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:26:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37072 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732725AbfJWP0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:26:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so12358957pgi.4;
        Wed, 23 Oct 2019 08:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=eB8tBI6yDFyKa7RDqC5m4uIkOsXMXVXVRZ+cXb0whiI=;
        b=bt4/svf29WjLyXtdV/XTOBIt3Q+Q3s0L4pf6nH3frdrJltuIWuw4kc/D/yHT03/yIX
         33R2LmJhWwWva9Xr8g1JiQioza0GRzkJR5kwSYBehMSTr6pPXkLoYe5nLkH+lBwCGEIX
         MypnYI93gJIiuc8vfZp0v7Sv9HbsQAxrNPbtqI5RJug8YWy5fBH6+/Hh8gu/Zl1ts2SL
         hUH6OjfLrxhIeh4vk2bAyJG/eY99dZOKtP7ZxjYUqFainhP7jWoQxf1vmiYjQs/ykAS2
         j9JZeVzb63Au67+2PiAPVjMSS53I8Q9WrYNQzDfXU8hssZp8Z68uNKnaIgK+qMMT1pBN
         Kq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=eB8tBI6yDFyKa7RDqC5m4uIkOsXMXVXVRZ+cXb0whiI=;
        b=juefXAIBklvnl7Nxts54rXFqPVG7jTvjl7862ftwLeAh1VHqGNdxRAJoNsnV9lacfg
         OOw4mMBgcNHDnNOzVaqVi5vn1dXd1gsovyOp4AywB3lJrJB5tJNTQzJXUEEAsszT0Pcq
         2Jib3v5VX5AIo34d7+kH/UZv/Oa95G1adaNXdcb6JjIabutW8izVKyVpqm58r7PzDeG5
         5egSjNkuLanL025F8iLO/cQPh7PfsrSCRTlfmDCpQ1q5KaomyxE45BCVNAzUsZhzuTjZ
         TWGeMV6KyTwIN4Zmm2bSvqiO1N6CIzeGPJtelPFPKzVKhIA9Iznel6QXuoRx/rmrPNKr
         X5fQ==
X-Gm-Message-State: APjAAAVGR7xeUpSQe7AGuhoKpjehuNkQJdD2Yc6Q8H4XOLpgmG8gNFEQ
        tUbpbLl9S5Nd1CezntQlHOo=
X-Google-Smtp-Source: APXvYqyIu2N5oOaT8KT0563kjSMOnaymaWdlyH/6wjqSwBA6M7dEp0dcvB2RactEHhIT3daWCrVzyQ==
X-Received: by 2002:a62:8248:: with SMTP id w69mr11477291pfd.236.1571844405770;
        Wed, 23 Oct 2019 08:26:45 -0700 (PDT)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id k17sm32510265pgh.30.2019.10.23.08.26.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Oct 2019 08:26:45 -0700 (PDT)
Date:   Wed, 23 Oct 2019 20:56:38 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: Use the correct style for SPDX License
 Identifier
Message-ID: <20191023152634.GA3749@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header file related to ethernet driver for Cortina Gemini
devices. For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/ethernet/cortina/gemini.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.h b/drivers/net/ethernet/cortina/gemini.h
index 0b12f89bf89a..9fdf77d5eb37 100644
--- a/drivers/net/ethernet/cortina/gemini.h
+++ b/drivers/net/ethernet/cortina/gemini.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /* Register definitions for Gemini GMAC Ethernet device driver
  *
  * Copyright (C) 2006 Storlink, Corp.
-- 
2.17.1

