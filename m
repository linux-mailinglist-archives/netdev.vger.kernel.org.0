Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7E94EC5A
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFUPlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:41:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42243 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfFUPlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:41:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id ay6so3171306plb.9;
        Fri, 21 Jun 2019 08:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QLu3Y0O1Cdy8sgEXtdnAkdEST9WDREreBBj3EafUb+I=;
        b=Ccxv6uFkPsDJh0cQmQajZCu7F58DZHUotKtX0SR1i7GWrZVwRHE3ZXuX47NpUARq04
         8CmAQXQY6rQipAfUC9ZMdb2pK2txncwKOTgqcWK5XW6yM33zAAcuGL/uzCYNpemOeAz/
         vw8iQvolbsSDaoYt0N6wVHEWuIt6tw+6k3jWnqJQogDmeUkt+k/HTJ7tOOitFBm5wOXV
         EHwaqYa8OvmYvlhf6v/7Hg6bVwRpVVe4yVokrbqOtzlCkXKjUAPwIAzgREmwBcidcjIg
         OtNqG2l2lgacEQouZa4wrNb2RkcPtiU68c5M2SG/WisFiEuW4r06r8flia8qorJcusKe
         6N5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLu3Y0O1Cdy8sgEXtdnAkdEST9WDREreBBj3EafUb+I=;
        b=sNplMAlGpij/yTkNOkW6VPYUvImRRRa3BhSSuOEOm5FoyNYLlDbZSudqWx2WDK2abB
         y3T6+zbA6In13M5FlRYoiU+A9mO8BZKSjcfS7N+NQKT846mXxDJ+ygD19xi0UlM30Ckh
         5PT288zVT0PhGzFttd3KF9JakttSIIXZHST0YZllpyEqA/kWXGWFevK5im73P33GzqV4
         LoYM1jyepT+k6Mzh4MtdIVeYcKAp/iezC888BW3yKl0bm4CBL3TAYt7hajsftQlrq/Kz
         x9ntUWwLHa452H9GUk2iCiutUITMPBuVcXHNmKqD0RwM4LbhREviJqdc5T0p8bnQj5SH
         xpTA==
X-Gm-Message-State: APjAAAVLaizxZmaSX3a27fKpts+ZOd5v3kSxz+v4If3KFeJ/BaOdv2mY
        RuCLm3xHGf9qJleLHgSTs1Q=
X-Google-Smtp-Source: APXvYqxacu24UAN5Jq8gCz/7WNJmdaqkkrCk2PCuFq6mjWTexzd3GwRqmJs2sT3R2WVRfhs1nAFQJw==
X-Received: by 2002:a17:902:9688:: with SMTP id n8mr49999680plp.227.1561131668159;
        Fri, 21 Jun 2019 08:41:08 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id m8sm2556940pjs.22.2019.06.21.08.41.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 08:41:07 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v5 2/3] net: fddi: skfp: Include generic PCI definitions
Date:   Fri, 21 Jun 2019 21:10:36 +0530
Message-Id: <20190621154037.25245-3-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621154037.25245-1-puranjay12@gmail.com>
References: <20190621154037.25245-1-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include the uapi/linux/pci_regs.h header file which contains the generic
PCI defines.

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/fddi/skfp/drvfbi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
index b324c1acf195..9c8aa3a95463 100644
--- a/drivers/net/fddi/skfp/drvfbi.c
+++ b/drivers/net/fddi/skfp/drvfbi.c
@@ -20,6 +20,7 @@
 #include "h/supern_2.h"
 #include "h/skfbiinc.h"
 #include <linux/bitrev.h>
+#include <linux/pci_regs.h>
 
 #ifndef	lint
 static const char ID_sccs[] = "@(#)drvfbi.c	1.63 99/02/11 (C) SK " ;
-- 
2.21.0

