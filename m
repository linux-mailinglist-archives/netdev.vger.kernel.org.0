Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA9B4E47B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 11:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfFUJq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 05:46:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37566 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfFUJq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 05:46:56 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so3322453pfa.4;
        Fri, 21 Jun 2019 02:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QLu3Y0O1Cdy8sgEXtdnAkdEST9WDREreBBj3EafUb+I=;
        b=M76k3QxSNScHh0VJNte68u7m+EbkxwGAvxVC0a4q1T0qNXcy5pDlQfWJ1V0xi1dyVr
         +kcR+ROpl0Cn6zqVD0pnHLavTertBoRh8oj/FgAgn6E5SVK/HwX8Ho75wQu1OoceyI8L
         m5MtcUdI7adrQMPUdr7/G2Xi+9gZF7x/mhfn95BiIng/iR44P6U3gqfZN1XnAPTd8xqW
         bHQ3JNnPqPuX5N99Pq1N9ur2z3V82pnYUFFK3Md+jq2nse2VFeMO/HjTGAq5M4MIHJGD
         kXEjoNhOy3+4Tb8HNvVpKN8UVDvck1FFdpC8r0v/Uj2DuJux/dHtBni2oi1dLB8sq4Z4
         reJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLu3Y0O1Cdy8sgEXtdnAkdEST9WDREreBBj3EafUb+I=;
        b=TXRBoXt9mN9oG1bgQ5j3ay5w3v8myweHt7KL3R5H6pr74FOm0vbWdlHQul1fgsv7Xr
         sP7a/sDchihuImK4aCKKr/hlBMujjjJDLRaJnUJVSsUsOvQ3IkzgR/GHSsR2p6iWfo8x
         kjUpWQBTHnS/gzH/sH3dIlRRk1kXtt1u/6sGiwHxjg6IvvhdkX9VRq/1sdaC+y3z0LtE
         lIGXzkxv73VeB+vFA6yNqSwM9C8CMfn82HbUc/qkt9Fh2H8jPqbX3TzTuqfYvyYdpW0Y
         SGHDym0XcIY5AodvgAwwxA9PZwU0tD9taDYs66k5USH3G1MkfQZs0Y4jps5iuumaTLwH
         rLUg==
X-Gm-Message-State: APjAAAWsAXn01+NEqHjTtRQqbs9FGX3X+ksFyH5ntdA9zyQoDNnmqFEW
        RW2pAUuK5zguWAxUvA8v6JA=
X-Google-Smtp-Source: APXvYqzFOThzE1HdyO3wP/KoX4pXxHjm+uPqz97SXqRGdESl2Wc/eMZzTkT3y4y0+soj0B7lG1f1wA==
X-Received: by 2002:a63:e14c:: with SMTP id h12mr16771008pgk.87.1561110415369;
        Fri, 21 Jun 2019 02:46:55 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:913:88b1:ac7e:774f:a03c:dcac])
        by smtp.googlemail.com with ESMTPSA id u2sm2147746pjv.9.2019.06.21.02.46.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 02:46:55 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 2/3] net: fddi: skfp: Include generic PCI definitions
Date:   Fri, 21 Jun 2019 15:16:06 +0530
Message-Id: <20190621094607.15011-3-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621094607.15011-1-puranjay12@gmail.com>
References: <20190621094607.15011-1-puranjay12@gmail.com>
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

