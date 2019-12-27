Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB1712B189
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 06:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfL0Fv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 00:51:59 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39831 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfL0Fv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 00:51:59 -0500
Received: by mail-qt1-f194.google.com with SMTP id e5so23875948qtm.6;
        Thu, 26 Dec 2019 21:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=kdHgW0IrRQQGnWtRUw8Yax1lznE+QBcpJNp1naTP4pA=;
        b=FU8h15ZIlY4jJPjz3cR3FBFAq7cRnbi70Xe/4+/ixQg9Iv55wr8nfWBHMkL8yskChO
         1kCOKScYHkbWhFlqR6747rPWZ5oFHL2+OE3malfcuP4ulAz4duTYkLzXak32n6CmsjlG
         6EJwX4LfncVSuU1W/57tHoCdlQtcA+Kqwfgb7e08Pih20qNAUN/jbic32WyCxmcDsRjd
         7uTRkXUwbhDt3+KlEB/8FbzCQuds1mQW7MISbu7z17KxiVwIE2r/6l0l3pUi9j9wbHcy
         rf9sw+HG7hQXMBxbggTUsafpn7w4rVFVQ61A7H8meKXuXNqNHVLC/Eqfyn9aCy2aaViU
         wa4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=kdHgW0IrRQQGnWtRUw8Yax1lznE+QBcpJNp1naTP4pA=;
        b=YsWstrQDaJ9aSon3Vyx7Ohx2dya12TnS1ozIkuDgtc1oDNg8qanWQw12eD2rMcGRQu
         1x3ghfIxnCZNIE59GEItEqmKk3kK0zKv2/g5IP7IDlCNYWeUGX7oIMmcLAcYAHo98rH5
         5xsp/i7VAQiHcJJfYVEJPrFpWuS/Cl4ByflCWZZ5yBjHAPHSADhylqGunqeR/ug/MKz7
         3Lf6C6f2WBThGHsFJJEyNQXFCnKmYs6LKWlLXEVgscCDuCKjogfzBJAsz38hZ/jiATMT
         vT3qPqBi5xrp0jWiIhH0zQz4lbWbY9Hs0t7Tp33jSoWHmIRHZTqJzfZYGC2gVRU1Z8+J
         rRIA==
X-Gm-Message-State: APjAAAUD3hdFH1fAuLuqLlqexLhtPZwWqxiDCuQBIeRKFjAXTWuqxUNc
        5XLJRimJLTQaU/Cb7ebtdoQ=
X-Google-Smtp-Source: APXvYqy8SGdMk2QGHp5+RNknV8E9nlvecViA8zz6UK40MYogjrtAqNjwUKRM0wkvPBj9BTPKdTxFAg==
X-Received: by 2002:ac8:2c7d:: with SMTP id e58mr37463162qta.196.1577425918536;
        Thu, 26 Dec 2019 21:51:58 -0800 (PST)
Received: from mandalore.localdomain (pool-71-244-100-50.phlapa.fios.verizon.net. [71.244.100.50])
        by smtp.gmail.com with ESMTPSA id t38sm10484480qta.78.2019.12.26.21.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 21:51:58 -0800 (PST)
Date:   Fri, 27 Dec 2019 00:51:38 -0500
From:   Matthew Hanzelik <mrhanzelik@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: qlge: qlge: Fix SPDX License Identifier style issue
Message-ID: <20191227055138.erzmqrahz2xksfda@mandalore.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed a style issue with the SPDX License Identifier style.

Signed-off-by: Matthew Hanzelik <mrhanzelik@gmail.com>
---
 drivers/staging/qlge/qlge.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 6ec7e3ce3863..d7729a3ef816 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * QLogic QLA41xx NIC HBA Driver
  * Copyright (c)  2003-2006 QLogic Corporation
--
2.24.1

