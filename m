Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20621C4643
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 05:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfJBDn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 23:43:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35092 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfJBDn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 23:43:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id 205so9601595pfw.2
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 20:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:user-agent:date:from:to:cc:cc:subject:references
         :mime-version:content-disposition;
        bh=C7Y6GNwgOVjjd9tAC+Hjo3zo6r/vBfLVHDVqF6AtxyA=;
        b=IxYQW2RDM93VdsYzai2Mjy44lCpEgALcsvvuI9OdrIn+cLosKczNi/vUgC+5hO+DTo
         Av+9U+CZJtpx1VmEC5f87hev5rVMDDI3l1/RQfEc7dH3y/hkjmPWLzy+Askd7rBF2Cw4
         Mel5lEkbEV1Ug3tMHyYnSxbQLsuFNqFwqR7mkNgou4loZCa2ePqkNFVav7knO73PL5Cg
         lU+mQuYbagbv4pyrSQYY7s91Utje+clNUPmZfFMvqSWdkq3DTUZ4dgYkgT2la+yiSlTh
         ix9uies7KaODDYE8gO4zEWF8mvwHr14xX9ufpzMzS9rqv+XXrtBQTsbh7m0xGh7GTxJp
         ZnIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:user-agent:date:from:to:cc:cc:subject
         :references:mime-version:content-disposition;
        bh=C7Y6GNwgOVjjd9tAC+Hjo3zo6r/vBfLVHDVqF6AtxyA=;
        b=DZh6GqnRsT/YOp+2ocLeehDIcRvvEeEbyxhXuWHCUkNYGE3aUGv7onzN+7j8uIkndF
         3mpdgfXcjL7QbhdfUZ8yEaLLYg00kFxZn2e98WoH2tpWj9Xrt1lh7qZ5ASiraeD3ubtC
         nlPBeOkt8Pou1JoqBqzcWXxEHVTLc1JUhyBlsDVRVGp7T3jOdyNfQrHmjzSuX1TF4K++
         z2I6eMQ3ZjqpvXRt9cznVy/hSYenJaPCBDPzVgI+z38tvmsmyoCVRp7Dwu0yk3GF3aRb
         OHHplaNfHz1GngHnHyXOO2OkJB9EOtjztLalB+GKns41ira5I5XV5BIK+w4A/8TTt7N7
         niaw==
X-Gm-Message-State: APjAAAU1IhLXYLs5VPV/TH4nNWNy5nz9NSBd9r0f6zpkrT5e4P7thEaL
        MlRM/mvJSwDtiZWEb3Crbfpymoq7
X-Google-Smtp-Source: APXvYqwgRo22KUotPzfcwa+Y8leZGWVcXqfk9fgxrv970xJ6Qpm0vr8aJ048EllZmZYDyMlcYidmkw==
X-Received: by 2002:a63:d05:: with SMTP id c5mr1414257pgl.182.1569987837264;
        Tue, 01 Oct 2019 20:43:57 -0700 (PDT)
Received: from localhost ([2601:1c0:6280:3f0::9a1f])
        by smtp.gmail.com with ESMTPSA id h8sm18064239pfo.64.2019.10.01.20.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 20:43:56 -0700 (PDT)
Message-Id: <20190920230359.064400931@gmail.com>
User-Agent: quilt/0.65
Date:   Tue, 01 Oct 2019 16:03:59 -0700
From:   rd.dunlab@gmail.com
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
Cc:     rdunlap@infradead.org
Subject: [PATCH 1/3] Clean up the net/caif/Kconfig menu
References: <20190920230358.973169240@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=net-caif-Kconfig-clean001.patch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the net/caif/Kconfig menu:
- remove extraneous space
- minor language tweaks
- fix punctuation

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 net/caif/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- lnx-53-caif.orig/net/caif/Kconfig
+++ lnx-53-caif/net/caif/Kconfig
@@ -13,11 +13,11 @@ menuconfig CAIF
 	with its modems. It is accessed from user space as sockets (PF_CAIF).
 
 	Say Y (or M) here if you build for a phone product (e.g. Android or
-	MeeGo ) that uses CAIF as transport, if unsure say N.
+	MeeGo) that uses CAIF as transport. If unsure say N.
 
 	If you select to build it as module then CAIF_NETDEV also needs to be
-	built as modules. You will also need to say yes to any CAIF physical
-	devices that your platform requires.
+	built as a module. You will also need to say Y (or M) to any CAIF
+	physical devices that your platform requires.
 
 	See Documentation/networking/caif for a further explanation on how to
 	use and configure CAIF.
@@ -37,7 +37,7 @@ config CAIF_NETDEV
 	default CAIF
 	---help---
 	Say Y if you will be using a CAIF based GPRS network device.
-	This can be either built-in or a loadable module,
+	This can be either built-in or a loadable module.
 	If you select to build it as a built-in then the main CAIF device must
 	also be a built-in.
 	If unsure say Y.
@@ -48,7 +48,7 @@ config CAIF_USB
 	default n
 	---help---
 	Say Y if you are using CAIF over USB CDC NCM.
-	This can be either built-in or a loadable module,
+	This can be either built-in or a loadable module.
 	If you select to build it as a built-in then the main CAIF device must
 	also be a built-in.
 	If unsure say N.


