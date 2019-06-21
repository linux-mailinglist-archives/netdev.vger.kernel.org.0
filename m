Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABC84ED41
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfFUQkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:40:21 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44099 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUQkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:40:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id t7so3254429plr.11;
        Fri, 21 Jun 2019 09:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+LmO7ticrmC3JfIg4AQOqPuyqJt0GySV9L0s39/uDrw=;
        b=bX1+vj4y8vN6rtL+XEllGurzFlBmP/jtny9CO82beZphLgDbQLa4wrGLVjLp3mCMI3
         ZPjztdEuXY/9iRPl0vPJ44rCBmkzzJ9QwF4fjdnlucDDK40vh3LjawXjMCk3VbBW8l4Q
         lZP0d/sPQrwsL0ifMWpIYJAhTIy8FsaRfqEYHrtym1w9rjIcYTCe2hWgDzAYLSDHGFgd
         ynzdjh+bR8dqm/x+sfvTHrhmR7ertFM6P/UTWRc3/HxRg0Y4udKNyeW8lLMAZV+PRNZp
         fEVLrPutlc9p5SqIwBZDUgE0d1uJTjeJoSZOh6KzmnsWy6UM35PlwXgkkN16VI04RE0F
         CvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+LmO7ticrmC3JfIg4AQOqPuyqJt0GySV9L0s39/uDrw=;
        b=TQRfy7vGd3L26KPoZBeZXHQcSacL+AUQQG76odn1OuTB/Rz8RK+eMtd/r92EzKqSrz
         qyl4f/VvY5aTn9MWRBL0lSiu3HbMIcEz7eeppSjm+oP8aCZx+HGeoEB9U1SwTOmA2csf
         a9iNvvb/zzu/cSjX/EtXAlzHybOvyp5IQ/Wr9waRE/+XYeSY7zRsMiAIjGJtOLugaoEO
         F4OKx7YU5jgD74pvz7OwyahlgvVXNz9asY5Ej5IjkB74aU0IzUG682hhmVWQ+Fugvgj2
         GcwLLyqEb3s8eXh9pgib7qJcBmLk4zZwula3iZCPoWua7v1yd1ndIAYmCyf5zs0uYXDy
         mWtQ==
X-Gm-Message-State: APjAAAV4Ta780i0fYZ4XI3L4WeV0EGR9ct/SDoYoU2TdJzxfAJ4FAo62
        YkLZ0paPAgDhdCdCqcc9qnY=
X-Google-Smtp-Source: APXvYqw7gTvJNhEDHEATxSdI6uuCNc7jtakHAR7EjGw5f/OMefYzh0AMXWEttyJiDdlMlsWRVLy85Q==
X-Received: by 2002:a17:902:1e6:: with SMTP id b93mr88496629plb.295.1561135220028;
        Fri, 21 Jun 2019 09:40:20 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id n89sm25702450pjc.0.2019.06.21.09.40.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 09:40:19 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/3] net: ethernet: atheros: atlx: Include generic PCI definitions
Date:   Fri, 21 Jun 2019 22:09:20 +0530
Message-Id: <20190621163921.26188-3-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621163921.26188-1-puranjay12@gmail.com>
References: <20190621163921.26188-1-puranjay12@gmail.com>
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
 drivers/net/ethernet/atheros/atlx/atl2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 478db3fe920a..58abadd18df2 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -24,6 +24,7 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+#include <linux/pci_regs.h>
 #include <linux/pm.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
-- 
2.21.0

