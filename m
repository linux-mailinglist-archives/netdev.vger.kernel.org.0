Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41AD1696A6
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgBWHcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:32:10 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36542 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbgBWHcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:32:01 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so6109960wma.1
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lPq98DvLOBgDS3OkFGWgwniLlPjPEfUY82nNbD/WvW8=;
        b=1JJKIzAwkS3F3em17FPwA63ft2y+j1g6qNeTyCFg0C5VNbHbVozLRmIhBLS8yaIxrS
         NOh1KRDqiBT5sE7CeT2sAdtoJYtXcbII840GC7FYhu+R66/GXd8Iqs7ClU8rRE3wh445
         9X1MwDyR5LL3P73v847VqGQi/Y+bajE3S+18ZpicZ7yDq6JhMFstPcrO/H7wDkJDljbT
         YtTl89oci983laWnekC00sbdNqH5vTsQXG7uD6RB3iKh6frWrdjYwvalb7otq9ACccIS
         OPA0PY89fD7va9WxfTDXoiReIqFpJhm0gYsmrtvx3L9010++pRf0jJFhHJkeckY3oEsx
         C6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lPq98DvLOBgDS3OkFGWgwniLlPjPEfUY82nNbD/WvW8=;
        b=s5mxzFFr5eBZ4lduP8UFVWHffo05li9Vvi2ISTQbl6LvNqqI6f0dnC5BXDWW3wFEjm
         7CvIS1gNTxn4lqr8WIWdMT5S1yASVQ7o4XRGeHJ8u6GSMItD2ZhDcMTA665Wlvo2vjJ+
         PcIa5aYIzI3HrJ4wYpeI1rgTawF3e5uDOPlKJzfgBMQ/3Rr7lHGgQSXqCaXlhfGnTxhL
         /mpSML208r/GUX7Co6HaH6ZPhc8dVkXwaKtezurjmRK0bod9W/0VNATGaDpBS0yxwacg
         SVHtJ9W60End+V0zfa/7qvZN3u6TqUeNBV4JNZiIoPcTII+jk38fpR6tRNLsfwmk8NzM
         DfNQ==
X-Gm-Message-State: APjAAAV2msMi/ZwXQlepvWMM5pIJd3mFYzB9uRcKHtYwnhISYIEHdkM0
        gOTTDQlPdAY7/2YBJi9GGuTMMG4b2Zs=
X-Google-Smtp-Source: APXvYqxyszBVesI//HNTAr7/tK5C8Ui20+w3ui/vBa3isJMQbBXak91ZLh3mCU/pgKIsd43gTRWbWA==
X-Received: by 2002:a7b:c183:: with SMTP id y3mr14539304wmi.0.1582443119457;
        Sat, 22 Feb 2020 23:31:59 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id z1sm11943487wmf.42.2020.02.22.23.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:59 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 12/12] mlxsw: pci: Remove unused values
Date:   Sun, 23 Feb 2020 08:31:44 +0100
Message-Id: <20200223073144.28529-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Since commit f3a52c6162f8 ("mlxsw: pci: Utilize MRSR register to perform
FW reset") the driver no longer issues a reset via the PCI BAR, so the
offset of the reset bit is unused. Remove it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 43fa8c85b5d9..c5ceb0bb6485 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -25,8 +25,6 @@
 #define MLXSW_PCI_CIR_CTRL_STATUS_SHIFT		24
 #define MLXSW_PCI_CIR_TIMEOUT_MSECS		1000
 
-#define MLXSW_PCI_SW_RESET			0xF0010
-#define MLXSW_PCI_SW_RESET_RST_BIT		BIT(0)
 #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
 #define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
 #define MLXSW_PCI_FW_READY			0xA1844
-- 
2.21.1

