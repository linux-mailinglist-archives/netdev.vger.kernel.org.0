Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421EBC4644
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 05:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbfJBDoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 23:44:04 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33057 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfJBDoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 23:44:04 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so6551576pls.0
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 20:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:user-agent:date:from:to:cc:cc:subject:references
         :mime-version:content-disposition;
        bh=FgsZhVvNDsvCo1ldLLi0PLQX9/K9QvT261cxTpSn4UQ=;
        b=eoMHNU89w9ftgg11Qr+NmcViygU9CybArAueC3PXkx6/WiSi1JLvVqh1XT4E3T5rHK
         g7KhYNzUY9jYNiVNyKCoLg6p57N2lnkynw0oJFUIIr8B10M3JEAWUlEupgS7DFPrU6hz
         Wo0eE5JdkJ2swiDgaZi5ahjEru2uIVb6L1E/kI/TLaPCBjeYNpn7gdzPMFt+runZrpwk
         Rs1OJWiJ1OnOFLA8pLfS7SGow5Zvw8Le+g6aolBFoHQkMLm1UqtXiI1mwhIzMfpl2RW5
         WvWfaMYFLWwiGS+z1Tl+/bwAWESaaYIqv9GtUCILM5cK7cJ3OJmmFBZRCcVWxZGrWDYN
         /HEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:user-agent:date:from:to:cc:cc:subject
         :references:mime-version:content-disposition;
        bh=FgsZhVvNDsvCo1ldLLi0PLQX9/K9QvT261cxTpSn4UQ=;
        b=JxLKBTAdUPpuVTiZRQ011j5TURA8I3Ji0pLqUj0yC/cY2UVjwe+F3JeHLXPfthcub/
         8ejWJRLwbw/lpuKqR519uu763RssfO1Nq/2wUv2EYWWAuHQHQu19sw28pGi7Uw94sfH4
         8FH2vN941X2JIP80fqs/kuEH6kaMAA8jGZiYXrNKg5KRMRK8ypYa2jtNIrkyYY9BC7BH
         X+ySv1IKoXPU2VcY1Fu+vWiLFkwiG2SkAyepfk8XtkOkvdna6Y6N7JrUOUbVsIhSzbty
         cUFSUnAEj78rKTs+/+ZCPRnM5qmmyUMyiDS13pZBiEyr07KtPSyQt6I+AwGRP2q9wWQ/
         Byxg==
X-Gm-Message-State: APjAAAXfaCU/4diCfrl2Dxmk/xCzwXLw9AS8/sLeVXEcX9lpgP+ivAGh
        i5FVY3iwhVfDeH/SvjYDa8qzr4Aa
X-Google-Smtp-Source: APXvYqzMDQZmFZTyD/SHj4cZ8T5WbjyOJYwTYnxYD7zDNv2+w7SwnQRt+6qDDpS351lVzdVbMcW+ig==
X-Received: by 2002:a17:902:b58c:: with SMTP id a12mr1354193pls.195.1569987843384;
        Tue, 01 Oct 2019 20:44:03 -0700 (PDT)
Received: from localhost ([2601:1c0:6280:3f0::9a1f])
        by smtp.gmail.com with ESMTPSA id i6sm27946254pfq.20.2019.10.01.20.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 20:44:02 -0700 (PDT)
Message-Id: <20190920230359.122042646@gmail.com>
User-Agent: quilt/0.65
Date:   Tue, 01 Oct 2019 16:04:00 -0700
From:   rd.dunlab@gmail.com
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
Cc:     rdunlap@infradead.org
Subject: [PATCH 2/3] Isolate CAIF transport drivers into their own menu
References: <20190920230358.973169240@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=drv-net-caif-menu.patch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Isolate CAIF transport drivers into their own menu.

This cleans up the main Network device support menu,
makes it easier to find the CAIF drivers, and makes it
easier to enable/disable them as a group.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/net/caif/Kconfig |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- lnx-53-caif.orig/drivers/net/caif/Kconfig
+++ lnx-53-caif/drivers/net/caif/Kconfig
@@ -3,7 +3,13 @@
 # CAIF physical drivers
 #
 
-comment "CAIF transport drivers"
+menuconfig CAIF_DRIVERS
+	bool "CAIF transport drivers"
+	depends on CAIF
+	help
+	  Enable this to see CAIF physical drivers.
+
+if CAIF_DRIVERS
 
 config CAIF_TTY
 	tristate "CAIF TTY transport driver"
@@ -55,3 +61,5 @@ config CAIF_VIRTIO
 if CAIF_VIRTIO
 source "drivers/vhost/Kconfig.vringh"
 endif
+
+endif # CAIF_DRIVERS


