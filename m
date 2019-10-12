Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9CAD4FF1
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 15:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfJLNMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 09:12:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40959 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfJLNMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 09:12:39 -0400
Received: by mail-pl1-f196.google.com with SMTP id d22so5779636pll.7;
        Sat, 12 Oct 2019 06:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=fJ+PFaaP+B+Q/EtiVfrsJVrXqtyueeEIeoYLfvXIfuY=;
        b=OIPN8/ETepz5A/lxGcqrB4I/RGEAp4A+21kyrIIoFaN8eS/Z+j8+37qf5lCTk6326X
         IYLSgfctqTaj7XQM44Oe70qlZqIzP4Uh0OjeAMlT8iy99ucG34Mi7vDDatIJYGtplRhC
         XxnLSFijbd9M+eW31uf47oPMWqVznWAU5yqVgMg/Q+liShHh5ZS7pJH3BB2nuDP9uz8M
         63+M28ylynnvs+JsOaYghZ85MAupg9wcCuYXec1jvzIpRfsjFZDaBszCy4g8eizppAFm
         +CQa0WHkQ3vJR2i7rAkUqS17clwPBtbngVVkvheTYeyLE1eiq77AbJfaXeeZpW7TAPRP
         6kZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=fJ+PFaaP+B+Q/EtiVfrsJVrXqtyueeEIeoYLfvXIfuY=;
        b=dC6l/c/HsqIfB0vGVSyABCnH/yf2k8gABWvKc6mWCo5S36OD3AIRzcymaUxGXMQtss
         XhDxcyj6Q8Jz6ORtrweyvo04vdIejiZ1ESSHq4vhpeAlGzmiOmWbdvGrp2MavVaMqfSn
         dK1NYOzHMxD/xYNSFA0LAyC7XrMrZXC7/KAyo0UEul3p1B+nA8VyeGKuKH40CL6dQ2mC
         7KwlfO7BUtqOTML7KdMzgpI0y1JW/664kmb/IDGiq9SPP+eIm8ZvhXGJNzGKYslE2Q+n
         YFl18TgppbZuqb/KqWG8LITDgUR+7qV9RYbaT8wjdQqBBG6eRpFEqikXPI9HA53OFX04
         13aA==
X-Gm-Message-State: APjAAAVjIBCIwqGYTApUDOu63LA0CKkrHjKuS9PPZEeA7xhBoglGNhzO
        FY5az2MlXwmVdvrC5aQiuW4=
X-Google-Smtp-Source: APXvYqwrIZfVGA0FwNgVrrMR2T9kxwqpnNUK9zJtuDZwG5bUI79nqD8Wfm+dhQ8V1uW09U5Lq+ehXQ==
X-Received: by 2002:a17:902:a712:: with SMTP id w18mr20484206plq.304.1570885958151;
        Sat, 12 Oct 2019 06:12:38 -0700 (PDT)
Received: from nishad ([2406:7400:54:9230:b578:2290:e0c4:6e96])
        by smtp.gmail.com with ESMTPSA id n66sm19392874pfn.90.2019.10.12.06.12.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 12 Oct 2019 06:12:37 -0700 (PDT)
Date:   Sat, 12 Oct 2019 18:42:28 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: cavium: Use the correct style for SPDX License
 Identifier
Message-ID: <20191012131224.GA8087@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style
in header files related to Cavium Ethernet drivers.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/ethernet/cavium/common/cavium_ptp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/common/cavium_ptp.h b/drivers/net/ethernet/cavium/common/cavium_ptp.h
index be2bafc7beeb..a04eccbc78e8 100644
--- a/drivers/net/ethernet/cavium/common/cavium_ptp.h
+++ b/drivers/net/ethernet/cavium/common/cavium_ptp.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /* cavium_ptp.h - PTP 1588 clock on Cavium hardware
  * Copyright (c) 2003-2015, 2017 Cavium, Inc.
  */
-- 
2.17.1

