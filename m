Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838868AF2E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfHMGFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:05:42 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37280 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfHMGFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:05:42 -0400
Received: by mail-lf1-f66.google.com with SMTP id c9so75872757lfh.4;
        Mon, 12 Aug 2019 23:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5zt07Eoa1ycI7ox8mSSL/qwrX1PHGOhlUz3HEiThMhQ=;
        b=N0lZY//vVPaW4uShnsDoorYmV0G1e7RazGMG3NNE1jz0xoM+sGPGKfNr1yYr/Ao1ZV
         f3YwnQkze4sAnzip9qTuqwHD25fmED3qOtYj0lH98N51302WTshX2Y6L0CVrhrHkzX0F
         wU9o0JG1xEGqmyBBOUCR0l+wElM+KfcSd6qWkX81tippUWki8DPySNZt3Cl49ZPXvGfG
         2qoazLmH/8xKXIhvUw0Qtuz7aTnlTr3zgQaODGc2GmOfuu3+90O7PEHZSYhNREg6aYCh
         itk85w6w4aYfbRCgIXcjcrKAAOWRJ9/c8WqzfZHfR4OtGMm6mhXKo/2LSARZVLONS1eW
         b1zA==
X-Gm-Message-State: APjAAAVM1xxLHBuUXF/IjSLVYgWj2HIx1NUV1buNdQVA4iV08Gokbq63
        u4L4VWDIEUlMUoHJG46zgtFklCfM0Ek=
X-Google-Smtp-Source: APXvYqz7x0+9GQcedanCeYjvFHgaFR1ZNePXc3avojJiWzg/3aia86Ewg/Dr/+mKDN1JJxaROxfBMA==
X-Received: by 2002:a19:c213:: with SMTP id l19mr21054090lfc.83.1565676339906;
        Mon, 12 Aug 2019 23:05:39 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id n7sm4125276lfk.24.2019.08.12.23.05.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 23:05:39 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: net_failover: Fix typo in a filepath
Date:   Tue, 13 Aug 2019 09:05:30 +0300
Message-Id: <20190813060530.13138-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190325212732.27253-1-joe@perches.com>
References: <20190325212732.27253-1-joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace "driver" with "drivers" in the filepath to net_failover.c

Cc: Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51ab502485ac..c2117e5f4ff8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11071,7 +11071,7 @@ NET_FAILOVER MODULE
 M:	Sridhar Samudrala <sridhar.samudrala@intel.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	driver/net/net_failover.c
+F:	drivers/net/net_failover.c
 F:	include/net/net_failover.h
 F:	Documentation/networking/net_failover.rst
 
-- 
2.21.0

