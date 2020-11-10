Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F722AD248
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbgKJJUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:20:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:23648 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbgKJJUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 04:20:06 -0500
IronPort-SDR: /6xIOXuZB7i0dszf1oFQJ3wxiSqmf5itmnfW8DpUtS8ZjgFLZ7XlvXhN1AVOYYMph5qscgEwyu
 IQNK35CUl7aA==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="234110528"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="234110528"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 01:20:05 -0800
IronPort-SDR: VQ3bkORQylbkUa5Ab3nfvfeEwiK5mOUIfyQWxmHZ2xQ0QtRgJRJkUY5hIabKJt0M8tR9IhG0Cg
 OBiFd1tbcduA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="322785992"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2020 01:20:01 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id B0ADE60A; Tue, 10 Nov 2020 11:19:57 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 10/10] MAINTAINERS: Add Isaac as maintainer of Thunderbolt DMA traffic test driver
Date:   Tue, 10 Nov 2020 12:19:57 +0300
Message-Id: <20201110091957.17472-11-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
References: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Isaac Hazan <isaac.hazan@intel.com>

I will be maintaining the Thunderbolt DMA traffic test driver.

Signed-off-by: Isaac Hazan <isaac.hazan@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3da6d8c154e4..83c4c66f8188 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17378,6 +17378,12 @@ W:	http://thinkwiki.org/wiki/Ibm-acpi
 T:	git git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
 F:	drivers/platform/x86/thinkpad_acpi.c
 
+THUNDERBOLT DMA TRAFFIC TEST DRIVER
+M:	Isaac Hazan <isaac.hazan@intel.com>
+L:	linux-usb@vger.kernel.org
+S:	Maintained
+F:	drivers/thunderbolt/dma_test.c
+
 THUNDERBOLT DRIVER
 M:	Andreas Noever <andreas.noever@gmail.com>
 M:	Michael Jamet <michael.jamet@intel.com>
-- 
2.28.0

