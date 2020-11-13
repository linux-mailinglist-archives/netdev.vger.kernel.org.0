Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C472B1641
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgKMHRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgKMHRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 02:17:54 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFD8C0613D6;
        Thu, 12 Nov 2020 23:17:54 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 62so6364714pgg.12;
        Thu, 12 Nov 2020 23:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XpJielsbomltdVuB/z23PcsD4Eziba/o/K52gFXVFZk=;
        b=uNV/kWP+dsjXI+cZgNVlaqPRfkKeRVskzhe/QoisWIqygNxK9KSdrzf/UQMbDbWOXj
         cDNOcRcKmnSwx2oB6HwROjnUGKm25rgB5AZRO9RJ5ITG96oQVPh0O4OPvyDGFKIUTB85
         wFEvZT8XRzqWJMG1HJzK0I+bm7FYZvVBMsN9ZPssZgODgL8lunYKldNmpNI0gVv/4QIn
         CXixMIJLPclON2bXBXeDu8+66whQRFpUjFRsX+VvBkpJ3Zme0JkScUPpcvNX1Je75+bs
         lGrsL+OgXSDw39H4BEMPz3x5tM15CVAbYIt76ZohQKWudg+pdwN4gbzwoI5dmwqGof3r
         L7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XpJielsbomltdVuB/z23PcsD4Eziba/o/K52gFXVFZk=;
        b=WnT9ku8C3IiQj0JK6rF4PC4IDoWr1m26r/s2d3wWPCp62LJ1yu3Be9GW8iOTRkIJDw
         Ucjy5g0zXEqDBStDt1YHqjGxJkbtTe7fMNadgasDlgAEJDub5y7/HEgUD4q/e+Ih2JyG
         DkTy6uPufNkCkliLWzw3diNF5aRBaqlQINRIeDujKBXGIvTwR6o4GxpUW0l4fXI281Rr
         XqfruVgRNfh1K4hXZ6Q+4UlyPBTZCgLmkYoRJsmluxbBT59saOO2j2To7D00t/YfScZR
         4MeIgf1Hl3cAzawQtk2CIMOzGQ53WUL9YTYfjPjB9896vi3SE/KOukvT0jLq0XD3hwkh
         sfBQ==
X-Gm-Message-State: AOAM533pnFyIPxVW4Eq94B9N/tmgyjxemRQtVecldMLQdDAsuJAIEcKf
        I/pnsuhx1OMgzJbNFoN3hRM=
X-Google-Smtp-Source: ABdhPJzWJ/ZnHZuLCY7A1QRXg1T6LOIn9MfMOo+gbPzT9A9wL/lfaxO7GGPMT1WE8rNM5WLGcxiaNg==
X-Received: by 2002:a17:90a:1992:: with SMTP id 18mr1470731pji.67.1605251874060;
        Thu, 12 Nov 2020 23:17:54 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:3e5e:820b:3892:3f80])
        by smtp.gmail.com with ESMTPSA id 3sm8847259pfv.92.2020.11.12.23.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 23:17:53 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Arnd Bergmann <arnd@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: [PATCH net-next RFC v2] MAINTAINERS: Add Martin Schiller as a maintainer for the X.25 stack
Date:   Thu, 12 Nov 2020 23:17:11 -0800
Message-Id: <20201113071711.29707-1-xie.he.0141@gmail.com>
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
index 2a0fde12b650..5adb78cb0d92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9832,13 +9832,6 @@ S:	Maintained
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
@@ -18979,12 +18972,18 @@ L:	linux-kernel@vger.kernel.org
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

