Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDA92B2CD1
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 12:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgKNLKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 06:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgKNLKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 06:10:35 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7265BC0613D1;
        Sat, 14 Nov 2020 03:10:35 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id g7so9651693pfc.2;
        Sat, 14 Nov 2020 03:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YNatTsbYkweFKdnOleBf0bsCzUL4SJDHgNbE+iqTc5Q=;
        b=F9n/TfJo5sOrNAeHMKRsi2G9F4nVU2YzCNxvS2Uv32YYB3fthPiYKks2Zxwz7o2klS
         Y0z7jZ1a0DBauUZsybL1yjrCR6MrEmOeKKMDRUms0Aq1GBZJ18ENzc4yhLTQ4vZoNxs0
         z0qrTDq82ri3KOYuvZEMuWkWbGpK2c1lXQfb+Z1l9LJ7mqLph6SWfHJncLuZppB77rwN
         UvkQv0mozTEzBP7KubgMMhWauGnxK18dlNrpwOowNHvDaQyvFGqBsnODMM9+heXd5Zjw
         XIf0zayWYEB73kSfnQMT+hfBwsslxbIl2Vv7tVubLtkjLbMQmQzKMg1mojWLdS2UQwlz
         pq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YNatTsbYkweFKdnOleBf0bsCzUL4SJDHgNbE+iqTc5Q=;
        b=ZadBTVwy7cr2zy+Olyh/VDnoML33LoHReQEfbZD66o7RiHD0BfhGM77XyzLfz5c7CN
         XoAdfT5FXbh4IF8q2GTXmXpcf2mRa8ZEyiCzQsF35ME3pyiyjyqsrpdYq0ynWi5fcwp3
         GtnKu/EPWQwcigWSsFEaKr8boXHKhRWepNdofVoXgIcGdnC50xl4FmH64hrrLTtNvAfU
         P0wLSiH490Ai+j2ULyUMCQki5QygS3pugCy/GhC9RRo7PLUKhi7wWy88OpWBILpzOH5I
         EY0MEl9ne/h8HQX5LfaH9IJQpc6q2iH4wXMRNerKhwJFvTOFj38BUEzRIKXiwxh3OLMy
         9awg==
X-Gm-Message-State: AOAM532rDWxGo4f9vXirALghV7ShRl3ucIHzT3NhQ4M6ClEZMUqqv9kw
        MAfbU/prce0rcRSUL2VL3y8=
X-Google-Smtp-Source: ABdhPJxEJx655OTIW0L7EVIt9fXu1zhmZz2wknk5dKq4p1xACL2k8X7Cb4Vo5qKTKsxCg9a6OiXFhw==
X-Received: by 2002:a62:254:0:b029:18b:fcea:8b7c with SMTP id 81-20020a6202540000b029018bfcea8b7cmr5869149pfc.69.1605352234959;
        Sat, 14 Nov 2020 03:10:34 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:98a0:19b2:d60d:c0c7])
        by smtp.gmail.com with ESMTPSA id e7sm10938369pgj.19.2020.11.14.03.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 03:10:34 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: [PATCH net-next] MAINTAINERS: Add Martin Schiller as a maintainer for the X.25 stack
Date:   Sat, 14 Nov 2020 03:10:29 -0800
Message-Id: <20201114111029.326972-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Schiller is an active developer and reviewer for the X.25 code.
His company is providing products based on the Linux X.25 stack.
So he is a good candidate for maintainers of the X.25 code.

The original maintainer of the X.25 network layer (Andrew Hendry) has
not sent any email to the netdev mail list since 2013. So he is probably
inactive now.

Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 MAINTAINERS | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index af9f6a3ab100..ab8b2c9ad00e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9842,13 +9842,6 @@ S:	Maintained
 F:	arch/mips/lantiq
 F:	drivers/soc/lantiq
 
-LAPB module
-L:	linux-x25@vger.kernel.org
-S:	Orphan
-F:	Documentation/networking/lapb-module.rst
-F:	include/*/lapb.h
-F:	net/lapb/
-
 LASI 53c700 driver for PARISC
 M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
@@ -18986,12 +18979,18 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 N:	axp[128]
 
-X.25 NETWORK LAYER
-M:	Andrew Hendry <andrew.hendry@gmail.com>
+X.25 STACK
+M:	Martin Schiller <ms@dev.tdt.de>
 L:	linux-x25@vger.kernel.org
-S:	Odd Fixes
+S:	Maintained
+F:	Documentation/networking/lapb-module.rst
 F:	Documentation/networking/x25*
+F:	drivers/net/wan/hdlc_x25.c
+F:	drivers/net/wan/lapbether.c
+F:	include/*/lapb.h
 F:	include/net/x25*
+F:	include/uapi/linux/x25.h
+F:	net/lapb/
 F:	net/x25/
 
 X86 ARCHITECTURE (32-BIT AND 64-BIT)
-- 
2.27.0

