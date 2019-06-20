Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F104D81F
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 20:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbfFTSYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 14:24:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38359 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfFTSIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 14:08:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id v11so1984973pgl.5;
        Thu, 20 Jun 2019 11:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DElqIywf6JUcWuo0rZ9a6EwgIu3tUka4AvA4dzhpqYE=;
        b=G56l50yP0b6U6H4NdWWf/Dv6OP6WqAUmAoeWuHJJqTwqT9iaG1vBNKZYsh5Giuvhnw
         aED6fgUw54XLonnrYNZZv6Cno7U/zr4c6hcbl+H3d+KIDs2Xsx/z2U/1261AbHzKUg4r
         oNevhrr0tWXaP+L6SoMosXmCiEhK2au9AS94MvDNOVXEwA7u8oD/hgDDguZ5dMs3SmmP
         82tINfOSiarXeRImZlPpp3hhFmrUQbvD0DLpiDzKwclAM+5YRCCqtJtomlq9zwQ1rafp
         1r4t6oeiUv4rhpyyu/UiaUGP3QKBRvHniTQvlPiXqkGo/QBlcDlWFUa3//uYec3h3w3o
         x9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DElqIywf6JUcWuo0rZ9a6EwgIu3tUka4AvA4dzhpqYE=;
        b=JSfGMimt+X1IwGqxjHvpX04hgM6klerN2EhgyT5vshNAiDubNK2SjntOH5IGKRnOSV
         t53Bc4JyjUvqPVJV7aVd9pNoRuW2msqDaWzvf5tCwPmWoIHwoEGLI/dQojn5FcqcofrO
         240vpMGrP5b0quXyklWYzWsAjKWkssAHRurvz8I1tdgiRfqRCG6yUpNgZPbNQk/hFp9x
         fL95t4vb4F2k/hSI9o1eoGgFYbzKnPNtw3A/8YdL50CGfHPvuiHIeFQvE8XSD+cgwcwg
         6HDKUZLSNYy1t0thi5NZSAC7tO09jTEJ8CcOz84d+3GfTavDLaWa4UqcG1tslgfNnX+B
         55kg==
X-Gm-Message-State: APjAAAURfnt1lQ+ueMn9P/ZUj4gRKP/Ed9atGLdoCykepPSSe8kXSmIU
        aasbwHjyEIuPVJlB6OV0g2s=
X-Google-Smtp-Source: APXvYqxFAQJsCXYzQ+qH0cA1M0uMpESe7qshj8mj8l4KMcP4Yo4JkiXtEV1IBXTaRIWBw9MoK6+1kw==
X-Received: by 2002:a62:3c3:: with SMTP id 186mr14403969pfd.21.1561054119280;
        Thu, 20 Jun 2019 11:08:39 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id 85sm289016pgb.52.2019.06.20.11.08.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 11:08:38 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 2/3] net: fddi: skfp: Include generic PCI definitions
Date:   Thu, 20 Jun 2019 23:37:53 +0530
Message-Id: <20190620180754.15413-3-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190620180754.15413-1-puranjay12@gmail.com>
References: <20190620180754.15413-1-puranjay12@gmail.com>
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
 drivers/net/fddi/skfp/drvfbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
index b324c1acf195..e8245cb281f8 100644
--- a/drivers/net/fddi/skfp/drvfbi.c
+++ b/drivers/net/fddi/skfp/drvfbi.c
@@ -20,7 +20,7 @@
 #include "h/supern_2.h"
 #include "h/skfbiinc.h"
 #include <linux/bitrev.h>
-
+#include <linux/pci_regs.h>
 #ifndef	lint
 static const char ID_sccs[] = "@(#)drvfbi.c	1.63 99/02/11 (C) SK " ;
 #endif
-- 
2.21.0

